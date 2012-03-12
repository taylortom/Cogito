//
//  DecisionTreeAgent.m
//  Author: Thomas Taylor
//
//  Handles the machine learning using Decision
//  Tree learning
//
//  06/02/2012: Created class
//

#import "DecisionTreeAgent.h"

@interface DecisionTreeAgent()

-(void)setOptimumRoute;
-(Action)getOptimumAction;

@end

@implementation DecisionTreeAgent

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [levelTree release]; 
    [optimumRoute release];
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
        optimumRoute = [[CCArray alloc] init];
        optimumRouteIndex = 0;
        currentAction = -1;
    }
    return self;
}

#pragma mark -

/**
 * Decides which action to take based on knowledgebase
 * @param state
 * @return the action to take
 */
-(Action)selectAction:(State*)_state
{    
    // the action to return
    Action action = -1;
    
    // if the Agent's died/won
    BOOL endConditionReached = (self.state == kStateDead || [_state getGameObject].gameObjectType == kObjectExit);
    
    // create state, and get actions
    TreeState* treeState = [[TreeState alloc] initStateForObject:[_state getGameObject]];
    CCArray* options = [self calculateAvailableActions:treeState];
    
    // uses the Constant to randomise actions  
    int randomNumber = [Utils generateRandomNumberFrom:0 to:(int)(1/kLearningRandomProbability)];
    BOOL chooseRandom = (randomNumber == 0) ? chooseRandom = YES : NO;
    if(kLearningRandomProbability == 0.0f) chooseRandom = NO;
    
    // if still learning, randomly choose action
    if(learningMode || chooseRandom) 
    {   
        if(!endConditionReached) action = [self chooseRandomAction:options];  
              
        // if we're at the root node, don't create a new state
        if([_state getGameObject] == [levelTree getGameObject] && currentState == nil) currentState = levelTree;
        else
        {            
            if(levelTree == nil) levelTree = treeState;
            else
            {
                [treeState setAction:currentAction];
                [currentState addChild:treeState]; 
            }
            
            // update the current state/action variable
            currentState = treeState;
        }
        
        currentAction = action;
            
        if(endConditionReached)
        {
            // if we've reached an end condition, make a leaf node
            if(self.state == kStateDead) [treeState setAsLeafNode:kStateDead];
            else if([_state getGameObject].gameObjectType == kObjectExit) [treeState setAsLeafNode:kStateWin];
            
            // reset the current node
            currentState = nil;
        }        
    }
    // not learning, choose the optimum action (providing not dead/won)
    else if(!endConditionReached) 
    {
        action = [self getOptimumAction];
        
        // no data for the current state, choose random action
        if(action == -1) action = [self chooseRandomAction:options];  
    }
    
    return action;
}

/**
 * Searches the levelTree for the shortest route(s)
 * @return the shortest routes
 */
-(CCArray*)getShortestRoutes
{    
    // build the routes
    CCArray* routes = [CCArray arrayWithCapacity:0];
    [levelTree buildRoutes:routes];
    
    // if no optimum routes are found, exit
    if([routes count] == 0) return nil;
    
    // find the shortest route
    CCArray* route = [routes objectAtIndex:0];
    
    for (int i = 1; i < [routes count]; i++) 
        if([[routes objectAtIndex:i] count] < [route count]) route = [routes objectAtIndex:i];
    
    // check through the routes for other shortest routes
    for (int i = 1; i < [routes count]; i++) 
        if([[routes objectAtIndex:i] count] > [route count]) [routes removeObjectAtIndex:i];
    
    return routes;
}

/**
 * Searches the levelTree for the shortest route
 */
-(void)setOptimumRoute
{    
    // build the routes
    
    CCArray* routes = [self getShortestRoutes];
    
    // if no optimum routes are found, exit
    if([routes count] == 0) return;
    
    // calculate the cost of each route (cost = +1 for every tool use)
    
    NSMutableDictionary* routesWithCosts = [NSMutableDictionary dictionaryWithCapacity:[routes count]];
    
    for (int i = 0; i < [routes count]; i++) 
    {
        CCArray* route = [routes objectAtIndex:i];
        int routeCost = 0;
        
        for (int i = 0; i < [route count]; i++) 
            if([[route objectAtIndex:i] getAction] == kActionDownUmbrella ||
               [[route objectAtIndex:i] getAction] == kActionEquipUmbrella ||
               [[route objectAtIndex:i] getAction] == kActionLeftHelmet ||
               [[route objectAtIndex:i] getAction] == kActionRightHelmet) 
                    routeCost++;
        
        [routesWithCosts setObject:[NSNumber numberWithInt:routeCost] forKey:route];
    }
    
    
    // find the route with the lowest cost
    
    int minimumCost = 999;      // the lowest cost so far
    CCArray* minimumCostRoute;
    
    for (CCArray* route in routesWithCosts) 
    {
        if([[routesWithCosts objectForKey:route] intValue] < minimumCost)
        {
            CCLOG(@"Route cost: %i", [[routesWithCosts objectForKey:route] intValue]);
            minimumCostRoute = route;
            minimumCost = [[routesWithCosts objectForKey:route] intValue];
        }
    }
    
    CCLOG(@"%@.setOptimumRoute: routes: %i mimumumCost: %i minimumCostRoute: %i", NSStringFromClass([self class]), [routes count], minimumCost, [minimumCostRoute count]);
    
    // finally, the array needs to be reversed
    for (int i = [minimumCostRoute count]-1; i > -1; i--) 
        [optimumRoute addObject:[minimumCostRoute objectAtIndex:i]];
    
    CCLOG(@"Optimum route is:");
    for (int i = 0; i < [optimumRoute count]; i++) CCLOG(@"   %@", [Utils getActionAsString:[[optimumRoute objectAtIndex:i] getAction]]);
}

/**
 * Gets the next action in the optimum route
 * @return the optimum action
 */
-(Action)getOptimumAction
{
    Action action = -1;
    
    if([optimumRoute count] > 0)
    {
        action = [[optimumRoute objectAtIndex:optimumRouteIndex] getAction];
        optimumRouteIndex++;
    }
        
    return action;
}

#pragma mark -
#pragma mark Overrides

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
    
    if(!(learningMode || self.state == kStateDead || self.state == kStateWin))
    {
        [debugLabel setString:([optimumRoute count] > 0) ? @"!" : @"?"];
    }
}

@end