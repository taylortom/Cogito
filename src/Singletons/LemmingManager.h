//
//  LemmingManager.h
//  Author: Thomas Taylor
//
//  Manages the Lemmings in the game
//
//  15/12/2011: Created class
//

#import "AgentStats.h"
#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"
#import "Lemming.h"
#import "DataManager.h"

@interface LemmingManager : NSObject

{
    MachineLearningType learningType;
    int learningEpisodes;
    int totalNumberOfLemmings;
    int lemmingsAdded;
    int lemmingsSaved;
    int lemmingsKilled;
    int spawnsRemaining;
    CCArray* lemmings;
}

+(LemmingManager*)sharedLemmingManager;
-(void)addLemming:(CCSprite*)_lemmingToAdd;
-(void)removeLemming:(CCSprite*)_lemmingToRemove;
-(GameRating)calculateGameRating;
-(MachineLearningType)learningType;
-(void)setLearningType:(MachineLearningType)_learningType;
-(int)learningEpisodes;
-(void)setLearningEpisodes:(int)_learningEpisodes;
-(CCArray*)lemmings;
-(BOOL)lemmingsMaxed;
-(int)lemmingCount;
-(void)setTotalNumberOfLemmings:(int)_lemmingsTotal;
-(int)lemmingsAdded;
-(int)lemmingsSaved;
-(int)lemmingsKilled;
-(void)reset;

@end
