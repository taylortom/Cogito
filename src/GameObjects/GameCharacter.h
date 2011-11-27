//
//  GameCharacter.h
//  Author: Thomas Taylor
//
//  21/11/2011: Created class
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject
{
    int characterHealth;
    CharacterStates characterState; 
}

-(void)checkAndClampSpritePosition;
-(int)getWeaponDamage;

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterState; 

@end
