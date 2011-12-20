//
//  StingScene.m
//  Author: Thomas Taylor
//
//  The intro animation scene
//
//  13/11/2011: Created class
//

#import "StingScene.h"

@implementation StingScene

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
        StingLayer *stingLayer = [StingLayer node];
        [self addChild:stingLayer];
    }
    
    return self;
}

@end
