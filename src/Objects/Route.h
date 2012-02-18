//
//  Route.h
//  Cogito
//
//  Contains data about a specific route
//
//  18/02/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import <Foundation/Foundation.h>
#import "State.h"

@interface Route : NSObject

{
    CCArray* nodes;
    BOOL survived;
}

@property (readwrite) BOOL survived;

-(void)addState:(State*)_state withAction:(Action)_action;
-(CCArray*)getNodes;

@end
