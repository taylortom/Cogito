//
//  GameObject.h
//  Author: Thomas Taylor
//
//  A base class for all game objects
//
//  21/11/2011: Created class
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CommonProtocols.h"

@interface GameObject : CCSprite

{
    BOOL isActive;
    BOOL reactsToScreenBoundaries;
    CGSize winSize;
    GameObjectType gameObjectType;
}

@property (readwrite) BOOL isActive;
@property (readwrite) BOOL reactsToScreenBoundaries;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;

-(void)changeState:(CharacterStates)_newState;
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray*)_listOfGameObjects;
-(CGRect)adjustedBoundingBox;
-(CCAnimation*)loadAnimationFromPlistWthName:(NSString*)_animationName andClassName:(NSString*)_className;

@end
