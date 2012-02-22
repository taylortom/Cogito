//
//  NewGameScene.m
//  Author: Thomas Taylor
//
//  The 'new game' scene
//
//  16/12/2011: Created class
//

#import "NewGameScene.h"

@implementation NewGameScene

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
		NewGameLayer *newGameLayer = [NewGameLayer node];
		[self addChild:newGameLayer];
	}
    
	return self;
}

@end
