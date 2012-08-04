//
//  LevelSelectLayer.h
//  Author: Thomas Taylor
//
//  The level select layer
//
//  04/08/2012: Created class
//

#import "LevelSelectLayer.h"

@interface LevelSelectLayer()

-(void)initBackground;
-(void)initButtons;
-(void)initLevelSelect;
-(void)onContinueButtonPressed;
-(void)onBackButtonPressed;

@end

@implementation LevelSelectLayer

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
		[self initBackground];
        [self initButtons];
        [self initLevelSelect];
	}
    
	return self;
}

/**
 * Initialises the background image
 */
-(void)initBackground
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // add the background image
    CCSprite *background = [CCSprite spriteWithFile:@"DefaultBackground.png"];
    [background setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:background];
    
    // add the banner with the titles
    CCSprite *banner = [CCSprite spriteWithFile:@"LevelSelectBanner.png"];
    [banner setAnchorPoint:ccp(0,0.5)];
    [banner setPosition:ccp(0, 255)];
    [self addChild:banner z:kUIZValue];
}

/**
 * Initialises the buttons
 */
-(void)initButtons
{
    CCMenuItemImage* backButton = [CCMenuItemImage itemFromNormalImage:@"Back.png" selectedImage:@"Back_down.png" disabledImage:nil target:self selector:@selector(onBackButtonPressed)];
    CCMenuItemImage* continueButton = [CCMenuItemImage itemFromNormalImage:@"Continue.png" selectedImage:@"Continue_down.png" disabledImage:nil target:self selector:@selector(onContinueButtonPressed)];
    
    // intialise the menu
    buttons = [CCMenu menuWithItems:backButton, continueButton, nil];
    [buttons setPosition:ccp(0,0)];
    
    // position the buttons
    [backButton setPosition: ccp(80, 25)];
    [continueButton setPosition: ccp(420, 25)];
    
    // add the menu
    [self addChild:buttons z:kUIZValue];
}

/**
 * Initialises the level select slider
 */
-(void)initLevelSelect
{
    // create the slides
    
    int levelCount = [[GameManager sharedGameManager] getLevelCount];
    CCArray* slides = [CCArray arrayWithCapacity:levelCount];

    for (int i = 1; i <= levelCount; i++)
        [slides addObject:[[Slide alloc] initWithImage:[NSString stringWithFormat:@"Level%i.png", i]]];
    
    slideViewer = [[SlideViewer alloc] initWithSlides:slides];
    [self addChild:slideViewer];
}

/**
 * Loads the main menu scene
 */
-(void)onContinueButtonPressed
{
    [[GameManager sharedGameManager] loadLevel:[slideViewer currentSlide]+1];
	[[GameManager sharedGameManager] runSceneWithID:kGameLevelScene];
}

/**
 * Loads the new game scene
 */
-(void)onBackButtonPressed
{
    [[GameManager sharedGameManager] runSceneWithID:kNewGameScene];
}

@end