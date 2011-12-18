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

-(void)playScene: (CCMenuItemFont*)menuItemToPlay;
-(void)displayMainMenu;
-(void)onNewGameButtonPressed;
-(void)onSettingsButtonPressed;
-(void)onAboutButtonPressed;

@end

@implementation MainMenuLayer

#pragma mark -
#pragma mark Initialisation

-(id)init
{    
    self = [super init];
    
    if (self != nil) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:ccp(screenSize.width / 2, screenSize.height / 2)];
        [self addChild:background];
        [self displayMainMenu];
    }
    
    return self;
}

#pragma mark -

/**
 * Plays the specified scene
 * @param scene to play
 */
-(void)playScene: (CCMenuItemFont*)menuItemToPlay
{
    if([menuItemToPlay tag] == 1)
    {
        [[GameManager sharedGameManager] runSceneWithID:kSettingsScene];
    }
    else
    {
        // do nothing yet
        CCLOG(@"Tag %d passed", [menuItemToPlay tag]);
    }
}

/**
 * Displays the main menu
 */
-(void)displayMainMenu
{
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //create the menu buttons
    CCMenuItemImage *newGameButton = [CCMenuItemImage itemFromNormalImage:@"Menu_NewGame.png" selectedImage:@"Menu_NewGame_down.png" disabledImage:nil target:self selector:@selector(onNewGameButtonPressed)];
    CCMenuItemImage *settingsButton = [CCMenuItemImage itemFromNormalImage:@"Menu_Settings.png" selectedImage:@"Menu_Settings_down.png" disabledImage:nil target:self selector:@selector(onSettingsButtonPressed)];
    CCMenuItemImage *aboutButton = [CCMenuItemImage itemFromNormalImage:@"Menu_About.png" selectedImage:@"Menu_About_down.png" disabledImage:nil target:self selector:@selector(onAboutButtonPressed)];
        
    // create menu with the items
    mainMenu = [CCMenu menuWithItems:newGameButton, settingsButton, aboutButton, nil];
    
    // position the menu
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition: ccp(screenSize.width * 2, screenSize.height * 0.28)];
    
    // create the animations
    id animateInAction = [CCMoveTo actionWithDuration:1.2f position:ccp(screenSize.width * 0.80f, screenSize.height * 0.28)];
    id easeEffectAction = [CCEaseIn actionWithAction:animateInAction rate:1.0f];
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
//    [[GameManager sharedGameManager] runSceneWithID:kNewGameScene];
    [[GameManager sharedGameManager] runSceneWithID:kGameLevelScene];
}

/**
 * Displays the settings screen
 */
-(void)onSettingsButtonPressed
{
    [[GameManager sharedGameManager] runSceneWithID:kSettingsScene];
}

/**
 * Displays the about screen
 */
-(void)onAboutButtonPressed
{
    [[GameManager sharedGameManager] runSceneWithID:kAboutScene];
}

@end
