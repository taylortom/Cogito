//
//  TerrainLayer.h
//  Cogito
//
//  A generic 'terrain' layer.
//  each level inherits from this class
//
//  24/12/2011: Created class
//

#import "cocos2d.h"
#import "Obstacle.h"
#import "Terrain.h"

@interface TerrainLayer : CCLayer

{
    NSString *plistFilename;
    CCArray *terrain;    // the floor/platform objects
    CCArray *obstacles; 
}
    
-(id)init:(NSString*)_plist;
-(CCArray*)terrain;
-(CCArray*)obstacles;

@end
