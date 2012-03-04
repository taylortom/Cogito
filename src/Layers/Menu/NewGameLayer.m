//
//  NewGameLayer.m
//  Author: Thomas Taylor
//
//  The 'new game' layer
//
//  16/12/2011: Created class
//

#import "NewGameLayer.h"

@interface NewGameLayer()

-(void)initGUI;
-(void)animateOutComponents;
-(void)removeComponents;
-(IBAction)onSliderUpdated:(UISlider*)sender;
-(IBAction)onSwitchUpdated:(UISwitch*)sender;
-(IBAction)onSegmentedControlUpdated:(UISegmentedControl*)sender;
-(void)onContinueButtonPressed;

@end

@implementation NewGameLayer

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
		
		CCSprite *background = [CCSprite spriteWithFile:@"NewGameBackground.png"];
		[background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background];
        
        lemmingCount = kLemmingTotal;
        learningEpisodes = KLearningEpisodes;
        debugMode = NO;
        learningType = kLearningReinforcement;
        
        [self performSelector:@selector(initGUI) withObject:nil afterDelay:0.6f];
	}

	return self;
}

/**
 * Creates all of the GUI components
 */
-(void)initGUI
{
    /**
     * Lemming count
     */
    
    // slider
    lemmingCountSlider = [[UISlider alloc] initWithFrame:CGRectMake(202, (320-220), 220, 50)];
    lemmingCountSlider.minimumTrackTintColor = [Utils getUIColourFromRed:102 green:153 blue:204];
    [lemmingCountSlider addTarget:self action:@selector(onSliderUpdated:)forControlEvents:UIControlEventValueChanged];
    lemmingCountSlider.minimumValue = 1.0;
    lemmingCountSlider.maximumValue = kLemmingMax;
    [lemmingCountSlider setValue:kLemmingTotal];
    [[[CCDirector sharedDirector] openGLView] addSubview:lemmingCountSlider];
    
    // value label
    lemmingCountLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", kLemmingTotal] fntFile:kFilenameDefFontLarge];
    [lemmingCountLabel setPosition:ccp(440, 189)];
    [self addChild:lemmingCountLabel];

    // label
    CCLabelBMFont* lemmingCountLabel2 = [CCLabelBMFont labelWithString:@"agent count" fntFile:kFilenameDefFontLarge];
    [lemmingCountLabel2 setAnchorPoint:ccp(0,0)];
    [lemmingCountLabel2 setPosition:ccp(38, 175)];
    [self addChild:lemmingCountLabel2];
    
    /**
     * Learning episodes
     */
    
    // slider
    learningEpisodesSlider = [[UISlider alloc] initWithFrame:CGRectMake(202, (320-180), 220, 50)];
    [learningEpisodesSlider setAlpha:0.0f];
    learningEpisodesSlider.minimumValue = 1.0;
    learningEpisodesSlider.maximumValue = KLearningMaxEpisodes;
    [learningEpisodesSlider setValue:KLearningEpisodes];
    learningEpisodesSlider.minimumTrackTintColor = [Utils getUIColourFromRed:102 green:153 blue:204];
    [learningEpisodesSlider addTarget:self action:@selector(onSliderUpdated:)forControlEvents:UIControlEventValueChanged];
    [[[CCDirector sharedDirector] openGLView] addSubview:learningEpisodesSlider];
    
    // value label
    learningEpisodesLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", KLearningEpisodes] fntFile:kFilenameDefFontLarge];
    [learningEpisodesLabel setPosition:ccp(440, 149)];
    [self addChild:learningEpisodesLabel];
    
    // label
    CCLabelBMFont* learningEpisodesLabel2 = [CCLabelBMFont labelWithString:@"learning episodes" fntFile:kFilenameDefFontLarge];
    [learningEpisodesLabel2 setAnchorPoint:ccp(0,0)];
    [learningEpisodesLabel2 setPosition:ccp(38, 135)];
    [self addChild:learningEpisodesLabel2];
    
    
    /**
     * Segment control
     */

    learningTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"reinforcement", @"decision tree", @"shortest path", @"none", nil]];
    [learningTypeControl setAlpha:0.0f];
    [learningTypeControl setTintColor:[Utils getUIColourFromRed:136 green:150 blue:204]];
    [learningTypeControl addTarget:self action:@selector(onSegmentedControlUpdated:)forControlEvents:UIControlEventValueChanged];
    [learningTypeControl setFrame:CGRectMake(30, (320-120), 420, 50)];
    learningTypeControl.selectedSegmentIndex = kLearningType;
    [learningTypeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [[[CCDirector sharedDirector] openGLView] addSubview:learningTypeControl];

    /**
     * Debug mode switch
     */
    
    // switch
    debugSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(150, (320-50), 200, 50)];
    [debugSwitch setAlpha:0.0f];
    [debugSwitch setOnTintColor:[Utils getUIColourFromRed:102 green:153 blue:204]];
    [debugSwitch addTarget:self action:@selector(onSwitchUpdated:)forControlEvents:UIControlEventValueChanged];
    [[[CCDirector sharedDirector] openGLView] addSubview:debugSwitch];
    
    // label
    debugModeLabel = [CCLabelBMFont labelWithString:@"debug mode" fntFile:kFilenameDefFontLarge];
    [debugModeLabel setPosition:ccp(85, 31)];
    [self addChild:debugModeLabel];
    
    /**
     * Continue button
     */
    CCMenuItemImage *_continueButton = [CCMenuItemImage itemFromNormalImage:@"Continue.png" selectedImage:@"Continue_down.png" disabledImage:nil target:self selector:@selector(onContinueButtonPressed)];
    continueButton = [CCMenu menuWithItems:_continueButton, nil];
    [continueButton setPosition: ccp(410, 37)];
    [self addChild:continueButton z:100];
    
    // animate the UI components
    
    [UIView animateWithDuration:0.6f 
        animations:^
        { 
            [lemmingCountSlider setAlpha:1.0f];
            [lemmingCountSlider setAlpha:1.0f];
            [learningEpisodesSlider setAlpha:1.0f];
            [learningTypeControl setAlpha:1.0f];
            [debugSwitch setAlpha:1.0f]; 
        }
        completion:^(BOOL finished){ }
     ];
}

#pragma mark -

/**
 * Adds a fade out animation to the UIComponents
 */
-(void)animateOutComponents
{
    [UIView animateWithDuration:0.6f 
        animations:^
        { 
            [lemmingCountSlider setAlpha:0.0f];
            [lemmingCountSlider setAlpha:0.0f];
            [learningEpisodesSlider setAlpha:0.0f];
            [learningTypeControl setAlpha:0.0f];
            [debugSwitch setAlpha:0.0f]; 
        }
        completion:^(BOOL finished)
        {
            if(finished) [self removeComponents];
        }
     ];
}

/**
 * Cleans up the components
 */ 
-(void)removeComponents
{
    NSArray * subviews = [[CCDirector sharedDirector] openGLView].subviews;
    for (id sv in subviews) 
    {
        [((UIView *)sv) removeFromSuperview];
        [sv release];
    }
}

#pragma mark -
#pragma mark Event Handling

/**
 * Updates the labels/values associated with the moved slider
 */
- (IBAction)onSliderUpdated:(UISlider*)sender
{    
    if(sender == lemmingCountSlider) 
    {
        lemmingCount = sender.value;
        [lemmingCountLabel setString:[NSString stringWithFormat:@"%i", lemmingCount]];
    }
    else if(sender == learningEpisodesSlider) 
    {
        learningEpisodes = sender.value;
        [learningEpisodesLabel setString:[NSString stringWithFormat:@"%i", learningEpisodes]];
    }
}

/**
 * Updates the switch
 */
- (IBAction)onSwitchUpdated:(UISwitch*)sender
{   
    debugMode = sender.on;  
}

/**
 * Updates the segmented controller
 */
- (IBAction)onSegmentedControlUpdated:(UISegmentedControl*)sender
{
    learningType = sender.selectedSegmentIndex;
}

/**
 * Sets the data, and loads the game scene
 */
-(void)onContinueButtonPressed 
{
    // first set the data
    [[LemmingManager sharedLemmingManager] setLearningType:learningType];
    [[LemmingManager sharedLemmingManager] setTotalNumberOfLemmings:lemmingCount];
    [[LemmingManager sharedLemmingManager] setLearningEpisodes:learningEpisodes];
    [[GameManager sharedGameManager] setDebug:debugMode];
    
    [self animateOutComponents];
    
    // load the game scene
	[[GameManager sharedGameManager] runSceneWithID:kGameLevelScene];
}

@end