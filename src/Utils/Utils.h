//
//  Utils.h
//  Author: Thomas Taylor
//
//  A class of static 'util' methods
//
//  18/12/2011: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"

@interface Utils : NSObject

+(int)generateRandomNumberFrom:(int)_min to:(int)_max;
+(NSString*)getTimeStampWithFormat:(NSString*)_format;
+(UIColor*)getUIColourFromRed:(int)_red green:(int)_green blue:(int)_blue;
+(NSString*)secondsToMinutes:(int)_seconds;
+(NSDictionary*)loadPlistFromFile:(NSString*)_filename;
+(void)listAvailableFonts;
+(NSString*)getActionAsString:(Action)_action;
+(NSString*)getBooleanAsString:(BOOL)_bool;
+(NSString*)getLearningTypeAsString:(MachineLearningType)_learningType;
+(NSString*)getObjectAsString:(GameObjectType)_object;
+(NSString*)getRatingAsString:(GameRating)_rating;
+(NSString*)getStateAsString:(CharacterStates)_state;

@end