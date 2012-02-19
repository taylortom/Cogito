//
//  State.h
//  Author: Thomas Taylor
//
//  Basic class to hold info about a state
//
//  02/02/2012: Created class
//

#import "cocos2d.h"
#import "CommonDataTypes.h"
#import "GameObject.h"

@interface State : NSObject

{
    GameObject* gameObject;
    
    // holds actions
    CCArray* actions;
}

-(id)initStateForObject:(GameObject*)_object;
-(Action)getOptimumAction;
-(CCArray*)getActions;
-(void)setActions:(CCArray*)_actions;
-(GameObject*)getGameObject;

@end
