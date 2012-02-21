//
//  Utils.h
//  Author: Thomas Taylor
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
+(NSString*)getActionAsString:(Action)_action
{
    NSString* action = nil;
    
    switch (_action) 
    {
        case kActionLeft:
            action = @"Left";
            break;
            
        case kActionLeftHelmet:
            action = @"Left (helmet)";
            break;
            
        case kActionRight:
            action = @"Right";
            break;
            
        case kActionRightHelmet:
            action = @"Right (helmet)";
            break;
            
        case kActionDown:
            action = @"Down";
            break;
            
        case kActionDownUmbrella:
            action = @"Down (umbrella)";
            break;
            
        case kActionEquipUmbrella:
            action = @"Equip umbrella";
            break;
            
        default:
            action = [NSString stringWithFormat:@"unknown Action: %i", _action];
            break;
    }
    
    return action;

}

/**
 * Returns the passed BOOL as a string
 * @param the BOOL to convert
 * @return the string equivalent
 */
+(NSString*)getBooleanAsString:(BOOL)_bool
{
    return (_bool) ? @"YES" : @"NO";
}

/**
 * Returns the passed MachineLearningType enum as a string
 * @param the learning type to convert
 * @return the string equivalent
 */
+(NSString*)getLearningTypeAsString:(MachineLearningType)_learningType
{
    NSString* learningType = nil;
    
    switch (_learningType) 
    {
        case kLearningMixed:
            learningType = @"Mixed";
            break;
            
        case kLearningReinforcement:
            learningType = @"Reinforcement";
            break;
            
        case kLearningTree:
            learningType = @"Tree";
            break;
            
        case kLearningShortestRoute:
            learningType = @"ShortestRoute";
            break;
            
        case kLearningNone:
            learningType = @"None";
            break;
            
        default:
            learningType = @"unknown MachineLearningType";
            break;
    }
    
    return learningType;
    
}

/**
 * Returns the passed GameObjectType enum as a string
 * @param the object to convert
 * @return the string equivalent
 */
+(NSString*)getObjectAsString:(GameObjectType)_object
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
+(NSString*)getRatingAsString:(GameRating)_rating
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
+(NSString*)getStateAsString:(CharacterStates)_state
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
