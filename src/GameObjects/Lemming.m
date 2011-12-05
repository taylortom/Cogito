//
//  Lemming.m
//  Author: Thomas Taylor
//
//  Code for the lemming characters
//
//  21/11/2011: Created class
//

#import "Lemming.h"

@implementation Lemming

@synthesize characterHealth;
@synthesize characterState;

// animation
@synthesize idleAnim;
@synthesize idleHelmetAnim;
@synthesize walkingAnim;
@synthesize walkingHelmetAnim;
// taking damage and dying
@synthesize deathAnim;
// misc
@synthesize floatUmbrellaAnim;
@synthesize goalReachedAnim;

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [idleAnim release];
    [idleHelmetAnim release];
    [walkingAnim release];
    [walkingHelmetAnim release];
    [deathAnim release];
    [floatUmbrellaAnim release];
    [goalReachedAnim release];
    
    [super dealloc];
}

-(id) init
{
    self = [super init];
    
    if (self != nil) 
    {
//        // load the sprite atlas
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lemming_atlas.plist"];
//        spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"lemming_atlas.png"];
//        
//        // create the lemming sprite
//        lemmingSprite = [CCSprite spriteWithSpriteFrameName:@"pixel_lemming_anim_1.png"];
//        [spriteBatchNode addChild:lemmingSprite];
//        [lemmingSprite setPosition:CGPointMake(50, 90)];
//        
//        direction = kDirectionRight;
//        
//        CCAnimation *exampleAnim = [CCAnimation animation];
//        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_2.png"]];
//        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_3.png"]];
//        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_4.png"]];
//        id animateAction = [CCAnimate actionWithDuration:0.5f animation:exampleAnim restoreOriginalFrame:YES];
//        id repeatAction = [CCRepeatForever actionWithAction:animateAction];
//        [lemmingSprite runAction:repeatAction];
    }
    return self;
}

/**
 * Clamp for iPhone to make sure object stays onscreen
 */
-(void)checkAndClampSpritePosition
{
    CGPoint currentSpritePosition = [self position];
    
    if (currentSpritePosition.y > 110) [self setPosition:ccp(currentSpritePosition.x, currentSpritePosition.y)];    
    
    if(currentSpritePosition.x < 24.0f) [self setPosition:ccp(24.0f, currentSpritePosition.y)];     
    else if(currentSpritePosition.x > 456.0f) [self setPosition:ccp(456.0f, currentSpritePosition.y)];
}

-(void)move: (float)amountToMove: (Axis)axis;
{    
    if(direction == kDirectionLeft) amountToMove = amountToMove*-1;
        
    CGFloat xPos = self.position.x;
    CGFloat yPos = self.position.y;
    
    if(axis == kAxisVertical) yPos += amountToMove;
    else xPos += amountToMove;
        
    [self setPosition:ccp(xPos, yPos)];
}

/**
 * Flips the lemming on the supplied axis
 */
-(void)flip: (Axis)axis
{
    if (axis == kAxisVertical) 
    {
        self.flipX = TRUE;
        direction = (direction == kDirectionLeft) ? kDirectionRight : kDirectionLeft;
    }
    else self.flipY = TRUE;    
}

#pragma mark -

-(void) changeState: (CharacterStates)newState
{
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) 
    {
        case kStateIdle:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lemming_helm_1"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lemming_anim_1"]];
            break;
        case kStateWalking:
            if(isUsingHelmet) action = [CCAnimate actionWithAnimation:walkingHelmetAnim restoreOriginalFrame:NO];
            else action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
            break;   
        case kStateDead:
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
            break;
        default:
            break;
    }
    
    if(action != nil) [self runAction:action];
}

@end
