//
//  Slide.h
//  Author: Thomas Taylor
//
//  Used in the SlideViewer
//
//  06/03/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Utils.h"

@interface Slide : CCSprite

{
    CCSprite* background;
}

-(id)initWithImage:(NSString*)_imageName;
-(void)update;

@end
