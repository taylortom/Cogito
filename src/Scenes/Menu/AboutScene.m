//
//  AboutScene.m
//  Author: Thomas Taylor
//
//  The 'about' scene
//
//  16/12/2011: Created class
//

#import "AboutScene.h"

@implementation AboutScene

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
		aboutLayer = [AboutLayer node];
		[self addChild:aboutLayer];
	}
    
	return self;
}

@end
