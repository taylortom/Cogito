//
//  GameplayLayer.m
//  Author: Thomas Taylor
//
//  13/11/2011: Created class
//

#import "GameplayLayer.h"
#import "Obstacle.h"

@implementation GameplayLayer

-(void)dealloc
{
    [settingsButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

-(id)init 
{    
    self = [super init];
 
    if (self != nil) 
    {
        CGSize windowSize = [CCDirector sharedDirector].winSize;
    
        self.isTouchEnabled = YES; // enable touch
    
        srandom(time(NULL)); // set up a random number generator
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lemming_atlas.plist"];
        sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"lemming_atlas.png"];
        
        [self addChild:sceneSpriteBatchNode z:0];
        [self initButtons]; // set up the buttons
    
        // instantiate lemming manager
        
        Lemming *lemming = [[Lemming alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_1.png"]];
        [lemming setPosition:ccp(windowSize.width*0.35f, windowSize.height*0.14f)];
        // set lemming health????
        [sceneSpriteBatchNode addChild:lemming z:kLemmingSpriteZValue tag:kLemmingSpriteTagValue];
                            
        [self createObjectofType:kLemmingType withHealth: 100 atLocation:ccp(windowSize.width*0.87f, windowSize.height*0.13f) withZValue: 10];
                        
        
        [self scheduleUpdate]; // sets the update method to cal every frame
        
        Obstacle *testObstacle = [[Obstacle alloc] init:kObstaclePit];
    }
    
    return self;
}

-(void)initButtons
{
    CCLOG(@"GameplayLayer.initButtons");
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGRect settingsButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);

    float buttonPadding = (32)+10;
    CGPoint settingsButtonPosition = ccp(screenSize.width-buttonPadding, buttonPadding);
    
    SneakyButtonSkinnedBase *settingsButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    settingsButtonBase.position = settingsButtonPosition;
    settingsButtonBase.defaultSprite = [CCSprite spriteWithFile:@"settings.png"];
    settingsButtonBase.activatedSprite = [CCSprite spriteWithFile:@"settings.png"];
    settingsButtonBase.pressSprite = [CCSprite spriteWithFile:@"settings_down.png"];
    settingsButtonBase.button = [[SneakyButton alloc] initWithRect:settingsButtonDimensions];
    settingsButton = [settingsButtonBase.button retain];
    settingsButton.isToggleable = NO;
    [self addChild:settingsButtonBase];
}

#pragma mark -
#pragma mark Update

-(void)update:(ccTime)deltaTime
{
    CCArray *gameObjects = [sceneSpriteBatchNode children];
    
    for (Lemming *tempLemming in gameObjects) 
        [tempLemming updateStateWithDeltaTime:deltaTime andListOfGameObjects:gameObjects];
}

#pragma mark -
#pragma mark Object Creation

-(void)createObjectofType:(GameObjectType)objectType withHealth:(int)health atLocation:(CGPoint)spawnLocation withZValue:(int)zValue
{
    if(objectType == kLemmingType)
    {
        CCLOG(@"Creating a Lemming");
        Lemming *lemming = [[Lemming alloc] initWithSpriteFrame:@"Lemming_anim_1.png"];
        [Lemming setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:lemming z:zValue tag:kLemmingSpriteTagValue];
        [lemming release];
    }
}

#pragma mark -

-(void)checkButtons
{
    if (settingsButton.active) 
    {
        CCLOG(@"Settings button pressed...");
        //[lemmingSprite setPosition:ccp(50, lemmingSprite.position.y)];
                
        /*
         * Need to open settings screen
         * - on screen close, update the state of the system 
         * based on which settings have been changed (if any)
         */
    }
}

@end
