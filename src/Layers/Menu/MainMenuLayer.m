//
//  MainMenuLayer.m
//  Author: Thomas Taylor
//
//  The main menu layer
//
//  16/12/2011: Created class
//

#import "MainMenuLayer.h"

#pragma mark -
#pragma mark Interface

@interface MainMenuLayer()

-(void)playScene:(CCMenuItemFont*)menuItemToPlay;
-(void)buildMainMenu;
-(void)onNewGameButtonPressed;
-(void)onHighScoresButtonPressed;
-(void)onAboutButtonPressed;

@end

@implementation MainMenuLayer

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the scene
 * @return self
 */
-(id)init
{    
    self = [super init];
    
    if (self != nil) 
    {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:ccp(winSize.width/2, winSize.height/2)];
        [self addChild:background];
        [self buildMainMenu];
    }
    
    return self;
}

#pragma mark -

/**
 * Plays the specified scene
 * @param scene to play
 */
-(void)playScene:(CCMenuItemFont*)menuItemToPlay
{
    if([menuItemToPlay tag] == 1) [[GameManager sharedGameManager] runSceneWithID:kSettingsScene];
    else CCLOG(@"Tag %d passed", [menuItemToPlay tag]);
}

/**
 * Displays the main menu
 */
-(void)buildMainMenu
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //create the menu buttons
    CCMenuItemImage *newGameButton = [CCMenuItemImage itemFromNormalImage:@"NewGame.png" selectedImage:@"NewGame_down.png" disabledImage:nil target:self selector:@selector(onNewGameButtonPressed)];
    CCMenuItemImage *instructionsButton = [CCMenuItemImage itemFromNormalImage:@"Instructions.png" selectedImage:@"Instructions_down.png" disabledImage:nil target:self selector:@selector(onInstructionsButtonPressed)];
    //CCMenuItemImage *highScoresButton = [CCMenuItemImage itemFromNormalImage:@"Settings.png" selectedImage:@"Settings_down.png" disabledImage:nil target:self selector:@selector(onAboutButtonPressed)];
    CCMenuItemImage *aboutButton = [CCMenuItemImage itemFromNormalImage:@"About.png" selectedImage:@"About_down.png" disabledImage:nil target:self selector:@selector(onAboutButtonPressed)];
        
    // create menu with the items
    //mainMenu = [CCMenu menuWithItems:newGameButton, highScoresButton, aboutButton, nil];
    mainMenu = [CCMenu menuWithItems:newGameButton, instructionsButton, aboutButton, nil];
    
    // position the menu
    [mainMenu alignItemsVerticallyWithPadding:winSize.height * 0.059f];
    [mainMenu setPosition: ccp(winSize.width * 2, winSize.height * 0.28)];
    
    // create the animations
    id animateInAction = [CCMoveTo actionWithDuration:1.5f position:ccp(winSize.width * 0.80f, winSize.height * 0.28)];
    id easeEffectAction = [CCEaseIn actionWithAction:animateInAction rate:1.5f];
    [mainMenu runAction:easeEffectAction];
    
    // add the menu
    [self addChild:mainMenu z:0 tag:kMainMenuTagValue];
}

#pragma mark -
#pragma mark Button release handlers

/**
 * Displays the new game screen
 */
-(void)onNewGameButtonPressed
{
    [[GameManager sharedGameManager] runSceneWithID:kNewGameScene];
}

/**
 * Displays the settings screen
 */
-(void)onInstructionsButtonPressed
{
    [[GameManager sharedGameManager] runSceneWithID:kInstructionsScene];
}

/**
 * Displays the settings screen
 */
-(void)onHighScoresButtonPressed
{
    CCLOG(@"MainMenuLayer.onHighScoresButtonPressed");
}

/**
 * Displays the about screen
 */
-(void)onAboutButtonPressed
{
    [[GameManager sharedGameManager] runSceneWithID:kAboutScene];
}

@end
