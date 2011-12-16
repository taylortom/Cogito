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
#import "NewGameScene.h"
#import "SettingsScene.h"
#import "AboutScene.h"
#import "GameCompleteScene.h"

@implementation GameManager

static GameManager* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

/**
 * Allocates needed memory
 * @return the instance
 */
+(id)alloc
{    
    @synchronized([GameManager class])
    {
        // if the _instance already exists, stop
        NSAssert(_instance == nil, @"There should only ever be one instance of GameManager");
        _instance = [super alloc];
        return _instance;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the class
 * @return self
 */
-(id)init 
{        
    self = [super init];
    
    if (self != nil) 
    {
        currentScene = kNoSceneUninitialised;
    }
    
    return self;
}

#pragma mark -

/**
 * Returns the GameManager instance
 * @return the instance
 */
+(GameManager*)sharedGameManager
{
    @synchronized([GameManager class])
    {
        if(!_instance) [[self alloc] init];
        return _instance;
    }
    
    return nil;
}



#pragma mark -

/**
 * Runs a specific scene from its ID
 * @param ID of the scene to run
 */
-(void)runSceneWithID:(SceneTypes)sceneID
{
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;
    
    switch(sceneID) 
    {
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        
        case kNewGameScene:
            sceneToRun = [NewGameScene node];
            break;
            
        case kSettingsScene:
            sceneToRun = [SettingsScene node];
            break;
            
        case kAboutScene:
            sceneToRun = [AboutScene node];
            break;
            
        case kGameOverScene:
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
        [sceneToRun setScaleX:0.4688f];
        [sceneToRun setScaleY:0.4166f];
    }*/
    
    // do we need to replace the scene?
    if([[CCDirector sharedDirector] runningScene] == nil) [[CCDirector sharedDirector] runWithScene:sceneToRun];
    else [[CCDirector sharedDirector] replaceScene:sceneToRun];
}

@end
