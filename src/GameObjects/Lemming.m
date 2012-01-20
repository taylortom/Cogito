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
-(void)changeStateDelegate:(id)_newState;
-(void)onObjectCollision:(GameObject*)_obstacle;
-(void)checkForCollisions:(CCArray*)_listOfGameObjects;
-(void)checkLemmingWithinScreenBounds;
-(void)updateDebugLabel;

@end

@implementation Lemming

@synthesize health;
@synthesize state;

@synthesize helmetUses;
@synthesize umbrellaUses;

// animation
@synthesize idleAnim;
@synthesize idleHelmetAnim;
@synthesize walkingAnim;
@synthesize walkingHelmetAnim;
@synthesize openUmbrellaAnim;
@synthesize floatUmbrellaAnim;
@synthesize deathAnim;

// used in debugging
@synthesize ID;
@synthesize debugLabel;

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
            [self setPosition:ccp([GameManager sharedGameManager].currentLevel.spawnPoint.x, [GameManager sharedGameManager].currentLevel.spawnPoint.y)];
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            respawns--;
            [self changeState:kStateFalling];
            break;

        case kStateFalling:
            action = [CCSpawn actions: [CCMoveBy actionWithDuration:0.12f position:ccp(0.0f, kLemmingMovementAmount*-1)], action, nil];         
            objectLastCollidedWith = kObjectTypeNone;
            break;
            
        case kStateIdle:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            break;
            
        case kStateWalking:   
            if(isUsingHelmet) action = [CCAnimate actionWithAnimation:walkingHelmetAnim restoreOriginalFrame:NO];
            else action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:YES];
            id walkingAction = [CCMoveBy actionWithDuration:1.04f position:ccp((movementDirection == kDirectionLeft) ? kLemmingMovementAmount * -1 : kLemmingMovementAmount, 0.0f)];
            action = [CCSpawn actions: walkingAction, action, nil];         
            break;  
            
        case kStateFloating:
            action = [CCAnimate actionWithAnimation:openUmbrellaAnim restoreOriginalFrame:NO];
            objectLastCollidedWith = kObjectTypeNone;
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
 * Changes the current state after a delay
 * @param state to change to
 * @param amount to delay by in seconds
 */
-(void)changeState: (CharacterStates)_newState afterDelay:(float)_delay
{
    [self performSelector:@selector(changeStateDelegate:) withObject:[NSNumber numberWithInt:_newState] afterDelay:_delay];
}

-(void)changeStateDelegate:(id)_newState
{
    [self changeState:(CharacterStates)[_newState intValue]];
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

#pragma mark -
#pragma mark Collisions

/**
 * Checks for collisions with the lemming
 * @param the list of game objects to check
 */
-(void)checkForCollisions:(CCArray*)_listOfGameObjects
{
    CGRect selfBBox = [self adjustedBoundingBox];
    BOOL colliding = NO;
    
    for (GameObject *gameObject in _listOfGameObjects) 
    {
        // no need to check for self-self collisions
        if(gameObject == self || gameObject.gameObjectType == kLemmingType) continue;
        
        CGRect objectBBox = [gameObject adjustedBoundingBox];
        if(CGRectIntersectsRect(selfBBox, objectBBox)) 
        {
            [self onObjectCollision:gameObject];
            if(gameObject.gameObjectType == kObjectTerrain || gameObject.gameObjectType == kObjectTrapdoor) colliding = YES;
        }
    }
    // check if the lemming should be falling
    if(!colliding && state != kStateSpawning && state != kStateFalling && state != kStateDead) [self changeState:kStateFalling];
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

/**
 * Applies the appropriate action when 
 * a Lemming collides with an object
 * @param object collided with
 */
-(void)onObjectCollision:(GameObject*)_object
{       
    // check that we're not colliding with the same object
    if(_object.gameObjectType == objectLastCollidedWith || ![_object isCollideable]) return;
    // it's possible to collide with the stamper and the ground at the same time, ignore this
    else if(objectLastCollidedWith == kObstacleStamper && _object.gameObjectType == kObjectTerrain) return;    
    
    objectLastCollidedWith = _object.gameObjectType;
    
    switch([_object gameObjectType]) 
    {
        case kObstaclePit:
        case kObstacleWater:
            if(self.state != kStateDead) [self changeState:kStateDead];
            break;
            
        case kObstacleStamper:
            if(!isUsingHelmet && self.state != kStateDead) [self changeState:kStateDead];
            break;
            
        case kObjectExit:
            [self changeState:kStateWin afterDelay:1.5f]; 
            break;
            
        case kObjectTerrain:
        case kObjectTrapdoor:
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
        
        case kObstacleCage:            
            // do nothing yet...
            break;
            
        default: 
            // do nothing...
            CCLOG(@"Lemming.onObjectCollision: %@", [Utils getObjectAsString:_object.gameObjectType]);
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
-(void)updateStateWithDeltaTime:(ccTime)_deltaTime andListOfGameObjects:(CCArray*)_listOfGameObjects
{      
    // if the lemming's dead there's no point continuing
    if(self.health <= 0 && self.state != kStateDead) { [self changeState:kStateDead]; return; }
    
    // make sure the lemming's onscreen
    if (state != kStateDead) [self checkLemmingWithinScreenBounds];
    
    // check for collisions
    [self checkForCollisions:_listOfGameObjects];
    
    /*
     * if actions have finished running...
     */
    if([self numberOfRunningActions] == 0)
    {
        if(self.state == kStateFloating) // lemming has opened umbrella, now to make it float
        {
            // create the movement/animation and play
            id floatAction = [CCAnimate actionWithAnimation:floatUmbrellaAnim restoreOriginalFrame:NO];
            id floatingAction = [CCMoveBy actionWithDuration:0.75f position:ccp(0.0f, kLemmingMovementAmount*-1)];
            floatAction = [CCSpawn actions: floatingAction, floatAction, nil];         
            floatAction = [CCRepeatForever actionWithAction:floatAction];
            [self runAction:floatAction];
        }
        // lemming has played death anim, respawn or remove
        else if(self.state == kStateDead)
        {
            if(respawns > 0) [self changeState:kStateSpawning];
            else [[LemmingManager sharedLemmingManager] removeLemming:self];
        }
        // remove lemming if it's reached the exit
        else if(self.state == kStateWin)
        {
            [[LemmingManager sharedLemmingManager] removeLemming:self];
            return;
        }
    }
    
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
    
    NSString* stateString = [Utils getStateAsString:self.state];
    
    if ([stateString compare:@""]) 
    {
        [debugLabel setString: [debugString stringByAppendingString:@" ["]];
        [debugLabel setString: [debugString stringByAppendingString:stateString]];
        [debugLabel setString: [debugString stringByAppendingString:@"]"]];
    }
    else [debugLabel setString:@""];
    
    float yOffset = winSize.height*0.1f;
    newPosition = ccp(newPosition.x, newPosition.y+yOffset);
    [debugLabel setPosition:newPosition];
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
