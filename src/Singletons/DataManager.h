//
//  DataManager.h
//  Author: Thomas Taylor
//
//  Manages saving the game data
//
//  21/02/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Constants.h"
#import "LemmingManager.h"

@interface DataManager : NSObject

{    
    // a sub-dictionary for each learning type
    NSMutableDictionary* reinforcementData;
    NSMutableDictionary* decisionTreeData;
    NSMutableDictionary* shortestRouteData;
    NSMutableDictionary* noLearningData;
}

+(DataManager*)sharedDataManager;
-(int)averageEpisodeTimeLearning:(MachineLearningType)_learningType;
-(int)averageEpisodeTimeNonLearning:(MachineLearningType)_learningType;
-(int)averageActionsLearning:(MachineLearningType)_learningType;
-(int)averageActionsNonLearning:(MachineLearningType)_learningType;
-(float)averageAgentsSaved:(MachineLearningType)_learningType;
-(void)addCurrentGameData;
-(void)loadGameData;
-(void)clearGameData;
-(void)exportGameData;
-(void)printData;

@end
