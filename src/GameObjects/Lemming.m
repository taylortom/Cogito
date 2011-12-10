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

@synthesize health;
@synthesize state;

// animation
@synthesize idleAnim;
@synthesize idleHelmetAnim;
@synthesize walkingAnim;
@synthesize walkingHelmetAnim;
@synthesize deathAnim;
@synthesize floatUmbrellaAnim;

#pragma mark -

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [idleAnim release];
    [idleHelmetAnim release];
    [walkingAnim release];
    [walkingHelmetAnim release];
    [floatUmbrellaAnim release];
    [deathAnim release];
    
    [super dealloc];
}

#pragma mark -

/**
 * Initialisation
 */
-(id) init
{
    self = [super init];
    
    if (self != nil) 
    {
        self.gameObjectType = kLemmingType;
        isUsingHelmet = NO;
        health = 100;
        [self changeState:kStateIdle];
        [self initAnimations];
    }
    return self;
}

/**
 * Loads all of the animations
 */
-(void) initAnimations
{        
    [self setIdleAnim:[self loadAnimationFromPlistWthName:@"idleAnim" andClassName:NSStringFromClass([self class])]];
    [self setIdleHelmetAnim:[self loadAnimationFromPlistWthName:@"idleHelmetAnim" andClassName:NSStringFromClass([self class])]];
    [self setWalkingAnim:[self loadAnimationFromPlistWthName:@"walkingAnim" andClassName:NSStringFromClass([self class])]];
    [self setWalkingHelmetAnim:[self loadAnimationFromPlistWthName:@"walkingHelmetAnim" andClassName:NSStringFromClass([self class])]];
    [self setFloatUmbrellaAnim:[self loadAnimationFromPlistWthName:@"floatUmbrellaAnim" andClassName:NSStringFromClass([self class])]];
    [self setDeathAnim:[self loadAnimationFromPlistWthName:@"deathAnim" andClassName:NSStringFromClass([self class])]];
}

#pragma mark -

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

/**
 * Changes the current state
 */
-(void) changeState: (CharacterStates)newState
{    
    [self stopAllActions];
    id action = nil;
    self.state = newState;
    
    switch (newState) 
    {
        case kStateIdle:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
//            if (isUsingHelmet) action = [CCAnimate actionWithAnimation:idleHelmetAnim restoreOriginalFrame:NO];
//            else action = [CCAnimate actionWithAnimation:idleAnim restoreOriginalFrame:YES];
            break;
        case kStateWalking:
            if(isUsingHelmet) action = [CCAnimate actionWithAnimation:walkingHelmetAnim restoreOriginalFrame:NO];
            else action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
            break;   
        case kStateFloating:
            action = [CCAnimate actionWithAnimation:floatUmbrellaAnim restoreOriginalFrame:NO];
            break;
        case kStateDead:
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
            break;
        default:
            break;
    }
    
    if(action != nil) 
    {
        if(newState != kStateDead) action = [CCRepeatForever actionWithAction:action];
        [self runAction:action];
    }
}

/**
 * Update function called every frame
 */
-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    if(self.state == kStateDead) return; // don't need to do anything if lemming's dead

    /*
     * check for collisions
     */
    
    CGRect selfBBox = [self adjustedBoundingBox];
    
    for (GameObject *gameObject in listOfGameObjects) 
    {
        // no need to check self with self
        if(gameObject == self) continue;
        
        CGRect objectBBox = [gameObject adjustedBoundingBox];
        
        if(CGRectIntersectsRect(selfBBox, objectBBox))
        {
            GameObjectType objectType = [gameObject gameObjectType];
            
            if(objectType == kObstaclePit || 
               objectType == kObstacleStamper || 
               objectType == kObstacleWater || 
               objectType == kObstacleCage) [self changeState:kStateDead];
            else if(objectType == kObjectExit) [self changeState:kStateWin]; 
            else if(objectType == kLemmingType); // do nothing 
        }
    }
    
   /* if([self numberOfRunningActions] == 0) // no anims running
    * { }
    */
    if([self health] <= 0) [self changeState:kStateDead];
}

/**
 * Adjusts the bounding box to the size of the sprite
 */
-(CGRect) adjustedBoundingBox
{
    CGRect bBox = [self boundingBox];
    float xOffset;
    float xCropAmount = bBox.size.width * 0.5482f;
    float yCropAmount = bBox.size.height * 0.095f;
    
    // get the xOffset based on direction of sprite
    if(![self flipX]) xOffset = bBox.size.width * 0.1566f;
    else xOffset = bBox.size.width * 0.4217f;
    
    bBox = CGRectMake(bBox.origin.x, bBox.origin.y, bBox.size.width-xCropAmount, bBox.size.height-yCropAmount);
    
    return bBox;
}

@end
