//
//  StatsLayer.m
//  Author: Thomas Taylor
//
//  The 'stats' layer
//
//  06/03/2012: Created class
//

#import "StatsLayer.h"

@interface StatsLayer()

-(void)initBackground;
-(void)initMenuButton;
-(void)initSlideViewer;
-(void)onBackButtonPressed;

@end

@implementation StatsLayer

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [slideViewer release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the scene
 * @return self
 */
-(id)init
{
    CCLOG(@"%@.init", NSStringFromClass([self class]));
    
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
 * Loads the background image
 */
-(void)initBackground
{
    CGSize winSize = [CCDirector sharedDirector].winSize; 
    CCSprite *background = [CCSprite spriteWithFile:kFilenameDefBG];
    [background setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:background];
}

/**
 * Adds the menu button to the screen
 */
-(void)initMenuButton
{    
    // create the button and add to the menu
    CCMenuItemImage *menuButton = [CCMenuItemImage itemFromNormalImage:@"Back.png" selectedImage:@"Back_down.png" disabledImage:nil target:self selector:@selector(onBackButtonPressed)];
    backButton = [CCMenu menuWithItems:menuButton, nil];
    
    // position and add the menu
    [backButton setPosition: ccp(70, 20)];
    [self addChild:backButton];
}

/**
 * Initialises the slide viewer and adds it to the screen
 */
-(void)initSlideViewer
{
    // create the slides
    CCArray* slides = [CCArray arrayWithCapacity:3];
    [slides addObject:[[GraphSlide alloc] initWithImage:@"EpisodeGraph.png" type:kGraphEpisodeTime]];
    [slides addObject:[[GraphSlide alloc] initWithImage:@"ActionsGraph.png" type:kGraphActions]];
    [slides addObject:[[GraphSlide alloc] initWithImage:@"AgentsSaved.png" type:kGraphAgentsSaved]];
    
    slideViewer = [[SlideViewer alloc] initWithSlides:slides];
    [self addChild:slideViewer];
}

/**
 * Loads the main menu scene
 */
-(void)onBackButtonPressed 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
