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
    [gameStates release];
    [routes release];
    
    [super dealloc];
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
        [self clearKnowledgeBase];
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

/**
 * Exports the knowledge base
 */
-(void)exportKnowledgeBase
{    
    // get the documents path
    NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"KnowledgeBase_Level%i_%@.plist", [[GameManager sharedGameManager] currentLevel].id, [Utils getTimeStampWithFormat:@"yyyy_MM_dd-HHmm"]]];
    
    // the dictionary to export
    NSMutableDictionary* exportData = [[NSMutableDictionary alloc] init];
    
    // create a dictionary ontaining the states
    for (int i = 0; i < [gameStates count]; i++) 
    {
        NSMutableDictionary* stateData = [[NSMutableDictionary alloc] init];
        QState* tempState = [gameStates objectAtIndex:i];
        NSString* stateId = [NSString stringWithFormat:@"%@ (%i,%i)", [Utils getObjectAsString:[[tempState getGameObject] gameObjectType]], ((int)[tempState getGameObject].position.x), ((int)[tempState getGameObject].position.y)];
        
        // no need adding states with no Q-values
        if([[tempState getGameObject] gameObjectType] == kObjectExit) continue;
        if([[tempState getGameObject] class] == [Obstacle class]) continue;
       
        // for each state, create a sub dictionary of actions/Q-values
        for (int j = 0; j < [[tempState getActions] count]; j++) 
        {
            Action action = [[[tempState getActions] objectAtIndex:j] intValue];
            NSNumber* qValue = [NSNumber numberWithFloat:[tempState getQValueForAction:action]];
            
            // store the pair
            [stateData setObject:qValue  forKey:[Utils getActionAsString:action]];
        }
        // store the state
        [exportData setObject:stateData forKey:stateId];
    }
    
    // finally write the file
    [exportData writeToFile:filePath atomically:YES];
}   

/**
 * Clears the knowledge base
 */
-(void)clearKnowledgeBase
{
    [gameStates release];
    gameStates = [[CCArray alloc] init]; 
}

@end
