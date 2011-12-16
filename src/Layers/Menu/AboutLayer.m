//
//  AboutLayer.m
//  Cogito
//
//  The 'about' layer
//
//  16/12/2011: Created class
//

#import "AboutLayer.h"

@implementation AboutLayer

#pragma mark -
#pragma mark Initialisation

-(id)init 
{
	self = [super init];
    
	if (self != nil) 
    {
		CGSize screenSize = [CCDirector sharedDirector].winSize; 
		CCSprite *background = [CCSprite spriteWithFile:@"AboutBackground.png"];
		[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:background];
        
        //create the menu buttons
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

#pragma mark -

-(void)returnToMainMenu 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
