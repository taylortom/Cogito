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
        isActive = true;
        gameObjectType = kObjectTypeNone;
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
    CCLOG(@"GameObject.changeState should be overridden");
}

/**
 * Updates the object, called every frame
 * @param deltaTime
 * @param listOfGameObjects
 */
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray *)_listOfGameObjects
{
    CCLOG(@"GameObject.updateStateWithDeltaTime should be overridden");
}

/**
 * Compensates for any transparent space
 * @return the new bounding box
 */
-(CGRect)adjustedBoundingBox
{
    CCLOG(@"GameObject.changeState should be overridden");
    
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
    NSString *filename = [NSString stringWithFormat:@"%.plist",_className];
    NSString *plistPath;
    
    // Get path to plist file
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:filename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) plistPath = [[NSBundle mainBundle] pathForResource:_className ofType:@"plist"];
    
    // Read plist file
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if(plistDictionary == nil) { CCLOG(@"Error reading plist: %@.plist", _className); return nil; }

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
