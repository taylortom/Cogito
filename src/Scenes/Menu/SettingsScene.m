//
//  SettingsScene.m
//  Author: Thomas Taylor
//
//  The 'settings' scene
//
//  16/12/2011: Created class
//

#import "SettingsScene.h"

@implementation SettingsScene

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
		SettingsLayer *settingsLayer = [SettingsLayer node];
		[self addChild:settingsLayer];
	}
    
	return self;
}

@end
