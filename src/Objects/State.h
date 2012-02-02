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
    // holds actions with corresponding Q-values
    CCArray* actions;
    float reward;
}

-(id)initStateForObject:(GameObject*)_object withReward:(float)_reward;
-(GameObject*)getGameObject;
-(CCArray*)getActions;
-(void)setActions:(CCArray*)_actions;
-(float)getReward;
-(float)getQValueForAction:(Action)_action;
-(void)setQValue:(float)_qValue forAction:(Action)_action;

@end
