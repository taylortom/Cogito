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

-(void)dealloc
{
    [lemmings release];
    [super dealloc];
}

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
        [self reset];
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
 * Resets the relevant variables ready for a new game
 */
-(void)reset
{
    totalNumberOfLemmings = kLemmingTotal;
    lemmingsAdded = 0;
    lemmingsKilled = 0;
    lemmingsSaved = 0;
    lemmings = [[CCArray alloc] init];
}

#pragma mark -

/**
 * Adds a Lemming to the Lemmings list
 * @param the Lemming to add
 */
-(void)addLemming:(Lemming*)_lemmingToAdd
{    
    [lemmings addObject:_lemmingToAdd];
    lemmingsAdded++;
}

/**
 * Removes a Lemming from the Lemmings list
 * @param the Lemming to remove
 */
-(void)removeLemming:(Lemming*)_lemmingToRemove
{        
    if(_lemmingToRemove.state == kStateDead) lemmingsKilled++;
    else 
    {
        lemmingsSaved++;
        spawnsRemaining += [_lemmingToRemove respawns];
    }

    [lemmings removeObject:_lemmingToRemove];
    [_lemmingToRemove removeFromParentAndCleanup:YES];
    
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
    //float bonus = ((float)spawnsRemaining/((float)kLemmingRespawns*(float)kLemmingTotal))*50;
    //float penalty = ((float)lemmingsKilled/(float)kLemmingTotal)+((float)[[GameManager sharedGameManager] getGameTimeInSecs]/10)*25;
    
    float bonus = 0;
    float penalty = (float)[[GameManager sharedGameManager] getGameTimeInSecs]/60;
    float baseScore = ((float)lemmingsSaved/(float)kLemmingTotal)*100;
    
    // calculate the score
    float score = baseScore + (bonus-penalty);
    
    CCLOG(@"LemmingManager.calculateGameRating: bonus: %f penalty: %f score: %f", bonus, penalty, score);
    
    if(score > 79) return kRatingA;
    if(score > 59) return kRatingB;
    if(score > 39) return kRatingC;
    if(score > 19) return kRatingD;
    else return kRatingF;
}

#pragma mark -
#pragma mark Getters

/**
 * Returns the lemmings
 * @return the lemmings
 */
-(CCArray*)lemmings
{
    return lemmings;
}

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
