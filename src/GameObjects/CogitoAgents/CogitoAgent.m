//
//  CogitoAgent.m
//  Author: Thomas Taylor
//
//  Base class for machine learning
//
//  20/02/2012: Created class
//

#import "CogitoAgent.h"

@implementation CogitoAgent

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
        respawns = [[LemmingManager sharedLemmingManager] learningEpisodes];
        learningMode = YES;
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
    CCArray* actions = [self calculateAvailableActions:_state];

    // choose a random action
    Action action = -1;
    if(self.state != kStateDead && [_state getGameObject].gameObjectType != kObjectExit) 
        action = [self chooseRandomAction:actions];
                
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
    
    int randomIndex = [Utils generateRandomNumberFrom:0 to:[_actions count]];  
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
 * Looks up the state for the passed object
 * @param object to search for
 * @return the matching state
 */
-(State*)getStateForGameObject:(GameObject*)_object
{
    return [[State alloc] initStateForObject:_object];
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
        
   /* 
    * only need to handle two types, 
    * rest are dealt with by superclass
    */
    switch([_object gameObjectType]) 
    {
        case kObjectTerrainEnd:
        case kObjectTrapdoor:
            [self takePath:[self selectAction:[self getStateForGameObject:_object]]];
            break;
            
        case kObstacleWater:
        case kObstaclePit:
        case kObjectExit:
            [self selectAction:[self getStateForGameObject:_object]];
            break;
            
        case kObstacleStamper:
            if(self.state == kStateDead) [self selectAction:[self getStateForGameObject:_object]];
            break;
    
        case kObjectTerrain:
            if(fatalFall) [self selectAction:[self getStateForGameObject:_object]];
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
    // add the data to AgentStats
    int length = [[GameManager sharedGameManager] getGameTimeInSecs] - spawnTime;
    if(self.state != kStateDead) [[AgentStats sharedAgentStats] addEpisodeWithLength:length andActions:actionsTaken learningMode:learningMode];
    else [[AgentStats sharedAgentStats] addEpisode];
    
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
    [super updateDebugLabel];
    [debugLabel setString:(learningMode || self.state == kStateDead || self.state == kStateWin) ? @"" : @"!"];
}

@end