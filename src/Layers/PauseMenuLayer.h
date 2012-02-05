//
//  PauseMenuLayer.m
//  Cogito
//
//  Class to contain the pause menu
//
//  22/12/2011: Created class
//

#import "cocos2d.h"
#import "GameManager.h"
#import "LemmingManager.h"

@interface PauseMenuLayer : CCLayer

{
    CCSprite *menuPopup;
    CCMenu *pauseButtons;
    CCLayerColor *screenlock;
    CCSprite *textOverlay;
    int screenlockOpacity;
    
    // if the menu's currently animating
    BOOL animating;
}

-(void)animateIn;
-(void)animateOut;
-(BOOL)animating;

@end
