//
//  Obstacle.h
//  Cogito
//
//  A basic class to contain obstacle relevant data
//
//  05/12/2011: Created class
//

#import "GameObject.h"

@interface Obstacle : GameObject 

{ 
    NSString *filename;
    CCAnimation *animation;
}

@property (nonatomic,retain) CCAnimation *animation;

- (id)initObstacleType:(GameObjectType)_obstacleType withPosition:(CGPoint)_position andFilename:(NSString*)_filename;

@end
