//
//  LevelSelectScene.h
//  Author: Thomas Taylor
//
//  The level select scene
//
//  04/08/2012: Created class
//

#import "LevelSelectScene.h"

@implementation LevelSelectScene

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
		LevelSelectLayer *levelSelectLayer = [LevelSelectLayer node];
		[self addChild:levelSelectLayer];
	}
    
	return self;
}

@end
