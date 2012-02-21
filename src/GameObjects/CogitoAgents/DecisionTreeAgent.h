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
#import "CogitoAgent.h"
#import "TreeState.h"

@interface DecisionTreeAgent : CogitoAgent

{
    CCArray* gameStates;
    
    TreeState* levelTree;    
    TreeState* currentState;
    Action currentAction;
    
    CCArray* optimumRoute;
    int optimumRouteIndex;    
}

@end