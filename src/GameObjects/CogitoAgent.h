//
//  CogitoAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning
//
//  15/01/2011: Created class
//

#import "Lemming.h"
#import "State.h"

@interface CogitoAgent : Lemming

{
    CCArray* gameStates;
    
    State* currentState;
    Action currentAction;
    
    BOOL learningMode;
}

@end