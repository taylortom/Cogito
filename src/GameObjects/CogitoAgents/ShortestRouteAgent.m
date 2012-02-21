//
//  ShortestRouteAgent.m
//  Author: Thomas Taylor
//
//  Handles the machine learning using a shortest 
//  route policy
//
//  18/02/2012: Created class
//

#import "ShortestRouteAgent.h"

@interface ShortestRouteAgent()

-(void)setOptimumRoute;
-(Action)getOptimumAction;

@end

@implementation ShortestRouteAgent

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [routes release]; 
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the lemming object
 * @return self
 */
-(id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        routes = [[CCArray alloc] init];
        currentRoute = [[Route alloc] init];
        optimumRouteIndex = 0;
    }
    return self;
}

#pragma mark -

/**
 * Decides which action to take based on knowledgebase
 * @param the object colliding with
 * @return the action to take
 */
-(Action)selectAction:(State*)_state
{
    Action action = -1;

    // get  list of the available action
    CCArray* options = [self calculateAvailableActions:_state];
   
    // if the Agent's died/won
    BOOL endConditionReached = (self.state == kStateDead || [_state getGameObject].gameObjectType == kObjectExit);
    
    // choose action
    if(!endConditionReached)
    {
        // uses the Constant to randomise actions  
        int randomNumber = arc4random() % (int)(1/kLearningRandomProbability);
        BOOL chooseRandom = (randomNumber == 0) ? chooseRandom = YES : NO;
        if(kLearningRandomProbability == 0.0f) chooseRandom = NO;
                
        // if still learning, randomly choose action
        if(learningMode || chooseRandom) action = [self chooseRandomAction:options];  
        // not learning, choose the optimum action
        else
        {
            action = [self getOptimumAction];
            // no optimum has been found. Choose random action
            if(action == -1) action = [self chooseRandomAction:options];  
        }
    }
    
    // Update the current route
    if(learningMode) 
    {
        [currentRoute addState:_state withAction:action];
        
        if(endConditionReached) 
        {
            // set the end condition
            if([_state getGameObject].gameObjectType == kObjectExit) [currentRoute setSurvived:YES];
            else if(self.state != kStateDead) [currentRoute setSurvived:NO];
            
            // add the route to routes
            [routes addObject:currentRoute];
                        
            // starting new route
            currentRoute = [[Route alloc] init];
        }
    }
        
    return action;
}

/**
 * Sets the shortest successful route taken by the 
 * agent during 'learning mode'
 */
-(void)setOptimumRoute
{
    for (int i = 0; i < [routes count]; i++) 
    {
        Route* route = [routes objectAtIndex:i];
                
        // if route's shorter (and we survived), set the shortest route
        if([route survived] && (optimumRoute == nil || [[route getNodes] count] < [[optimumRoute getNodes] count])) 
            optimumRoute = route;
    }
}

/**
 * Gets the next action for the optimum route
 */
-(Action)getOptimumAction
{
    Action action = -1;
    
    if(optimumRoute != nil)
    {
        action = [[[[optimumRoute getNodes] objectAtIndex:optimumRouteIndex] objectAtIndex:1] intValue];
        optimumRouteIndex++;
    }
    return action;
}

#pragma mark -
#pragma mark Overrides

/**
 * Looks up the state for the passed object
 * @param object to search for
 * @return the matching state
 */
-(State*)getStateForGameObject:(GameObject*)_object
{
    return [[State alloc] initStateForObject:_object];
}

/**
 * Lemming has either died, or won
 * act accordingly
 */
-(void)onEndConditionReached
{            
    if(learningMode && respawns < 2) [self setOptimumRoute];
    [super onEndConditionReached];
}

/**
 * Updates the debug string
 */
-(void)updateDebugLabel
{    
    [super updateDebugLabel];
    if(!learningMode) (optimumRoute != nil) ? [debugLabel setString:@"!"] : [debugLabel setString:@"?"];
}

@end