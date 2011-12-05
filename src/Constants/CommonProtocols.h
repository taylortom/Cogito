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
    kAxisHorizontal,
    kAxisVertical,
} Axis;

typedef enum
{
    kDirectionLeft,
    kDirectionRight,
} Direction;

typedef enum
{
    kStateSpawning,
    kStateIdle,
    kStateWalking,
    kStateDead,
} CharacterStates;

typedef enum
{
    kObjectTypeNone,
    kToolHelmet,
    kToolUmbrella,
    kLemmingType,
    kObstaclePit,
    kObstacleCage,
    kObstacleWater,
    kObstacleStamper
} GameObjectType;

@protocol GameplayLayerDelegate

-(void)createObjectOfType:(GameObjectType)objectType atLocation:(CGPoint)spawnLocation withZValue:(int)zValue;

@end