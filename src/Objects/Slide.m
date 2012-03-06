//
//  Slide.m
//  Author: Thomas Taylor
//
//  Used in the Stats screen, displays graphs
//  and other information
//
//  06/03/2012: Created class
//

#import "Slide.h"

@interface Slide()

-(void)initBars;
-(void)updateEpisodeTimeGraph;
-(void)updateActionsGraph;
-(void)updateAgentsSavedGraph;

@end

@implementation Slide

@synthesize graphType;

#pragma mark -
#pragma mark Memory Allocation

/**
 * Releases any used storage
 */
-(void)dealloc
{
    [background release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the state
 * @return self
 */
-(id)initWithImage:(NSString*)_imageName graph:(GraphType)_graphType
{    
    self = [super init];
    
    if (self != nil) 
    {
        background = [CCSprite spriteWithFile:_imageName];
        [self addChild:background];
        
        graphType = _graphType;
        
        if(graphType != kGraphNone) [self initBars];
    }
    return self;
}

#pragma mark -

/**
 * Adds the bars to the graph
 */
-(void)initBars
{
    NSString* barImage = @"GraphBar.png";
    
    // colours
    ccColor3B beforeColour = ccc3(120, 171, 211);
    ccColor3B afterColour = ccc3(91, 131, 163);
    
    float yPos = 44.6;
    float startScale = 0.02;
    
    // reinforcement
    
    reinforcementBefore = [CCSprite spriteWithFile:barImage];
    reinforcementAfter = [CCSprite spriteWithFile:barImage];
    
    reinforcementBefore.position = ccp(87, yPos);
    reinforcementAfter.position = ccp(94, yPos);

    [reinforcementBefore setAnchorPoint:ccp(0.5, 0)];
    [reinforcementAfter setAnchorPoint:ccp(0.5, 0)];
    
    [reinforcementBefore setColor:beforeColour];
    [reinforcementAfter setColor:afterColour];

    reinforcementBefore.scaleY = startScale;
    reinforcementAfter.scaleY = startScale;
    
    [background addChild:reinforcementBefore];
    [background addChild:reinforcementAfter];
        
    // decision tree
    
    decisionTreeBefore = [CCSprite spriteWithFile:barImage];
    decisionTreeAfter = [CCSprite spriteWithFile:barImage];
    
    decisionTreeBefore.position = ccp(157, yPos);
    decisionTreeAfter.position = ccp(164, yPos);
    
    [decisionTreeBefore setAnchorPoint:ccp(0.5, 0)];
    [decisionTreeAfter setAnchorPoint:ccp(0.5, 0)];
    
    [decisionTreeBefore setColor:beforeColour];
    [decisionTreeAfter setColor:afterColour];
    
    decisionTreeBefore.scaleY = startScale;
    decisionTreeAfter.scaleY = startScale;
    
    [background addChild:decisionTreeBefore];
    [background addChild:decisionTreeAfter];
    
    // shortest route
    
    shortestRouteBefore = [CCSprite spriteWithFile:barImage];
    shortestRouteAfter = [CCSprite spriteWithFile:barImage];
    
    shortestRouteBefore.position = ccp(227, yPos);
    shortestRouteAfter.position = ccp(234.9, yPos);
    
    [shortestRouteBefore setAnchorPoint:ccp(0.5, 0)];
    [shortestRouteAfter setAnchorPoint:ccp(0.5, 0)];
    
    [shortestRouteBefore setColor:beforeColour];
    [shortestRouteAfter setColor:afterColour];
    
    shortestRouteBefore.scaleY = startScale;
    shortestRouteAfter.scaleY = startScale;
    
    [background addChild:shortestRouteBefore];
    [background addChild:shortestRouteAfter];
    
    // none
    
    noneBefore = [CCSprite spriteWithFile:barImage];
    noneAfter = [CCSprite spriteWithFile:barImage];
    
    noneBefore.position = ccp(293, yPos);
    noneAfter.position = ccp(300.8, yPos);
    
    [noneBefore setAnchorPoint:ccp(0.5, 0)];
    [noneAfter setAnchorPoint:ccp(0.5, 0)];
    
    [noneBefore setColor:beforeColour];
    [noneAfter setColor:afterColour];
    
    noneBefore.scaleY = startScale;
    noneAfter.scaleY = startScale;
    
    [background addChild:noneBefore];
    [background addChild:noneAfter];
}

/**
 * Updates the slide
 */
-(void)update
{
    switch(graphType) 
    {
        case kGraphEpisodeTime:
            [self updateEpisodeTimeGraph];
            break;
        
        case kGraphActions:
            [self updateActionsGraph];
            break;
        
        case kGraphAgentsSaved:
            [self updateAgentsSavedGraph];
            break;
            
        case kGraphNone:
            CCLOG(@"NOT A GRAPH. DO SOMETHING!!!");
            break;
            
        default:
            break;
    }
}

/**
 * Updates the graph displaying average episode time
 */
-(void)updateEpisodeTimeGraph
{    
    DataManager* dm = [DataManager sharedDataManager];
    float maxTime = 60.0f;
    
    // reinforcment
        
    reinforcementBefore.scaleY = (float)[dm averageEpisodeTimeLearning:kLearningReinforcement]/(float)maxTime;
    reinforcementAfter.scaleY = (float)[dm averageEpisodeTimeNonLearning:kLearningReinforcement]/(float)maxTime;
    
    // decision tree
    
    decisionTreeBefore.scaleY = (float)[dm averageEpisodeTimeLearning:kLearningTree]/maxTime;
    decisionTreeAfter.scaleY = (float)[dm averageEpisodeTimeNonLearning:kLearningTree]/maxTime;
    
    // shortest route
    
    shortestRouteBefore.scaleY = (float)[dm averageEpisodeTimeLearning:kLearningShortestRoute]/maxTime;
    shortestRouteAfter.scaleY = (float)[dm averageEpisodeTimeNonLearning:kLearningShortestRoute]/maxTime;
    
    // none
    
    noneBefore.scaleY = (float)[dm averageEpisodeTimeLearning:kLearningNone]/maxTime;
    noneAfter.scaleY = (float)[dm averageEpisodeTimeNonLearning:kLearningNone]/maxTime;
}

/**
 * Updates the graph displaying average actions
 */
-(void)updateActionsGraph
{    
    DataManager* dm = [DataManager sharedDataManager];
    float maxActions = 10.0f;
    
    // reinforcment
    
    reinforcementBefore.scaleY = (float)[dm averageActionsLearning:kLearningReinforcement]/maxActions;
    reinforcementAfter.scaleY = (float)[dm averageActionsNonLearning:kLearningReinforcement]/maxActions;
    
    // decision tree
    
    decisionTreeBefore.scaleY = (float)[dm averageActionsLearning:kLearningTree]/maxActions;
    decisionTreeAfter.scaleY = (float)[dm averageActionsNonLearning:kLearningTree]/maxActions;
    
    // shortest route
    
    shortestRouteBefore.scaleY = (float)[dm averageActionsLearning:kLearningShortestRoute]/maxActions;
    shortestRouteAfter.scaleY = (float)[dm averageActionsNonLearning:kLearningShortestRoute]/maxActions;
    
    // none
    
    noneBefore.scaleY = (float)[dm averageActionsLearning:kLearningNone]/maxActions;
    noneAfter.scaleY = (float)[dm averageActionsNonLearning:kLearningNone]/maxActions;
}

/**
 * Updates the graph displaying agents saved
 */
-(void)updateAgentsSavedGraph
{    
    DataManager* dm = [DataManager sharedDataManager];
    
    reinforcementAfter.scaleY = [dm averageAgentsSaved:kLearningReinforcement];
    decisionTreeAfter.scaleY = [dm averageAgentsSaved:kLearningTree];
    shortestRouteAfter.scaleY = [dm averageAgentsSaved:kLearningShortestRoute];
    noneAfter.scaleY = (float)[dm averageAgentsSaved:kLearningNone];
}


@end
