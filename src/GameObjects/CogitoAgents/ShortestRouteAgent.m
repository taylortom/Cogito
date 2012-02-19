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

-(Action)selectAction:(State*)_state;
-(Action)chooseRandomAction:(CCArray*)_actions;
-(CCArray*)calculateAvailableActions:(State*)_state;
-(void)setOptimumRoute;

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
        respawns = KLearningEpisodes;
        learningMode = YES;
        routes = [[CCArray alloc] init];
        currentRoute = [[Route alloc] init];
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
            // set the optimum route if it hasn't been already
            if(shortestRoute == nil) [self setOptimumRoute];
            
            if(shortestRoute != nil)
            {
                action = [[[[shortestRoute getNodes] objectAtIndex:shortestRouteIndex] objectAtIndex:1] intValue];
                shortestRouteIndex++;
            }
            // if still nil, no optimum has been found. Choose random action
            else action = [self chooseRandomAction:options];  
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
 * Randomly selects an action from the options
 * @param the available options
 * @return the action
 */
-(Action)chooseRandomAction:(CCArray*)_actions
{
    Action action = -1;
    
    int randomIndex = arc4random() % [_actions count];  
    action = [[_actions objectAtIndex:randomIndex] intValue];
    
    return action;
}

/**
 * Returns a list of actions available for the agent to take
 * only needs to be called once per-state
 * @param the current object type
 * @return an array of actions
 */
-(CCArray*)calculateAvailableActions:(State*)_state
{    
    GameObject* object = [_state getGameObject];
    CCArray* actions = [[CCArray alloc] init];
    
    [actions addObject:[NSNumber numberWithInt:kActionLeft]];
    [actions addObject:[NSNumber numberWithInt:kActionRight]];
    
    if(helmetUses > 0) 
    {   
        [actions addObject:[NSNumber numberWithInt:kActionLeftHelmet]];
        [actions addObject:[NSNumber numberWithInt:kActionRightHelmet]];
    }
    
    // add 'down' action if appropriate
    if(object.gameObjectType == kObjectTrapdoor) 
    {
        [actions addObject:[NSNumber numberWithInt:kActionDown]];
        if(umbrellaUses > 0) [actions addObject:[NSNumber numberWithInt:kActionDownUmbrella]];
    }
    else if(object.gameObjectType == kObjectTerrainEnd && umbrellaUses > 0) 
        [actions addObject:[NSNumber numberWithInt:kActionEquipUmbrella]];
    
    [_state setActions:actions];
    return actions;
}

/**
 * Gets the shortest successful route taken by the 
 * agent during 'learning mode'
 */
-(void)setOptimumRoute
{
    // the shortest route length (for comparison)
    int minLength = 999;
    
    for (int i = 0; i < [routes count]; i++) 
    {
        Route* route = [routes objectAtIndex:i];
                
        // if route's shorter (and we survived), set the shortest route
        if([[route getNodes] count] < minLength && [route survived])
        {
            shortestRoute = route;
            minLength = [[route getNodes] count];
        }
    }
    
    shortestRouteIndex = 0;
}

#pragma mark -
#pragma mark Overrides

/**
 * Applies the appropriate action when 
 * an agent collides with an object
 * @param object collided with
 */
-(void)onObjectCollision:(GameObject*)_object
{    
    // need to know if the lemming's fall was fatal (has to be checked before call to super and fallCounter's reset)
    BOOL fatalFall = (fallCounter >= ((float)kLemmingFallTime*(float)kFrameRate) && self.state != kStateFloating) ? YES : NO;
    
    // call the method in super
    [super onObjectCollision:_object];
        
    State* newState = [[State alloc] initStateForObject:_object];
    
    // perform correct action based on object
    switch([_object gameObjectType]) 
    {
        case kObjectTerrainEnd:
        case kObjectTrapdoor:
            [self takePath:[self selectAction:newState]];
            break;
            
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            [self selectAction:newState];
            break;
            
        case kObstacleStamper:
            if(self.state == kStateDead) [self selectAction:newState];
            break;
    
        case kObjectTerrain:
            if(fatalFall) [self selectAction:newState];
            break;
            
        default:
            break;
    }
}

/**
 * Lemming has either died, or won
 * act accordingly
 */
-(void)onEndConditionReached
{                                        
    if(learningMode) 
    {   
        if(respawns > 1) [self changeState:kStateSpawning];
        else 
        {
            learningMode = NO;
            respawns = kLemmingRespawns;
            [self changeState:kStateSpawning];
        }
    }
    else if(self.state == kStateDead && respawns > 0) [self changeState:kStateSpawning];
    else [[LemmingManager sharedLemmingManager] removeLemming:self];
}

/**
 * Updates the debug string
 */
-(void)updateDebugLabel
{    
    CGPoint newPosition = [self position];
    
    NSString *debugString = @"";
    if(!learningMode) debugString = @"\n!";
    
    [debugLabel setString:debugString];
    
    float yOffset = 30.0f;
    newPosition = ccp(newPosition.x, newPosition.y+yOffset);
    [debugLabel setPosition:newPosition];    
}

@end