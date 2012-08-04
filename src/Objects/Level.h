//
//  Level.h
//  Author: Thomas Taylor
//
//  Very basic class to hold info about a level
//
//  19/01/2012: Created class
//

#import "CommonDataTypes.h"
#import <Foundation/Foundation.h>

@interface Level : NSObject

{
    int id;
    Difficulty difficulty;
    CGPoint spawnPosition;
    int umbrellaUses;
    int helmetUses;
}

@property (readwrite) int id;
@property (readwrite) Difficulty difficulty;
@property (readwrite) CGPoint spawnPoint;
@property (readwrite) int umbrellaUses;
@property (readwrite) int helmetUses;

@end
