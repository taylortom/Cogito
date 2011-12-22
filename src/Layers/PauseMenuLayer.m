//
//  PauseMenuLayer.m
//  Cogito
//
//  Class to contain the pause menu
//
//  22/12/2011: Created class
//

#import "PauseMenuLayer.h"

@interface PauseMenuLayer()

-(void)initScreenlock;
-(void)initPopup;
-(void)initStatsLabel;
-(void)initMenuButtons;
-(void)toggleVisibility;
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
        screenlockOpacity = 150;
        
        [self initScreenlock];
        [self initPopup];
        [self initStatsLabel];
        [self initMenuButtons];
    }
    
    return self;
}

/**
 * Initialises the screenlock
 */
-(void)initScreenlock
{
    screenlock = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
    [screenlock setOpacity:screenlockOpacity];
//    screenlock.isTouchEnabled = NO;
    [self addChild:screenlock z:0];
}

/**
 * Initialises the popup image
 */
-(void)initPopup
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    menuPopup = [CCSprite spriteWithFile:@"MenuPopup.png"];
    [menuPopup setVisible:NO];
    [menuPopup setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:menuPopup z:1];
}

/**
 * Initialises the game stats label
 */
-(void)initStatsLabel
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    NSString *statsString = [NSString stringWithFormat:
                             @"saved: %i \nkilled: %i \ntime: %@",
                             [[LemmingManager sharedLemmingManager] lemmingsSaved],
                             [[LemmingManager sharedLemmingManager] lemmingsKilled],
                             [[GameManager sharedGameManager] getGameTimeInMins]
                             ];

    CCLabelBMFont *statsText = [CCLabelBMFont labelWithString:statsString fntFile:@"bangla_dark_s.fnt"];
    [statsText setAnchorPoint:ccp(1,1)];
    [statsText setPosition:ccp(winSize.width*0.68, winSize.height*0.37)];

    [menuPopup addChild:statsText z:0];
}

/**
 * Initialises the menu buttons
 */
-(void)initMenuButtons
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    
    CCLabelBMFont *resumeButtonLabel = [CCLabelBMFont labelWithString:@"> resume" fntFile:kMenuFont];
    CCMenuItemLabel *resumeButton = [CCMenuItemLabel itemWithLabel:resumeButtonLabel target:self selector:@selector(onResumePressed)];    
    
    CCLabelBMFont *exitButtonLabel = [CCLabelBMFont labelWithString:@"> exit" fntFile:kMenuFont];
    CCMenuItemLabel *exitButton = [CCMenuItemLabel itemWithLabel:exitButtonLabel target:self selector:@selector(onQuitPressed)];
    
    pauseButtons = [CCMenu menuWithItems:resumeButton, exitButton, nil];
    [pauseButtons alignItemsVerticallyWithPadding:-5];
    [pauseButtons setPosition:ccp(winSize.width*0.22f, winSize.height*0.43f)];
    [menuPopup addChild:pauseButtons z:1];
}
    
#pragma mark -

/**
 * Nicely animates all the elements in
 */
-(void)animateIn
{
    [screenlock setOpacity:0];
    [screenlock runAction:[CCFadeTo actionWithDuration:0.15f opacity:screenlockOpacity]];
    
    [menuPopup setScale:0.6f];
    
    // create the zoom sequence
    id show = [CCCallFunc actionWithTarget:self selector:@selector(toggleVisibility)];
    id initialZoom = [CCScaleTo actionWithDuration:0.1f scale:1.05];
    id zoomOut = [CCScaleTo actionWithDuration:0.05f scale:1];
    id zoomInSequence = [CCSequence actions:show, initialZoom, zoomOut, nil];
    [menuPopup runAction:zoomInSequence];
}

/**
 * Nicely animates all the elements out
 */
-(void)animateOut
{
    [screenlock runAction:[CCFadeTo actionWithDuration:0.15f opacity:0]];
    
    id initialZoom = [CCScaleTo actionWithDuration:0.1f scale:1.05];
    id zoomOut = [CCScaleTo actionWithDuration:0.05f scale:0.8];
    id hide = [CCCallFunc actionWithTarget:self selector:@selector(toggleVisibility)];
    id zoomOutSequence = [CCSequence actions:initialZoom, zoomOut, hide, nil];
    [menuPopup runAction:zoomOutSequence];    
}

/**
 * Shows/hides the menu as applicable
 */
-(void)toggleVisibility
{
    if(menuPopup.visible) [menuPopup setVisible:NO];
    else [menuPopup setVisible:YES];
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
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}


@end
