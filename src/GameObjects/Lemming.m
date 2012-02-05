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
-(void)resetState;
-(void)changeStateDelegate:(id)_newState;
-(void)useHelmet:(BOOL)_useHelmet;
-(void)useUmbrella;
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
        respawns = kLemmingRespawns;
        movementDirection = kDirectionRight;
        [self initAnimations];
        [self resetState];
        [self changeState:kStateSpawning];
        
    }
    return self;
}

/**
 * Loads all of the animations
 */
-(void)initAnimations
{        
    [self setIdleAnim:[self loadAnimationFromPlistWthName:@"idleAnim" andClassName:@"Lemming"]];
    [self setIdleHelmetAnim:[self loadAnimationFromPlistWthName:@"idleHelmetAnim" andClassName:@"Lemming"]];
    [self setWalkingAnim:[self loadAnimationFromPlistWthName:@"walkingAnim" andClassName:@"Lemming"]];
    [self setWalkingHelmetAnim:[self loadAnimationFromPlistWthName:@"walkingHelmetAnim" andClassName:@"Lemming"]];
    [self setOpenUmbrellaAnim:[self loadAnimationFromPlistWthName:@"openUmbrellaAnim" andClassName:@"Lemming"]];
    [self setFloatUmbrellaAnim:[self loadAnimationFromPlistWthName:@"floatUmbrellaAnim" andClassName:@"Lemming"]];
    [self setDeathAnim:[self loadAnimationFromPlistWthName:@"deathAnim" andClassName:@"Lemming"]];
}

/**
 * Resets relevnt vars for respawns
 */
-(void)resetState
{
    health = 100;
    isUsingHelmet = NO;
    isUsingUmbrella = NO;
    umbrellaEquipped = NO;
    umbrellaTimer = 0;
    objectLastCollidedWith = kObjectTypeNone;
    helmetUses = 5;
    umbrellaUses = 5;
    if(movementDirection != kDirectionRight) [self changeDirection];
}

#pragma mark -
#pragma mark State Changing

/**
 * Changes the current state
 * @param state to change to
 */
-(void)changeState: (CharacterStates)_newState
{      
    // if need to use umbrella, delay, then call useUmbrella
    if(umbrellaEquipped) 
    {
        if(umbrellaTimer >= 65) [self useUmbrella];
        return; 
    }
    //CCLOG(@"Lemming.changeState: %@", [Utils getStateAsString:_newState]);
    
    [self stopAllActions];
    id action = nil;
    self.state = _newState;
    // reset the fall counter
    fallCounter = 0;
    
    switch(_newState) 
    {
        case kStateSpawning:
            [self setPosition:ccp([GameManager sharedGameManager].currentLevel.spawnPoint.x, [GameManager sharedGameManager].currentLevel.spawnPoint.y)];
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            [self resetState];
            respawns--;
            [self changeState:kStateFalling];
            break;

        case kStateFalling:
            action = [CCSpawn actions: [CCMoveBy actionWithDuration:0.12f position:ccp(0.0f, kLemmingMovementAmount*-1)], action, nil];         
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
            break;
           
        case kStateDead:
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
            break;
            
        case kStateWin:
            if (isUsingHelmet) [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_helmet_1.png"]];
            else [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
            break;
            
        default:
            CCLOG(@"Lemming.changeState: unknown state '%@'", [Utils getStateAsString:_newState]);
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

#pragma mark -

/**
 * Changes the lemming's action
 * @param the action to take
 */
-(void)takePath:(Action)_action
{
    if(_action == -1) { CCLOG(@"Lemming.takePath: Uknown action chosen"); return; }
    
    switch (_action) 
    {
        case kActionLeft:
            if(movementDirection != kDirectionLeft) [self changeDirection];
            break;
            
        case kActionRight:
            if(movementDirection != kDirectionRight) [self changeDirection];
            break;
            
        case kActionLeftHelmet:
            if(movementDirection != kDirectionLeft) [self changeDirection];
            if(!isUsingHelmet) [self useHelmet:YES];
            break;
            
        case kActionRightHelmet:
            if(movementDirection != kDirectionRight) [self changeDirection];
            if(!isUsingHelmet) [self useHelmet:YES];
            break;
            
        case kActionEquipUmbrella:
            umbrellaEquipped = YES;
            break;
            
        case kActionDownUmbrella:
            isUsingUmbrella = YES;
            [self performSelector:@selector(useUmbrella) withObject:nil afterDelay:1.5f];
            break;
            
        case kActionDown:
            [self changeState:kStateFalling afterDelay:1.5f];
            break;
            
        default:
            break;
    }
    
    if(isUsingHelmet && _action != kActionLeftHelmet && _action != kActionRightHelmet) [self useHelmet:NO];
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
 * Lemming has either died, or won
 * act accordingly
 */
-(void)onEndConditionReached
{
    // lemming has played death anim, respawn or remove
    if(self.state == kStateDead)
    {
        if(respawns > 0) [self changeState:kStateSpawning];
        else [[LemmingManager sharedLemmingManager] removeLemming:self];
    }
    // remove lemming if it's reached the exit
    else [[LemmingManager sharedLemmingManager] removeLemming:self];
}

#pragma mark -
#pragma mark Tools

/**
 * Put the helmet on the lemming
 */
-(void)useHelmet:(BOOL)_useHelmet
{
    if(isUsingHelmet != _useHelmet) 
    {   
        isUsingHelmet = _useHelmet;
        helmetUses--;
        [self changeState:kStateWalking];
    }
}

/**
 * Makes the lemming get his umbrella out
 */
-(void)useUmbrella
{
    if(isUsingUmbrella || umbrellaEquipped)
    {
        //CCLOG(@"Lemming.useUmbrella: isUsingUmbrella: %i umbrellaEquipped: %i -> %i", isUsingUmbrella, umbrellaEquipped, umbrellaTimer);
        isUsingUmbrella = NO;
        umbrellaEquipped = NO;
        umbrellaUses--;
        umbrellaTimer = 0;
        [self changeState:kStateFloating];
    }
}


#pragma mark -
#pragma mark Collisions

/**
 * Checks for collisions with the lemming
 * @param the list of game objects to check
 */
-(void)checkForCollisions:(CCArray*)_listOfGameObjects
{
    CCArray* collisions = [[CCArray alloc] init];
    CGRect selfBBox = [self adjustedBoundingBox];
    BOOL colliding = NO;
    
    for (GameObject *gameObject in _listOfGameObjects) 
    {
        // no need to check for self-self collisions
        if(gameObject == self || gameObject.gameObjectType == kLemmingType) continue;
        
        CGRect objectBBox = [gameObject adjustedBoundingBox];
        if(CGRectIntersectsRect(selfBBox, objectBBox)) 
        {
            [collisions addObject:gameObject];
            if(gameObject.gameObjectType == kObjectTerrain || gameObject.gameObjectType == kObjectTrapdoor) colliding = YES;
        }
    }
    
    // check if the lemming should be falling
    if(!colliding && state != kStateSpawning && state != kStateFalling && state != kStateFloating && state != kStateDead) [self changeState:kStateFalling];
    
    // work out what we're actually colliding with, and call onObjectCollision
    if([collisions count] > 0)
    {
        GameObject* object = nil;
        
        // work out if we're colliding with two objects
        if([collisions count] > 1)
        {        
            GameObject* object1 = [collisions objectAtIndex:0];
            GameObject* object2 = [collisions objectAtIndex:1];
            
            if(object1.gameObjectType == kObjectTerrain || object2.gameObjectType == kObjectTerrain) 
            {
                if(object1.gameObjectType == kObjectTerrain) object = object2;
                else object = object1;
            }
        }
        else object = [collisions objectAtIndex:0];
        
        // if the object isn't collideable, exit
        if(![object isCollideable]) return;
        // check that we're not colliding with the same object
        if(object.gameObjectType == objectLastCollidedWith) 
        {
            if(object.gameObjectType == kObjectTerrain && (self.state == kStateFalling || self.state == kStateFloating)); // do nothing
            else return;    
        }
        else objectLastCollidedWith = object.gameObjectType; 
        
        [self onObjectCollision:object];
    }
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
    switch([_object gameObjectType]) 
    {
        case kObstaclePit:
        case kObstacleWater:
            [self changeState:kStateDead];
            break;
            
        case kObstacleStamper:
            if(!isUsingHelmet) [self changeState:kStateDead];
            break;
            
        case kObjectExit:
            [self changeState:kStateWin afterDelay:1.0f];
            break;
            
        case kObjectTerrain:
            if(self.state != kStateWalking && self.state != kStateDead && self.state != kStateWin && ![(Terrain*)_object isWall]) 
            {
                if(fallCounter >= ((float)kLemmingFallTime*(float)kFrameRate) && self.state != kStateFloating) [self changeState:kStateDead];
                else [self changeState:kStateWalking];
            }
            else if([(Terrain*)_object isWall]) [self changeDirection];
            break;
        
        case kObjectTerrainEnd:
        case kObjectTrapdoor:
        case kObstacleCage:            
            // do nothing...
            break;
            
        default: 
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
    
    // increment any counters
    if(self.state == kStateFalling) fallCounter++;
    if(umbrellaEquipped) umbrellaTimer++;
    
    if(DEBUG_MODE > 0) [self updateDebugLabel];
    
    [super updateStateWithDeltaTime:_deltaTime andListOfGameObjects:_listOfGameObjects];

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
        
        if(self.state == kStateWin || self.state == kStateDead) [self onEndConditionReached];
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
    
    NSString* stateString = [Utils getStateAsString:self.state];
    if (![stateString compare:@""]) debugString = [NSString stringWithFormat:@"%@ [%@]", debugString, stateString];
    
    [debugLabel setString:debugString];
    
    float yOffset = 10.0f;
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
