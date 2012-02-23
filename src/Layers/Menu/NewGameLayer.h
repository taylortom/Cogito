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
    int lemmingCount;
    MachineLearningType learningType;
    int learningEpisodes;
    BOOL debugMode;

    // components
    
    UISlider* lemmingCountSlider;
    UISlider* learningEpisodesSlider;
    UISwitch* debugSwitch;
    UISegmentedControl* learningTypeControl;
    
    CCMenu *continueButton;
    
    CCLabelBMFont* lemmingCountLabel;
    CCLabelBMFont* learningEpisodesLabel;
    CCLabelBMFont* debugModeLabel;
}

@end
