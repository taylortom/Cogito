//
//  Lemming.m
//  Author: Thomas Taylor
//
//  Code for the lemming characters
//
//  21/11/2011: Created class
//

#import "Lemming.h"

@interface Lemming()

-(void)initAnimations;
-(void)updateDebugLabel;
-(void)onObjectCollision:(GameObject*)_obstacle;
-(void)checkLemmingWithinScreenBounds;

@end

@implementation Lemming

@synthesize health;
@synthesize state;

@synthesize ID;
@synthesize debugLabel;

// animation
@synthesize idleAnim;
@synthesize idleHelmetAnim;
@synthesize walkingAnim;
@synthesize walkingHelmetAnim;
@synthesize openUmbrellaAnim;
@synthesize floatUmbrellaAnim;
@synthesize deathAnim;

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    CCLOG(@"Lemming.dealloc");
    [idleAnim release];
    [idleHelmetAnim release];
    [walkingAnim release];
    [walkingHelmetAnim release];
    [openUmbrellaAnim release];
    [floatUmbrellaAnim release];
    [deathAnim release];
    debugLabel = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the lemming object
 * @return self
 */
-(id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        self.gameObjectType = kLemmingType;
        health = 100;
        movementAmount = 20;
        movementDirection = kDirectionRight;
        respawns = 0;
        isUsingHelmet = NO;
        [self changeState:kStateSpawning];
        
        [self initAnimations];
    }
    return self;
}

/**
 * Loads all of the animations
 */
-(void)initAnimations
{        
    [self setIdleAnim:[self loadAnimationFromPlistWthName:@"idleAnim" andClassName:NSStringFromClass([self class])]];
    [self setIdleHelmetAnim:[self loadAnimationFromPlistWthName:@"idleHelmetAnim" andClassName:NSStringFromClass([self class])]];
    [self setWalkingAnim:[self loadAnimationFromPlistWthName:@"walkingAnim" andClassName:NSStringFromClass([self class])]];
    [self setWalkingHelmetAnim:[self loadAnimationFromPlistWthName:@"walkingHelmetAnim" andClassName:NSStringFromClass([self class])]];
    [self setOpenUmbrellaAnim:[self loadAnimationFromPlistWthName:@"openUmbrellaAnim" andClassName:NSStringFromClass([self class])]];
    [self setFloatUmbrellaAnim:[self loadAnimationFromPlistWthName:@"floatUmbrellaAnim" andClassName:NSStringFromClass([self class])]];
    [self setDeathAnim:[self loadAnimationFromPlistWthName:@"deathAnim" andClassName:NSStringFromClass([self class])]];
}

#pragma mark -

/**
 * Changes the current state
 * @param state to change to
 */
-(void)changeState: (CharacterStates)_newState
{        
    [self stopAllActions];
    id action = nil;
    self.state = _newState;
    
    switch(_newState) 
    {
        case kStateSpawning:
            [self setPosition:ccp(winSize.width*kLemmingSpawnXPos, winSize.height*kLemmingSpawnYPos)];
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            respawns--;
            [self changeState:kStateFalling];
            break;

        case kStateFalling:
            action = [CCSpawn actions: [CCMoveBy actionWithDuration:0.15f position:ccp(0.0f, movementAmount*-1)], action, nil];         
            break;
            
        case kStateIdle:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            break;
            
        case kStateWalking:   
            CCLOG(@"Lemming.changeState: %i -> WALKING WALKING WALKING", state != kStateWalking);
            if(isUsingHelmet) action = [CCAnimate actionWithAnimation:walkingHelmetAnim restoreOriginalFrame:NO];
            else action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
            id walkingAction = [CCMoveBy actionWithDuration:1.04f position:ccp((movementDirection == kDirectionLeft) ? movementAmount * -1 : movementAmount, 0.0f)];
            action = [CCSpawn actions: walkingAction, action, nil];         
            break;  
            
        case kStateFloating:
            action = [CCAnimate actionWithAnimation:openUmbrellaAnim restoreOriginalFrame:NO];
            break;
           
        case kStateDead:
            CCLOG(@"Lemming.changeState: DEAD DEAD DEAD");
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
            break;
            
        default:
            CCLOG(@"Lemming.changeState: unknown state '%d'", _newState);
            break;
    }
    
    // run the animations
    if(action != nil) 
    {
        if(_newState != kStateDead && _newState != kStateFloating) action = [CCRepeatForever actionWithAction:action];
        [self runAction:action];
    }
}

/**
 * Changes the direction of the lemming
 */
-(void)changeDirection
{   
    if(movementDirection == kDirectionRight)
    {
        self.flipX = YES;
        movementDirection = kDirectionLeft;
        [self setPosition:ccp(self.position.x-1, self.position.y)];
    }
    else
    {
        self.flipX = NO;
        movementDirection = kDirectionRight;
        [self setPosition:ccp(self.position.x+1, self.position.y)];
    }
    
    [self changeState:kStateWalking];
}

/**
 * Applies the appropriate action when 
 * a Lemming collides with an object
 */
-(void)onObjectCollision:(GameObject*)_object
{
    switch([_object gameObjectType]) 
    {
        case kObstaclePit:
        case kObstacleWater:
            [self changeState:kStateDead];
            break;
            
        case kObstacleStamper:
        case kObstacleCage:
            health -= health*kStamperDamage;
            break;

        case kObjectTerrain:
            if(state != kStateWalking && ![_object isWall]) [self changeState:kStateWalking];
            else if([_object isWall]) [self changeDirection];
            break;
        
        case kObjectExit:
            [self changeState:kStateWin]; 
            break;
        
        default: 
            break;
    }
}

#pragma mark -
#pragma mark Update

/**
 * Update function called every frame
 */
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray *)_listOfGameObjects
{    
    if(COCOS2D_DEBUG > 1) [self updateDebugLabel];
    if (state != kStateDead) [self checkLemmingWithinScreenBounds];
    
    /*
     * check for collisions
     */
    
    CGRect selfBBox = [self adjustedBoundingBox];
    BOOL colliding = NO;
    
    for (GameObject *gameObject in _listOfGameObjects) 
    {
        // no need to check self with self
        if(gameObject == self) continue;
             
        CGRect objectBBox = [gameObject adjustedBoundingBox];
        if(CGRectIntersectsRect(selfBBox, objectBBox)) 
        {
            [self onObjectCollision:gameObject];
            if(gameObject.gameObjectType == kObjectTerrain) colliding = YES;
        }
    }
    if(!colliding && state != kStateSpawning && state != kStateFalling && state != kStateDead) [self changeState:kStateFalling];
        
    // check if the lemming is dead
    if(self.health <= 0 && self.state != kStateDead) [self changeState:kStateDead];
    
    // if actions have finished running...
    if([self numberOfRunningActions] == 0)
    {
        if(self.state == kStateFloating) // lemming has opened umbrella, now to make it float
        {
            id animAction = [CCAnimate actionWithAnimation:floatUmbrellaAnim restoreOriginalFrame:NO];
            
            // make the lemming move
            id floatingAction = [CCMoveBy actionWithDuration:0.75f position:ccp(0.0f, movementAmount*-1)];
            
            // merge the two actions
            
            animAction = [CCSpawn actions: floatingAction, animAction, nil];         
            animAction = [CCRepeatForever actionWithAction:animAction];
            
            [self runAction:animAction];
        }
        else if(self.state == kStateDead) // lemming has played death anim, respawn or remove
        {
            if(respawns > 0) [self changeState:kStateSpawning];
            else [[LemmingManager sharedLemmingManager] removeLemming:self];
        }
    }
}

/**
 * Updates the debug string
 */
-(void)updateDebugLabel
{
    CGPoint newPosition = [self position];
    
    //NSString *debugString = [NSString stringWithFormat:@"ID: %i Health: %i \n", self.ID, self.health];
    NSString *debugString = [NSString stringWithFormat:@"x: %f y: %f \n Health: %i \n", newPosition.x, newPosition.y, self.health];
    
    switch (state) 
    {
            
        case kStateSpawning:
            [debugLabel setString: [debugString stringByAppendingString:@" [spawning]"]];
            break;
            
        case kStateIdle:
            [debugLabel setString: [debugString stringByAppendingString:@" [idle]"]];
            break;
            
        case kStateWalking:            
            [debugLabel setString: [debugString stringByAppendingString:@" [walking]"]];
            break;  
            
        case kStateFloating:
            [debugLabel setString: [debugString stringByAppendingString:@" [floating]"]];
            break;
            
        case kStateDead:
            [debugLabel setString:@""];
            break;
            
        default:
            CCLOG(@"Lemming.changeState: unknown state '%d'", state);
            break;
    }
    
    float yOffset = winSize.height*0.1f;
    newPosition = ccp(newPosition.x, newPosition.y+yOffset);
    [debugLabel setPosition:newPosition];
}

/**
 * Checks that the lemming is within the screen area
 */
-(void)checkLemmingWithinScreenBounds
{
    CGPoint position = [self position];
    
    // if the lemming reaches edge of screen, change direction
    if (position.x <= 10 || position.x >= 470) [self changeDirection];
    // if the lemming falls of the bottom of the screen, change to dead
    if (position.y <= 20) [self changeState:kStateDead];
}

#pragma mark -
#pragma mark Getters/Setters

/**
 * Adjusts the bounding box to the size of the sprite
 * (25% width, 9.5% height)
 * @return the new bounding box
 */
-(CGRect)adjustedBoundingBox
{
    CGRect bBox = [self boundingBox];
    float xCropAmount = bBox.size.width * 0.25;
    float yCropAmount = bBox.size.height * 0.095f;
    
    bBox = CGRectMake(bBox.origin.x, bBox.origin.y, bBox.size.width-xCropAmount, bBox.size.height-yCropAmount);
    
    return bBox;
}

@end
