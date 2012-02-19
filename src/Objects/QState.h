//
//  QState.h
//  Author: Thomas Taylor
//
//  Basic class to hold info about a state in Q-learning
//
//  06/02/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "GameObject.h"
#import "State.h"

@interface QState : State

{
    float reward;
}

-(id)initStateForObject:(GameObject*)_object withReward:(float)_reward;
-(float)calculateMaxQValue;
-(Action)getOptimumAction;
-(float)getQValueForAction:(Action)_action;
-(void)setQValue:(float)_qValue forAction:(Action)_action;
-(float)getReward;

@end
