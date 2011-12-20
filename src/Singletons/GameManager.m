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
#import "GameOverScene.h"

@implementation GameManager

@synthesize currentScene;

static GameManager* _instance = nil;
static int secondsPlayed;

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
        [[CCDirector sharedDirector] setAnimationInterval: 1.0/kFrameRate];
        currentScene = kNoSceneUninitialised; 
        secondsPlayed = 0;
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
            sceneToRun = [GameOverScene node];
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
    
    // do we need to replace the scene?
    if([[CCDirector sharedDirector] runningScene] == nil) [[CCDirector sharedDirector] runWithScene:sceneToRun];
    else if(sceneID == kMainMenuScene) [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:0.75 scene:sceneToRun]];
    else [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.75 scene:sceneToRun]];    
}

/**
 * Increments the second counter
 */
-(void)incrementSecondCounter
{
    secondsPlayed++;
}

/**
 * Resets the second counter to 0
 */
-(void)resetSecondCounter
{
    secondsPlayed = 0;
}

/**
 * Converts the secondsPlayed into a string
 * in the format mm:ss
 */
-(NSString*)getGameTimeInMins
{
    int quotient = floor(secondsPlayed/60);
    int remainder = fmod(secondsPlayed, 60);
    
    NSString* quotientString = quotient;
    NSString* remainderString = remainder;
        
    if(quotient < 10) quotientString = [NSString stringWithFormat:@"0%i", quotient];
    if(remainder < 10) remainderString = [NSString stringWithFormat:@"0%i", remainder];
    
    return [NSString stringWithFormat:@"%@:%@", quotientString, remainderString];
}

@end
