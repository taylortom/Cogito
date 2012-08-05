//
//  LevelSelectLayer.h
//  Author: Thomas Taylor
//
//  The level select layer
//
//  04/08/2012: Created class
//

#import "cocos2d.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"
#import "SlideViewer.h"

@interface LevelSelectLayer : CCLayer

{
    SlideViewer* slideViewer;
    CCMenu *buttons;  
}

@end