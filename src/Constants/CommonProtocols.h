//
//  CommonProtocols.h
//  Author: Thomas Taylor
//
//  Some enums and protocols used 
//  throughout the game
//
//  21/11/2011: Created class
//

#ifndef Cogito_CommonProtocols_h
#define Cogito_CommonProtocols_h

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
    kNoSceneUninitialised       = 0,
    kStingScene                 = 1,
    kMainMenuScene              = 2,
    kNewGameScene               = 3,
    kSettingsScene              = 4,
    kAboutScene                 = 5,
    kGameOverScene              = 6,
    kGameLevelScene             = 101
} SceneTypes;