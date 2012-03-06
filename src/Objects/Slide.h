//
//  Slide.h
//  Author: Thomas Taylor
//
//  Used in the Stats screen, displays graphs
//  and other information
//
//  06/03/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "DataManager.h"
#import <Foundation/Foundation.h>
#import "Utils.h"

@interface Slide : CCSprite

{
    CCSprite* background;
    
    GraphType graphType;
    
    // the graph bars
    CCSprite* reinforcementBefore;
    CCSprite* reinforcementAfter;
    
    CCSprite* decisionTreeBefore;
    CCSprite* decisionTreeAfter;
    
    CCSprite* shortestRouteBefore;
    CCSprite* shortestRouteAfter;
    
    CCSprite* noneBefore;
    CCSprite* noneAfter;
}

@property (readonly) GraphType graphType;

-(id)initWithImage:(NSString*)_imageName graph:(GraphType)_graphType;
-(void)update;

@end
