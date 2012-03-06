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
-(void)initSlides;
-(void)initNavButtons;
-(void)initMenuButton;
-(void)onPreviousNavButtonPressed;
-(void)onNextNavButtonPressed;
-(void)updateNavButtons;
-(void)onBackButtonPressed;

@end

@implementation StatsLayer

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [slides release];
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
        slides = [[CCArray alloc] init];
        slideNumber = 0;
        
        CGSize winSize = [CCDirector sharedDirector].winSize; 
        centrePosition = ccp(winSize.width/2, winSize.height/2);
        leftPosition = ccp(0-winSize.width/2, winSize.height/2);
        rightPosition = ccp(winSize.width*1.5, winSize.height/2);
        slideAnimationDuration = 0.75f;
        
		[self initBackground];
        [self initSlides];
        [self initNavButtons];
        [self initMenuButton];
        
        [self updateNavButtons];
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
 * Loads up the 3 slides
 */
-(void)initSlides
{
    [slides addObject:[[Slide alloc] initWithImage:@"EpisodeGraph.png" graph:kGraphEpisodeTime]];
    [slides addObject:[[Slide alloc] initWithImage:@"ActionsGraph.png" graph:kGraphActions]];
    [slides addObject:[[Slide alloc] initWithImage:@"AgentsSaved.png" graph:kGraphAgentsSaved]];
    
    for (int i = 0; i < [slides count]; i++)
    {
        Slide* slide = [slides objectAtIndex:i];
        [self addChild:slide];
        [slide update];
        
        if(i == 0) 
        {
            currentSlide = slide;
            slide.position = centrePosition;
        }
        else slide.position = rightPosition;
    }
}

/**
 * Adds the nav buttons to the screen
 */
-(void)initNavButtons
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //create the buttons
    previousButton = [CCMenuItemImage itemFromNormalImage:@"Previous.png" selectedImage:@"Previous_down.png" disabledImage:nil target:self selector:@selector(onPreviousNavButtonPressed)];
    nextButton = [CCMenuItemImage itemFromNormalImage:@"Next.png" selectedImage:@"Next_down.png" disabledImage:nil target:self selector:@selector(onNextNavButtonPressed)];
    
    // create menu with the items
    navButtons = [CCMenu menuWithItems:previousButton, nextButton, nil];
    
    // position the menu
    [nextButton setPosition:ccp(nextButton.position.x+420, nextButton.position.y)];
    [navButtons setPosition: ccp(30, winSize.height/2)];
    
    // add the menu
    [self addChild:navButtons];
}

/**
 * Adds the menu button to the screen
 */
-(void)initMenuButton
{    
    // create the button
    CCMenuItemImage *menuButton = [CCMenuItemImage itemFromNormalImage:@"Back.png" selectedImage:@"Back_down.png" disabledImage:nil target:self selector:@selector(onBackButtonPressed)];
    
    // create menu
    backButton = [CCMenu menuWithItems:menuButton, nil];
    
    // position the menu
    [backButton setPosition: ccp(70, 20)];
    
    // add the menu
    [self addChild:backButton];
}

#pragma mark -
#pragma mark Event Handling

/**
 * Moves to the previous slide
 */
-(void)onPreviousNavButtonPressed 
{    
    if([currentSlide numberOfRunningActions] > 0) return;
    
	slideNumber--;
    
    // animate out
    id animateOutAction = [CCMoveTo actionWithDuration:slideAnimationDuration position:rightPosition];
    [currentSlide runAction:animateOutAction];
    
    currentSlide = [slides objectAtIndex:slideNumber];
    
    // animate in
    id animateInAction = [CCMoveTo actionWithDuration:slideAnimationDuration position:centrePosition];
    [currentSlide runAction:animateInAction];
    
    [self updateNavButtons];
}

/**
 * Moves to the next slide
 */
-(void)onNextNavButtonPressed 
{        
    if([currentSlide numberOfRunningActions] > 0) return;
    
	slideNumber++;
    
    // animate out
    id animateOutAction = [CCMoveTo actionWithDuration:slideAnimationDuration position:leftPosition];
    [currentSlide runAction:animateOutAction];
    
    currentSlide = [slides objectAtIndex:slideNumber];
    
    // animate in
    id animateInAction = [CCMoveTo actionWithDuration:slideAnimationDuration position:centrePosition];
    [currentSlide runAction:animateInAction];
    
    [self updateNavButtons];
}

-(void)updateNavButtons
{
    int disabledOpacity = 50;
    
    // enable/disable the previous button as appropriate
    BOOL previousEnabled = (slideNumber > 0) ? YES : NO;
    [previousButton setIsEnabled:previousEnabled];
    [previousButton setOpacity:(previousEnabled) ? 255 : disabledOpacity];
    
    // enable/disable the next button as appropriate
    BOOL nextEnabled = (slideNumber < [slides count]-1) ? YES : NO;
    [nextButton setIsEnabled:nextEnabled];
    [nextButton setOpacity:(nextEnabled) ? 255 : disabledOpacity];
}

/**
 * Loads the main menu scene
 */
-(void)onBackButtonPressed 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
