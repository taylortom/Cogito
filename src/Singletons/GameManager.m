//
//  GameManager.m
//  Cogito
//
//  Manages the scenes in the game
//
//  15/12/2011: Created class
//

//#import "Constants.h"
#import "GameManager.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "SettingsScene.h"
#import "AboutScene.h"
#import "GameCompleteScene.h"

@implementation GameManager

static GameManager* _sharedGameManager = nil;

+(GameManager*)sharedGameManager
{
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager) [[self alloc] init];
        return _sharedGameManager;
    }
    
    return nil;
}

-(id)alloc
{
    @synchronized([GameManager class])
    {
        // if the _sharedGameManager already exists, stop
        NSAssert(_sharedGameManager == nil, @"There should only ever be one instance of GameManager");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    
    return nil;
}

-(id)init 
{        
    self = [super init];
    
    if (self != nil) 
    {
        currentScene = kNoSceneUninitialised;
    }
    
    return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID
{
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;
    
    switch (sceneID) 
    {
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        
        case kSettingsScene:
            sceneToRun = [SettingsScene node];
            break;
            
        case kAboutScene:
            sceneToRun = [AboutScene node];
            break;
            
        case kGameCompleteScene:
            sceneToRun = [GameCompleteScene node];
            break;
            
        case kGameLevelScene:
            sceneToRun = [GameScene node];
            break;
            
        default:
            CCLOG(@"Error: Unknown scene ID");
            break;
    }
    
    if(sceneToRun == nil) 
    {
        currentScene = oldScene;
        return;
    }
    
    
    // dont think I need this resizing stuff
    /*if(sceneID < 100) // must be menu scene
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        [sceneToRun setScaleX:0.4688f];
        [sceneToRun setScaleY:0.4166f];
    }*/
    
    // do we need to replace the scene?
    if([[CCDirector sharedDirector] runningScene] == nil) [[CCDirector sharedDirector] runWithScene:sceneToRun];
    else [[CCDirector sharedDirector] replaceScene:sceneToRun];
}

@end
