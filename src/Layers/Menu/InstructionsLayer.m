//
//  InstructionsLayer.m
//  Cogito
//
//  Plays the instructions animation
//
//  20/01/2012: Created class
//

#import "InstructionsLayer.h"

@interface InstructionsLayer()

-(void)initBackground;
-(void)initImages;
-(void)initMenuButtons;
-(void)fadeOutCurrent;
-(void)fadeInNext;
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
        numberOfImages = 3;
        images = [[CCArray alloc] initWithCapacity:numberOfImages];
        
		[self initBackground];
        [self initImages];
        [self initMenuButtons];
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
    CCSprite *background = [CCSprite spriteWithFile:@"DefaultBackground.png"];
    [background setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:background z:0];
}

/**
 * Loads the anims images, and stores them in the images array
 */
-(void)initImages
{
    for (int i = 0; i < numberOfImages; i++) 
    {
        CCSprite *image = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Instructions_%i.png", i+1]];
        image.opacity = 0.0f;
        CGPoint imagePosition = ccp([CCDirector sharedDirector].winSize.width/2, [CCDirector sharedDirector].winSize.height/2);
        [image setPosition:imagePosition];
        [self addChild:image z:i];
        [images addObject:image];
    }
}

/**
 * Adds the menu buttons to screen
 */
-(void)initMenuButtons
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // create and add the menu button
    CCMenuItemImage *_menuButton = [CCMenuItemImage itemFromNormalImage:@"Instructions_menu.png" selectedImage:@"Instructions_menu_down.png" disabledImage:nil target:self selector:@selector(loadMainMenu)];
    menuButton = [CCMenu menuWithItems:_menuButton, nil];
    [menuButton alignItemsVerticallyWithPadding:winSize.height * 0.059f];
    [menuButton setPosition: ccp(winSize.width * 0.2, winSize.height * 0.08)];
    [self addChild:menuButton z:100];
    
    // create and add the next button
    CCMenuItemImage *_nextButton = [CCMenuItemImage itemFromNormalImage:@"Instructions_next.png" selectedImage:@"Instructions_next_down.png" disabledImage:nil target:self selector:@selector(fadeOutCurrent)];
    nextButton = [CCMenu menuWithItems:_nextButton, nil];
    [nextButton setPosition: ccp(winSize.width * 0.9, winSize.height * 0.08)];
    [self addChild:nextButton z:100];
    
    currentSequence = 0;
    [self fadeInNext];
}

/**
 * Fades out the current screen
 */
-(void)fadeOutCurrent
{    
    nextButton.visible = NO;
    
    id fadeOut = [CCFadeOut actionWithDuration:0.5f];
    id delay = [CCDelayTime actionWithDuration:0.5f];
    id playNext = [CCCallFunc actionWithTarget:self selector:@selector(fadeInNext)];
    id fadeSequence = [CCSequence actions: fadeOut, delay, playNext, nil];
    
    [[images objectAtIndex:currentSequence-1] runAction:fadeSequence];
}

/**
 * Fades in the next screen
 */
-(void)fadeInNext
{
    if(currentSequence == numberOfImages) return;
    
    id fadeIn = [CCFadeIn actionWithDuration:0.5f];
    [[images objectAtIndex:currentSequence] runAction:fadeIn];
    
    currentSequence++;
    if(currentSequence != numberOfImages) nextButton.visible = YES;
}

/**
 * Loads the main menu scene
 */
-(void)loadMainMenu 
{
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
