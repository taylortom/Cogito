//
//  TerrainLayer.m
//  Cogito
//
//  A generic 'terrain' layer.
//  each level inherits from this class
//
//  24/12/2011: Created class
//

#import "TerrainLayer.h"

@interface TerrainLayer()

-(void)loadTerrainFromPlist;

@end

@implementation TerrainLayer

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
		[self loadTerrainFromPlist];
	}
    
	return self;
}

/**
 *
 */
-(void)loadTerrainFromPlist
{
    CCLOG(@"%@.loadTerrainFromPlist", NSStringFromClass([self class]));
    
    NSString *filename = [NSString stringWithFormat:@"%.plist",NSStringFromClass([self class])];
    
    
    // Get path to plist file
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:filename];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) plistPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"plist"];
    
    
    // Read plist file
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    // if plistDictionary is empty, throw file not found error
    
    if(plistDictionary == nil) CCLOG(@"%@.loadTerrainFromPlist: Error reading plist: %@.plist", NSStringFromClass([self class]),NSStringFromClass([self class]));
    
    
    // get the mini-dictionary for the animation
    
    //NSDictionary *terrainObjects = [plistDictionary objectForKey:@"terrain"];
    if(plistDictionary == nil) CCLOG(@"No terrain objects found");
    else CCLOG(@"Number of terrain objects: %i", [plistDictionary count]);
    
    
    
    // get the delay value for the animation
    
    /*float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    
    // add the frames to the animation
    
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) 
    {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }*/
}


/**
 * Getters/Setters
 */

#pragma mark -
#pragma mark Getters/Setters

/**
 * Returns the list of terrain objects
 * @return terrain
 */
-(NSMutableArray*)terrain
{
    // do stuff
    return nil;
}


/**
 * Returns the list of obstacle objects
 * @return obstacle
 */
-(NSMutableArray*)obstacles
{
    // do stuff
    return nil;
}

@end
