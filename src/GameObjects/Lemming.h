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
    int health;
    CharacterStates state; 
    CCSpriteFrame *standingFrame;
    Direction movementDirection;
    // number of pixels moved per animation cycle
    int movementAmount;
    // how many respawns the character has
    int respawns;
    bool isUsingHelmet;
    
    // idle and walking animations
    CCAnimation *idleAnim;
    CCAnimation *idleHelmetAnim;
    CCAnimation *walkingAnim;
    CCAnimation *walkingHelmetAnim;

    // misc animations
    CCAnimation *deathAnim;    
    CCAnimation *floatUmbrellaAnim;
}

@property (readwrite) int health;
@property (readwrite) CharacterStates state; 

// idle and walking animations
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *idleHelmetAnim;
@property (nonatomic, retain) CCAnimation *walkingAnim;
@property (nonatomic, retain) CCAnimation *walkingHelmetAnim;

//misc animations
@property (nonatomic, retain) CCAnimation *deathAnim;
@property (nonatomic, retain) CCAnimation *floatUmbrellaAnim;

-(void)initAnimations;
-(void)respawn;
-(void)checkAndClampSpritePosition;

@end
