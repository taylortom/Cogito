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
-(void)onObstacleCollision:(GameObjectType)obstacleType;

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
@synthesize deathAnim;
@synthesize floatUmbrellaAnim;

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
    [self setFloatUmbrellaAnim:[self loadAnimationFromPlistWthName:@"floatUmbrellaAnim" andClassName:NSStringFromClass([self class])]];
    [self setDeathAnim:[self loadAnimationFromPlistWthName:@"deathAnim" andClassName:NSStringFromClass([self class])]];
}

#pragma mark -

/**
 * Changes the current state
 * @param state to change to
 */
-(void)changeState: (CharacterStates)newState
{        
    [self stopAllActions];
    id action = nil;
    self.state = newState;
    
    switch(newState) 
    {
            
        case kStateSpawning:
            [self setPosition:ccp(screenSize.width*kLemmingSpawnXPos, screenSize.height*kLemmingSpawnYPos)];
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            id fallingAction = [CCMoveBy actionWithDuration:0.20f position:ccp(0.0f, movementAmount*-1)];
            action = [CCSpawn actions: fallingAction, action, nil];         
            respawns--;
            break;
            
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
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
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
 * Applies the appropriate damage when 
 * a Lemming collides with an obstacle
 */
-(void)onObstacleCollision:(GameObjectType)obstacleType
{
    switch(obstacleType) 
    {
        case kObstaclePit:
        case kObstacleWater:
            [self changeState:kStateDead];
            break;
        case kObstacleStamper:
        case kObstacleCage:
            // don't do anything yet
            break;
        default: 
            CCLOG(@"Lemming.onObstacleCollision: Unknown obstacle [%@]", obstacleType);
            break;
    }
}

#pragma mark -
#pragma mark Update

/**
 * Update function called every frame
 */
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{    
    [self updateDebugLabel];
    
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
            
            if(objectType == kObstaclePit || objectType == kObstacleStamper || objectType == kObstacleWater || objectType == kObstacleCage) 
                [self onObstacleCollision:objectType];
            else if(objectType == kObjectExit) [self changeState:kStateWin]; 
            else if(objectType == kLemmingType); // do nothing 
        }
    }
    
    // wait until actions have finished running before respawning or
    if([self numberOfRunningActions] == 0)
    {
        if(self.state == kStateDead)
        {
            if(respawns > 0) [self changeState:kStateSpawning];
            else [[AgentManager sharedAgentManager] removeAgent:self];
        }
    }
    
    if(self.health <= 0 && self.state != kStateDead) [self changeState:kStateDead];
}

-(void)updateDebugLabel
{
    CGPoint newPosition = [self position];
    NSString *debugString = [NSString stringWithFormat:@"ID: %i Health: %i \n", self.ID, self.health];
    
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
    
    float yOffset = screenSize.height*0.1f;
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

@end
