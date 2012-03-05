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
        debugMode = NO;
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
    NSDictionary *plistDictionary = [Utils loadPlistFromFile:kFilenameLevelData];
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
    CCLOG(@"%@.loadRandomLevel: %@", NSStringFromClass([self class]), [Utils getDifficultyAsString:levelDifficulty]);
    
    // temporary storage for levels with the chosen difficulty
    CCArray* tempLevels = [CCArray arrayWithCapacity:0];
    
    for (int i = 0; i < [levelData count]; i++) 
    {
        Level* tempLevel = [levelData objectAtIndex:i];
        if(tempLevel.difficulty == levelDifficulty) [tempLevels addObject:tempLevel];
    }
    
    if([tempLevels count] == 0) CCLOG(@"%@.loadRandomLevel: Error, no level found with difficulty: %@", NSStringFromClass([self class]), [Utils getDifficultyAsString:levelDifficulty]);
        
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
            [[AgentStats sharedAgentStats] clearTempData];
            debugMode = NO;
            break;
        
        case kNewGameScene:
            sceneToRun = [NewGameScene node];
            break;
       
        case kInstructionsScene:
            sceneToRun = [InstructionsScene node];
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
    
    // clear the shared knowledgebase
    [[KnowledgeBase sharedKnowledgeBase] clearKnowledgeBase];
    
    // whether to display the FPS
    [[CCDirector sharedDirector] setDisplayFPS:debugMode];
    
    // seed the random number generator
    srandom(time(NULL));
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
    return [Utils secondsToMinutes:secondsPlayed];
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

/**
 * Sets the difficulty of the current level
 */
-(void)setLevelDifficulty:(Difficulty)_difficulty
{
    levelDifficulty = _difficulty;
}

@end
