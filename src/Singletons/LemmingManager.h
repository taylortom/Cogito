//
//  LemmingManager.h
//  Cogito
//
//  Manages the Lemmings in the game
//
//  TODO: add/removeLemming: Change variable type to Lemming
//
//  15/12/2011: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"
#import "Lemming.h"

@interface LemmingManager : NSObject

{
    MachineLearningType learningType;
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
-(CCArray*)lemmings;
-(BOOL)lemmingsMaxed;
-(int)lemmingCount;
-(int)lemmingsAdded;
-(int)lemmingsSaved;
-(int)lemmingsKilled;
-(void)reset;

@end
