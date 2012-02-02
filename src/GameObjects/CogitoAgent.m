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
-(float)calculateQValueFromState:(State*)_state andAction:(MovementDecision)_action;
-(float)calculateMaxQValueForState:(State*)_state;
-(void)updateQValues;

-(MovementDecision)selectAction:(State*)_state;
-(CCArray*)calculateAvailableActions:(State*)_state;

-(void)addRowToTable:(State*)_state withAction:(MovementDecision)_action withQValue:(float)_qValue;
-(CCArray*)getDataForState:(State*)_state;
-(CCArray*)getDataForPair:(State*)_state andAction:(MovementDecision)_action;
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
    [qTable release]; 
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
        qIndex = -1;
        
        gameStates = [[CCArray alloc] init];
        qTable = [[CCArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Q-Value Calculations

/**
 *
 */
-(void)updateQValues
{
    CCLOG(@"CogitoAgent.updateQValues");
    if(qIndex == -1) return;
    
    /*
     * Qi(X,a) = (1 - Ci) Qi-1(X,a) + Ci[Ri + gamma(Vi-1(Xprimei))]
     *
     * Qi = the q-value for the i-th step
     * Qi-1 = the q-value for the (i-1)-th step
     * Ci = the learning factor
     * Ri = the immediate reward
     * gamma = the discount factor
     */
    
    CCArray* currentQData = [qTable objectAtIndex:qIndex];
    //if();
    //else if([[currentQData objectAtIndex:kRLRewardIndex] floatValue] == 0.0f) [currentQData replaceObjectAtIndex:kRLRewardIndex withObject:[NSNumber numberWithFloat:-0.2f]];
}

/**
 * Returns the Q value for the passed state-action pair
 * @param state
 * @param action
 * @return the Q value
 */
-(float)calculateQValueFromState:(State*)_state andAction:(MovementDecision)_action
{
    return 0.0f; 
}

/**
 * Returns the max possible Q value for the passed state
 * @param state
 * @return the max Q value
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
 */
-(MovementDecision)selectAction:(State*)_state
{
    //[self updateQValues];
    
    MovementDecision action = -1;
    BOOL chooseRandom = (arc4random() % (int)(1/kRLRandomProbability) == 0) ? YES : NO;    
    CCArray* options = ([[_state getActions] count] > 0) ? [_state getActions] : [self calculateAvailableActions:_state];
    
    // if still learning, randomly choose action
    if(learningMode || chooseRandom) 
    {
        int randomIndex = arc4random() % [options count];    
        action = [[options objectAtIndex:randomIndex] intValue];
        
        CCArray* qTableData = [self getDataForPair:_state andAction:action];
        if(qTableData == nil) [self addRowToTable:_state withAction:action withQValue:0.0f];
    }
    else
    {
        // get the values from the lookup table from current state
        // compare, choose best one
        
        CCArray* qTableData = [self getDataForState:_state];
        if ([qTableData count] > 0) 
        {
            // do nothing
        }
        else 
        {
            // no data for the current state, choose random action
            int randomIndex = arc4random() % [options count];    
            action = [[options objectAtIndex:randomIndex] intValue];
        }
    }
    
    CCLOG(@"CogitoAgent.chooseAction: %@ (random: %i)", [Utils getActionAsString:action], chooseRandom);
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
    
    [actions addObject:[NSNumber numberWithInt:kDecisionLeft]];
    [actions addObject:[NSNumber numberWithInt:kDecisionRight]];
    
    if(helmetUses > 0) 
    {   
        [actions addObject:[NSNumber numberWithInt:kDecisionLeftHelmet]];
        [actions addObject:[NSNumber numberWithInt:kDecisionRightHelmet]];
    }
    
    // add 'down' action if appropriate
    if(object.gameObjectType == kObjectTrapdoor) 
    {
        [actions addObject:[NSNumber numberWithInt:kDecisionDown]];
        if(umbrellaUses > 0) [actions addObject:[NSNumber numberWithInt:kDecisionDownUmbrella]];
    }
    else if(object.gameObjectType == kObjectTerrainEnd && umbrellaUses > 0) 
        [actions addObject:[NSNumber numberWithInt:kDecisionEquipUmbrella]];
    
    [_state setActions:actions];
    return actions;
}

#pragma mark -
#pragma mark State-Action Table Maintenance

/**
 * Adds a row to the qTable
 * @param current state
 * @param action taken
 * @param q value
 * @param reward
 */
-(void)addRowToTable:(State*)_state withAction:(MovementDecision)_action withQValue:(float)_qValue
{
    //CCLOG(@"CogitoAgent.addRowToTable: %@-%@: %f - %f", [Utils getObjectAsString:_object.gameObjectType], [Utils getActionAsString:_action], _qValue, _reward);
    
    CCArray* rowToAdd = [[CCArray alloc] init];
    
    [rowToAdd insertObject:_state atIndex:kRLStateIndex];
    [rowToAdd insertObject:[NSNumber numberWithInt:_action] atIndex:kRLActionIndex];
    [rowToAdd insertObject:[NSNumber numberWithFloat:_qValue] atIndex:kRLQValueIndex];
    [qTable addObject:rowToAdd];
}

/**
 * Searches the qTable for actions matching the state
 * @param object
 */
-(CCArray*)getDataForState:(GameObject*)_object
{    
    CCArray* rows = [[CCArray alloc] init];
    
    for (int i = 0; i < [qTable count]; i++) 
    {
        CCArray* tempRow = [qTable objectAtIndex:i];
        if([tempRow objectAtIndex:0] == _object) [rows addObject:tempRow];
        else continue;
    }
    
    return rows;
}

/**
 * Searches the qTable for a matching state-action pair
 * @param object
 * @param action
 */
-(CCArray*)getDataForPair:(State*)_state andAction:(MovementDecision)_action
{    
    for (int i = 0; i < [qTable count]; i++) 
    {
        CCArray* tempRow = [qTable objectAtIndex:i];
        if([tempRow objectAtIndex:kRLStateIndex] == _state && [[tempRow objectAtIndex:kRLActionIndex] intValue] == _action) 
            return tempRow;
        else continue;
    }
    
    return nil;
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
    
   /* 
    * only need to handle two types, 
    * rest are dealt with by superclass
    */
    switch([_object gameObjectType]) 
    {
        case kObjectTerrainEnd:
            if(self.state == kStateFalling || self.state == kStateFloating) break;
            
        case kObjectTrapdoor:
            [self takePath:[self selectAction:[self getStateForGameObject:_object]]];
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