//
//  GameCompleteScene.m
//  Author: Thomas Taylor
//
//  The game complete scene
//
//  16/12/2011: Created class
//

#import "GameCompleteScene.h"
#import "GameCompleteLayer.h"

@implementation GameCompleteScene

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
		GameCompleteLayer *gameCompleteLayer = [GameCompleteLayer node];
		[self addChild:gameCompleteLayer];
	}
    
	return self;
}

@end

