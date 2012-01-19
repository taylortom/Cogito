//
//  Utils.h
//  Cogito
//
//  A class of static 'util' methods
//
//  18/12/2011: Created class
//

#import "CommonProtocols.h"
#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(NSString*)getStateAsString:(CharacterStates)_state;
+(NSString*)getObjectAsString:(GameObjectType)_object;
+(NSString*)getRatingAsString:(GameRating)_rating;
+(void)listAvailableFonts;

@end
