//
//  QLearningAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning using Q-learning
//
//  15/01/2012: Created class
//

#import "AgentStats.h"
#import "CogitoAgent.h"
#import "KnowledgeBase.h"
#import "QState.h"

@interface QLearningAgent : CogitoAgent

{
    CCArray* gameStates;
    
    QState* currentState;
    Action currentAction;    
}

@end