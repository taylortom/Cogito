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

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the object
 * @param type of object
 * @param position
 * @param filename
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

/**
 * Creates and plays a movement action
 * @param amount to move object
 * @param length of animation
 * @param axis of movement
 */
-(void)animateObstacleBy:(int)_movementAmount withLength:(float)_length alongAxis:(Axis)_axis 
{    
    id action = nil;
    
    // create and run the action
    if(_axis == kAxisHorizontal)
    {
        action = [CCSequence actions:
                    [CCMoveBy actionWithDuration:_length/2 position:ccp(_movementAmount,0)],
                    [CCMoveBy actionWithDuration:_length/2 position:ccp(_movementAmount*-1,0)], 
                  nil];
    }
    else 
    {
        action = [CCSequence actions:
                  [CCMoveBy actionWithDuration:_length/2 position:ccp(0,_movementAmount)],
                  [CCMoveBy actionWithDuration:_length/2 position:ccp(0,_movementAmount*-1)], 
                  nil];
    }
    
    action = [CCRepeatForever actionWithAction:action];
    [self runAction:action];
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
