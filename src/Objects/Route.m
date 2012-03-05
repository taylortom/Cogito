//
//  Route.m
//  Author: Thomas Taylor
//
//  Contains data about a specific route
//
//  18/02/2012: Created class
//

#import "Route.h"

@implementation Route

@synthesize survived;

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [nodes release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the state
 * @return self
 */
-(id)init
{    
    self = [super init];
    
    if (self != nil) 
    {
        survived = NO;
        nodes = [[CCArray alloc] init];
    }
    return self;
}

#pragma mark -

/**
 * Adds a state to the nodes array
 * @param state to add
 */
-(void)addState:(State*)_state withAction:(Action)_action
{
    //CCLOG(@"%@.addState: %@ withAction: %@", NSStringFromClass([self class]), [Utils getObjectAsString:[_state getGameObject].gameObjectType], [Utils getActionAsString:_action]);
    [nodes addObject:[NSMutableArray arrayWithObjects:_state, [NSNumber numberWithInt:_action], nil]];
}

/**
 * Returns the list of nodes
 * @return the nodes
 */
-(CCArray*)getNodes
{    
    return nodes;
}


@end