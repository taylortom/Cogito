//
//  CommonProtocols.h
//  Author: Thomas Taylor
//
//  Some common protocols...
//
//  21/11/2011: Created class
//

#ifndef Cogito_CommonProtocols_h
#define Cogito_CommonProtocols_h

#endif

typedef enum
{
    kDirectionLeft,
    kDirectionRight,
} PhaserDirection;

typedef enum
{
    kStateSpawning,
    kStateIdle,
    kStateCrouching,
    kStateStandingUp,
    kStateWalking,
    kStateAttacking,
    kStateJumping,
    kStateAfterJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateTravelling,
    kStateRotating,
    kStateDrilling,
} CharacterStates;

typedef enum
{
    kObjectTypeNone,
    kPowerUpTypeHealth,
    kPowerUpTypeMallet,
    kEnemyTypeRadarDish,
    kEnemyTypeSpaceCargoShip,
    kEnemyTypeAlienRobot,
    kEnemyTypePhaser,
    kVikingType,
    kSkullType,
    kRockType,
    kMeteorType,
    kFrozenVikingType,
    kIceType,
    kLongBlockType,
    kCartType,
    kSpikesType,
    kDiggerType,
    kGroundType
} GameObjectType;

@protocol GameplayLayerDelegate

-(void)createObjectOfType:(GameObjectType)objectType withHealth:(int)initialHealth atLocation:(CGPoint)spawnLocation withZValue:(int)zValue;
-(void)createPhaserWithDirection:(PhaserDirection)phaserDirection andPosition:(CGPoint)spawnPosition;

@end