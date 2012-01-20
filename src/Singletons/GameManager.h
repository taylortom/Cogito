//
//  GameManager.h
//  Cogito
//
//  Manages the scenes in the game
//
//  15/12/2011: Created class
//

#import "CommonProtocols.h"
#import <Foundation/Foundation.h>

@interface GameManager : NSObject

{
    SceneTypes currentScene;
    BOOL levelLoaded;
    BOOL gamePaused;
}

@property (readonly) SceneTypes currentScene;
@property (readwrite) BOOL levelLoaded;
@property (readwrite) BOOL gamePaused;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;
-(void)pauseGame;
-(void)resumeGame;
-(void)incrementSecondCounter;
-(void)resetSecondCounter;
-(NSString*)getGameTimeInMins;
-(int)getGameTimeInSecs;

@end
