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

-(Action)selectAction:(GameObject*)_object;
-(Action)chooseRandomAction:(CCArray*)_actions;
-(CCArray*)calculateAvailableActions:(TreeState*)_state;
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
        respawns = KLearningEpisodes;
        learningMode = YES;
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
 * @param the object currently colliding with
 * @return the action to take
 */
-(Action)selectAction:(GameObject*)_object
{    
    Action action = -1;
    
    // if the Agent's died/won
    BOOL endConditionReached = (self.state == kStateDead || _object.gameObjectType == kObjectExit);
    
    // create state, and get actions
    TreeState* treeState = [[TreeState alloc] initStateForObject:_object];
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
        if(_object == [levelTree getGameObject] && currentState == nil) currentState = levelTree;
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
            else if(_object.gameObjectType == kObjectExit) [treeState setAsLeafNode:kStateWin];
            
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
-(CCArray*)calculateAvailableActions:(TreeState*)_state
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
    
    // perform correct action based on object
    switch([_object gameObjectType]) 
    {
        case kObjectTerrainEnd:
        case kObjectTrapdoor:
            [self takePath:[self selectAction:_object]];
            break;
            
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            [self selectAction:_object];
            break;
            
        case kObstacleStamper:
            if(self.state == kStateDead) [self selectAction:_object];
            break;
            
        case kObjectTerrain:
            if(fatalFall) [self selectAction:_object];
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

            [self setOptimumRoute];
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
    
    NSString *debugString = (learningMode) ? [NSString stringWithFormat:@"%i", self.respawns] : @"";
    [debugLabel setString:debugString];
    
    float yOffset = 20.0f;
    newPosition = ccp(newPosition.x, newPosition.y+yOffset);
    [debugLabel setPosition:newPosition];    
}

@end