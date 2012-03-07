//
//  InstructionsLayer.h
//  Author: Thomas Taylor
//
//  Plays the instructions animation
//
//  20/01/2012: Created class
//

#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "SlideViewer.h"

@interface InstructionsLayer : CCLayer

{
    SlideViewer* slideViewer;
    CCMenu *menuButton;
}

@end
