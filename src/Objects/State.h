//
//  State.h
//  Cogito
//
//  Basic class to hold info about a state.
//
//  02/02/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface State : NSObject

{
    GameObject* gameObject;
    CCArray* actions;
    float reward;
}

-(id)initStateForObject:(GameObject*)_object withReward:(float)_reward;
-(GameObject*)getGameObject;
-(CCArray*)getActions;
-(float)getReward;
-(void)setActions:(CCArray*)_actions;

@end
