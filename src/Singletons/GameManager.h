//
//  GameManager.h
//  Cogito
//
//  Manages the scenes in the game
//
//  15/12/2011: Created class
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameManager : NSObject

{
    SceneTypes currentScene;
    BOOL gamePaused;
}

@property (readonly) SceneTypes currentScene;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;
-(void)pauseGame;
-(void)resumeGame;
-(void)incrementSecondCounter;
-(void)resetSecondCounter;
-(NSString*)getGameTimeInMins;
-(int)getGameTimeInSecs;
-(BOOL)gamePaused;
-(void)gamePaused:(BOOL)value;

@end
