//
//  Lemming.h
//  Author: Thomas Taylor
//
//  Code for the lemming characters
//
//  21/11/2011: Created class
//

#import "LemmingManager.h"
#import "CogitoAgent.h"
#import <Foundation/Foundation.h>

@interface Lemming : CogitoAgent

{
    int health;
    CharacterStates state; 
    CCSpriteFrame *standingFrame;
    Direction movementDirection;
    int movementAmount;             // number of pixels moved per animation cycle
    int respawns;                   // number of respawns
    bool isUsingHelmet;
    
    int ID;                         // a unique ID, used for debugging
    CCLabelBMFont *debugLabel;      // text label used for debugging 
    
    // idle and walking animations
    CCAnimation *idleAnim;
    CCAnimation *idleHelmetAnim;
    CCAnimation *walkingAnim;
    CCAnimation *walkingHelmetAnim;

    // misc animations
    CCAnimation *openUmbrellaAnim;
    CCAnimation *floatUmbrellaAnim;
    CCAnimation *deathAnim;    
}

@property (readwrite) int health;
@property (readwrite) CharacterStates state; 

@property (readwrite) int ID; 
@property (nonatomic,retain) CCLabelBMFont *debugLabel;

// idle and walking animations
@property (nonatomic,retain) CCAnimation *idleAnim;
@property (nonatomic,retain) CCAnimation *idleHelmetAnim;
@property (nonatomic,retain) CCAnimation *walkingAnim;
@property (nonatomic,retain) CCAnimation *walkingHelmetAnim;

//misc animations
@property (nonatomic,retain) CCAnimation *openUmbrellaAnim;
@property (nonatomic,retain) CCAnimation *floatUmbrellaAnim;
@property (nonatomic,retain) CCAnimation *deathAnim;

-(void)changeState: (CharacterStates)newState;
-(void)changeDirection;

@end
