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
    
    // add the bacground image
    CCSprite *background = [CCSprite spriteWithFile:@"DefaultBackground.png"];
    [background setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:background];
}

/**
 * Initialises the buttons
 */
-(void)initButtons
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCMenuItemImage *continueButton = [CCMenuItemImage itemFromNormalImage:@"Continue.png" selectedImage:@"Continue_down.png" disabledImage:nil target:self selector:@selector(onContinueButtonPressed)];
    buttons = [CCMenu menuWithItems:continueButton, nil];
    [buttons alignItemsVerticallyWithPadding:winSize.height * 0.059f];
    [buttons setPosition: ccp(winSize.width * 0.9, winSize.height * 0.065)];
    
    // add the menu
    [self addChild:buttons];
}

/**
 * Initialises the level select slider
 */
-(void)initLevelSelect
{
    // create the slides
    
    int levelCount = [[GameManager sharedGameManager] getLevelCount];
    CCArray* slides = [CCArray arrayWithCapacity:levelCount];

    for (int i = 0; i < levelCount; i++)
        [slides addObject:[[Slide alloc] initWithImage:[NSString stringWithFormat:@"InstructionsLevel.png"]]];
//    [slides addObject:[[Slide alloc] initWithImage:[NSString stringWithFormat:@"Level%i.png", i]]];
    
    slideViewer = [[SlideViewer alloc] initWithSlides:slides];
    [self addChild:slideViewer];
}

/**
 * Loads the main menu scene
 */
-(void)onContinueButtonPressed
{
    CCLOG(@"%@.onContinueButtonPressed", NSStringFromClass([self class]));
    [[GameManager sharedGameManager] loadLevel:[slideViewer currentSlide]];
	[[GameManager sharedGameManager] runSceneWithID:kGameLevelScene];
}

@end