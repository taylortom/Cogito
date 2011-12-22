//
//  NewGameLayer.m
//  Author: Thomas Taylor
//
//  The 'new game' layer
//
//  16/12/2011: Created class
//

#import "NewGameLayer.h"

@interface NewGameLayer()

-(void)onBackButtonPressed;

@end

@implementation NewGameLayer

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
		
		CCSprite *background = [CCSprite spriteWithFile:@"DefaultBackground.png"];
		[background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background];
	}

	return self;
}

#pragma mark -

/**
 * Loads the main menu scene
 */
-(void)onBackButtonPressed 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end