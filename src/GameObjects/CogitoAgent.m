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
-(void)updateQValues:(State*)_newState;
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
 */
-(void)updateQValues:(State*)_newState
{
    if(currentState == nil) return;
        
    float oldQValue = [currentState getQValueForAction:currentAction];
    float maximumQValue = [_newState calculateMaxQValue];
    float reward = [_newState getReward];
    
    float updatedQValue = oldQValue + kRLearningRate * (reward + kRLDiscountFactor * maximumQValue - oldQValue);
    CCLOG(@"CogitoAgent.updateQValues: oldQ: %f maxQ: %f reward: %f => newQ: %f", oldQValue, maximumQValue, reward, updatedQValue);
    [currentState setQValue:updatedQValue forAction:currentAction];
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
    Action action = -1;

    CCArray* options = [_state getActions];
    if([options count] < 1) options = [self calculateAvailableActions:_state];

    // calcuates the Q-value for the previous state
    [self updateQValues:_state];
        
    if(self.state != kStateDead && self.state != kStateWin) 
    {
        BOOL chooseRandom = (arc4random() % (int)(1/kRLRandomProbability) == 0) ? YES : NO;    
        
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
        //CCLOG(@"CogitoAgent.selectAction: %@ (random: %i Q-Value: %f)", [Utils getActionAsString:action], chooseRandom, [currentState getQValueForAction:currentAction]);
    }
    
    // update the current state/action variable
    if(action != -1)
    {    
        currentState = _state;
        currentAction = action;
    }
    
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
    float reward = kRLDefaultReward;
    if(_object.gameObjectType == kObjectExit) reward = kRLWinReward;
    else if(self.state == kStateDead) reward = kRLDeathReward;
    
    State* returnState = [[State alloc] initStateForObject:_object withReward:reward];
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
    
    CCLOG(@"ON ONJECT COLLISION: %@ -> %@", [Utils getObjectAsString:_object.gameObjectType], [Utils getStateAsString:self.state]);
    
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
            
            //case kObstacleStamper:
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            [self selectAction:[self getStateForGameObject:_object]];
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
            CCLOG(@"-------------------- THIS AIN'T NO HIGH SCHOOL MUSICAL --------------------");
            learningMode = NO;
            respawns = kLemmingRespawns;
            [self changeState:kStateSpawning];
        }
    }
    else if(self.state == kStateDead && respawns > 0) [self changeState:kStateSpawning];
    else [[LemmingManager sharedLemmingManager] removeLemming:self];
}

@end