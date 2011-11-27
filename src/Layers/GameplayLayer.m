//
//  GameplayLayer.m
//  Author: Thomas Taylor
//
//  13/11/2011: Created class
//

#import "GameplayLayer.h"

@implementation GameplayLayer

float buttonDimensions = 64.0f;

-(id)init 
{    
    self = [super init];
 
    if (self != nil) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;                            
        
        // enable touches
        self.isTouchEnabled = YES;                                                               
        
        // load the sprite atlas
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lemming_atlas.plist"];
        spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"lemming_atlas.png"];
        
        // create the lemming sprite
        lemmingSprite = [CCSprite spriteWithSpriteFrameName:@"pixel_lemming_anim_1.png"];
        [spriteBatchNode addChild:lemmingSprite];
        [self addChild:spriteBatchNode];
        [lemmingSprite setPosition:CGPointMake(50, 90)];
        
        /**
         * TEST ANIMATION - REMOVE
         */
        CCAnimation *exampleAnim = [CCAnimation animation];
        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_2.png"]];
        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_3.png"]];
        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pixel_lemming_anim_4.png"]];
        id animateAction = [CCAnimate actionWithDuration:0.5f animation:exampleAnim restoreOriginalFrame:YES];
        id repeatAction = [CCRepeatForever actionWithAction:animateAction];
        [lemmingSprite runAction:repeatAction];
        
        /*// to add to the animation cache:
        [[CCAnimationCache sharedAnimationCache] addAnimation:animationToCache name:@"animationName"];
        // to access the animation:
        CCAnimation *myAnimaition = [[CCAnimationCache sharedAnimationCache] animationByName:@"animationName"];*/
         
        // set up the buttons
        [self initButtons];
        [self scheduleUpdate];
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
    [self checkButtons];
    [lemmingSprite setPosition:ccp(lemmingSprite.position.x+0.35, lemmingSprite.position.y)];
}

-(void)checkButtons
{
    if (settingsButton.active) 
    {
        CCLOG(@"Settings button pressed...");
        [lemmingSprite setPosition:ccp(50, lemmingSprite.position.y)];
        
        /*
         * Need to open settings screen
         * - on screen close, update the state of the system 
         * based on which settings have been changed (if any)
         */
    }
        
}

@end
