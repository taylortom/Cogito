//
//  AgentStats.m
//  Author: Thomas Taylor
//
//  Used to calculate various stats
//
//  20/02/2011: Created class
//

#import "AgentStats.h"

@implementation AgentStats

static AgentStats* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [learningLengths release];
    [nonLearningLengths release];
    [learningActions release];
    [nonLearningActions release];
    
    [super dealloc];
}

/**
 * Allocates needed memory
 * @return the instance
 */
+(id)alloc
{    
    @synchronized([AgentStats class])
    {
        // if the _instance already exists, stop
        NSAssert(_instance == nil, @"There should only ever be one instance of AgentStats");
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
        learningLengths = [[CCArray alloc] init];
        nonLearningLengths = [[CCArray alloc] init];
        learningActions = [[CCArray alloc] init];
        nonLearningActions = [[CCArray alloc] init];
    }
    
    return self;
}

#pragma mark -

/**
 * Returns the AgentStats instance
 * @return the instance
 */
+(AgentStats*)sharedAgentStats
{
    @synchronized([AgentStats class])
    {
        if(!_instance) [[self alloc] init];
        return _instance;
    }
    
    return nil;
}

/**
 * Increments the episode counter
 */
-(void)addEpisode
{
    episodesCompleted++;
}

/**
 * Adds an episode to the correct array for later analysis
 * @param time taken
 * @param actions performed
 * @param whether still learning
 */
-(void)addEpisodeWithLength:(int)_time andActions:(int)_actions learningMode:(BOOL)_learning
{
    //CCLOG(@"%@.addEpisode: L: %i A: %i [%@]", NSStringFromClass([self class]), _time, _actions, [Utils getBooleanAsString:_learning]);
    
    if(_learning) 
    {
        [learningLengths addObject:[NSNumber numberWithInt:_time]];
        [learningActions addObject:[NSNumber numberWithInt:_actions]];
    }
    else 
    {
        [nonLearningLengths addObject:[NSNumber numberWithInt:_time]];
        [nonLearningActions addObject:[NSNumber numberWithInt:_actions]];
    }
    
    [self addEpisode];
}

/**
 * Calculates the average of all of the learning times
 * @return the average
 */
-(int)averageTimeLearning
{
    int average = 0;
    
    for (int i = 0; i < [learningLengths count]; i++) average += [[learningLengths objectAtIndex:i] intValue];
    if([learningLengths count] > 0) average = average/[learningLengths count];
    
    return average;
}

/**
 * Calculates the average of all of the non-learning times
 * @return the average
 */
-(int)averageTimeNonLearning
{
    int average = 0;
    
    for (int i = 0; i < [nonLearningLengths count]; i++) average += [[nonLearningLengths objectAtIndex:i] intValue];
    if([nonLearningLengths count] > 0) average = average/[nonLearningLengths count];
    
    return average;
}

/**
 * Calculates the average actions taken when learning
 * @return the average
 */
-(int)averageActionsLearning
{    
    float average = 0;
    
    for (int i = 0; i < [learningActions count]; i++) average += [[learningActions objectAtIndex:i] intValue];
    if([learningActions count] > 0) average = average/[learningActions count];
    
    return average;
}

/**
 * Calculates the average actions taken when not learning
 * @return the average
 */
-(int)averageActionsNonLearning
{
    float average = 0;
    
    for (int i = 0; i < [nonLearningActions count]; i++) average += [[nonLearningActions objectAtIndex:i] intValue];
    if([nonLearningActions count] > 0) average = average/[nonLearningActions count];
    
    return average;
}

/**
 * Returns how many episodes have been completed
 */
-(int)episodesCompleted
{
    return episodesCompleted;
}

/**
 * Resets the temporary variables 
 */
-(void)clearTempData
{
    episodesCompleted = 0;
    learningLengths = [[CCArray alloc] init];
    nonLearningLengths = [[CCArray alloc] init];
    learningActions = [[CCArray alloc] init];
    nonLearningActions = [[CCArray alloc] init];
}

@end
