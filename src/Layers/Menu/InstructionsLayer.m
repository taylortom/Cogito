//
//  InstructionsLayer.m
//  Author: Thomas Taylor
//
//  Plays the instructions animation
//
//  20/01/2012: Created class
//

#import "InstructionsLayer.h"

@interface InstructionsLayer()

-(void)initBackground;
-(void)initSlideViewer;
-(void)initMenuButton;
-(void)loadMainMenu;

@end

@implementation InstructionsLayer

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
        [self initMenuButton];
        [self initSlideViewer];
	}
    
	return self;
}

/**
 * Loads the background image and adds it to screen
 */
-(void)initBackground
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // add default backdround to make transitions look nicer 
    CCSprite *background = [CCSprite spriteWithFile:kFilenameDefBG];
    [background setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:background z:0];
}

/**
 * Initialises and adds the slide viewer
 */
-(void)initSlideViewer
{
    // create the slides
    CCArray* slides = [CCArray arrayWithCapacity:3];
    [slides addObject:[[Slide alloc] initWithImage:@"InstructionsIntroduction.png"]];
    [slides addObject:[[Slide alloc] initWithImage:@"InstructionsNewGame.png"]];
    [slides addObject:[[Slide alloc] initWithImage:@"InstructionsLevel.png"]];
    [slides addObject:[[Slide alloc] initWithImage:@"InstructionsPause.png"]];
    [slides addObject:[[Slide alloc] initWithImage:@"InstructionsGameOver.png"]];
    
    slideViewer = [[SlideViewer alloc] initWithSlides:slides];
    [self addChild:slideViewer];
}

/**
 * Adds the menu buttons to screen
 */
-(void)initMenuButton
{
    // create and add the menu button
    CCMenuItemImage *_menuButton = [CCMenuItemImage itemFromNormalImage:@"Back.png" selectedImage:@"Back_down.png" disabledImage:nil target:self selector:@selector(loadMainMenu)];
    menuButton = [CCMenu menuWithItems:_menuButton, nil];
    [menuButton setPosition: ccp(80, 25)];
    [self addChild:menuButton z:100];
}

/**
 * Loads the main menu scene
 */
-(void)loadMainMenu 
{
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
