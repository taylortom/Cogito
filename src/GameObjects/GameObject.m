//
//  GameObject.m
//  Author: Thomas Taylor
//
//  A base class for all game objects
//
//  21/11/2011: Created class
//

#import "GameObject.h"

@implementation GameObject

@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize isCollideable;
@synthesize gameObjectType;

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the object
 * @return self
 */
-(id)init
{    
    if(self = [super init])
    {
        winSize = [CCDirector sharedDirector].winSize;
        isActive = YES;
        isCollideable = YES;
        gameObjectType = kObjectTypeNone;
        delayCounter = 0;
        incrementDelay = NO;
    }
    
    return self;
}

#pragma mark -

/**
 * Transforms objects from one state to another
 * @param the state to transition to
 */
-(void)changeState:(CharacterStates)_newState
{
    // should be overridden in subclasses
}

/**
 * Updates the object, called every frame
 * @param deltaTime
 * @param listOfGameObjects
 */
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray *)_listOfGameObjects
{
    if(incrementDelay) delayCounter++;
    
    if(delayCounter > delayAmount*kFrameRate)
    {
        [self performSelector:delayMethod];
        incrementDelay = NO;
        delayCounter = 0;
    }
}

/**
 * Calls a method after a specified delay
 * @param method to call
 * @param delay amount
 */
-(void)delayMethodCall:(SEL)_method by:(float)_delay
{
    delayMethod = _method;
    delayAmount = _delay;
    incrementDelay = YES;
}

/**
 * Compensates for any transparent space
 * @return the new bounding box
 */
-(CGRect)adjustedBoundingBox
{
    // should be overridden in subclasses
    
    // return standard bounding box for now
    return [self boundingBox];
}

#pragma mark -
#pragma mark Animation Loading

/**
 * Sets up an animation from its .plist file
 * @param animationName
 * @param className
 * @return the animation
 */
-(CCAnimation*)loadAnimationFromPlistWthName:(NSString*)_animationName andClassName:(NSString*)_className
{
    CCAnimation *animationToReturn = nil;
    NSDictionary *plistDictionary = [Utils loadPlistFromFile:_className];
    if(plistDictionary == nil) { CCLOG(@"GameObject.loadAnimationFromPlistWithName: Error loading %@.plist", _className); return nil; }
    
    // get the mini-dictionary for the animation
    NSDictionary *animationSettings = [plistDictionary objectForKey:_animationName];
    if(animationSettings == nil) { CCLOG(@"Could not locate animation with name: %@", _animationName); return nil; }
    
    // get the delay value for the animation
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:[[animationSettings objectForKey:@"delay"] floatValue]];
    
    // add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) 
    {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    // return the animation
    return animationToReturn;
}

@end
