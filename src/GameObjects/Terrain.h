//
//  Terrain.h
//  Cogito
//
//  A basic class to contain terrain relevant data
//
//  05/01/2012: Created class
//

#import "GameObject.h"

@interface Terrain : GameObject 

{
    NSString *filename;
    BOOL isWall;
}

@property (readonly) BOOL isWall;

-(id)initWithPosition:(CGPoint)_position andFilename:(NSString*)_filename isWall:(BOOL)_isWall;

@end
