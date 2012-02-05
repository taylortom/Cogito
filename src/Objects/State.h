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
    float reward;
    
    // holds actions with corresponding Q-values
    CCArray* actions;
}

-(id)initStateForObject:(GameObject*)_object withReward:(float)_reward;
-(float)calculateMaxQValue;
-(Action)getOptimumAction;
-(float)getQValueForAction:(Action)_action;
-(void)setQValue:(float)_qValue forAction:(Action)_action;
-(CCArray*)getActions;
-(void)setActions:(CCArray*)_actions;
-(GameObject*)getGameObject;
-(float)getReward;

@end
