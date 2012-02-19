//
//  GameObject.h
//  Author: Thomas Taylor
//
//  A base class for all game objects
//
//  21/11/2011: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "Constants.h"
#import "Utils.h"

@interface GameObject : CCSprite

{
    BOOL isActive;
    BOOL isCollideable;
    BOOL reactsToScreenBoundaries;
    CGSize winSize;
    GameObjectType gameObjectType;
}

@property (readwrite) BOOL isActive;
@property (readwrite) BOOL isCollideable;
@property (readwrite) BOOL reactsToScreenBoundaries;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;

-(void)changeState:(CharacterStates)_newState;
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray*)_listOfGameObjects;
-(CGRect)adjustedBoundingBox;
-(CCAnimation*)loadAnimationFromPlistWthName:(NSString*)_animationName andClassName:(NSString*)_className;

@end
