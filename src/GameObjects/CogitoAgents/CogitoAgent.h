//
//  CogitoAgent.h
//  Author: Thomas Taylor
//
//  Base class for machine learning
//
//  20/02/2012: Created class
//

#import "AgentStats.h"
#import "Lemming.h"
#import "State.h"

@interface CogitoAgent : Lemming

{
    BOOL learningMode;
}

-(Action)selectAction:(State*)_state;
-(Action)chooseRandomAction:(CCArray*)_actions;
-(CCArray*)calculateAvailableActions:(State*)_state;
-(State*)getStateForGameObject:(GameObject*)_object;

@end