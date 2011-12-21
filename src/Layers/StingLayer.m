//
//  StingLayer.m
//  Cogito
//
//  The intro layer
//
//  16/12/2011: Created class
//


#import "StingLayer.h"

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
        
		CCSprite *background = nil;
		background = [CCSprite spriteWithFile:@"DefaultBackground.png"];
		[background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background];
                
        [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
	}
    
	return self;
}

@end
