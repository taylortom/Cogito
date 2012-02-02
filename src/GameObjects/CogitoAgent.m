//
//  CogitoAgent.m
//  Author: Thomas Taylor
//
//  Handles the machine learning
//
//  15/01/2011: Created class
//

#import "CogitoAgent.h"

@interface CogitoAgent()

// get Policy
-(float)calculateQValueFromState:(State*)_state andAction:(Action)_action;
-(float)calculateMaxQValueForState:(State*)_state;
-(void)updateQValues;

-(Action)selectAction:(State*)_state;
-(CCArray*)calculateAvailableActions:(State*)_state;
-(State*)getStateForGameObject:(GameObject*)_object;

@end

@implementation CogitoAgent

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [gameStates release]; 
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the lemming object
 * @return self
 */
-(id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        learningMode = YES;
        gameStates = [[CCArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Q-Value Calculations

/**
 * Updates the Q-values
 * TODO: updateQValues
 */
-(void)updateQValues
{
    CCLOG(@"CogitoAgent.updateQValues");
    
    /*
     * Qi(X,a) = (1 - Ci) Qi-1(X,a) + Ci[Ri + gamma(Vi-1(Xprimei))]
     *
     * Qi = the q-value for the i-th step
     * Qi-1 = the q-value for the (i-1)-th step
     * Ci = the learning factor
     * Ri = the immediate reward
     * gamma = the discount factor
     */
    
    //if();
    //else if([[currentQData objectAtIndex:kRLRewardIndex] floatValue] == 0.0f) [currentQData replaceObjectAtIndex:kRLRewardIndex withObject:[NSNumber numberWithFloat:-0.2f]];
}

/**
 * Returns the Q value for the passed state-action pair
 * @param state
 * @param action
 * @return the Q value
  * TODO: calculateQValueFromState
 */
-(float)calculateQValueFromState:(State*)_state andAction:(Action)_action
{
    return 0.0f; 
}

/**
 * Returns the max possible Q value for the passed state
 * @param state
 * @return the max Q value
  * TODO: calculateMaxQValueForState
 */
-(float)calculateMaxQValueForState:(State*)_state
{
    return 0.0f;
}

#pragma mark -

/**
 * Decides which action to take based on knowledgebase
 * @param the object colliding with
 * @return the action to take
 * TODO: selectAction
 */
-(Action)selectAction:(State*)_state
{
    //[self updateQValues];
    
    Action action = -1;
    BOOL chooseRandom = (arc4random() % (int)(1/kRLRandomProbability) == 0) ? YES : NO;    

    CCArray* options = [_state getActions];
    if([options count] < 1) options = [self calculateAvailableActions:_state];
    
    // if still learning, randomly choose action
    if(learningMode || chooseRandom) 
    {
        int randomIndex = arc4random() % [options count];    
        action = [[options objectAtIndex:randomIndex] intValue];
    }
    else
    {
        // get the values from the lookup table from current state
        // compare, choose best one
        
        // no data for the current state, choose random action
        int randomIndex = arc4random() % [options count];    
        action = [[options objectAtIndex:randomIndex] intValue];
    }
    
    CCLOG(@"CogitoAgent.chooseAction: %@ (random: %i - Q-Value: %f)", [Utils getActionAsString:action], chooseRandom, [_state getQValueForAction:action]);
    [_state setQValue:50.0f forAction:action];
    return action;
}

/**
 * Returns a list of actions available for the agent to take
 * only needs to be called once per-state
 * @param the current object type
 * @return an array of actions
 */
-(CCArray*)calculateAvailableActions:(State*)_state
{    
    GameObject* object = [_state getGameObject];
    CCArray* actions = [[CCArray alloc] init];
    
    [actions addObject:[NSNumber numberWithInt:kActionLeft]];
    [actions addObject:[NSNumber numberWithInt:kActionRight]];
    
    if(helmetUses > 0) 
    {   
        [actions addObject:[NSNumber numberWithInt:kActionLeftHelmet]];
        [actions addObject:[NSNumber numberWithInt:kActionRightHelmet]];
    }
    
    // add 'down' action if appropriate
    if(object.gameObjectType == kObjectTrapdoor) 
    {
        [actions addObject:[NSNumber numberWithInt:kActionDown]];
        if(umbrellaUses > 0) [actions addObject:[NSNumber numberWithInt:kActionDownUmbrella]];
    }
    else if(object.gameObjectType == kObjectTerrainEnd && umbrellaUses > 0) 
        [actions addObject:[NSNumber numberWithInt:kActionEquipUmbrella]];
    
    [_state setActions:actions];
    return actions;
}

/**
 * Looks up the state for the passed object
 * @param object to search for
 * @return the matching state
 */
-(State*)getStateForGameObject:(GameObject*)_object
{        
    for (int i = 0; i < [gameStates count]; i++) 
    {
        State* tempState = [gameStates objectAtIndex:i];
        if([tempState getGameObject] == _object) return tempState;
    }
    
    // state not found, make a new one
    State* returnState = [[State alloc] initStateForObject:_object withReward:kRLDefaultReward];
    [gameStates addObject:returnState];
    return returnState;
}

#pragma mark -
#pragma mark Overrides

/**
 * Applies the appropriate action when 
 * an agent collides with an object
 * @param object collided with
 */
-(void)onObjectCollision:(GameObject*)_object
{       
    // first call in the superclass
    [super onObjectCollision:_object];
    
    if(self.state == kStateFalling || self.state == kStateFloating) return;
    
   /* 
    * only need to handle two types, 
    * rest are dealt with by superclass
    */
    switch([_object gameObjectType]) 
    {
        case kObjectTerrainEnd:            
        case kObjectTrapdoor:
            [self takePath:[self selectAction:[self getStateForGameObject:_object]]];
            break;

        // make sure the following are added to the states list
        case kObstacleStamper:
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            [self getStateForGameObject:_object];
            break;
            
        default:
            break;
    }
}

/**
 * Lemming has either died, or won
 * act accordingly
 */
-(void)onEndConditionReached
{                                        
    if(learningMode) 
    {   
        if(respawns > 0) [self changeState:kStateSpawning];
        else 
        {
            learningMode = NO;
            respawns = kLemmingRespawns;
            [self changeState:kStateSpawning];
        }
    }
    else if(self.state == kStateDead && respawns > 0) [self changeState:kStateSpawning];
    else [[LemmingManager sharedLemmingManager] removeLemming:self];
}

@end