//
//  GameplayLayer.h
//  Author: Thomas Taylor
//
//  The main layer in the game, handles 
//  the main 'gameplay' elements
//
//  13/11/2011: Created class
//

#import "LemmingManager.h"
#import "cocos2d.h"
#import "CommonProtocols.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"
#import "Lemming.h"
#import "PauseMenuLayer.h"

@interface GameplayLayer : CCLayer

{
    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    CCMenu *gameplayMenu;
    CCLabelBMFont *lemmingText;
    CCLabelBMFont *timeText;
    
    PauseMenuLayer *pauseMenu;
    
    int frameCounter;
}

@end