//
//  AboutLayer.m
//  Cogito
//
//  The 'about' layer
//
//  16/12/2011: Created class
//

#import "AboutLayer.h"

@interface AboutLayer()

-(void)returnToMainMenu;

@end

@implementation AboutLayer

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the scene
 * @return self
 */
-(id)init 
{
	self = [super init];
    
	if (self != nil) 
    {
		CGSize winSize = [CCDirector sharedDirector].winSize; 
		CCSprite *background = [CCSprite spriteWithFile:@"AboutBackground.png"];
		[background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background];
        
        //create the menu buttons
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"Menu_Back.png" selectedImage:@"Menu_Back_down.png" disabledImage:nil target:self selector:@selector(returnToMainMenu)];
        
        // create menu with the items
        buttons = [CCMenu menuWithItems:backButton, nil];
        
        // position the menu
        [buttons alignItemsVerticallyWithPadding:winSize.height * 0.059f];
        [buttons setPosition: ccp(winSize.width * 0.2, winSize.height * 0.1)];
        
        // add the menu
        [self addChild:buttons];
    }
	return self;
}

#pragma mark -

/**
 * Loads the main menu scene
 */
-(void)returnToMainMenu 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end
