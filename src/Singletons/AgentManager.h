//
//  AgentManager.h
//  Cogito
//
//  Manages the agents in the game
//
//  15/12/2011: Created class
//

#import "cocos2d.h"
#import "CogitoAgent.h"
#import "CommonProtocols.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"

@interface AgentManager : NSObject

{
    int totalNumberOfAgents;
    NSMutableArray *agents;
}

+(AgentManager*)sharedAgentManager;
-(void)addAgent:(CogitoAgent*)agentToAdd;
-(void)removeAgent:(CogitoAgent*)agentToRemove;
-(BOOL)agentsMaxed;
-(int)agentCount;

@end
