//
//  GameManager.m
//  Author: Thomas Taylor
//
//  Manages the scenes in the game
//
//  15/12/2011: Created class
//

#import "AboutScene.h"
#import "GameOverScene.h"
#import "GameManager.h"
#import "GameScene.h"
#import "InstructionsScene.h"
#import "MainMenuScene.h"
#import "NewGameScene.h"
#import "StingScene.h"

@implementation GameManager

@synthesize currentScene;
@synthesize currentLevel;
@synthesize gamePaused;
@synthesize chosenDifficulty;

static GameManager* _instance = nil;
static int secondsPlayed;

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [levelData release];
    [super dealloc];
}

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
        // set the framerate
        [[CCDirector sharedDirector] setAnimationInterval:1.0/kFrameRate];
        
        currentScene = kNoSceneUninitialised; 
        levelData = [[CCArray alloc] init];
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
#pragma mark Level Data

/**
 * Loads the level data from the LevelData plist file
 */
-(void)loadLevelData
{
    // load plist file
    NSDictionary *plistDictionary = [Utils loadPlistFromFile:@"LevelData"];
    // if plistDictionary is empty, display error message
    if(plistDictionary == nil) { CCLOG(@"GameManager.loadLevelData: Error loading LevelData.plist"); return; }
    
    for(NSDictionary *object in plistDictionary)
    {
        NSDictionary *objectDictionary = [plistDictionary objectForKey:object];        

        NSString* name = [objectDictionary objectForKey:@"name"];
        int umbrellaUses = [[objectDictionary objectForKey:@"umbrellaUses"] intValue];
        int helmetUses = [[objectDictionary objectForKey:@"helmetUses"] intValue];
        
        NSString* difficultyString = [objectDictionary objectForKey:@"difficulty"];
        Difficulty difficulty = kDifficultyEasy;
        if([difficultyString isEqualToString:@"normal"]) difficulty = kDifficultyNormal;
        else if([difficultyString isEqualToString:@"hard"]) difficulty = kDifficultyHard;
        else if(![difficultyString isEqualToString:@"easy"]) CCLOG(@"GameManager.loadLevelData: difficulty '%@' not recognised, using 'easy' as default", difficultyString);        
        
        // set the data, and add to levelData
        Level* level = [[Level alloc] init];
        level.name = name;
        level.difficulty = difficulty;
        level.umbrellaUses = umbrellaUses;
        level.helmetUses = helmetUses;
        
        [levelData addObject:level];
    }    
}

/**
 * Randomly selects a level with the difficulty chosen by the player
 */
-(void)loadRandomLevel
{
    // temporary storage for levels with the chosen difficulty
    CCArray* tempLevels = [[CCArray alloc] init];
    
    for (int i = 0; i < [levelData count]; i++) 
    {
        Level* tempLevel = [levelData objectAtIndex:i];
        if(tempLevel.difficulty == chosenDifficulty) [tempLevels addObject:tempLevel];
    }
        
    // pick a random index and set it as the current level
    int randomIndex = [Utils generateRandomNumberFrom:0 to:[tempLevels count]];
    currentLevel = [tempLevels objectAtIndex:randomIndex];
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
            //sceneToRun = [GameScene node];
            break;
       
        case kInstructionsScene:
            [[DataManager sharedDataManager] clearGameData];
            sceneToRun = [InstructionsScene node];
            break;
            
        case kAboutScene:
            [[DataManager sharedDataManager] printData];
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
    
    // whether to display the FPS
    if(debugMode) [[CCDirector sharedDirector] setDisplayFPS:YES];
}

/**
 * Pauses the running scene
 */
-(void)pauseGame
{
    [[CCDirector sharedDirector] pause];
    gamePaused = YES;
}

/**
 * Resumes the running scene
 */
-(void)resumeGame
{
    [[CCDirector sharedDirector] resume];
    gamePaused = NO;
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
 * @return the formatted time string
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
 * @return seconds played
 */
-(int)getGameTimeInSecs
{
    return secondsPlayed;
}

/**
 * Whether debug mode is on
 */
-(BOOL)debug
{
    return debugMode;
}

/**
 * Enables/disables debug mode
 */
-(void)setDebug:(BOOL)_debug
{
    debugMode = _debug;
}

@end
