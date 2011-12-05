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
    GameObjectType obstacleType;
    float damage;
    CCAnimation *animation;
}

@property (readwrite) GameObjectType obstacleType;
@property (readonly) float damage;
@property (nonatomic, retain) CCAnimation *animation;

@end
