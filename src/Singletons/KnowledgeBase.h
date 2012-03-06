//
//  KnowledgeBase.h
//  Author: Thomas Taylor
//
//  A shared knowledge base used by the lemmings
//
//  18/02/2011: Created class
//

#import "cocos2d.h"
#import "GameManager.h"
#import "GameObject.h"
#import "LemmingManager.h"
#import "Obstacle.h"
#import "QState.h"
#import "TreeState.h"

@interface KnowledgeBase : NSObject

{
    // reinforcement
    CCArray* gameStates;
    
    // shortest route
    CCArray* routes;      
}

+(KnowledgeBase*)sharedKnowledgeBase;
-(QState*)getStateForGameObject:(GameObject*)_object;
-(void)exportKnowledgeBase;
-(void)clearKnowledgeBase;

@end
