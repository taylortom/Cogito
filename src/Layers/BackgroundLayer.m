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
        CCSprite *backgroundImage;
        
        // Set background image depending on device
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) backgroundImage = [CCSprite spriteWithFile:@"blue_background.png"];
     
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        
        [self addChild:backgroundImage z:0 tag:0];
    }
    
    return self;
}  

@end
