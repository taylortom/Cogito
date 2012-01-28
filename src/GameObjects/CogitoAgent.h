//
//  CogitoAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning
//
//  15/01/2011: Created class
//

#import "GameObject.h"

@interface CogitoAgent : GameObject

{
    BOOL learningMode;
    int helmetUses;
    int umbrellaUses;
}

-(MovementDecision)chooseAction:(GameObjectType) objectType;
-(void)stopLearning;

@property (readwrite) int helmetUses;
@property (readwrite) int umbrellaUses;

@end
