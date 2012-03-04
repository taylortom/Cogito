//
//  PauseMenuLayer.m
//  Author: Thomas Taylor
//
//  Class to contain the pause menu
//
//  22/12/2011: Created class
//

#import "PauseMenuLayer.h"

@interface PauseMenuLayer()

-(void)initScreenlock;
-(void)initTextOverlay;
-(void)initPopup;
-(void)initHUDText;
-(void)initMenuButtons;
-(void)updateHUDText;
-(void)onResumePressed;
-(void)onQuitPressed;

@end

@implementation PauseMenuLayer

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the layer
 * @return self
 */
-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        screenlockOpacity = 110;
        
        [self initScreenlock];
        [self initTextOverlay];
        [self initPopup];
        [self initHUDText];
        [self initMenuButtons];
        
        [self scheduleUpdate]; // set the update method to be called every frame
    }
    
    return self;
}

/**
 * Initialises the screenlock
 */
-(void)initScreenlock
{
    screenlock = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
    [screenlock setOpacity:0];
    [self addChild:screenlock z:0];
}

/**
 * Initialises the 'game paused' overlay
 */
-(void)initTextOverlay
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    textOverlay = [CCSprite spriteWithFile:@"TextOverlay.png"];
    [textOverlay setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:textOverlay z:1];
}

/**
 * Adds the HUD text
 */
-(void)initHUDText
{    
    HUDTextLeft = [CCLabelBMFont labelWithString:@"" fntFile:@"bangla_light_HUD.fnt"];
    [HUDTextLeft setAnchorPoint:ccp(0,1)];
    [HUDTextLeft setPosition:ccp(55, 300)];
    [HUDPopup addChild:HUDTextLeft];
   
    HUDTextRight = [CCLabelBMFont labelWithString:@"" fntFile:@"bangla_light_HUD.fnt"];
    [HUDTextRight setAnchorPoint:ccp(1,1)];
    [HUDTextRight setPosition:ccp(425, 300)];
    [HUDPopup addChild:HUDTextRight];
    
    [self updateHUDText];
}

/**
 * Initialises the popup image
 */
-(void)initPopup
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    // menu
    menuPopup = [CCSprite spriteWithFile:@"MenuPopup.png"];
    [menuPopup setAnchorPoint:ccp(0.5,1)];
    [menuPopup setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:menuPopup z:2];
    
    // HUD
    HUDPopup = [CCSprite spriteWithFile:@"MenuHUD.png"];
    [HUDPopup setAnchorPoint:ccp(0.5,0)];
    [HUDPopup setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:HUDPopup z:3];
}

/**
 * Initialises the menu buttons
 */
-(void)initMenuButtons
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    //create the menu buttons
    CCMenuItemImage *resumeButton = [CCMenuItemImage itemFromNormalImage:@"Resume.png" selectedImage:@"Resume_down.png" disabledImage:nil target:self selector:@selector(onResumePressed)];
    CCMenuItemImage *quitButton = [CCMenuItemImage itemFromNormalImage:@"Quit.png" selectedImage:@"Quit_down.png" disabledImage:nil target:self selector:@selector(onQuitPressed)];
    [resumeButton setAnchorPoint:ccp(0, 0.5)];
    [quitButton setAnchorPoint:ccp(0, 0.5)];
    
    // create menu with the items
    pauseButtons = [CCMenu menuWithItems:resumeButton, quitButton, nil];
    
    // position the menu
    [pauseButtons alignItemsVerticallyWithPadding:winSize.height * 0.059f];
    [pauseButtons setAnchorPoint:ccp(0, 0.5)];
    [pauseButtons setPosition:ccp(winSize.width*0.18, winSize.height*0.2)];
    [menuPopup addChild:pauseButtons z:1];
}

#pragma mark -
#pragma mark Update

/**
 * Method called every frame
 * @param delta time
 */ 
-(void)update:(ccTime)deltaTime
{
    animating = ([menuPopup numberOfRunningActions] != 0) ? YES : NO;
}

/**
 * Updates the HUD display with the latest stats
 */
-(void)updateHUDText
{
    AgentStats* as = [AgentStats sharedAgentStats];
    GameManager* gm = [GameManager sharedGameManager];
    LemmingManager* lm = [LemmingManager sharedLemmingManager];
    
    [HUDTextLeft setString:[NSString stringWithFormat:@"time elapsed: %@ \nagents remaining: %i \nsaved: %i   killed: %i", [gm getGameTimeInMins], [lm lemmingCount], [lm lemmingsSaved],[lm lemmingsKilled]]];
    [HUDTextRight setString:[NSString stringWithFormat:@"episodes completed: %i \navg. time/episode: %@ \navg. actions/episode: %i", [as episodesCompleted],[Utils secondsToMinutes:[as averageTimeLearning]],[as averageActionsLearning]]];
}
    
#pragma mark -

/**
 * Nicely animates all the elements in
 */
-(void)animateIn
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    [screenlock runAction:[CCFadeTo actionWithDuration:0.15f opacity:screenlockOpacity]];    
    [textOverlay runAction:[CCFadeIn actionWithDuration:0.15f]];
    
    // menu animation
    [menuPopup setPosition: ccp(winSize.width/2, winSize.height/2)];
    id animateInAction = [CCMoveTo actionWithDuration:0.25f position:ccp(winSize.width/2, winSize.height)];
    id pauseGame = [CCCallFunc actionWithTarget:self selector:@selector(pauseGame)];
    animateInAction = [CCSequence actions:animateInAction, pauseGame, nil];
    [menuPopup runAction:animateInAction];
    
    [self updateHUDText];
    
    // HUD animation
    [HUDPopup setPosition: ccp(winSize.width/2, winSize.height/2)];
    id animateInActionHUD = [CCMoveTo actionWithDuration:0.25f position:ccp(winSize.width/2, 0)];
    [HUDPopup runAction:animateInActionHUD];
}

/**
 * Nicely animates all the elements out
 */
-(void)animateOut
{
    [[GameManager sharedGameManager] resumeGame];
    
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    [screenlock runAction:[CCFadeTo actionWithDuration:0.15f opacity:0]];
    [textOverlay runAction:[CCFadeOut actionWithDuration:0.15f]];
    
    // menu animation
    id animateOutAction = [CCMoveTo actionWithDuration:0.35f position:ccp(winSize.width/2, winSize.height/2)]; 
    [menuPopup runAction:animateOutAction];  
    
    // hud animation
    id animateOutActionHUD = [CCMoveTo actionWithDuration:0.35f position:ccp(winSize.width/2, winSize.height/2)]; 
    [HUDPopup runAction:animateOutActionHUD];  
}

/**
 * Pauses the game
 * Called at the end on the animation
 */ 
-(void)pauseGame
{
    [[GameManager sharedGameManager] pauseGame];
}

#pragma mark -
#pragma mark Event Handling


/**
 * Hide the menu and resume the game
 */ 
-(void)onResumePressed
{
    [self animateOut];
    [[GameManager sharedGameManager] resumeGame];
}

/**
 * Loads the main menu scene
 */
-(void)onQuitPressed
{
    [self animateOut];
    [GameManager sharedGameManager].gamePaused = NO;
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

/**
 * Returns whether the menu is currently animating
 * @return if the menu's animating
 */
-(BOOL)animating
{
    return animating;
}

@end
