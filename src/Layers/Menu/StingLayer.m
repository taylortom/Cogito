//
//  StingLayer.m
//  Author: Thomas Taylor
//
//  The intro 'animation' layer
//
//  16/12/2011: Created class
//

#import "StingLayer.h"

@interface StingLayer()

-(void)displayLogo;
-(void)loadMainMenu;

@end

@implementation StingLayer

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
		CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // add default backdround to make transitions look nicer 
		CCSprite *background = [CCSprite spriteWithFile:kFilenameDefBG];
        [background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background z:0];
        
        [self displayLogo];
	}
    
	return self;
}

/**
 * Loads the logo splash and animates it in/out
 */
- (void)displayLogo
{    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCSprite *splashImage = [CCSprite spriteWithFile:kFilenameSplash];
    splashImage.opacity = 0.0f;
    [splashImage setPosition:ccp(winSize.width/2, winSize.height/2)];
    [self addChild:splashImage z:1];
    
    // create the sequence of actions
    id fadeIn = [CCFadeIn actionWithDuration:0.5f];
    id delay = [CCDelayTime actionWithDuration:2.0f];
    id fadeOut = [CCFadeOut actionWithDuration:0.75f];
    id loadMenu = [CCCallFunc actionWithTarget:self selector:@selector(loadMainMenu)];
    id logoSequence = [CCSequence actions:fadeIn, delay, fadeOut, loadMenu, nil];
    [splashImage runAction:logoSequence];
}

/**
 * Loads the main menu scene
 */
-(void)loadMainMenu 
{
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
