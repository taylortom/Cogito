//
//  GameplayLayer.m
//  Author: Thomas Taylor
//
//  The main layer in the game, handles 
//  the main 'gameplay' elements
//
//  13/11/2011: Created class
//

#import "GameplayLayer.h"
#import "Obstacle.h"

@implementation GameplayLayer

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [settingsButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the layer
 * @return self
 */
-(id)init 
{    
    CCLOG(@"GameplayLayer.init: %i", COCOS2D_DEBUG);
    
    self = [super init];
 
    if (self != nil) 
    {
        self.isTouchEnabled = YES; // enable touch
        totalNumberOfLemmings = 25;
        lemmingCount = 0;
    
        srandom(time(NULL)); // set up a random number generator
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Lemming_atlas.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"Lemming_atlas.png"];
        
        [self addChild:sceneSpriteBatchNode z:0];
        [self initButtons]; // set up the buttons
    
        //
        //
        //
        // instantiate lemming manager
        //
        //
        //
        //Obstacle *testObstacle = [[Obstacle alloc] init:kObstaclePit];
        
        [self schedule:@selector(addLemming) interval:1.0f]; // create some lemmings
        [self scheduleUpdate]; // set the update method to be called every frame
    }
        
    return self;
}

/**
 * Initialises any buttons in the layer
 */
-(void)initButtons
{
    CCLOG(@"GameplayLayer.initButtons");
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGRect settingsButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGPoint settingsButtonPosition = ccp(screenSize.width*0.90, screenSize.width*0.10f);
    
    SneakyButtonSkinnedBase *settingsButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    settingsButtonBase.position = settingsButtonPosition;
    settingsButtonBase.defaultSprite = [CCSprite spriteWithFile:@"settings.png"];
    settingsButtonBase.activatedSprite = [CCSprite spriteWithFile:@"settings.png"];
    settingsButtonBase.pressSprite = [CCSprite spriteWithFile:@"settings_down.png"];
    settingsButtonBase.button = [[SneakyButton alloc] initWithRect:settingsButtonDimensions];
    
    settingsButton = [settingsButtonBase.button retain];
    settingsButton.isToggleable = YES;
    
    [self addChild:settingsButtonBase];
}

#pragma mark -
#pragma mark Update

/**
 * Method called every frame
 */ 
-(void)update:(ccTime)deltaTime
{
    CCArray *gameObjects = [sceneSpriteBatchNode children];
        
    for (Lemming *tempLemming in gameObjects) 
    {
        [tempLemming updateStateWithDeltaTime:deltaTime andListOfGameObjects:gameObjects];
    }
    
    // if all lemmings are dead and there are no respawns, game is over
//    if (lemmingsLeft == 0) [[GameManager sharedGameManager] runSceneWithID:kGameOverScene];
    
    [self checkButtons];
}

#pragma mark -
#pragma mark Object Creation

/**
 * Adds a lemming to the scene provided
 * there aren't already the max number 
 */
-(void)addLemming
{
    if(lemmingCount < totalNumberOfLemmings) 
    {
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        [self createObjectofType:kLemmingType withHealth: 100 atLocation:ccp(windowSize.width*kLemmingSpawnXPos, windowSize.height*kLemmingSpawnYPos) withZValue: (lemmingCount+10) withID: lemmingCount];
        lemmingCount++;
    }
    else [self unschedule:@selector(addLemming)];
}

/**
 * Creates a new object
 * @param objectType
 * @param withHealth
 * @param atLocation
 * @param withZvalue
 */
-(void)createObjectofType:(GameObjectType)objectType withHealth:(int)health atLocation:(CGPoint)spawnLocation withZValue:(int)zValue withID:(int)id 
{
    if(objectType == kLemmingType)
    {
        Lemming *lemming = [[Lemming alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
        lemming.id = id;
        lemming.health = health;
        
        if(COCOS2D_DEBUG > 1)
        {
            CCLabelBMFont *debugLabel = [CCLabelBMFont labelWithString:@"NoneNone" fntFile:@"helvetica_blue_small.fnt"];
            [self addChild:debugLabel];
            [lemming setDebugLabel:debugLabel];
        }
            
        [lemming setPosition:spawnLocation]; 
        [sceneSpriteBatchNode addChild:lemming z:zValue tag:kLemmingSpriteTagValue];
        [lemming release];
    }
    else CCLOG(@"GameplayLayer.createObjectofType: ObjectType not supported");
}

#pragma mark -

/**
 * Checks if any buttons are being pressed
 */
-(void)checkButtons
{
    if (settingsButton.active) 
    {
        CCLOG(@"Settings button pressed...");
        
        CCArray *gameObjects = [sceneSpriteBatchNode children];
        
        for (Lemming *tempLemming in gameObjects) 
            if([tempLemming state] == kStateIdle) [tempLemming changeState:kStateWalking];
            else if([tempLemming state] == kStateWalking) [tempLemming changeState:kStateFloating];
            else if([tempLemming state] == kStateFloating) tempLemming.health = 0;
            else 
            {
                tempLemming.health = 100;
                [tempLemming changeState:kStateIdle];
            }
        
        /*
         * Need to open settings screen
         * - on screen open, pause the game
         * - on screen close, update the state of the system 
         * based on which settings have been changed (if any)
         */
    }
}

#pragma mark -
#pragma mark Util methods

-(void)listAvailableFonts
{
    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
    NSArray *fontFamilyNames = [UIFont familyNames];
    
    for (NSString *familyName in fontFamilyNames) 
    {
        NSLog(@"Font Family Name = %@", familyName);
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        NSLog(@"Font Names = %@", fontNames);
        [fontNames addObjectsFromArray:names];
    }
    
    [fontNames release];
}

@end
