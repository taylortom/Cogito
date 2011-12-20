//
//  LemmingManager.m
//  Cogito
//
//  Manages the Lemmings in the game
//
//  15/12/2011: Created class
//

#import "LemmingManager.h"

@implementation LemmingManager

static LemmingManager* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

/**
 * Allocates needed memory
 * @return the instance
 */
+(id)alloc
{    
    @synchronized([LemmingManager class])
    {
        // if the _instance already exists, stop
        NSAssert(_instance == nil, @"There should only ever be one instance of AgentManager");
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
        totalNumberOfLemmings = 3;
        lemmingsAdded = 0;
        lemmingsKilled = 0;
        lemmingsSaved = 0;
        lemmings = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark -

/**
 * Returns the LemmingManager instance
 * @return the instance
 */
+(LemmingManager*)sharedLemmingManager
{
    @synchronized([LemmingManager class])
    {
        if(!_instance) [[self alloc] init];
        return _instance;
    }
    
    return nil;
}

#pragma mark -

/**
 * Adds a Lemming to the Lemmings list
 * @param the Lemming to add
 */
-(void)addLemming:(Lemming*)lemmingToAdd
{
    [lemmings addObject:lemmingToAdd];
    lemmingsAdded++;
}

/**
 * Removes a Lemming from the Lemmings list
 * @param the Lemming to remove
 */
-(void)removeLemming:(Lemming*)lemmingToRemove
{    
    if(lemmingToRemove.state == kStateDead) lemmingsKilled++;
    else lemmingsSaved++;
    
    [lemmings removeObject:lemmingToRemove];
    [lemmingToRemove removeFromParentAndCleanup:YES];
    
    if([self lemmingCount] == 0) [[GameManager sharedGameManager] runSceneWithID:kGameOverScene];
}

#pragma mark -

/**
 * Calculates a game rating (A,B,C,D,F)
 * from variaous variables
 * TODO: calculateGameRating
 */
-(GameRating)calculateGameRating
{
    return kRatingF;
}

#pragma mark -
#pragma mark Getters

/**
 * Determines whether the total number of
 * Lemmings has been reached
 * @return whether or not the Lemming count is maxed
 */
-(BOOL)lemmingsMaxed
{
    return lemmingsAdded == totalNumberOfLemmings;
}

/**
 * Returns the number of Lemmings currently in 
 * the game
 * @return number of Lemmings in game
 */
-(int)lemmingCount
{
    return [lemmings count];
}

/**
 * Returns the number of Lemmings which have been added
 * to the game (not the same as lemmingCount)
 * @return number of Lemmings which have been added
 */
-(int)lemmingsAdded
{
    return lemmingsAdded;
}

/**
 * Returns the number of Lemmings which have been saved
 * @return number of Lemmings which have been saved
 */
-(int)lemmingsSaved
{
    return lemmingsSaved;
}

/**
 * Returns the number of Lemmings which have been killed
 * @return number of Lemmings which have been killed
 */
-(int)lemmingsKilled
{
    return lemmingsKilled;
}

@end
