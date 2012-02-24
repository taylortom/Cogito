//
//  AgentStats.h
//  Author: Thomas Taylor
//
//  Used to calculate various stats
//
//  20/02/2011: Created class
//

#import "cocos2d.h"
#import "GameObject.h"

@interface AgentStats : NSObject

{
    int episodesCompleted;
    CCArray* learningLengths;
    CCArray* nonLearningLengths;
    CCArray* learningActions;
    CCArray* nonLearningActions;
}

+(AgentStats*)sharedAgentStats;
-(void)addEpisodeWithLength:(int)_time andActions:(int)_actions learningMode:(BOOL)_learning;
-(void)addEpisode;
-(int)averageTimeLearning;
-(int)averageTimeNonLearning;
-(int)averageActionsLearning;
-(int)averageActionsNonLearning;
-(int)episodesCompleted;
-(void)clearTempData;

@end
