//
//  GameOverLayer.m
//  Author: Thomas Taylor
//
//  The game over layer
//
//  16/12/2011: Created class
//


#import "GameOverLayer.h"

@interface GameOverLayer() 

-(void)onMenuButtonPressed;

@end

@implementation GameOverLayer

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
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
        // add the bacground image
        CCSprite *background = [CCSprite spriteWithFile:@"GameOverBackground.png"];
		[background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background];
		
		// Add the text for level complete.
        AgentStats* as = [AgentStats sharedAgentStats];
        GameManager* gm = [GameManager sharedGameManager];
        LemmingManager* lm = [LemmingManager sharedLemmingManager];
        NSString *statString = [NSString stringWithFormat:@"> time: %@  \n> saved: %i  killed: %i \n> avg. episode time (secs): \n     before: %i  after: %i \n> avg. actions per episode: \n     before: %i  after: %i", [gm getGameTimeInMins], [lm lemmingsSaved], [lm lemmingsKilled], [as averageTimeLearning], [as averageTimeNonLearning], [as averageActionsLearning], [as averageActionsNonLearning]];
		CCLabelBMFont *statTextLeft = [CCLabelBMFont labelWithString:statString fntFile:kFilenameDefFontLarge];
		[statTextLeft setAnchorPoint:ccp(0, 1)];
        [statTextLeft setPosition:ccp(41, winSize.height-100)];
		[self addChild:statTextLeft];
        
        // add the game rating image
        CCSprite *gameRating;
        
        switch ([[LemmingManager sharedLemmingManager] calculateGameRating]) 
        {
            case kRatingA:
                gameRating = [CCSprite spriteWithFile:@"GameRating_A.png"];
                break;
            
            case kRatingB:
                gameRating = [CCSprite spriteWithFile:@"GameRating_B.png"];
                break;
                
            case kRatingC:
                gameRating = [CCSprite spriteWithFile:@"GameRating_C.png"];
                break;
                
            case kRatingD:
                gameRating = [CCSprite spriteWithFile:@"GameRating_D.png"];
                break;
                
            case kRatingF:
                gameRating = [CCSprite spriteWithFile:@"GameRating_F.png"];
                break;
                
            default:
                CCLOG(@"Unknown rating: %@", [[LemmingManager sharedLemmingManager] calculateGameRating]);
                break;
        }
		
        [gameRating setPosition:ccp(winSize.width*0.75f, winSize.height*0.45)];
		[self addChild:gameRating];
        
        //create and position the screen buttons
        CCMenuItemImage *menuButton = [CCMenuItemImage itemFromNormalImage:@"Menu.png" selectedImage:@"Menu_down.png" disabledImage:nil target:self selector:@selector(onMenuButtonPressed)];
        buttons = [CCMenu menuWithItems:menuButton, nil];
        [buttons alignItemsVerticallyWithPadding:winSize.height * 0.059f];
        [buttons setPosition: ccp(winSize.width * 0.2, winSize.height * 0.1)];
        
        // add the menu
        [self addChild:buttons];
	}
    
	return self;
}

/**
 * Loads the main menu scene
 */
-(void)onMenuButtonPressed
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
