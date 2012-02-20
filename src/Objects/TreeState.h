//
//  TreeState.h
//  Author: Thomas Taylor
//
//  Basic class to hold info about a state in
//  decision tree learning
//
//  09/02/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "GameObject.h"
#import "State.h"

@interface TreeState : State

{
    int nodeValue;
    Action action;
    
    TreeState* parent;
    CCArray* children;
}

-(void)addChild:(TreeState*)_state;
-(CCArray*)getChildren;
-(void)setAsLeafNode:(CharacterStates)_state;
-(void)setParent:(TreeState*)_parent;
-(BOOL)isLeaf;
-(BOOL)isEqualTo:(TreeState*)_state;
-(Action)getAction;
-(void)setAction:(Action)_action;
-(CCArray*)buildRoute:(CCArray*)_route;
-(CCArray*)buildRoutes:(CCArray*)_routes;
-(void)printStructure;

@end
