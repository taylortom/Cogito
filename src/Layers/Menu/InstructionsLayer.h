//
//  InstructionsLayer.h
//  Cogito
//
//  Plays the instructions animation
//
//  20/01/2012: Created class
//

#import "cocos2d.h"
#import "GameManager.h"

@interface InstructionsLayer : CCLayer

{
    CCMenu *menuButton;
    CCMenu *nextButton;
    int currentSequence;
    int numberOfImages;
    CCArray* images;
}

@end
