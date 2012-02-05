//
//  State.m
//  Cogito
//
//  Basic class to hold info about a state.
//
//  02/02/2012: Created class
//

#import "State.h"

@interface State()

-(CCArray*)getDataForAction:(Action)_action;

@end

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

#pragma mark -

-(Action)getOptimumAction
{
    Action optimumAction = -1;
    float maxQValue = -1000000;
    CCArray* actionsArray = [self getActions];
    
    for (int i = 0; i < [actionsArray count]; i++) 
    {
        float qValue = [self getQValueForAction:[[actionsArray objectAtIndex:i] intValue]];
        if(qValue > maxQValue) 
        {
            maxQValue = qValue;
            optimumAction = [[actionsArray objectAtIndex:i] intValue];
        }
    }
    
    return optimumAction;
}

#pragma mark -
#pragma mark Q-Value Calculations

/**
 * Returns the max possible Q value for the passed state
 * @param state
 * @return the max Q value
 */
-(float)calculateMaxQValue
{    
    // set a very low starting value
    float maximumQValue = -1000000.0f;
    
    CCArray* actionsArray = [self getActions];
    
    for (int i = 0; i < [actionsArray count]; i++) 
    {
        Action action = [[actionsArray objectAtIndex:i] intValue];
        float tempQValue = [self getQValueForAction:action];
        if(tempQValue > maximumQValue) maximumQValue = tempQValue;
    }
    
    return maximumQValue;
}

/**
 * Looks up the Q-value for the action
 * @param action to look up
 * @return the Q-value
 */
-(float)getQValueForAction:(Action)_action
{
    // throw any relevant error messages before continuing
    if([actions count] == 0) { CCLOG(@"%@.getQValueForAction: Error, actions not initialised", NSStringFromClass([self class])); return -1000000.0f; }
    else if([[actions objectAtIndex:0] count] < 2) { CCLOG(@"%@.getQValueForAction: Error, Q-values not initialised %i", NSStringFromClass([self class]), [actions count]); return -1000000.0f; }
    
    CCArray* qData = [self getDataForAction:_action];
    if (qData != nil) return [[qData objectAtIndex:1] floatValue];
    else 
    {
        CCLOG(@"%@.getQValueForAction: %@ action: %i", NSStringFromClass([self class]), [Utils getObjectAsString:gameObject.gameObjectType], _action);
        return -1000000.0f;
    }
}

/**
 * Sets the Q-value for the action
 * @param action to look up
 * @return the Q-value
 */
-(void)setQValue:(float)_qValue forAction:(Action)_action
{
    CCArray* qData = [self getDataForAction:_action];
    if (qData != nil)
    {   
        [qData removeObjectAtIndex: 1];
        [qData insertObject:[NSNumber numberWithFloat:_qValue] atIndex:1];
    }    
}

#pragma mark -

/**
 * Gets the CCArray for the passed action
 * @param action to look up
 * @return the CCArray
 */
-(CCArray*)getDataForAction:(Action)_action
{    
    for (int i = 0; i < [actions count]; i++) 
    {
        Action tempAction = [[[actions objectAtIndex:i] objectAtIndex:0] intValue];
        if(tempAction == _action) return [actions objectAtIndex:i];
    }
    
    // shouldn't get here
    return nil;
}

/**
 * Returns the actions
 * @return The actions as a CCArray
 */
-(CCArray*)getActions
{    
    CCArray* tempArray = [CCArray arrayWithCapacity:[actions count]];
        
    for (int i = 0; i < [actions count]; i++) [tempArray addObject:[[actions objectAtIndex:i] objectAtIndex:0]];
        
    return tempArray;
}

/**
 * Converts the passed CCArray of actions
 * into an NSDictionary with zeroed Q-values
 * @param actions to convert
 */
-(void)setActions:(CCArray*)_actions
{    
    if([actions count] > 0) return;
    
    for (int i = 0; i < [_actions count]; i++) 
        [actions addObject:[NSMutableArray arrayWithObjects:[_actions objectAtIndex:i],[NSNumber numberWithFloat:0.0f],nil]];
}

/**
 * Returns the GameObject
 * @return the GameObject
 */
-(GameObject*)getGameObject
{
    return gameObject;
}

/**
 * Returns the reward 
 * @return the reward
 */
-(float)getReward
{
    return reward;
}

@end
