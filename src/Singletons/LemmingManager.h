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
#import "KnowledgeBase.h"
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
    BOOL sharedKnowledge;
}

@property (readwrite) MachineLearningType learningType;
@property (readwrite) int learningEpisodes;
@property (readwrite) int totalNumberOfLemmings;
@property (readwrite) BOOL sharedKnowledge;

+(LemmingManager*)sharedLemmingManager;
-(void)addLemming:(CCSprite*)_lemmingToAdd;
-(void)removeLemming:(CCSprite*)_lemmingToRemove;
-(GameRating)calculateGameRating;
-(CCArray*)lemmings;
-(BOOL)lemmingsMaxed;
-(int)lemmingCount;
-(int)lemmingsAdded;
-(int)lemmingsSaved;
-(int)lemmingsKilled;
-(void)reset;

@end
