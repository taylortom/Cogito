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
-(void)initButtons;
-(void)initSegmentedControls;
-(void)initSliders;
-(void)initSwitches;
-(void)animateOutComponents;
-(void)removeComponents;
-(IBAction)onSliderUpdated:(UISlider*)sender;
-(IBAction)onSwitchUpdated:(UISwitch*)sender;
-(IBAction)onSegmentedControlUpdated:(UISegmentedControl*)sender;
-(void)onContinueButtonPressed;
-(void)loadMainMenu;

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
		
        // add the background
		CCSprite *background = [CCSprite spriteWithFile:@"NewGameBackground.png"];
		[background setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:background];

        // add the facade
        facade = [CCSprite spriteWithFile:@"NewGameFacade.png"];
		[facade setPosition:ccp(winSize.width/2, winSize.height/2)];
		[self addChild:facade];
        
        lemmingCount = kLemmingTotal;
        learningEpisodes = KLearningEpisodes;
        sharedKnowledge = YES;
        debugMode = NO;
        learningType = kLearningReinforcement;
        
        [self performSelector:@selector(initGUI) withObject:nil afterDelay:0.6f];
	}

	return self;
}

/**
 * Initialises all of the GUI components
 */
-(void)initGUI
{
    [self initButtons];
    [self initSegmentedControls];
    [self initSliders];
    [self initSwitches];
    
    // animate the UI components
    [UIView animateWithDuration:0.6f 
                     animations:^
     { 
         [lemmingCountSlider setAlpha:1.0f];
         [lemmingCountSlider setAlpha:1.0f];
         [learningEpisodesSlider setAlpha:1.0f];
         [learningTypeControl setAlpha:1.0f];
         [sharedKnowledgeSwitch setAlpha:1.0f];
         [debugSwitch setAlpha:1.0f]; 
     }
                     completion:^(BOOL finished)
                     { 
                         /*
                          * hide the facade when components are visible
                          * LIKE A NINJA
                          */
                         [facade setOpacity:0];
                     }
     ];
    
}

/**
 * Initialises the buttons
 */
-(void)initButtons
{    
    /**
     * Menu buttons
     */
    CCMenuItemImage* backButton = [CCMenuItemImage itemFromNormalImage:@"Back.png" selectedImage:@"Back_down.png" disabledImage:nil target:self selector:@selector(loadMainMenu)];
    CCMenuItemImage* continueButton = [CCMenuItemImage itemFromNormalImage:@"Continue.png" selectedImage:@"Continue_down.png" disabledImage:nil target:self selector:@selector(onContinueButtonPressed)];
    
    // intialise the menu
    menuButtons = [CCMenu menuWithItems:backButton, continueButton, nil];
    [menuButtons setPosition:ccp(0,0)];
    
    // position the buttons
    [backButton setPosition: ccp(80, 25)];
    [continueButton setPosition: ccp(420, 25)];
    
    // add the menu
    [self addChild:menuButtons z:kUIZValue];

}

/**
 * Initialises the segmented controls
 */
-(void)initSegmentedControls
{
    /**
     * Learning type
     */
    
    learningTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"reinforcement", @"decision tree", @"shortest path", @"none", nil]];
    [learningTypeControl setAlpha:0.0f];
    [learningTypeControl setTintColor:[Utils getUIColourFromRed:136 green:150 blue:204]];
    [learningTypeControl addTarget:self action:@selector(onSegmentedControlUpdated:)forControlEvents:UIControlEventValueChanged];
    [learningTypeControl setFrame:CGRectMake(30, (320-148), 420, 50)];
    learningTypeControl.selectedSegmentIndex = kLearningType;
    [learningTypeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [[[CCDirector sharedDirector] openGLView] addSubview:learningTypeControl];

}

/**
 * Initialises the sliders
 */
-(void)initSliders
{
    /**
     * Lemming count
     */
    
    // slider
    lemmingCountSlider = [[UISlider alloc] initWithFrame:CGRectMake(202, (320-240), 220, 50)];
    lemmingCountSlider.minimumTrackTintColor = [Utils getUIColourFromRed:102 green:153 blue:204];
    [lemmingCountSlider addTarget:self action:@selector(onSliderUpdated:)forControlEvents:UIControlEventValueChanged];
    lemmingCountSlider.minimumValue = 1.0;
    lemmingCountSlider.maximumValue = kLemmingMax;
    [lemmingCountSlider setValue:kLemmingTotal];
    [[[CCDirector sharedDirector] openGLView] addSubview:lemmingCountSlider];
    
    // value label
    lemmingCountLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", kLemmingTotal] fntFile:kFilenameDefFontLarge];
    [lemmingCountLabel setPosition:ccp(440, 209)];
    [self addChild:lemmingCountLabel];
    
    // label
    CCLabelBMFont* lemmingCountLabel2 = [CCLabelBMFont labelWithString:@"agent count" fntFile:kFilenameDefFontLarge];
    [lemmingCountLabel2 setAnchorPoint:ccp(0,0)];
    [lemmingCountLabel2 setPosition:ccp(38, 195)];
    [self addChild:lemmingCountLabel2];
    
    /**
     * Learning episodes
     */
    
    // slider
    learningEpisodesSlider = [[UISlider alloc] initWithFrame:CGRectMake(202, (320-205), 220, 50)];
    [learningEpisodesSlider setAlpha:0.0f];
    learningEpisodesSlider.minimumValue = 1.0;
    learningEpisodesSlider.maximumValue = KLearningMaxEpisodes;
    [learningEpisodesSlider setValue:KLearningEpisodes];
    learningEpisodesSlider.minimumTrackTintColor = [Utils getUIColourFromRed:102 green:153 blue:204];
    [learningEpisodesSlider addTarget:self action:@selector(onSliderUpdated:)forControlEvents:UIControlEventValueChanged];
    [[[CCDirector sharedDirector] openGLView] addSubview:learningEpisodesSlider];
    
    // value label
    learningEpisodesLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i", KLearningEpisodes] fntFile:kFilenameDefFontLarge];
    [learningEpisodesLabel setPosition:ccp(440, 174)];
    [self addChild:learningEpisodesLabel];
    
    // label
    CCLabelBMFont* learningEpisodesLabel2 = [CCLabelBMFont labelWithString:@"learning episodes" fntFile:kFilenameDefFontLarge];
    [learningEpisodesLabel2 setAnchorPoint:ccp(0,0)];
    [learningEpisodesLabel2 setPosition:ccp(38, 160)];
    [self addChild:learningEpisodesLabel2];

}

/**
 * Initialises the switches
 */
-(void)initSwitches
{
    /**
     * Shared knowledge switch
     */
    
    // switch
    sharedKnowledgeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(178, (320-80), 200, 50)];
    [sharedKnowledgeSwitch setAlpha:0.0f];
    [sharedKnowledgeSwitch setOnTintColor:[Utils getUIColourFromRed:102 green:153 blue:204]];
    [sharedKnowledgeSwitch addTarget:self action:@selector(onSwitchUpdated:)forControlEvents:UIControlEventValueChanged];
    [sharedKnowledgeSwitch setOn:YES];
    [[[CCDirector sharedDirector] openGLView] addSubview:sharedKnowledgeSwitch];
    
    // label
    sharedKnowledgeLabel = [CCLabelBMFont labelWithString:@"shared knowledge" fntFile:kFilenameDefFontLarge];
    [sharedKnowledgeLabel setPosition:ccp(100, 61)];
    [self addChild:sharedKnowledgeLabel];
    
    /**
     * Debug mode switch
     */
    
    // switch
    debugSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(374, (320-80), 200, 71)];
    [debugSwitch setAlpha:0.0f];
    [debugSwitch setOnTintColor:[Utils getUIColourFromRed:102 green:153 blue:204]];
    [debugSwitch addTarget:self action:@selector(onSwitchUpdated:)forControlEvents:UIControlEventValueChanged];
    [[[CCDirector sharedDirector] openGLView] addSubview:debugSwitch];
    
    // label
    debugModeLabel = [CCLabelBMFont labelWithString:@"debug mode" fntFile:kFilenameDefFontLarge];
    [debugModeLabel setPosition:ccp(315, 61)];
    [self addChild:debugModeLabel];
}

#pragma mark -

/**
 * Adds a fade out animation to the UIComponents
 */
-(void)animateOutComponents
{
    /*
     * show the facade again in time for the scene transition
     * LIKE A NINJA
     */
    //[facade setOpacity:255];
    
    [UIView animateWithDuration:0.6f 
        animations:^
        { 
            [lemmingCountSlider setAlpha:0.0f];
            [lemmingCountSlider setAlpha:0.0f];
            [learningEpisodesSlider setAlpha:0.0f];
            [learningTypeControl setAlpha:0.0f];
            [sharedKnowledgeSwitch setAlpha:0.0f];
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
    if(sender == debugSwitch) debugMode = sender.on;  
    else if(sender == sharedKnowledgeSwitch) sharedKnowledge = sender.on;
}

/**
 * Updates the segmented controller
 */
- (IBAction)onSegmentedControlUpdated:(UISegmentedControl*)sender
{
    learningType = sender.selectedSegmentIndex;
    
    BOOL enabled = (learningType == kLearningReinforcement) ? YES : NO;
 
    sharedKnowledgeSwitch.on = enabled;
    sharedKnowledgeSwitch.enabled = enabled;
    sharedKnowledge = enabled;
}

/**
 * Sets the data, and loads the game scene
 */
-(void)onContinueButtonPressed 
{
    CCLOG(@"Initialising game: learning: %@ lemmings: %i episodes: %i shared: %@", [Utils getLearningTypeAsString:learningType], lemmingCount, learningEpisodes, [Utils getBooleanAsString:sharedKnowledge]);

    // first set the data
    [[LemmingManager sharedLemmingManager] setLearningType:learningType];
    [[LemmingManager sharedLemmingManager] setTotalNumberOfLemmings:lemmingCount];
    [[LemmingManager sharedLemmingManager] setLearningEpisodes:learningEpisodes];
    [[LemmingManager sharedLemmingManager] setSharedKnowledge:sharedKnowledge];
    [[GameManager sharedGameManager] setDebug:debugMode];
    
    // fade out the UIComponents
    [self animateOutComponents];
    
    // load the game scene
	[[GameManager sharedGameManager] runSceneWithID:kLevelSelectScene];
}

/**
 * Loads the main menu scene
 */
-(void)loadMainMenu 
{
    [self animateOutComponents];
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

@end