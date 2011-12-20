//
//  GameOverScene.m
//  Author: Thomas Taylor
//
//  The game over scene
//
//  16/12/2011: Created class
//

#import "GameOverScene.h"
#import "GameOverLayer.h"

@implementation GameOverScene

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
		GameOverLayer *gameOverLayer = [GameOverLayer node];
		[self addChild:gameOverLayer];
	}
    
	return self;
}

@end

