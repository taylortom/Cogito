//
//  SlideViewer.h
//  Author: Thomas Taylor
//
//  A viewer for Slide objects
//  with navigation
//
//  07/03/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Slide.h"
#import "Utils.h"

@interface SlideViewer : CCSprite

{
    CCMenuItemImage *previousButton;
    CCMenuItemImage *nextButton;
    
    CCMenu *navButtons;
    
    Slide* currentSlide;
    CCArray* slides;
    
    int slideNumber;
    CGPoint centrePosition;
    CGPoint leftPosition;
    CGPoint rightPosition;
    float slideAnimationDuration;
}

-(id)initWithSlides:(CCArray*)_slides;
-(int)currentSlide;

@end
