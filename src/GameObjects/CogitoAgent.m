//
//  CogitoAgent.m
//  Author: Thomas Taylor
//
//  Handles the machine learning
//
//  15/01/2011: Created class
//

#import "CogitoAgent.h"

@interface CogitoAgent()

-(CCArray*)calculatePathChoices:(GameObjectType)_objectType;

@end

@implementation CogitoAgent

@synthesize helmetUses;
@synthesize umbrellaUses;

-(id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        learningMode = YES;
    }
    return self;
}

/**
 * Creates an empty table for Q-values or rewards
 */
-(void)initialiseEmptyTable
{
    // do nothing
}

/**
 * Decides which action to take based on knowledgebase
 * @param the object colliding with
 * @return the action to take
 */
-(MovementDecision)chooseAction:(GameObjectType)_objectType
{
    MovementDecision action = -1;
    BOOL chooseRandom = ((arc4random() % kRLRandomFactor) == 0) ? YES : NO;    
    CCArray* options = [self calculatePathChoices:_objectType];
    
    // if still learning, randomly choose action
    if(learningMode || chooseRandom) 
    {
        int randomIndex = arc4random() % [options count];    
        action = [[options objectAtIndex:randomIndex] intValue];
    }
    else
    {
        // get the values from the lookup table from current state
        // compare, choose best one
    }
    
    CCLOG(@"CogitoAgent.chooseAction: %@ (random: %i)", [Utils getActionAsString:action], chooseRandom);
    if(_objectType == kObjectTrapdoor) return kDecisionDownUmbrella;
    else return action;
}

/**
 * Returns a list of options available for the agent to take
 * @param the current object type
 * @return am array of options
 */
-(CCArray*)calculatePathChoices:(GameObjectType)_objectType
{
    CCArray* options = [[CCArray alloc] init];
    
    [options addObject:[NSNumber numberWithInt:kDecisionLeft]];
    [options addObject:[NSNumber numberWithInt:kDecisionRight]];
    
    if(helmetUses > 0) 
    {   
        [options addObject:[NSNumber numberWithInt:kDecisionLeftHelmet]];
        [options addObject:[NSNumber numberWithInt:kDecisionRightHelmet]];
    }
    
    // add 'down' action if appropriate
    if(_objectType == kObjectTrapdoor) 
    {
        [options addObject:[NSNumber numberWithInt:kDecisionDown]];
        if(umbrellaUses > 0) [options addObject:[NSNumber numberWithInt:kDecisionDownUmbrella]];
    }
    else if(_objectType == kObjectTerrainEnd && umbrellaUses > 0) 
        [options addObject:[NSNumber numberWithInt:kDecisionEquipUmbrella]];
    
    return options;
}

/**
 * Sets the variable to let
 * agent use knowledge base
 */
-(void)stopLearning
{
    learningMode = NO;
}

@end