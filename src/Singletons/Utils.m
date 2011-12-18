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
