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

@interface GameplayLayer()

-(void)initButtons;
-(void)createLemmingAtLocation:(CGPoint)spawnLocation withHealth:(int)health withZValue:(int)zValue withID:(int)ID;
-(void)update:(ccTime)deltaTime;
-(void)onSettingsButtonPressed;
-(void)listAvailableFonts;

@end

@implementation GameplayLayer

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
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
    self = [super init];
 
    if (self != nil) 
    {
        self.isTouchEnabled = YES; // enable touch
    
        srandom(time(NULL)); // set up a random number generator
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Lemming_atlas.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"Lemming_atlas.png"];
        
        [self addChild:sceneSpriteBatchNode z:0];
        [self initButtons]; // set up the buttons
        
        [self schedule:@selector(addLemming) interval:kLemmingSpawnSpeed]; // create some lemmings
        [self scheduleUpdate]; // set the update method to be called every frame
    }
        
    return self;
}

/**
 * Creates the in-game 'menu'
 * Initialises any buttons in the layer
 */
-(void)initButtons
{    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCMenuItem *settingsButton = [CCMenuItemImage itemFromNormalImage:@"settings.png" selectedImage:@"settings_down.png" target:self selector:@selector(onSettingsButtonPressed)];
    settingsButton.position = ccp(screenSize.width*0.90, screenSize.width*0.10f);
    
    gameplayMenu = [CCMenu menuWithItems:settingsButton, nil];
    gameplayMenu.position = CGPointZero;
    
    [self addChild:gameplayMenu];
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
}

#pragma mark -
#pragma mark Object Creation

/**
 * Adds a lemming to the scene
 */
-(void)addLemming
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    int lemmingCount = [AgentManager sharedAgentManager].agentCount;
    
    [self createLemmingAtLocation:ccp(screenSize.width*kLemmingSpawnXPos, screenSize.height*kLemmingSpawnYPos) withHealth:100 withZValue:(lemmingCount+10) withID:lemmingCount];
}

/**
 * Creates a new Lemming object
 * @param withHealth
 * @param atLocation
 * @param withZvalue
 */
-(void)createLemmingAtLocation:(CGPoint)spawnLocation withHealth:(int)health withZValue:(int)zValue withID:(int)ID  
{
    if (![[AgentManager sharedAgentManager] agentsMaxed]) 
    {
        Lemming *lemming = [[Lemming alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Lemming_idle_1.png"]];
        lemming.ID = ID;
        lemming.health = health;
        
        if(COCOS2D_DEBUG > 1)
        {
            CCLabelBMFont *debugLabel = [CCLabelBMFont labelWithString:@"NoneNone" fntFile:@"helvetica_blue_small.fnt"];
            [self addChild:debugLabel];
            [lemming setDebugLabel:debugLabel];
        }
        
        [[AgentManager sharedAgentManager] addAgent:lemming]; 
        
        [lemming setPosition:spawnLocation]; 
        [sceneSpriteBatchNode addChild:lemming z:zValue tag:kLemmingSpriteTagValue];
        [lemming release];
    }
    else [self unschedule:@selector(addLemming)];
}

#pragma mark -

/**
 * Called when settings button's pressed
 */
-(void)onSettingsButtonPressed
{
    CCLOG(@"GameplayLayer.onSettingsButtonPressed");
    
    CCArray *gameObjects = [sceneSpriteBatchNode children];
    
    for (Lemming *tempLemming in gameObjects) 
    {
        if([tempLemming state] == kStateIdle) [tempLemming changeState:kStateWalking];
        else if([tempLemming state] == kStateWalking) [tempLemming changeState:kStateFloating];
        else if([tempLemming state] == kStateFloating) tempLemming.health = 0;
        else 
        {
            tempLemming.health = 100;
            [tempLemming changeState:kStateIdle];
        }
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
