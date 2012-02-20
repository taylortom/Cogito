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
    CCArray* learningLengths;
    CCArray* nonLearningLengths;
    CCArray* learningActions;
    CCArray* nonLearningActions;
}

+(AgentStats*)sharedAgentStats;
-(void)addEpisodeWithLength:(int)_time andActions:(int)_actions learningMode:(BOOL)_learning;
-(int)averageTimeLearning;
-(int)averageTimeNonLearning;
-(int)averageActionsLearning;
-(int)averageActionsNonLearning;

@end
