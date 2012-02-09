//
//  Constants.h
//  Author: Thomas Taylor
//
//  Constants used in the game
//
//  21/11/2011: Created class
//

#ifndef Cogito_Constants_h
#define Cogito_Constants_h

#define DEBUG_MODE              0

#define kFrameRate              60.0f

#define kDefaultLargeFont       @"bangla_dark.fnt"
#define kDefaultSmallFont       @"bangla_dark_small.fnt"

#define kRLearningRate          0.4f
#define kRLDiscountFactor       0.9f
#define kRLRandomProbability    2.0f
#define kRLDefaultReward        -2.0f
#define kRLWinReward            100.0f
#define kRLDeathReward          -100.0f
#define kRLStateIndex           0
#define kRLActionIndex          1
#define kRLQValueIndex          2
#define KRLLearningEpisodes     15
#define kDefaultDebugFont       @"andale_debug.fnt"

#define kLemmingMovementAmount  20
#define kLemmingFallTime        0.85f
#define kLemmingRespawns        3
#define kLemmingTotal           1
#define kLemmingSpawnSpeed      1.0f

#define kUISpriteZValue         300
#define kTerrainZValue          50
#define kObstacleZValue         10

#define kLemmingSpriteZValue    100
#define kLemmingSpriteTagValue  0

#define kMainMenuTagValue       10
#define kSceneMenuTagValue      20

#endif