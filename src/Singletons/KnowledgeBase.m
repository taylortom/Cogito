//
//  KnowledgeBase.m
//  Author: Thomas Taylor
//
//  A shared knowledge base used by the lemmings
//
//  18/02/2011: Created class
//

#import "KnowledgeBase.h"

@implementation KnowledgeBase

static KnowledgeBase* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [super dealloc];
    [gameStates release];
}

/**
 * Allocates needed memory
 * @return the instance
 */
+(id)alloc
{    
    @synchronized([KnowledgeBase class])
    {
        // if the _instance already exists, stop
        NSAssert(_instance == nil, @"There should only ever be one instance of KnowledgeBase");
        _instance = [super alloc];
        return _instance;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the class
 * @return self
 */
-(id)init 
{        
    self = [super init];
    
    if (self != nil) 
    {
        gameStates = [[CCArray alloc] init]; 
    }
    
    return self;
}

#pragma mark -

/**
 * Returns the KnowledgeBase instance
 * @return the instance
 */
+(KnowledgeBase*)sharedKnowledgeBase
{
    @synchronized([KnowledgeBase class])
    {
        if(!_instance) [[self alloc] init];
        return _instance;
    }
    
    return nil;
}

/**
 * Looks up the state for the passed object
 * @param object to search for
 * @return the matching state
 */
-(QState*)getStateForGameObject:(GameObject*)_object
{            
    for (int i = 0; i < [gameStates count]; i++) 
    {
        QState* tempState = [gameStates objectAtIndex:i];
        if([tempState getGameObject] == _object) return tempState;
    }
    
    // state not found, make a new one    
    float reward = kQDefaultReward;
    
    // set the reward
    switch(_object.gameObjectType)
    {
        case kObjectExit:
            reward = kQWinReward;
            break;
            
        case kObstaclePit:
        case kObstacleWater:
        case kObstacleStamper:
            reward = kQDeathReward;
            break;            
            
        default:
            break;
    }
    
    QState* returnState = [[QState alloc] initStateForObject:_object withReward:reward];
    [gameStates addObject:returnState];
    return returnState;
}

@end
