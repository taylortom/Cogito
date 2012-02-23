//
//  GameManager.h
//  Author: Thomas Taylor
//
//  Manages the scenes in the game
//
//  15/12/2011: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import <Foundation/Foundation.h>
#import "Level.h"

@interface GameManager : NSObject

{
    CCArray* levelData;
    Difficulty chosenDifficulty;
    SceneTypes currentScene;
    Level* currentLevel;
    BOOL gamePaused;
    BOOL debugMode;
}

@property (readonly) SceneTypes currentScene;
@property (readwrite, retain) Level* currentLevel;
@property (readwrite) BOOL gamePaused;
@property (readwrite) Difficulty chosenDifficulty;

+(GameManager*)sharedGameManager;
-(void)loadLevelData;
-(void)loadRandomLevel;
-(void)runSceneWithID:(SceneTypes)_sceneID;
-(void)pauseGame;
-(void)resumeGame;
-(void)incrementSecondCounter;
-(void)resetSecondCounter;
-(NSString*)getGameTimeInMins;
-(int)getGameTimeInSecs;
-(BOOL)debug;
-(void)setDebug:(BOOL)_debug;

@end
