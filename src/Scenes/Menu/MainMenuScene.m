//
//  MainMenuScene.m
//  Author: Thomas Taylor
//
//  The main menu
//
//  16/12/2011: Created class
//

#import "MainMenuScene.h"

@implementation MainMenuScene

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
        mainMenuLayer = [MainMenuLayer node];
        [self addChild:mainMenuLayer];
    }
    
    return self;
}

@end
