//
//  GraphSlide.h
//  Author: Thomas Taylor
//
//  A type of slide which displays a graph(!)
//
//  07/03/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "DataManager.h"
#import "Slide.h"
#import "Utils.h"

@interface GraphSlide : Slide

{
    GraphType type;
    
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

@property (readonly) GraphType type;

-(id)initWithImage:(NSString*)_imageName type:(GraphType)_type;

@end
