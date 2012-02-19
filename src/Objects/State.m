//
//  State.m
//  Author: Thomas Taylor
//
//  Basic class to hold info about a state
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
-(id)initStateForObject:(GameObject*)_object
{    
    self = [super init];
    
    if (self != nil) 
    {
        gameObject = _object;
        actions = [[CCArray alloc] init];
    }
    return self;
}

#pragma mark -

/**
 * Returns the best action
 * @return the action
 */
-(Action)getOptimumAction
{
    // should be overridden in subclasses
    return -1;
}

/**
 * Returns the actions
 * @return The actions as a CCArray
 */
-(CCArray*)getActions
{    
    // should be overridden in subclasses
    return nil;
}

/**
 * Converts the passed CCArray of actions
 * into an NSDictionary with zeroed Q-values
 * @param actions to convert
 */
-(void)setActions:(CCArray*)_actions
{    
    // should be overridden in subclasses
}

/**
 * Returns the GameObject
 * @return the GameObject
 */
-(GameObject*)getGameObject
{
    return gameObject;
}

@end
