//
//  SettingsLayer.m
//  Author: Thomas Taylor
//
//  The settings layer
//
//  16/12/2011: Created class
//

#import "SettingsLayer.h"

@interface SettingsLayer()

-(void)buildInterface;
-(void)returnToMainMenu;

@end

@implementation SettingsLayer

#pragma mark -
#pragma mark Initialisation

-(id)init 
{
	self = [super init];
	
    if (self != nil) 
    {
		CGSize screenSize = [CCDirector sharedDirector].winSize; 
		
		CCSprite *background = [CCSprite spriteWithFile:@"SettingsBackground.png"];
		[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[self addChild:background];
		
		[self buildInterface];
	}

	return self;
}

#pragma mark -

/**
 *
 */
-(void)buildInterface
{
    /*CCLabelBMFont *musicOnLabelText = [CCLabelBMFont labelWithString:@"Music ON" fntFile:@"VikingSpeechFont64.fnt"];
     CCMenuItemLabel *musicOnLabel = [CCMenuItemLabel itemWithLabel:musicOnLabelText target:self selector:nil];
     CCLabelBMFont *musicOffLabelText = [CCLabelBMFont labelWithString:@"Music OFF" fntFile:@"VikingSpeechFont64.fnt"];
     CCMenuItemLabel *musicOffLabel = [CCMenuItemLabel itemWithLabel:musicOffLabelText target:self selector:nil];
     
     CCMenuItemToggle *musicToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicTogglePressed) items:musicOnLabel,musicOffLabel,nil];
     
     CCLabelBMFont *creditsButtonLabel = [CCLabelBMFont labelWithString:@"Credits" fntFile:@"VikingSpeechFont64.fnt"];
     CCMenuItemLabel	*creditsButton = [CCMenuItemLabel itemWithLabel:creditsButtonLabel target:self selector:@selector(showCredits)];
     
     CCLabelBMFont *backButtonLabel = [CCLabelBMFont labelWithString:@"Back" fntFile:@"VikingSpeechFont64.fnt"];
     CCMenuItemLabel	*backButton = [CCMenuItemLabel itemWithLabel:backButtonLabel target:self selector:@selector(returnToMainMenu)];
     
     CCMenu *optionsMenu = [CCMenu menuWithItems:musicToggle, creditsButton, backButton, nil];
     [optionsMenu alignItemsVerticallyWithPadding:60.0f];
     [optionsMenu setPosition:ccp(screenSize.width * 0.75f, screenSize.height/2)];
     [self addChild:optionsMenu];
     
     if ([[GameManager sharedGameManager] isMusicON] == NO) [musicToggle setSelectedIndex:1]; // Music is OFF
     if ([[GameManager sharedGameManager] isSoundEffectsON] == NO) [SFXToggle setSelectedIndex:1]; // SFX are OFF*/
}

/**
 *
 */
-(void)returnToMainMenu 
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end