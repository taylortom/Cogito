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
#import "CommonProtocols.h"
#import "Constants.h"
#import "CCLayer.h"
#import <Foundation/Foundation.h>
#import "Lemming.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"


@interface GameplayLayer : CCLayer

{
    int lemmingCount;
    int totalNumberOfLemmings;
    
    SneakyButton *settingsButton; // input    
    CCSpriteBatchNode *sceneSpriteBatchNode;
}

-(void)initButtons;
-(void)addLemming;
-(void)createObjectofType:(GameObjectType)objectType withHealth:(int)health atLocation:(CGPoint)spawnLocation withZValue:(int)zValue;
-(void)update:(ccTime)deltaTime;
-(void)checkButtons;
-(void)listAvailableFonts;

@end