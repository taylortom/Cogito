//
//  CommonDataTypes.h
//  Author: Thomas Taylor
//
//  Some useful enum datatypes
//  used throughout the game
//
//  21/11/2011: Created class
//

#ifndef Cogito_CommonDataTypes_h
#define Cogito_CommonDataTypes_h

#endif

typedef enum
{
    kAxisHorizontal,
    kAxisVertical,
} Axis;

typedef enum
{
    kDirectionLeft,
    kDirectionRight,
} Direction;

typedef enum
{
    kDifficultyEasy,
    kDifficultyNormal,
    kDifficultyHard,
} Difficulty;

typedef enum
{
    kLearningReinforcement,
    kLearningTree,
    kLearningShortestRoute,
    kLearningNone,
    kLearningMixed
} MachineLearningType;


typedef enum
{
    kRatingA,
    kRatingB,
    kRatingC,
    kRatingD,
    kRatingF
} GameRating;

typedef enum
{
    kStateSpawning,
    kStateFalling,
    kStateIdle,
    kStateWalking,
    kStateFloating,
    kStateDead,
    kStateWin
} CharacterStates;

typedef enum
{
    kObjectTypeNone,
    kObjectExit,
    kObjectTrapdoor,
    kObjectTerrain,
    kObjectTerrainEnd,
    kToolHelmet,
    kToolUmbrella,
    kLemmingType,
    kObstaclePit,
    kObstacleCage,
    kObstacleWater,
    kObstacleStamper
} GameObjectType;

typedef enum
{
    kActionLeft               = 0,
    kActionLeftHelmet         = 1,
    kActionRight              = 2,
    kActionRightHelmet        = 3,
    kActionDown               = 4,
    kActionDownUmbrella       = 5,
    kActionEquipUmbrella      = 6,
    kTotalActions              
} Action;

typedef enum
{
    kNoSceneUninitialised       = 0,
    kStingScene                 = 1,
    kMainMenuScene              = 2,
    kNewGameScene               = 3,
    kInstructionsScene          = 4,
    kSettingsScene              = 5,
    kAboutScene                 = 6,
    kGameOverScene              = 7,
    kGameLevelScene             = 101
} SceneTypes;