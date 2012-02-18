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

#define DEBUG_MODE                  1

#define kFrameRate                  60.0f

#define kDefaultLargeFont           @"bangla_dark.fnt"
#define kDefaultSmallFont           @"bangla_dark_small.fnt"
#define kDefaultDebugFont           @"andale_debug.fnt"

#define kLemmingMovementAmount      18
#define kLemmingFallAmount          15
#define kLemmingFallTime            0.8f
#define kLemmingRespawns            3
#define kLemmingTotal               50
#define kLemmingSpawnSpeed          1.5f

#define kLearningType               kLearningReinforcement
#define KLearningEpisodes           3
#define kLearningRandomProbability  0.0f

#define kQLearningSharedKnowledge   YES
#define kQLearningRate              0.4f
#define kQDiscountFactor            0.9f
#define kQDefaultReward             -2.0f
#define kQWinReward                 100.0f
#define kQDeathReward               -100.0f
    
#define kPauseMenuZValue            999
#define kUIZValue                   500
#define kTerrainZValue              50
#define kObstacleZValue             10

#define kLemmingSpriteZValue        100
#define kLemmingSpriteTagValue      0

#define kMainMenuTagValue           10
#define kSceneMenuTagValue          20

#endif