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
-(void)initMenuButtons;
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
 * Initialises the popup image
 */
-(void)initPopup
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    menuPopup = [CCSprite spriteWithFile:@"MenuPopup.png"];
    [menuPopup setAnchorPoint:ccp(0.5,1)];
    [menuPopup setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:menuPopup z:2];
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
    
#pragma mark -

/**
 * Nicely animates all the elements in
 */
-(void)animateIn
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    [screenlock runAction:[CCFadeTo actionWithDuration:0.15f opacity:screenlockOpacity]];    
    [textOverlay runAction:[CCFadeIn actionWithDuration:0.15f]];
    
    [menuPopup setPosition: ccp(winSize.width/2, 0-winSize.height*0.05)];
    id animateInAction = [CCMoveTo actionWithDuration:0.20f position:ccp(winSize.width/2, winSize.height)];
    id easeEffectAction = [CCEaseIn actionWithAction:animateInAction rate:0.20f];
    [menuPopup runAction:easeEffectAction];
}

/**
 * Nicely animates all the elements out
 */
-(void)animateOut
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    [screenlock runAction:[CCFadeTo actionWithDuration:0.15f opacity:0]];
    [textOverlay runAction:[CCFadeOut actionWithDuration:0.15f]];
    
    id animateOutAction = [CCMoveTo actionWithDuration:0.50f position:ccp(winSize.width/2, winSize.height*0.05)]; 
    [menuPopup runAction:animateOutAction];  
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
