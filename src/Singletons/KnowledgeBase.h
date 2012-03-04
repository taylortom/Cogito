//
//  KnowledgeBase.h
//  Author: Thomas Taylor
//
//  A shared knowledge base used by the lemmings
//
//  18/02/2011: Created class
//

#import "cocos2d.h"
#import "GameObject.h"
#import "Obstacle.h"
#import "QState.h"

@interface KnowledgeBase : NSObject

{
    CCArray* gameStates;
}

+(KnowledgeBase*)sharedKnowledgeBase;
-(QState*)getStateForGameObject:(GameObject*)_object;
-(void)exportKnowledgeBase;
-(void)clearKnowledgeBase;

@end
