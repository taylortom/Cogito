//
//  PauseMenuLayer.h
//  Author: Thomas Taylor
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
    CCSprite* menuPopup;
    CCSprite* HUDPopup;
    CCSprite* textOverlay;
    
    CCLabelBMFont* HUDTextLeft;
    CCLabelBMFont* HUDTextRight;
    
    CCMenu* pauseButtons;
    CCLayerColor* screenlock;
    int screenlockOpacity;
    
    BOOL animating;
}

-(void)animateIn;
-(void)animateOut;
-(BOOL)animating;

@end
