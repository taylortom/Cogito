//
//  StatsScene.m
//  Author: Thomas Taylor
//
//  The 'stats' scene
//
//  06/03/2012: Created class
//

#import "StatsScene.h"

@implementation StatsScene

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
		statsLayer = [StatsLayer node];
		[self addChild:statsLayer];
	}
    
	return self;
}

@end
