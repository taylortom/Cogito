//
//  LemmingManager.m
//  Author: Thomas Taylor
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
        NSAssert(_instance == nil, @"There should only ever be one instance of LemmingManager");
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
    @synchronized(lemmings) { [lemmings addObject:_lemmingToAdd]; }
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

    @synchronized(lemmings) { [lemmings removeObject:_lemmingToRemove]; }
    [_lemmingToRemove removeAllChildrenWithCleanup:YES];
    [_lemmingToRemove removeFromParentAndCleanup:YES];
    
    if([self lemmingCount] == 0) 
    {
        [[DataManager sharedDataManager] addCurrentGameData];
        [[KnowledgeBase sharedKnowledgeBase] exportKnowledgeBase];
        [[GameManager sharedGameManager] runSceneWithID:kGameOverScene];
    }
}

#pragma mark -

/**
 * Calculates a game rating (A,B,C,D,F)
 * from variaous variables
 * @return the GameRating
 */
-(GameRating)calculateGameRating
{
    // calcuate the base score
    float baseScore = ((float)lemmingsSaved/(float)totalNumberOfLemmings)*100;
    
    // calculate bonuses
    float respawnBonus = (float)spawnsRemaining/((float)kLemmingRespawns*(float)totalNumberOfLemmings)*25;
    float totalBonus = respawnBonus;
    
    // calculate penalties
    float deathPenalty = (float)lemmingsKilled/(float)totalNumberOfLemmings*50;
    float timePenalty = (float)[[GameManager sharedGameManager] getGameTimeInSecs]/60;
    float totalPenalty = timePenalty + deathPenalty;
    
    // calculate the score
    //float score = baseScore + (totalBonus-totalPenalty);
    float score = baseScore - totalPenalty;
    
    CCLOG(@"LemmingManager.calculateGameRating: base: %f bonus: %f penalty: %f score: %f", baseScore, totalBonus, totalPenalty, score);
    
    // convert score into rating
    if(score > 79) return kRatingA;
    if(score > 59) return kRatingB;
    if(score > 39) return kRatingC;
    if(score > 19) return kRatingD;
    else return kRatingF;
}

#pragma mark -
#pragma mark Getters/setters

/**
 * Returns the type of machine learning being used
 * @return the MachineLearningType
 */
-(MachineLearningType)learningType
{
    return learningType;
}

/**
 * Sets the learning type
 * @param the learning type
 */
-(void)setLearningType:(MachineLearningType)_learningType
{
    learningType = _learningType;
}

/**
 * Returns the number of learning episodes
 * @return number of episodes
 */
-(int)learningEpisodes
{
    return learningEpisodes;
}

/**
 * Sets the number of learning episodes
 * @param number of learning episodes
 */
-(void)setLearningEpisodes:(int)_learningEpisodes
{
    learningEpisodes = _learningEpisodes;
}

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

-(void)setTotalNumberOfLemmings:(int)_lemmingsTotal
{
    totalNumberOfLemmings = _lemmingsTotal;
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
