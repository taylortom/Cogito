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
}

@property (readonly) SceneTypes currentScene;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;
-(void)incrementSecondCounter;
-(void)resetSecondCounter;
-(NSString*)getGameTimeInMins;

@end
