//
//  Lemming.h
//  Author: Thomas Taylor
//
//  Code for the lemming characters
//
//  21/11/2011: Created class
//

#import "CogitoAgent.h"
#import <Foundation/Foundation.h>
#import "LemmingManager.h"
#import "Obstacle.h"
#import "Terrain.h"
#import "Utils.h"

@interface Lemming : CogitoAgent

{
    int health;
    CharacterStates state; 
    Direction movementDirection;
    GameObjectType objectLastCollidedWith;
    
    int respawns;                           // number of respawns
    BOOL isUsingHelmet;
    BOOL isUsingUmbrella;
    int fallCounter;
    
    CCSpriteFrame *standingFrame;
    
    // idle and walking animations
    CCAnimation *idleAnim;
    CCAnimation *idleHelmetAnim;
    CCAnimation *walkingAnim;
    CCAnimation *walkingHelmetAnim;

    // misc animations
    CCAnimation *openUmbrellaAnim;
    CCAnimation *floatUmbrellaAnim;
    CCAnimation *deathAnim;    
    
    // debugging        
    int ID;                                 // a unique ID, used for debugging
    CCLabelBMFont *debugLabel;              // text label used for debugging 
}

@property (readwrite) int health;
@property (readwrite) CharacterStates state; 


// idle and walking animations
@property (nonatomic,retain) CCAnimation *idleAnim;
@property (nonatomic,retain) CCAnimation *idleHelmetAnim;
@property (nonatomic,retain) CCAnimation *walkingAnim;
@property (nonatomic,retain) CCAnimation *walkingHelmetAnim;

//misc animations
@property (nonatomic,retain) CCAnimation *openUmbrellaAnim;
@property (nonatomic,retain) CCAnimation *floatUmbrellaAnim;
@property (nonatomic,retain) CCAnimation *deathAnim;

// debugging
@property (readwrite) int ID; 
@property (nonatomic,retain) CCLabelBMFont *debugLabel;

-(void)changeState: (CharacterStates)_newState;
-(void)changeDirection;
-(int)respawns;

@end
