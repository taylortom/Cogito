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

#define DEBUG_MODE                  YES

#define kFrameRate                  60.0f

// filenames
#define kFilenameSplash             @"LogoSplash.png"
#define kFilenameDefBG              @"DefaultBackground.png"

#define kFilenameDefFontLarge       @"bangla_dark_large.fnt"
#define kFilenameDefFontSmall       @"bangla_dark_small.fnt"
#define kFilenameDefFontDebug       @"andale_debug.fnt"

#define kFilenameDefLemmingFrame    @"Lemming_idle_1.png"
#define kFilenameDefAtlas           @"Lemming_atlas"

#define kFilenameDefButton           @"Lemming_atlas"

// Lemming-related
#define kLemmingMovementAmount      18
#define kLemmingFallAmount          15
#define kLemmingFallTime            0.8f
#define kLemmingRespawns            0
#define kLemmingTotal               15
#define kLemmingSpawnSpeed          1.5f

// Learning-related
#define kLearningType               kLearningShortestRoute
#define KLearningEpisodes           5
#define kLearningRandomProbability  0.0f

// Q learning-related
#define kQLearningSharedKnowledge   YES
#define kQLearningRate              0.4f
#define kQDiscountFactor            0.9f
#define kQWinReward                 100.0f
#define kQDeathReward               -100.0f
#define kQToolReward                -5.0f
#define kQDefaultReward             -2.0f
    
// z values
#define kPauseMenuZValue            999
#define kUIZValue                   500
#define kTerrainZValue              50
#define kObstacleZValue             10
#define kLemmingSpriteZValue        100

// tag values
#define kMainMenuTagValue           10
#define kSceneMenuTagValue          20
#define kLemmingSpriteTagValue      0

#endif