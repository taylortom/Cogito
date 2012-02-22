//
//  InstructionsScene.m
//  Author: Thomas Taylor
//
//  Plays the instructions animation
//
//  13/11/2011: Created class
//

#import "InstructionsScene.h"

@implementation InstructionsScene

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
        InstructionsLayer *instructionsLayer = [InstructionsLayer node];
        [self addChild:instructionsLayer];
    }
    
    return self;
}

@end
