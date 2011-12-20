//
//  GameOverLayer.m
//  Cogito
//
//  The game over layer
//
//  16/12/2011: Created class
//


#import "GameOverLayer.h"

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
	}
    
	return self;
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CCLOG(@"Touches received, returning to the Main Menu");
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
