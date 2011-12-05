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
#import "Lemming.h"

float buttonDimensions;

// input
SneakyButton *settingsButton;

// sprites
Lemming *lemming;

@interface GameplayLayer : CCLayer

-(void)initButtons;
-(void)update:(ccTime)deltaTime;
-(void)checkButtons;

@end