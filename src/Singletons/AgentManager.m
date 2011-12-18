//
//  AgentManager.m
//  Cogito
//
//  Manages the agents in the game
//
//  15/12/2011: Created class
//

#import "AgentManager.h"

@implementation AgentManager

static AgentManager* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

/**
 * Allocates needed memory
 * @return the instance
 */
+(id)alloc
{    
    @synchronized([AgentManager class])
    {
        // if the _instance already exists, stop
        NSAssert(_instance == nil, @"There should only ever be one instance of AgentManager");
        _instance = [super alloc];
        return _instance;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the class
 * @return self
 */
-(id)init 
{        
    self = [super init];
    
    if (self != nil) 
    {
        totalNumberOfAgents = 3;
        agents = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark -

/**
 * Returns the AgentManager instance
 * @return the instance
 */
+(AgentManager*)sharedAgentManager
{
    @synchronized([AgentManager class])
    {
        if(!_instance) [[self alloc] init];
        return _instance;
    }
    
    return nil;
}

#pragma mark -

/**
 * Adds an agent to the agents list
 * @param the agent to add
 */
-(void)addAgent:(CogitoAgent*)agentToAdd
{
    CCLOG(@"AgentManager.agentToAdd");
    [agents addObject:agentToAdd];
}

/**
 * Removes an agent from the agents list
 * @param the agent to remove
 */
-(void)removeAgent:(CogitoAgent*)agentToRemove
{
    CCLOG(@"AgentManager.removeAgent");
    
    @synchronized([AgentManager class])
    {
        [agents removeObject:agentToRemove];
        [agentToRemove removeFromParentAndCleanup:YES];
    }
}

#pragma mark -
#pragma mark Getters

/**
 * Determines whether the total number of
 * agents has been reached
 * @return whether or not the agent count is maxed
 */
-(BOOL)agentsMaxed
{
    return [agents count] == totalNumberOfAgents;
}

/**
 * Returns the number of agents currently in 
 * the game
 * @return number of agents in game
 */
-(int)agentCount
{
    return [agents count];
}

@end
