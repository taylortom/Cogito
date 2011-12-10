//
//  GameScene.m
//  Author: Thomas Taylor
//
//  The main 'scene' in the game
//
//  13/11/2011: Created class
//

#import "GameScene.h"

@implementation GameScene

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
        // Background Layer
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:0];
        
        // Gameplay Layer
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:5];
    }
    
    return self;
}

@end
