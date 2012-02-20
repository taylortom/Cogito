//
//  GameplayLayer.h
//  Author: Thomas Taylor
//
//  The main layer in the game, handles 
//  the main 'gameplay' elements
//
//  13/11/2011: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Constants.h"
#import "DecisionTreeAgent.h"
#import <Foundation/Foundation.h>
#import "GameManager.h"
#import "LemmingManager.h"
#import "PauseMenuLayer.h"
#import "QLearningAgent.h"
#import "ShortestRouteAgent.h"
#import "TerrainLayer.h"
#import "Utils.h"

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