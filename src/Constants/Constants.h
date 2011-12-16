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

#define COCOS2D_DEBUG           2

#define kLemmingSpriteZValue    100
#define kLemmingSpriteTagValue  0
#define kLemmingIdleTimer       3.0f

#define kLemmingSpawnXPos       0.07f 
#define kLemmingSpawnYPos       0.90f

#define kMainMenuTagValue       10
#define kSceneMenuTagValue      20

typedef enum
{
    kNoSceneUninitialised       = 0,
    kMainMenuScene              = 1,
    kSettingsScene              = 2,
    kAboutScene                 = 3,
    kGameCompleteScene          = 4,
    kGameLevelScene             = 101
} SceneTypes;

#endif