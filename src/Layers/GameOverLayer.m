//
//  GameOverLayer.m
//  Cogito
//
//  The game over layer
//
//  16/12/2011: Created class
//


#import "GameOverLayer.h"

@interface GameOverLayer() 

-(void)returnToMainMenu;

@end

@implementation GameOverLayer

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the layer
 * @return self
 * TODO: add rating image
 */
-(id)init 
{
	self = [super init];
    
	if (self != nil) 
	{
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCSprite *background = nil;
		background = [CCSprite spriteWithFile:@"GameOverBackground.png"];
		[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:background];
		
        //NSString *statString = [NSString stringWithFormat:@"Lemmings saved: %i \n Lemmings killed: %i \n Time taken: %f \n Game rating: %s", 0, 0, 0.30, @"F"];
        NSString *statString = [NSString stringWithFormat:@"Lemmings saved: %i\nLemmings killed: %i\nTime taken: %@", [[LemmingManager sharedLemmingManager] lemmingsSaved],[[LemmingManager sharedLemmingManager] lemmingsKilled],[[GameManager sharedGameManager] getGameTimeInMins]];
        
		// Add the text for level complete.
		CCLabelBMFont *statTextLeft = [CCLabelBMFont labelWithString:statString fntFile:@"bangla_dark.fnt"];
		[statTextLeft setAnchorPoint:ccp(0, 1)];
        [statTextLeft setPosition:ccp(41, screenSize.height-110)];
		[self addChild:statTextLeft];
        
        
        //create the screen buttons
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"Menu_Back.png" selectedImage:@"Menu_Back_down.png" disabledImage:nil target:self selector:@selector(returnToMainMenu)];
        
        // create menu with the items
        buttons = [CCMenu menuWithItems:backButton, nil];
        
        // position the menu
        [buttons alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
        [buttons setPosition: ccp(screenSize.width * 0.2, screenSize.height * 0.1)];
        
        // add the menu
        [self addChild:buttons];
	}
    
	return self;
}


-(void)returnToMainMenu
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
