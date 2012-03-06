//
//  StatsLayer.m
//  Author: Thomas Taylor
//
//  The 'about' layer
//
//  06/03/2012: Created class
//

#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "Slide.h"

@interface StatsLayer : CCLayer

{
    CCMenuItemImage *previousButton;
    CCMenuItemImage *nextButton;
    
    CCMenu *navButtons;
    CCMenu *backButton;
    
    Slide* currentSlide;
    CCArray* slides;
    
    int slideNumber;
    CGPoint centrePosition;
    CGPoint leftPosition;
    CGPoint rightPosition;
    float slideAnimationDuration;
}

@end
