//
//  NewGameLayer.h
//  Author: Thomas Taylor
//
//  The 'new game' layer
//
//  16/12/2011: Created class
//

#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "LemmingManager.h"
#import "Utils.h"

@interface NewGameLayer : CCLayer

{
    // HACK: screenshot of the screen - for nice transition anim
    CCSprite* facade;
    
    int lemmingCount;
    MachineLearningType learningType;
    int learningEpisodes;
    BOOL sharedKnowledge;
    //BOOL debugMode;
    BOOL demoMode;

    // components
    
    UISlider* lemmingCountSlider;
    UISlider* learningEpisodesSlider;
    UISwitch* sharedKnowledgeSwitch;
    //UISwitch* debugSwitch;
    UISwitch* demoSwitch;
    UISegmentedControl* learningTypeControl;
    
    CCMenu *menuButtons;
    
    CCLabelBMFont* lemmingCountLabel;
    CCLabelBMFont* learningEpisodesLabel;
    CCLabelBMFont* sharedKnowledgeLabel;
    //CCLabelBMFont* debugModeLabel;
    CCLabelBMFont* demoModeLabel;
}

@end
