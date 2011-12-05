//
//  GameplayLayer.m
//  Author: Thomas Taylor
//
//  13/11/2011: Created class
//

#import "GameplayLayer.h"
#import "Obstacle.h"

@implementation GameplayLayer

float buttonDimensions = 64.0f;
Lemming *lemming;
bool countDown = NO;
int frameCount = 0;

-(id)init 
{    
    self = [super init];
 
    if (self != nil) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;                            
        
        // enable touches
        self.isTouchEnabled = YES;                                                               
        
        /*
         * TEST ANIMATION - REMOVE
         */
        
        lemming = [[Lemming alloc] init];
        [self addChild:[lemming getSpriteBatchNode]];
        
        /*// to add to the animation cache:
        [[CCAnimationCache sharedAnimationCache] addAnimation:animationToCache name:@"animationName"];
        // to access the animation:
        CCAnimation *myAnimaition = [[CCAnimationCache sharedAnimationCache] animationByName:@"animationName"];*/

        /*
         * END OF TEST ANIMATION
         */
        
        // set up the buttons
        [self initButtons];
        [self scheduleUpdate];
        
        Obstacle *testObstacle = [[Obstacle alloc] init:kObstaclePit];
    }
    
    return self;
}

-(void)initButtons
{
    CCLOG(@"GameplayLayer.initButtons");
    
    CGRect settingsButtonDimensions = CGRectMake(0, 0, buttonDimensions, buttonDimensions);
    
    float windowWidth = [CCDirector sharedDirector].winSize.width;
    float buttonPadding = (buttonDimensions/2)+10;
    CGPoint settingsButtonPosition = ccp(windowWidth-buttonPadding, buttonPadding);
        
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

-(void)update:(ccTime)deltaTime
{
    [lemming move: 0.35f: kAxisHorizontal];
    [self checkButtons];
}

-(void)checkButtons
{
    if (settingsButton.active) 
    {
        CCLOG(@"Settings button pressed...");
        //[lemmingSprite setPosition:ccp(50, lemmingSprite.position.y)];
        
        [lemming flip: kAxisVertical];
        
        /*
         * Need to open settings screen
         * - on screen close, update the state of the system 
         * based on which settings have been changed (if any)
         */
    }
}

@end
