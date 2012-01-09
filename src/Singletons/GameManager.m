//
//  GameManager.m
//  Cogito
//
//  Manages the scenes in the game
//
//  15/12/2011: Created class
//

#import "AboutScene.h"
#import "GameOverScene.h"
#import "GameManager.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "NewGameScene.h"
#import "StingScene.h"

@interface GameManager()

-(void)pauseSchedulerAndActionsRecursive:(CCNode *)node;
-(void)resumeSchedulerAndActionsRecursive:(CCNode *)node;

@end

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
        gamePaused = NO;
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
        case kStingScene:
            sceneToRun = [StingScene node];
            break;
            
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        
        case kNewGameScene:
            sceneToRun = [NewGameScene node];
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
 * Pauses all nodes in the running scene
 */
-(void)pauseGame
{
    [self pauseSchedulerAndActionsRecursive:[CCDirector sharedDirector].runningScene];
    gamePaused = YES;
}

/**
 * Resumes all nodes in the running scene
 */
-(void)resumeGame
{
    [self resumeSchedulerAndActionsRecursive:[CCDirector sharedDirector].runningScene];
    gamePaused = NO;
}

/**
 * Recursively calls pauseSchedulerAndActions to every child of the passed CCNode 
 */
-(void)pauseSchedulerAndActionsRecursive:(CCNode *)node 
{
    [node pauseSchedulerAndActions];
    for (CCNode *child in [node children]) [self pauseSchedulerAndActionsRecursive:child];
}

/**
 * Recursively calls resumeSchedulerAndActions to every child of the passed CCNode 
 */
-(void)resumeSchedulerAndActionsRecursive:(CCNode *)node 
{
    [node resumeSchedulerAndActions];
    for (CCNode *child in [node children]) [self resumeSchedulerAndActionsRecursive:child];
}

#pragma mark -

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
    
    NSString* quotientString = (quotient < 10) ? [NSString stringWithFormat:@"0%i", quotient] : [NSString stringWithFormat:@"%i", quotient];
    NSString* remainderString = (remainder < 10) ? [NSString stringWithFormat:@"0%i", remainder] : [NSString stringWithFormat:@"%i", remainder];
    
    return [NSString stringWithFormat:@"%@:%@", quotientString, remainderString];
}

/**
 * Just returns the time played in seconds
 */
-(int)getGameTimeInSecs
{
    return secondsPlayed;
}

/**
 * Whether the game is currently is paused
 */
-(BOOL)gamePaused
{
    return gamePaused;
}

/**
 * Set the game paused value
 */
-(void)gamePaused:(BOOL)value
{
    if(value != gamePaused) gamePaused = value;
}

@end
