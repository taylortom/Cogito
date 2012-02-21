//
//  Lemming.h
//  Author: Thomas Taylor
//
//  Code for the lemming characters
//
//  21/11/2011: Created class
//

#import "GameObject.h"
#import "LemmingManager.h"
#import "Obstacle.h"
#import "Terrain.h"
#import "Utils.h"

@interface Lemming : GameObject

{
    int health;
    int respawns;                          
    int fallCounter;
    CCSpriteFrame* standingFrame;
    CharacterStates state; 
    Direction movementDirection;
    GameObjectType objectLastCollidedWith;  
    
    BOOL isUsingHelmet;
    int helmetUses;
    
    BOOL isUsingUmbrella;
    BOOL umbrellaEquipped;
    int umbrellaUses;
    int umbrellaTimer;
    
    int spawnTime;
    int actionsTaken;
    
    CCAnimation* idleAnim;
    CCAnimation* idleHelmetAnim;
    CCAnimation* walkingAnim;
    CCAnimation* walkingHelmetAnim;
    CCAnimation* openUmbrellaAnim;
    CCAnimation* floatUmbrellaAnim;
    CCAnimation* deathAnim;    
    
    // used in debugging
    int ID;                                 
    CCLabelBMFont* debugLabel;              
}

@property (readwrite) int health;
@property (readwrite) CharacterStates state; 

@property (readwrite) int helmetUses;
@property (readwrite) int umbrellaUses;

// idle and walking animations
@property (nonatomic,retain) CCAnimation* idleAnim;
@property (nonatomic,retain) CCAnimation* idleHelmetAnim;
@property (nonatomic,retain) CCAnimation* walkingAnim;
@property (nonatomic,retain) CCAnimation* walkingHelmetAnim;

//misc animations
@property (nonatomic,retain) CCAnimation* openUmbrellaAnim;
@property (nonatomic,retain) CCAnimation* floatUmbrellaAnim;
@property (nonatomic,retain) CCAnimation* deathAnim;

// debugging
@property (readwrite) int ID; 
@property (nonatomic,retain) CCLabelBMFont* debugLabel;

-(void)changeState:(CharacterStates)_newState;
-(void)changeState:(CharacterStates)_newState afterDelay:(float)_delay;
-(void)changeDirection;
-(void)takePath:(Action)_decision;
-(int)respawns;
-(void)onObjectCollision:(GameObject*)_object;
-(void)onEndConditionReached;
-(void)updateDebugLabel;

@end
