//
//  Obstacle.m
//  Author: Thomas Taylor
//
//  A basic class to contain obstacle relevant data
//
//  05/12/2011: Created class
//

#import "Obstacle.h"

@interface Obstacle()

-(void)animateObstacleBy:(int)_movementAmount withLength:(float)_length andDelay:(float)_delay alongAxis:(Axis)_axis;

@end

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
- (id)initObstacleType:(GameObjectType)_type withPosition:(CGPoint)_position andFilename:(NSString*)_filename;
{    
    self = [super init];
    
    if (self != nil) 
    {        
        self.gameObjectType = _type;
        filename = [NSString stringWithFormat:@"%@.png", _filename];
        
        [self setPosition:_position];
        
        // set the display frame
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename]];
        
        // set up the animation if necessary
        if(_type == kObstacleStamper) [self animateObstacleBy:-50 withLength:1.25f andDelay:2.5f alongAxis:kAxisVertical];
        else if(_type == kObstacleWater) [self animateObstacleBy:-15 withLength:2.0f andDelay:0.0f alongAxis:kAxisHorizontal];
    }
    return self;
}

/**
 * Creates and plays a movement action
 * @param amount to move object
 * @param length of animation
 * @param axis of movement
 */
-(void)animateObstacleBy:(int)_movementAmount withLength:(float)_length andDelay:(float)_delay alongAxis:(Axis)_axis 
{    
    id action = nil;
    
    // create and run the action
    if(_axis == kAxisHorizontal)
    {
        action = [CCSequence actions:
                    [CCMoveBy actionWithDuration:_length/2 position:ccp(_movementAmount,0)],
                    [CCMoveBy actionWithDuration:_length/2 position:ccp(_movementAmount*-1,0)], 
                    [CCMoveBy actionWithDuration:_delay position:ccp(0,0)],
                  nil];
    }
    else 
    {
        action = [CCSequence actions:
                  [CCMoveBy actionWithDuration:_length/2 position:ccp(0,_movementAmount)],
                  [CCMoveBy actionWithDuration:_length/2 position:ccp(0,_movementAmount*-1)], 
                  [CCMoveBy actionWithDuration:_delay position:ccp(0,0)],
                  nil];
    }
    
    action = [CCRepeatForever actionWithAction:action];
    [self runAction:action];
}

@end
