//
//  Slide.m
//  Author: Thomas Taylor
//
//  Used in the SlideViewer
//
//  06/03/2012: Created class
//

#import "Slide.h"

@implementation Slide

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [background release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the state
 * @return self
 */
-(id)initWithImage:(NSString*)_imageName
{    
    self = [super init];
    
    if (self != nil) 
    {
        background = [CCSprite spriteWithFile:_imageName];
        [self addChild:background];
    }
    return self;
}

#pragma mark -

/**
 * Updates the slide
 */
-(void)update
{
    // do nothing
}

@end
