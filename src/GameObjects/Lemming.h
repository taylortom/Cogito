//
//  Lemming.h
//  Author: Thomas Taylor
//
//  Code for the lemming characters
//
//  21/11/2011: Created class
//

#import <Foundation/Foundation.h>
#import "CogitoAgent.h"

@interface Lemming : CogitoAgent
{
    int characterHealth;
    CharacterStates characterState; 
    CCSpriteFrame *standingFrame;
    float millisecondsIdle;
    Direction direction;
    bool isUsingHelmet;

    /*
     * Animation stuff
     */
    
    // idle and walking
    CCAnimation *idleAnim;
    CCAnimation *idleHelmetAnim;
    CCAnimation *walkingAnim;
    CCAnimation *walkingHelmetAnim;

    // taking damage and dying
    CCAnimation *deathAnim;
    
    // misc
    CCAnimation *floatUmbrellaAnim;
    CCAnimation *goalReachedAnim;
}

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterState; 

/*
 * Animation stuff
 */

// idle and walking
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *idleHelmetAnim;
@property (nonatomic, retain) CCAnimation *walkingAnim;
@property (nonatomic, retain) CCAnimation *walkingHelmetAnim;

// taking damage and dying
@property (nonatomic, retain) CCAnimation *deathAnim;

//misc
@property (nonatomic, retain) CCAnimation *floatUmbrellaAnim;
@property (nonatomic, retain) CCAnimation *goalReachedAnim;

-(void)checkAndClampSpritePosition;
-(void)flip: (Axis)axis;
-(void)move: (float)amountToMove: (Axis)axis;
-(CCSpriteBatchNode*)getSpriteBatchNode;

@end
