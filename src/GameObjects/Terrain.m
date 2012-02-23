//
//  Terrain.m
//  Author: Thomas Taylor
//
//  A basic class to contain Terrain relevant data
//
//  05/01/2012: Created class
//

#import "Terrain.h"

@implementation Terrain

@synthesize isWall;

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the object
 * @param position
 * @param filename
 * @param whether terrain is a wall
 * @return self
 */
- (id)initObjectType:(GameObjectType)_type withPosition:(CGPoint)_position andFilename:(NSString*)_filename isWall:(BOOL)_isWall
{    
    self = [super init];
    
    if (self != nil) 
    {              
        
        self.gameObjectType = _type;
        
        if(_type == kObjectTerrainEnd && [[GameManager sharedGameManager] debug]) filename = [NSString stringWithFormat:@"%@%@.png", _filename, @"Fill"];  
        else filename = [NSString stringWithFormat:@"%@.png", _filename];
        
        isWall = _isWall;
        [self setPosition:_position];
        
        // set the display frame
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename]];
    }
    return self;
}

@end
