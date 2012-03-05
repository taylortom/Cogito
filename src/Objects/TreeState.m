//
//  TreeState.m
//  Author: Thomas Taylor
//
//  Basic class to hold info about a state in
//  decision tree learning
//
//  09/02/2012: Created class
//

#import "TreeState.h"

@implementation TreeState

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the state
 * @return self
 */
-(id)initStateForObject:(GameObject*)_object
{        
    self = [super initStateForObject:_object];
    
    if (self != nil) 
    {
        nodeValue = 0;
        action = -1;;
        
        children = [[CCArray alloc] init];
    }
    return self;
}

#pragma mark -

/**
 * Adds a child node
 * @param the state to add
 */
-(void)addChild:(TreeState*)_state
{        
    // whether the state is already a child
    BOOL new = YES;
    
    // look for duplicates
    for (int i = 0; i < [children count]; i++) 
        if([[children objectAtIndex:i] isEqualTo:_state]) new = NO;
    
    // Don't add the child if it already exists
    if(new) 
    {
        [children addObject:_state];
        [_state setParent:self];
    }
}

/**
 * Sets the nodeValue according to the passed state
 * @param the current state
 */
-(void)setAsLeafNode:(CharacterStates)_state
{        
    switch (_state) 
    {
        case kStateWin:
            nodeValue = 1;
            break;
            
        case kStateDead:
            nodeValue = -1;
            break;
            
        default:
            CCLOG(@"%@.setAsLeafNode: Error, agent not dead/won", NSStringFromClass([self class]));
            break;
    }
}

/**
 * Sets the parent node
 * @param the parent
 */
-(void)setParent:(TreeState*)_parent
{    
    parent = _parent;
}

/**
 * If the node value's 1 or -1, it's a leaf
 * @return the above as a BOOL
 */
-(BOOL)isLeaf
{
    return (nodeValue == 1 || nodeValue == -1);
}


/**
 * Compares the gameobjects/actions to determine
 * if the states are the same
 * @param the state to compare
 * @return a BOOL representation
 */
-(BOOL)isEqualTo:(TreeState*)_state
{
    return (gameObject == [_state getGameObject] && action == [_state getAction]);
}

/**
 * Returns the node value
 * @return the node value
 */
-(int)getValue
{
    return nodeValue;
}

/**
 * Returns the child nodes
 * @return The children as a CCArray
 */
-(CCArray*)getChildren
{    
    return children;
}

/**
 * Sets the action which leads to this state
 * @param the action to set
 */
-(void)setAction:(Action)_action
{
    action = _action;
}

/**
 * Gets the action which leads to this state
 * @return the action
 */
-(Action)getAction
{
    return action;
}

/**
 * Returns the actions
 * @return The actions in a CCArray
 */
-(CCArray*)getActions
{        
    CCArray* actionsArray = [CCArray arrayWithCapacity:0];
    
    for (int i = 0; i < [actions count]; i++) 
        [actionsArray addObject:[[actions objectAtIndex:i] objectAtIndex:0]];
    
    return actionsArray;
}

/**
 * Converts the passed CCArray of actions
 * into an NSDictionary with zeroed Q-values
 * @param actions to convert
 */
-(void)setActions:(CCArray*)_actions
{        
    for (int i = 0; i < [_actions count]; i++) 
        [actions addObject:[NSMutableArray arrayWithObjects:[_actions objectAtIndex:i], [NSNull null], nil]];    
}

/**
 * Recursively builds an array with the tree nodes
 * @return the array
 */
-(CCArray*)buildRoute:(CCArray*)_route
{    
    // don't add the root
    if(parent != nil) 
    {
        [_route addObject:self];
        return [parent buildRoute:_route];
    }
    else return _route;
}

/**
 * Recursively builds the structure
 */
-(CCArray*)buildRoutes:(CCArray*)_routes
{    
    for (int i = 0; i < [children count]; i++) 
    {
        TreeState* node = [children objectAtIndex:i];
        if([node getValue] == 1) 
            [_routes addObject:[[children objectAtIndex:i] buildRoute:[[CCArray alloc] init]]];
        else [node buildRoutes:_routes];
    }
    return _routes;
}

/**
 * Recursively prints the structure
 */
-(void)printStructure
{
    NSString* outputString = [NSString stringWithFormat:@"%i: Node: %@ Action: %i Parent: %@", [children count], [Utils getObjectAsString:gameObject.gameObjectType], action, [Utils getBooleanAsString:(parent != nil)]];
    
    for (int i = 0; i < [children count]; i++) 
        [NSString stringWithFormat:@"%@%@, ", outputString, [Utils getObjectAsString:[[children objectAtIndex:i] getGameObject].gameObjectType]];
    
    CCLOG(@"%@", outputString);
    
    for (int i = 0; i < [children count]; i++) [[children objectAtIndex:i] printStructure];
}

@end
