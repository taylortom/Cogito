//
//  GameplayLayer.h
//  Author: Thomas Taylor
//
//  13/11/2011: Created class
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"

float buttonDimensions;

// input
SneakyButton *settingsButton;

// sprites
CCSprite *lemmingSprite;
CCSpriteBatchNode *spriteBatchNode;

@interface GameplayLayer : CCLayer

-(id)init;
-(void)initButtons;
-(void)update:(ccTime)deltaTime;
-(void)checkButtons;

@end