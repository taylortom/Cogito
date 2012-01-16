//
//  TerrainLayer.m
//  Cogito
//
//  A generic 'terrain' layer.
//  each level inherits from this class
//
//  24/12/2011: Created class
//

#import "TerrainLayer.h"

@interface TerrainLayer()

-(void)loadTerrainFromPlist;

@end

@implementation TerrainLayer

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [super dealloc];
    [terrain release];
    [obstacles release];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the layer
 * @return self
 */
-(id)init:(NSString*)_plist 
{    
	self = [super init];
    
	if (self != nil) 
	{
        plistFilename = _plist;
        
        terrain = [[CCArray alloc] init];
        obstacles = [[CCArray alloc] init];
		
        [self loadTerrainFromPlist];
	}
    
	return self;
}

/**
 * Initialises the terrain from the plist file
 */
-(void)loadTerrainFromPlist
{        
    // Get path to plist file
    NSString *filename = [NSString stringWithFormat:@"%@.plist", plistFilename];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:filename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) plistPath = [[NSBundle mainBundle] pathForResource:plistFilename ofType:@"plist"];
    
    // Read plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // if plistDictionary is empty, throw file not found error
    if(plistDictionary == nil) { CCLOG(@"%@.loadTerrainFromPlist: Error reading plist: %@ from %@", NSStringFromClass([self class]), plistFilename, plistPath); return; }
    
    for(NSDictionary *object in plistDictionary)
    {
        NSDictionary *objectDictionary = [plistDictionary objectForKey:object];
    
        // store the attributes shared by terrain and obstacles
        NSString *type = [objectDictionary objectForKey:@"type"];
        float x = [[objectDictionary objectForKey:@"x"] floatValue];
        float y = [[objectDictionary objectForKey:@"y"] floatValue];
        NSString *filename = [NSString stringWithFormat:@"%@.png", [objectDictionary objectForKey:@"filename"]];
        GameObjectType gameObjectType;
        NSString *objectType = [objectDictionary objectForKey:@"objectType"];
        
        if([type isEqualToString:@"terrain"])
        {
            BOOL isWall = [[objectDictionary objectForKey:@"isWall"] boolValue];
            BOOL isCollideable = [[objectDictionary objectForKey:@"isCollideable"] boolValue];
            if([objectDictionary objectForKey:@"isCollideable"] == nil) isCollideable = YES;
            
            if([objectType isEqualToString:@"exit"]) gameObjectType = kObjectExit;
            else gameObjectType = kObjectTerrain;
            
            Terrain *terrainObject = [[Terrain alloc] initObjectType:(GameObjectType)gameObjectType withPosition:ccp(x,y) andFilename:filename isWall:isWall];
            terrainObject.isCollideable = isCollideable;
            [self addChild:terrainObject];
            [terrain addObject:terrainObject];
        }
        else if([type isEqualToString:@"obstacle"])
        {            
            if([objectType isEqualToString:@"spikes"]) gameObjectType = kObstaclePit;
            else if([objectType isEqualToString:@"cage"]) gameObjectType = kObstacleCage;
            else if([objectType isEqualToString:@"water"]) gameObjectType = kObstacleWater;
            else if([objectType isEqualToString:@"stamper"]) gameObjectType = kObstacleStamper;
                        
            Obstacle *obstacleObject = [[Obstacle alloc] initObstacleType:gameObjectType withPosition:ccp(x,y) andFilename:filename];
            
            if(gameObjectType == kObstacleStamper) [obstacleObject animateObstacleBy:-50 withLength:1.0f alongAxis:kAxisVertical];
            else if(gameObjectType == kObstacleWater) [obstacleObject animateObstacleBy:-10 withLength:2.0f alongAxis:kAxisHorizontal];

            [obstacles addObject:obstacleObject];
            [self addChild:obstacleObject];
        }
    }
}


/**
 * Getters/Setters
 */

#pragma mark -
#pragma mark Getters/Setters

/**
 * Returns the list of terrain objects
 * @return terrain
 */
-(CCArray*)terrain
{
    return terrain;
}


/**
 * Returns the list of obstacle objects
 * @return obstacle
 */
-(CCArray*)obstacles
{
    return obstacles;
}

@end
