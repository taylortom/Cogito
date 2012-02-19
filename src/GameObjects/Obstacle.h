//
//  Obstacle.h
//  Author: Thomas Taylor
//
//  A basic class to contain obstacle relevant data
//
//  05/12/2011: Created class
//

#import "GameObject.h"

@interface Obstacle : GameObject 

{ 
    NSString* filename;
}

-(id)initObstacleType:(GameObjectType)_type withPosition:(CGPoint)_position andFilename:(NSString*)_filename;

@end
