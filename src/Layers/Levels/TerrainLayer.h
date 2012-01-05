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

@interface TerrainLayer : CCLayer

{
    NSMutableArray *terrain;    // the floor/platform objects
    NSMutableArray *obstacles; 
}
    
-(NSMutableArray*)terrain;
-(NSMutableArray*)obstacles;

@end
