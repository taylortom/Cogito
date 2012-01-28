//
//  Level.h
//  Cogito
//
//  Very basic class to hold info about a level
//
//  19/01/2012: Created class
//

#import "CommonDataTypes.h"
#import <Foundation/Foundation.h>

@interface Level : NSObject

{
    NSString* name;
    Difficulty difficulty;
    CGPoint spawnPosition;
    int umbrellaUses;
    int helmetUses;
}

@property (readwrite, retain) NSString* name;
@property (readwrite) Difficulty difficulty;
@property (readwrite) CGPoint spawnPoint;
@property (readwrite) int umbrellaUses;
@property (readwrite) int helmetUses;

@end
