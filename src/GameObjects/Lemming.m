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
#pragma mark Initialisation

/**
 * Initialises the lemming object
 * @return self
 */
-(id) init
{
    self = [super init];
    
    if (self != nil) 
    {
        self.gameObjectType = kLemmingType;
        health = 100;
        movementAmount = 20;
        movementDirection = kDirectionRight;
        respawns = 5;
        isUsingHelmet = NO;
        self.state = kStateIdle;
        
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
 * Changes the current state
 * @param state to change to
 */
-(void) changeState: (CharacterStates)newState
{    
//    if(self.state == kStateDead) return; 
    
    [self stopAllActions];
    id action = nil;
    self.state = newState;
    
    switch (newState) 
    {
        case kStateIdle:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            break;
            
        case kStateWalking:            
            if(isUsingHelmet) action = [CCAnimate actionWithAnimation:walkingHelmetAnim restoreOriginalFrame:NO];
            else action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
            // make the lemming move
            id walkingAction = [CCMoveBy actionWithDuration:1.04f position:ccp((movementDirection == kDirectionLeft) ? movementAmount * -1 : movementAmount, 0.0f)];
            // merge the two actions
            action = [CCSpawn actions: walkingAction, action, nil];         
            break;  
            
        case kStateFloating:
            action = [CCAnimate actionWithAnimation:floatUmbrellaAnim restoreOriginalFrame:NO];
            // make the lemming move
            id floatingAction = [CCMoveBy actionWithDuration:0.75f position:ccp(0.0f, movementAmount*-1)];
            // merge the two actions
            action = [CCSpawn actions: floatingAction, action, nil];         
            break;
            
        case kStateDead:
            if(respawns > 1) 
            {
                action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
                [self respawn];
            }
            // remove the character
            else [self removeFromParentAndCleanup:YES];
            break;
            
        default:
            CCLOG(@"Lemming.changeState: unknown state '%d'", newState);
            break;
    }
    
    // run the animations
    if(action != nil) 
    {
        if(newState != kStateDead) action = [CCRepeatForever actionWithAction:action];
        [self runAction:action];
    }
}

/**
 * Moves the sprite to the spawn-point
 */
-(void)respawn
{
    self.visible = YES;
    
    // do some stuff
    
    respawns--;
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
    
    if([self numberOfRunningActions] == 0)
    {
        if(self.state == kStateDead)
        {
            // do stuff
        }
        /*else if(other check)
        {
            // do other stuff
        }*/
    }
    
    if(self.health <= 0 && self.state != kStateDead) [self changeState:kStateDead];
}

/**
 * Makes sure the lemming stays onscreen
 */
-(void)checkAndClampSpritePosition
{
    CGPoint currentSpritePosition = [self position];
    
    if (currentSpritePosition.y > 110) [self setPosition:ccp(currentSpritePosition.x, currentSpritePosition.y)];    
    
    if(currentSpritePosition.x < 24.0f) [self setPosition:ccp(24.0f, currentSpritePosition.y)];     
    else if(currentSpritePosition.x > 456.0f) [self setPosition:ccp(456.0f, currentSpritePosition.y)];
}

#pragma mark -
#pragma mark Getters/Setters

/**
 * Adjusts the bounding box to the size of the sprite
 * (25% width, 9.5% height)
 * @return the new bounding box
 */
-(CGRect) adjustedBoundingBox
{
    CGRect bBox = [self boundingBox];
    float xCropAmount = bBox.size.width * 0.25;
    float yCropAmount = bBox.size.height * 0.095f;
    
    bBox = CGRectMake(bBox.origin.x, bBox.origin.y, bBox.size.width-xCropAmount, bBox.size.height-yCropAmount);
    
    return bBox;
}

@end
