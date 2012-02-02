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
#import "CogitoAgent.h"
#import "CommonDataTypes.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"
#import "PauseMenuLayer.h"
#import "TerrainLayer.h"

@interface GameplayLayer : CCLayer

{
    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    CCMenu *gameplayMenu;
    CCLabelBMFont *lemmingText;
    CCLabelBMFont *timeText;
    
    TerrainLayer *currentTerrainLayer;
    
    PauseMenuLayer *pauseMenu;
    
    int frameCounter;
}

@end