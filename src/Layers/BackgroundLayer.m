//
//  BackgroundLayer.m
//  Author: Thomas Taylor
//
//  Handles the background of the game
//
//  13/11/2011: Created class
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the layer
 * @return self
 */
-(id)init 
{
    self = [super init];
    
    if (self != nil) 
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"DefaultBackground.png"];
        [backgroundImage setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
    }
    
    return self;
}  

@end
