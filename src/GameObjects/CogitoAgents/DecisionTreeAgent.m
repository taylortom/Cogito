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
    [gameStates release]; 
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
        gameStates = [[CCArray alloc] init];
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
    Action action = -1;
    
    // if the Agent's died/won
    BOOL endConditionReached = (self.state == kStateDead || [_state getGameObject].gameObjectType == kObjectExit);
    
    // create state, and get actions
    TreeState* treeState = [[TreeState alloc] initStateForObject:[_state getGameObject]];
    CCArray* options = [self calculateAvailableActions:treeState];
    
    // uses the Constant to randomise actions  
    int randomNumber = arc4random() % (int)(1/kLearningRandomProbability);
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
 * Searches the levelTree for the shortest route
 * @return the optimum route
 */
-(void)setOptimumRoute
{
    // build the routes
    CCArray* routes = [[CCArray alloc] init];
    [levelTree buildRoutes:routes];
    
    // if no optimum route are found, exit
    if([routes count] == 0) return;
    
    // find the shortest route
    CCArray* route = [routes objectAtIndex:0];
    
    for (int i = 1; i < [routes count]; i++) 
        if([[routes objectAtIndex:i] count] < [route count]) route = [routes objectAtIndex:i];
    
    // the array needs to be reversed
    for (int i = [route count]-1; i >= 0; i--) 
        [optimumRoute addObject:[route objectAtIndex:i]];
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
    if(!learningMode) ([optimumRoute count] > 0) ? [debugLabel setString:@"!"] : [debugLabel setString:@"?"];
}

@end