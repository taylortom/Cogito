//
//  DecisionTreeAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning using Decision
//  Tree learning
//
//  06/02/2012: Created class
//

#import "AgentStats.h"
#import "Lemming.h"
#import "TreeState.h"

@interface DecisionTreeAgent : Lemming

{
    CCArray* gameStates;
    
    TreeState* levelTree;    
    TreeState* currentState;
    Action currentAction;
    
    CCArray* optimumRoute;
    int optimumRouteIndex;
    
    BOOL learningMode;
}

@end