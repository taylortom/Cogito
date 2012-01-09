//
//  Terrain.m
//  Cogito
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
        filename = _filename;
        isWall = _isWall;
        [self setPosition:_position];
        
        // set the display frame
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename]];
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

}

/**
 * Updates the object, called every frame
 * @param deltaTime
 * @param listOfGameObjects
 */
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray *)_listOfGameObjects
{
    [super updateStateWithDeltaTime:_deltaTime andListOfGameObjects:_listOfGameObjects];
}

/**
 * Compensates for any transparent space
 * @return the new bounding box
 */
-(CGRect)adjustedBoundingBox
{
    return [self boundingBox];
}

@end
