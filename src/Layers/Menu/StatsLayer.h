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
#import "GraphSlide.h"
#import "Slide.h"
#import "SlideViewer.h"

@interface StatsLayer : CCLayer

{
    SlideViewer* slideViewer;
    CCMenu *backButton;
}

@end
