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

-(void)initTerrainFromPlist;

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
		
        [self initTerrainFromPlist];
	}
    
	return self;
}

/**
 * Initialises the terrain from the level's plist
 */
-(void)initTerrainFromPlist
{
    // load plist file
    NSDictionary *plistDictionary = [Utils loadPlistFromFile:plistFilename];
    // if plistDictionary is empty, display error message
    if(plistDictionary == nil) { CCLOG(@"TerrainLayer.initTerrainFromPlist: Error loading %@.plist", plistFilename); return; }
    
    for(NSDictionary *object in plistDictionary)
    {
        // the individual object
        NSDictionary *objectDictionary = [plistDictionary objectForKey:object];
        
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
        BOOL isWall = ([objectDictionary objectForKey:@"isWall"] == nil) ? NO : [[objectDictionary objectForKey:@"isWall"] boolValue];
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
