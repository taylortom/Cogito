//
//  State.m
//  Cogito
//
//  Basic class to hold info about a state.
//
//  02/02/2012: Created class
//

#import "State.h"

@implementation State


#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [actions release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the state
 * @return self
 */
-(id)initStateForObject:(GameObject*)_object withReward:(float)_reward
{
    self = [super init];
    
    if (self != nil) 
    {
        gameObject = _object;
        reward = _reward;
        actions = [[CCArray alloc] init];
    }
    return self;
}

-(void)setActions:(CCArray*)_actions
{
    actions = _actions;
}

-(GameObject*)getGameObject
{
    return gameObject;
}

-(CCArray*)getActions
{
    return actions;
}

-(float)getReward
{
    return reward;
}

@end
