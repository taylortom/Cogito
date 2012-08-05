//
//  DataManager.m
//  Author: Thomas Taylor
//
//  Manages the game settings
//
//  21/02/2012: Created class
//

#import "DataManager.h"

@interface DataManager()

-(int)calculateAverageFor:(NSString*)_object andType:(MachineLearningType)_learningType;
-(void)saveGameData;

@end

@implementation DataManager

static DataManager* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
    [reinforcementData release];
    [decisionTreeData release];
    [shortestRouteData release];
    [noLearningData release];
    [super dealloc];
}

/**
 * Allocates needed memory
 * @return the instance
 */
+(id)alloc
{    
    @synchronized([DataManager class])
    {
        // if the _instance already exists, stop
        NSAssert(_instance == nil, @"There should only ever be one instance of DataManager");
        _instance = [super alloc];
        return _instance;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Initialisation

/**
 * Initialises the class
 * @return self
 */
-(id)init 
{        
    self = [super init];
    
    if (self != nil) 
    {
        reinforcementData = [[NSMutableDictionary alloc] init];
        decisionTreeData = [[NSMutableDictionary alloc] init];
        shortestRouteData = [[NSMutableDictionary alloc] init];
        noLearningData = [[NSMutableDictionary alloc] init];
        
        [self loadGameData];
    }
    
    return self;
}

#pragma mark -

/**
 * Returns the DataManager instance
 * @return the instance
 */
+(DataManager*)sharedDataManager
{
    @synchronized([DataManager class])
    {
        if(!_instance) [[self alloc] init];
        return _instance;
    }
    
    return nil;
}

#pragma mark -

/**
 * Works out the average episode time for the passed learning type
 * @param learning type
 * @return the average
 */
-(int)averageEpisodeTimeLearning:(MachineLearningType)_learningType
{
    return [self calculateAverageFor:@"averageTimeLearning" andType:_learningType];
}


/**
 * Works out the average episode time (non-learning) for the passed learning type
 * @param learning type
 * @return the average
 */
-(int)averageEpisodeTimeNonLearning:(MachineLearningType)_learningType
{
    return [self calculateAverageFor:@"averageTimeNonLearning" andType:_learningType];
}

/**
 * Works out the average actions per episode for the passed learning type
 * @param learning type
 * @return the average
 */
-(int)averageActionsLearning:(MachineLearningType)_learningType
{
    return [self calculateAverageFor:@"averageActionsLearning" andType:_learningType];
}

/**
 * Works out the average actions per episode (non-learning) for the passed learning type
 * @param learning type
 * @return the average
 */
-(int)averageActionsNonLearning:(MachineLearningType)_learningType
{
    return [self calculateAverageFor:@"averageActionsNonLearning" andType:_learningType];
}

/**
 * Works out the average agents saved for the passed learning type
 * @param learning type
 * @return the average
 */
-(float)averageAgentsSaved:(MachineLearningType)_learningType
{
    int saved = [self calculateAverageFor:@"saved" andType:_learningType];
    int killed = [self calculateAverageFor:@"killed" andType:_learningType];
    
    return (float)saved/((float)(saved+killed));
}

/**
 * Calculates an average for the passed dictionary id
 * @param the object
 * @param the learning type
 * @return the average
 */
-(int)calculateAverageFor:(NSString*)_object andType:(MachineLearningType)_learningType
{
    NSMutableDictionary* learningData;
    float average = 0;
    
    switch (_learningType) 
    {
        case kLearningReinforcement:
            learningData = reinforcementData;
            break;
            
        case kLearningTree:
            learningData = decisionTreeData;
            break;
            
        case kLearningShortestRoute:
            learningData = shortestRouteData;
            break;
            
        case kLearningNone:
            learningData = noLearningData;
            break;
            
        default:
            break;
    }
    
    for(NSString* item in learningData)
    {
        NSMutableDictionary* subDict = [learningData objectForKey:item];
        average += [[subDict objectForKey:_object] intValue];
    }
    
    average /= [learningData count];
        
    return average;
}

#pragma mark -
#pragma mark Data Manipulation

/**
 * Adds the current data to the appropriate dictionary
 */
-(void)addCurrentGameData
{
    CCLOG(@"%@.addCurrentGameData: %@", NSStringFromClass([self class]), [Utils getLearningTypeAsString:[LemmingManager sharedLemmingManager].learningType]);
    
    // create references to the managers to prevent repeated calling
    AgentStats* am = [AgentStats sharedAgentStats];
    GameManager* gm = [GameManager sharedGameManager];
    LemmingManager* lm = [LemmingManager sharedLemmingManager];
    
    MachineLearningType learningType = lm.learningType;
    
    // if using mixed learning, display error and return
    if(learningType == kLearningMixed) { CCLOG(@"%@.addCurrentGameData: Can't save data when mixing learning types", NSStringFromClass([self class])); return; }
    
    // pull the data from the various managers
    int saved = [lm lemmingsSaved];
    int killed = [lm lemmingsKilled];
    int time = [gm getGameTimeInSecs];
    int learningEpisodes = [lm learningEpisodes];
    int averageTimeLearning = [am averageTimeLearning];
    int averageTimeNonLearning = [am averageTimeNonLearning];
    int averageActionsLearning = [am averageActionsLearning];
    int averageActionsNonLearning = [am averageActionsNonLearning];
    GameRating rating = [lm calculateGameRating];
    
    // stick the data into a dictionary
    NSDictionary* gameData = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [NSNumber numberWithInt:saved], @"saved", 
                                [NSNumber numberWithInt:killed], @"killed", 
                                [NSNumber numberWithInt:time], @"time", 
                                [NSNumber numberWithInt:learningEpisodes], @"learningEpisodes",
                                [NSNumber numberWithInt:averageTimeLearning], @"averageTimeLearning",
                                [NSNumber numberWithInt:averageTimeNonLearning], @"averageTimeNonLearning",
                                [NSNumber numberWithInt:averageActionsLearning], @"averageActionsLearning",
                                [NSNumber numberWithInt:averageActionsNonLearning], @"averageActionsNonLearning",
                                [NSNumber numberWithInt:rating], @"rating",  nil];
    
    // the current time will be the current game's unique key
    NSString* timeStamp = [Utils getTimeStampWithFormat:@"yyyy-MM-dd [HH:mm:ss]"];
        
    
    // add the dictionary to the save data
    switch (learningType) 
    {
        case kLearningReinforcement:
            [reinforcementData setObject:gameData forKey:[NSString stringWithFormat:@"Level%i %@", [gm currentLevel].id, timeStamp]];
            break;
            
        case kLearningTree:
            [decisionTreeData setObject:gameData forKey:timeStamp];
            break;
        
        case kLearningShortestRoute:
            [shortestRouteData setObject:gameData forKey:timeStamp];
            break;
            
        case kLearningNone:
            [noLearningData setObject:gameData forKey:timeStamp];
            break;
            
        default:
            CCLOG(@"%@.addCurrentGameData: Unknown learning type (%i)", NSStringFromClass([self class]), learningType);
            break;
    }    
    
    CCLOG(@"Adding: saved: %i killed: %i time: %i avg time L: %i avg time: %i avg actions L: %i avg actions: %i rating: %i completed at: %@", saved, killed, time, averageTimeLearning, averageTimeNonLearning, averageActionsLearning, averageActionsNonLearning, rating, timeStamp);
    [self saveGameData];
    [self exportGameData];
}

/**
 * Loads the saved stats from the previous games
 */
-(void)loadGameData
{    
    NSMutableDictionary* tempData = [[NSUserDefaults standardUserDefaults] objectForKey:kProjectName];
    
    if(tempData != nil)
    {
        [reinforcementData addEntriesFromDictionary:[tempData objectForKey:@"reinforcement"]];
        [decisionTreeData addEntriesFromDictionary:[tempData objectForKey:@"decisionTree"]];
        [shortestRouteData addEntriesFromDictionary:[tempData objectForKey:@"shortestRoute"]];        
        [noLearningData addEntriesFromDictionary:[tempData objectForKey:@"noLearning"]];        
    }
    else CCLOG(@"No data to load");
}

/**
 * Saves the stats the iPhone for later analysis
 */
-(void)saveGameData
{    
    // create a dictionary with the sub-dictionaries and Commit This To Memory.
	[[NSUserDefaults standardUserDefaults] setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys: reinforcementData, @"reinforcement", decisionTreeData, @"decisionTree", shortestRouteData, @"shortestRoute", noLearningData, @"noLearning", nil] forKey:kProjectName];
	[[NSUserDefaults standardUserDefaults] synchronize];    
}

/**
 * Clears any previously saved data 
 */
-(void)clearGameData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kProjectName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Exports the saved data to GameData.plist
 */
-(void)exportGameData
{    
    // get the documents path
    NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:kFilenameGameData];
    
    // finally write the file
    [[NSMutableDictionary dictionaryWithObjectsAndKeys: reinforcementData, @"reinforcement", decisionTreeData, @"decisionTree", shortestRouteData, @"shortestRoute", nil] writeToFile:filePath atomically:YES];
}   

/**
 * Displays the saved data
 */
-(void)printData
{
    CCLOG(@"%@.printData", NSStringFromClass([self class]));
    
    CCLOG(@"   Reinforcement: ");
    for(NSString* item in reinforcementData) NSLog(@"      [Key: %@ - Value: %@]", item, [reinforcementData valueForKey:item]);
    
    CCLOG(@"   Decision Tree: ");
    for(NSString* item in decisionTreeData) NSLog(@"      [Key: %@ - Value: %@]", item, [decisionTreeData valueForKey:item]);
    
    CCLOG(@"   Shortest Route: ");
    for(NSString* item in shortestRouteData) NSLog(@"      [Key: %@ - Value: %@]", item, [shortestRouteData valueForKey:item]);
    
    CCLOG(@"   No Learning: ");
    for(NSString* item in noLearningData) NSLog(@"      [Key: %@ - Value: %@]", item, [noLearningData valueForKey:item]);
}

@end
