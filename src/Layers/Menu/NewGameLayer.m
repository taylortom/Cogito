//
//  NewGameLayer.m
//  Author: Thomas Taylor
//
//  The 'new game' layer
//
//  16/12/2011: Created class
//

#import "NewGameLayer.h"

@implementation NewGameLayer

#pragma mark -
#pragma mark Initialisation

-(id)init 
{
	self = [super init];
	
    if (self != nil) 
    {
		CGSize screenSize = [CCDirector sharedDirector].winSize; 
		
		CCSprite *background = [CCSprite spriteWithFile:@"DefaultBackground.png"];
		[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:background];
	}

	return self;
}

#pragma mark -

-(void)returnToMainMenu 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end