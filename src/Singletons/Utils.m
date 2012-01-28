//
//  Utils.h
//  Cogito
//
//  A class of static 'util' methods
//
//  18/12/2011: Created class
//

#import "Utils.h"

@implementation Utils

/**
 * Returns the passed MovementDecision enum as a string
 * @param the action to convert
 * @return the string equivalent
 */
+(NSString*)getActionAsString:(MovementDecision)_action
{
    NSString* action = nil;
    
    switch (_action) 
    {
        case kDecisionLeft:
            action = @"Left";
            break;
            
        case kDecisionLeftHelmet:
            action = @"Left (helmet)";
            break;
            
        case kDecisionRight:
            action = @"Right";
            break;
            
        case kDecisionRightHelmet:
            action = @"Right (helmet)";
            break;
            
        case kDecisionDown:
            action = @"Down";
            break;
            
        case kDecisionDownUmbrella:
            action = @"Down (umbrella)";
            break;
            
        case kDecisionEquipUmbrella:
            action = @"Equip umbrella";
            break;
            
        default:
            action = @"unknown MovementDecision";
            break;
    }
    
    return action;

}

/**
 * Returns the passed GameObjectType enum as a string
 * @param the object to convert
 * @return the string equivalent
 */
+(NSString*)getObjectAsString:(GameObjectType)_object;
{
    NSString* object = nil;
    
    switch (_object) 
    {
        case kObjectTypeNone:
            object = @"None";
            break;
            
        case kObjectExit:
            object = @"Exit";
            break;
            
        case kObjectTrapdoor:
            object = @"Trapdoor";
            break;
            
        case kObjectTerrain:
            object = @"Terrain";
            break;
            
        case kObjectTerrainEnd:
            object = @"Terrain End";
            break;
            
        case kObstaclePit:
            object = @"Pit";
            break;
            
        case kObstacleCage:
            object = @"Cage";
            break;
            
        case kObstacleWater:
            object = @"Water";
            break;
            
        case kObstacleStamper:
            object = @"Stamper";
            break;
            
        default:
            object = @"Unknown GameObject";
            break;
    }
 
    return object;
}

/**
 * Returns the passed GameRating enum as a string
 * @param the rating to convert
 * @return the string equivalent
 */
+(NSString*)getRatingAsString:(GameRating)_rating;
{
    NSString* rating = nil;
    
    switch (_rating) 
    {
        case kRatingA:
            rating = @"A";
            break;
            
        case kRatingB:
            rating = @"B";
            break;
            
        case kRatingC:
            rating = @"C";
            break;
            
        case kRatingD:
            rating = @"D";
            break;
            
        case kRatingF:
            rating = @"F";
            break;
            
        default:
            rating = @"Unknown GameRating";
            break;
    }
  
    return rating;
}

/**
 * Returns the passed CharacterState enum as a string
 * @param the state to convert
 * @return the string equivalent
 */
+(NSString*)getStateAsString:(CharacterStates)_state;
{
    NSString* state = nil;
    
    switch (_state) 
    {
        case kStateSpawning:
            state = @"Spawning";
            break;
            
        case kStateFalling:
            state = @"Falling";
            break;
            
        case kStateIdle:
            state = @"Idle";
            break;
            
        case kStateWalking:
            state = @"Walking";
            break;
            
        case kStateFloating:
            state = @"Floating";
            break;
            
        case kStateDead:
            state = @"Dead";
            break;
            
        case kStateWin:
            state = @"CHARLIE SHEEN";
            break;
            
        default:
            state = @"unknown CharacterState";
            break;
    }
    
    return state;
}


/**
 * Loads a plist with the passed filename
 * @param the filename of the plist
 */
+(NSDictionary*)loadPlistFromFile:(NSString*)_filename
{
    NSString *plistPath;
    
    // Get path to plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%.plist", _filename]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) plistPath = [[NSBundle mainBundle] pathForResource:_filename ofType:@"plist"];
    
    // Read the plist file and return the dictionary
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return plistDictionary;
}

/**
 * Prints out a list of all availiable fonts
 * (in alphabetical order)
 */
+(void)listAvailableFonts
{
    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
    NSArray *fontFamilyNames = [UIFont familyNames];
    
    for (NSString *familyName in fontFamilyNames) 
    {
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        [fontNames addObjectsFromArray:names];
    }
    
    [fontNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"%@", fontNames);
    [fontNames release];
}

@end
