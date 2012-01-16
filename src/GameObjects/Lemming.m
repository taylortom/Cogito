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
-(void)killLemming;
-(void)updateDebugLabel;
-(void)onObjectCollision:(GameObject*)_obstacle;
-(void)checkLemmingWithinScreenBounds;

@end

@implementation Lemming

@synthesize health;
@synthesize state;

// used in debugging
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
        movementAmount = 18;
        movementDirection = kDirectionRight;
        respawns = kLemmingRespawns;
        isUsingHelmet = NO;
        objectLastCollidedWith = kObjectTypeNone;
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

    // reset the counter
    fallCounter = 0;
    
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
            action = [CCSpawn actions: [CCMoveBy actionWithDuration:0.12f position:ccp(0.0f, movementAmount*-1)], action, nil];         
            objectLastCollidedWith = kObjectTypeNone;
            break;
            
        case kStateIdle:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            break;
            
        case kStateWalking:   
            if(isUsingHelmet) action = [CCAnimate actionWithAnimation:walkingHelmetAnim restoreOriginalFrame:NO];
            else action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
            id walkingAction = [CCMoveBy actionWithDuration:1.04f position:ccp((movementDirection == kDirectionLeft) ? movementAmount * -1 : movementAmount, 0.0f)];
            action = [CCSpawn actions: walkingAction, action, nil];         
            break;  
            
        case kStateFloating:
            action = [CCAnimate actionWithAnimation:openUmbrellaAnim restoreOriginalFrame:NO];
            break;
           
        case kStateDead:
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
            break;
            
        case kStateWin:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
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
 * Changes the state to dead.
 * Used by delayMethodCall
 */
-(void)killLemming
{   
    [self changeState:kStateDead];
}

-(void)winLemming
{   
    [self changeState:kStateWin];
}

/**
 * Applies the appropriate action when 
 * a Lemming collides with an object
 * @param object collided with
 */
-(void)onObjectCollision:(GameObject*)_object
{       
    // check that we're not colliding with the same object
    if(_object.gameObjectType == objectLastCollidedWith || ![_object isCollideable]) return;
        
    objectLastCollidedWith = _object.gameObjectType;
    
    switch([_object gameObjectType]) 
    {
        case kObstaclePit:
        case kObstacleWater:
            if(self.state != kStateDead) [self changeState:kStateDead];
            break;
            
        case kObstacleStamper:
            if(!isUsingHelmet && self.state != kStateDead) [self delayMethodCall:@selector(killLemming) by:1.5];
            break;
            
        case kObstacleCage:
            /* either: 
             *    - kill lemming
             *    - animate up
             *
             * or:
             *    - trap lemming
             *    - ignore any further collisions
             */
            //[self delayMethodCall:@selector(killLemming) by:1.0];
            break;

        case kObjectTrapdoor:
            // do nothing
            break;
            
        case kObjectExit:
            [self delayMethodCall:@selector(winLemming) by:1.0f]; 
            break;
            
        case kObjectTerrain:
            /*if(![_object isCollideable]) 
            {
                if(state == kStateFalling) return;
                else [self changeState:kStateFalling];
            }*/
            if(self.state != kStateWalking && self.state != kStateDead && self.state != kStateWin && ![(Terrain*)_object isWall]) 
            {
                if(fallCounter > (kLemmingFallTime*kFrameRate) && self.state != kStateFloating) 
                {
                    [self changeState:kStateDead];
                    fallCounter = 0;
                }
                else [self changeState:kStateWalking];
            }
            else if([(Terrain*)_object isWall]) [self changeDirection];
            break;
        
        default: 
            break;
    }
}

#pragma mark -
#pragma mark Update

/**
 * Update function called every frame
 * @param deltaTime
 * @param listOfGameObjects
 */
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray *)_listOfGameObjects
{      
    // check if the lemming is dead
    if(self.health <= 0 && self.state != kStateDead)
    {
        [self changeState:kStateDead];
        return;
    }
    
    /*
     * check for collisions
     */
    CGRect selfBBox = [self adjustedBoundingBox];
    BOOL colliding = NO;
    
    for (GameObject *gameObject in _listOfGameObjects) 
    {
        // no need to check for self-self collisions
        if(gameObject == self) continue;
             
        CGRect objectBBox = [gameObject adjustedBoundingBox];
        if(CGRectIntersectsRect(selfBBox, objectBBox)) 
        {
            [self onObjectCollision:gameObject];
            if(gameObject.gameObjectType == kObjectTerrain) colliding = YES;
        }
    }
    // check if the lemming should be falling
    if(!colliding && state != kStateSpawning && state != kStateFalling && state != kStateDead) [self changeState:kStateFalling];
    
    /*
     * if actions have finished running...
     */
    if([self numberOfRunningActions] == 0)
    {
        if(self.state == kStateFloating) // lemming has opened umbrella, now to make it float
        {
            // create the movement/animation and play
            id animAction = [CCAnimate actionWithAnimation:floatUmbrellaAnim restoreOriginalFrame:NO];
            id floatingAction = [CCMoveBy actionWithDuration:0.75f position:ccp(0.0f, movementAmount*-1)];
            animAction = [CCSpawn actions: floatingAction, animAction, nil];         
            animAction = [CCRepeatForever actionWithAction:animAction];
            [self runAction:animAction];
        }
        // lemming has played death anim, respawn or remove
        else if(self.state == kStateDead)
        {
            if(respawns > 0) [self changeState:kStateSpawning];
            else [[LemmingManager sharedLemmingManager] removeLemming:self];
        }
        // remove lemming if it's reached the exit
        else if(self.state == kStateWin) [[LemmingManager sharedLemmingManager] removeLemming:self];
    }
    
    // make sure the lemming's onscreen
    if (state != kStateDead) [self checkLemmingWithinScreenBounds];
    
    // increment the fall counter
    if(kStateFalling) fallCounter++;
    
    [super updateStateWithDeltaTime:_deltaTime andListOfGameObjects:_listOfGameObjects];
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
 * Check for collisions
 */
-(void)checkForCollisions
{
    
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

/**
 * Returns the number of respawns left
 */
-(int)respawns
{
    return respawns;
}

@end
