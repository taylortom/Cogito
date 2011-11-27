//
//  GameCharacter.m
//  Author: Thomas Taylor
//
//  21/11/2011: Created class
//

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize characterHealth;
@synthesize characterState;

-(void)dealloc
{
    [super dealloc];
}

/**
 * How much damage to give when character attacks
 */
-(int)getWeaponDamage
{
    CCLOG(@"GameCharacter.getWeaponDamage should be overridden");
    
    // Default to zero damage
    return 0;
}

/**
 * Clamp for iPhone to make sure object stays onscreen
 */
-(void)checkAndClampSpritePosition
{
    CGPoint currentSpritePosition = [self position];
    
    if(currentSpritePosition.x < 24.0f) [self setPosition:ccp(24.0f, currentSpritePosition.y)];     
    else if(currentSpritePosition.x > 456.0f) [self setPosition:ccp(456.0f, currentSpritePosition.y)];
}

@end
