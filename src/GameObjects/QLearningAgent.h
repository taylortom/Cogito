//
//  QLearningAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning using Q-learning
//
//  15/01/2012: Created class
//

#import "Lemming.h"
#import "QState.h"

@interface QLearningAgent : Lemming

{
    CCArray* gameStates;
    
    QState* currentState;
    Action currentAction;
    
    BOOL learningMode;
}

@end