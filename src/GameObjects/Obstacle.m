//
//  Obstacle.m
//  Cogito
//
//  A basic class to contain obstacle relevant data
//
//  05/12/2011: Created class
//

#import "Obstacle.h"

@implementation Obstacle

@synthesize animation;

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the object
 * @return self
 */
- (id)initObstacleType:(GameObjectType)_obstacleType withPosition:(CGPoint)_position andFilename:(NSString*)_filename;
{
    CCLOG(@"Obstacle.init");
    
    self = [super init];
    
    if (self != nil) 
    {        
        self.gameObjectType = _obstacleType;
        filename = _filename;
        [self setPosition:_position];
        
        // set the display frame
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_filename]];
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
