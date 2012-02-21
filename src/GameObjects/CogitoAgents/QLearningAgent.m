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

-(void)updateQValues:(QState*)_newState;

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
        gameStates = [[CCArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Q-Value Calculations

/**
 * Updates the Q-values
 * @param the state to update
 */
-(void)updateQValues:(QState*)_newState
{
    if(currentState == nil) return;
        
    float oldQValue = [currentState getQValueForAction:currentAction];
    float maximumQValue = [_newState calculateMaxQValue];
    float reward = [_newState getReward];
    
    float updatedQValue = oldQValue * (1 - kQLearningRate) + kQLearningRate * (reward + kQDiscountFactor * maximumQValue);
    //CCLOG(@"Q: %f => newQ: %f maxQ: %f R: %i [%@ - %@]", oldQValue, updatedQValue, maximumQValue, (int)reward, [Utils getObjectAsString:currentState.getGameObject.gameObjectType], [Utils getActionAsString:currentAction]);
    [currentState setQValue:updatedQValue forAction:currentAction];
}

#pragma mark -
#pragma mark Overrides

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
        // uses the Constant to randomise actions  
        int randomNumber = [Utils generateRandomNumberFrom:0 to:(int)(1/kLearningRandomProbability)];
        BOOL chooseRandom = (randomNumber == 0) ? chooseRandom = YES : NO;
        if(kLearningRandomProbability == 0.0f) chooseRandom = NO;
        
        // if still learning, randomly choose action
        if(learningMode || chooseRandom) action = [self chooseRandomAction:options];  
        // not learning, choose the optimum action
        else
        {
            action = [_state getOptimumAction];
            
            // no data for the current state, choose random action
            if(action == -1) action = [self chooseRandomAction:options];  
        }
    }
    
    // update the current state/action variable (nil if we've reached a goal state)
    currentState = (action != -1) ? _state : nil;
    currentAction = action;
    
    return action;
}

/**
 * Looks up the state for the passed object
 * @param object to search for
 * @return the matching state
 */
-(QState*)getStateForGameObject:(GameObject*)_object
{        
    // if we're using the shared knowledge base...
    if(kQLearningSharedKnowledge) 
        return [[KnowledgeBase sharedKnowledgeBase] getStateForGameObject:_object];
    
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

@end