//
//  TerrainLayer.h
//  Author: Thomas Taylor
//
//  A generic 'terrain' layer.
//  each level inherits from this class
//
//  24/12/2011: Created class
//

#import "cocos2d.h"
#import "GameManager.h"
#import "Obstacle.h"
#import "Terrain.h"
#import "Utils.h"

@interface TerrainLayer : CCLayer

{
    NSString *plistFilename;
    CCArray *terrain;    // the floor/platform objects
    CCArray *obstacles; 
}
    
-(id)init:(int)_levelId;
-(CCArray*)terrain;
-(CCArray*)obstacles;

@end
