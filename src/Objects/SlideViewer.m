//
//  SlideViewer.m
//  Author: Thomas Taylor
//
//  A viewer for Slide objects
//  with navigation
//
//  07/03/2012: Created class
//

#import "SlideViewer.h"

@interface SlideViewer()

-(void)initSlides;
-(void)initNavButtons;
-(void)onPreviousNavButtonPressed;
-(void)onNextNavButtonPressed;
-(void)updateNavButtons;

@end

@implementation SlideViewer

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{    
    [slides release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the state
 * @return self
 */
-(id)initWithSlides:(CCArray*)_slides
{    
    self = [super init];
    
    if (self != nil) 
    {        
        slides = [[CCArray alloc] initWithArray:_slides];
        slideNumber = 0;
        
        CGSize winSize = [CCDirector sharedDirector].winSize; 
        centrePosition = ccp(winSize.width/2, winSize.height/2);
        leftPosition = ccp(0-winSize.width/2, winSize.height/2);
        rightPosition = ccp(winSize.width*1.5, winSize.height/2);
        slideAnimationDuration = 0.75f;
        
        [self initSlides];
        [self initNavButtons];
        [self updateNavButtons];
    }
    return self;
}

#pragma mark -

/**
 * Loads up the slides
 */
-(void)initSlides
{
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

@end
