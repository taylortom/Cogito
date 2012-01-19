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

-(void)loadPlistFile;
-(void)initTerrainFromPlist:(NSDictionary*)_plist;

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
		
        [self loadPlistFile];
	}
    
	return self;
}

/**
 * Loads the plist file
 */
-(void)loadPlistFile
{        
    // Get path to plist file
    NSString *filename = [NSString stringWithFormat:@"%@.plist", plistFilename];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:filename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) plistPath = [[NSBundle mainBundle] pathForResource:plistFilename ofType:@"plist"];
    
    // Read plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [self initTerrainFromPlist:plistDictionary];
}

/**
 * Initialises the terrain from the supplied plist
 * @param the plist to load from
 */
-(void)initTerrainFromPlist:(NSDictionary*)_plist
{
    // if plistDictionary is empty, display error message
    if(_plist == nil) 
    { 
        CCLOG(@"TerrinLayer.loadTerrainFromPlist: Error reading plist"); 
        return; 
    }
    
    for(NSDictionary *object in _plist)
    {
        // the individual object
        NSDictionary *objectDictionary = [_plist objectForKey:object];
        
        // type refers to terrain/obstacle, objectType refers to stamper, exit, trapdoor etc.
        NSString* type = [objectDictionary objectForKey:@"type"];
        NSString *objectType = [objectDictionary objectForKey:@"objectType"];
        GameObjectType gameObjectType;
        
        // the filename of the image
        NSString* filename = [NSString stringWithFormat:@"%@.png", [objectDictionary objectForKey:@"filename"]];

        // screen coordinates for the object
        float x = [[objectDictionary objectForKey:@"x"] floatValue];
        float y = [[objectDictionary objectForKey:@"y"] floatValue];

        // used in collision detection
        BOOL isWall = [[objectDictionary objectForKey:@"isWall"] boolValue];
        BOOL isCollideable = ([objectDictionary objectForKey:@"isCollideable"] == nil) ? YES : [[objectDictionary objectForKey:@"isCollideable"] boolValue];
        
        /**
         * now actually create the objects
         * from the collected info
         */
        if([type isEqualToString:@"terrain"])
        {
            // set the correct object type
            if([objectType isEqualToString:@"exit"]) gameObjectType = kObjectExit;
            else if([objectType isEqualToString:@"trapdoor"]) gameObjectType = kObjectTrapdoor;
            else gameObjectType = kObjectTerrain;
            
            // initialise the object, and add it to the layer
            Terrain *terrainObject = [[Terrain alloc] initObjectType:(GameObjectType)gameObjectType withPosition:ccp(x,y) andFilename:filename isWall:isWall];
            terrainObject.isCollideable = isCollideable;
            [self addChild:terrainObject z:kTerrainZValue];
            [terrain addObject:terrainObject];
        }
        else if([type isEqualToString:@"obstacle"])
        {            
            // set the correct obstacle type
            if([objectType isEqualToString:@"spikes"]) gameObjectType = kObstaclePit;
            else if([objectType isEqualToString:@"cage"]) gameObjectType = kObstacleCage;
            else if([objectType isEqualToString:@"water"]) gameObjectType = kObstacleWater;
            else if([objectType isEqualToString:@"stamper"]) gameObjectType = kObstacleStamper;
            
            // initialise the obstacle from the plist info
            Obstacle *obstacleObject = [[Obstacle alloc] initObstacleType:gameObjectType withPosition:ccp(x,y) andFilename:filename];
            
            // add the obstacle to the layer
            [obstacles addObject:obstacleObject];
            [self addChild:obstacleObject z:kObstacleZValue];
        }
    }
    
    // let the game manager know the level has loaded
    [GameManager sharedGameManager].levelLoaded = YES;
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
