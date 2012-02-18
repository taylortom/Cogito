//
//  QLearningAgent.m
//  Author: Thomas Taylor
//
//  Handles the machine learning using Q-learning
//
//  15/01/2012: Created class
//

#import "QLearningAgent.h"

@interface QLearningAgent()

// get Policy
-(void)updateQValues:(QState*)_newState;
-(Action)selectAction:(QState*)_state;
-(Action)chooseRandomAction:(CCArray*)_actions;
-(CCArray*)calculateAvailableActions:(QState*)_state;
-(QState*)getStateForGameObject:(GameObject*)_object;

@end

@implementation QLearningAgent

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
        respawns = KLearningEpisodes;
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
-(void)updateQValues:(QState*)_newState
{
    if(currentState == nil) return;
        
    float oldQValue = [currentState getQValueForAction:currentAction];
    float maximumQValue = [_newState calculateMaxQValue];
    float reward = [_newState getReward];
    
    float updatedQValue = oldQValue * (1 - kQLearningRate) + kQLearningRate * (reward + kQDiscountFactor * maximumQValue);
    CCLOG(@"Q: %f => newQ: %f maxQ: %f R: %i [%@ - %@]", oldQValue, updatedQValue, maximumQValue, (int)reward, [Utils getObjectAsString:currentState.getGameObject.gameObjectType], [Utils getActionAsString:currentAction]);
    [currentState setQValue:updatedQValue forAction:currentAction];
}

#pragma mark -

/**
 * Decides which action to take based on knowledgebase
 * @param the object colliding with
 * @return the action to take
 */
-(Action)selectAction:(QState*)_state
{
    Action action = -1;

    // get  list of the available action
    CCArray* options = [_state getActions];
    if([options count] < 1) options = [self calculateAvailableActions:_state];

    // calcuates the Q-value for the previous state
    [self updateQValues:_state];
        
    if(self.state != kStateDead && [_state getGameObject].gameObjectType != kObjectExit) 
    {
        // uses the Constant var to randomise actions
        BOOL chooseRandom = (arc4random() % (int)(1/kLearningRandomProbability) == 0) ? YES : NO;    
        
        // if still learning, randomly choose action
        if(learningMode || chooseRandom) action = [self chooseRandomAction:options];  
        // not learning, choose the optimum action
        else
        {
            action = [_state getOptimumAction];
            
            // no data for the current state, choose random action
            if(action == -1) action = [self chooseRandomAction:options];  
        }
        
        //CCLOG(@"CogitoAgent.selectAction: %@ (random: %i Q-Value: %f)", [Utils getActionAsString:action], chooseRandom, [currentState getQValueForAction:currentAction]);
    }
    
    // update the current state/action variable (nil if we've reached a goal state)
    currentState = (action != -1) ? _state : nil;
    currentAction = action;
    
    return action;
}

-(Action)chooseRandomAction:(CCArray*)_actions
{
    Action action = -1;
    
    int randomIndex = arc4random() % [_actions count];  
    action = [[_actions objectAtIndex:randomIndex] intValue];
    
    return action;
}

/**
 * Returns a list of actions available for the agent to take
 * only needs to be called once per-state
 * @param the current object type
 * @return an array of actions
 */
-(CCArray*)calculateAvailableActions:(QState*)_state
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
-(QState*)getStateForGameObject:(GameObject*)_object
{        
    for (int i = 0; i < [gameStates count]; i++) 
    {
        QState* tempState = [gameStates objectAtIndex:i];
        if([tempState getGameObject] == _object) return tempState;
    }
        
    // state not found, make a new one    
    float reward = kQDefaultReward;
    if(_object.gameObjectType == kObjectExit) reward = kQWinReward;
    else if(self.state == kStateDead) reward = kQDeathReward;
    
    QState* returnState = [[QState alloc] initStateForObject:_object withReward:reward];
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
    // need to know if the lemming's fall was fatal (has to be checked before call to super and fallCounter's reset)
    BOOL fatalFall = (fallCounter >= ((float)kLemmingFallTime*(float)kFrameRate) && self.state != kStateFloating) ? YES : NO;
    
    // call the method in super
    [super onObjectCollision:_object];
        
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
            
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            [self selectAction:[self getStateForGameObject:_object]];
            break;
            
        case kObstacleStamper:
            if(self.state == kStateDead) [self selectAction:[self getStateForGameObject:_object]];
            break;
    
        case kObjectTerrain:
            if(fatalFall) [self selectAction:[self getStateForGameObject:_object]];
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

/**
 * Updates the debug string
 */
-(void)updateDebugLabel
{    
    CGPoint newPosition = [self position];
    
    NSString *debugString = @"";
    
    switch([[currentState getGameObject] gameObjectType]) 
    {
        case kObjectTerrainEnd:
        case kObjectTrapdoor:
        debugString = [NSString stringWithFormat:@"%@\n%@",[Utils getObjectAsString:[currentState getGameObject].gameObjectType] , [Utils getActionAsString:[currentState getOptimumAction]]];
        break;
            
        case kObstacleStamper:
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            break;
        
        default:
            break;
    }

    if(!learningMode) debugString = @"\n!";
    
    [debugLabel setString:debugString];
    
    float yOffset = 30.0f;
    newPosition = ccp(newPosition.x, newPosition.y+yOffset);
    [debugLabel setPosition:newPosition];    
}

@end