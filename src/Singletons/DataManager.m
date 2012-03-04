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

-(void)saveGameData;

@end

@implementation DataManager

static DataManager* _instance = nil;

#pragma mark -
#pragma mark Memory Allocation

-(void)dealloc
{
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
 * Adds the current data to the appropriate dictionary
 */
-(void)addCurrentGameData
{
    CCLOG(@"%@.addCurrentGameData: %@", NSStringFromClass([self class]), [Utils getLearningTypeAsString:[LemmingManager sharedLemmingManager].learningType]);
    
    MachineLearningType learningType = [LemmingManager sharedLemmingManager].learningType;
    
    // if using mixed learning, display error and return
    if(learningType == kLearningMixed) { CCLOG(@"%@.addCurrentGameData: Can't save data when mixing learning types", NSStringFromClass([self class])); return; }
    
    // pull the data from the various managers
    int saved = [[LemmingManager sharedLemmingManager] lemmingsSaved];
    int killed = [[LemmingManager sharedLemmingManager] lemmingsKilled];
    int time = [[GameManager sharedGameManager] getGameTimeInSecs];
    int learningEpisodes = [[LemmingManager sharedLemmingManager] learningEpisodes];
    int averageTimeLearning = [[AgentStats sharedAgentStats] averageTimeLearning];
    int averageTimeNonLearning = [[AgentStats sharedAgentStats] averageTimeNonLearning];
    int averageActionsLearning = [[AgentStats sharedAgentStats] averageActionsLearning];
    int averageActionsNonLearning = [[AgentStats sharedAgentStats] averageActionsNonLearning];
    GameRating rating = [[LemmingManager sharedLemmingManager] calculateGameRating];
    
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
            [reinforcementData setObject:gameData forKey:timeStamp];
            
            break;
            
        case kLearningTree:
            [decisionTreeData setObject:gameData forKey:timeStamp];
            break;
        
        case kLearningShortestRoute:
            [shortestRouteData setObject:gameData forKey:timeStamp];
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
    }
    else CCLOG(@"No data to load");
}

/**
 * Saves the stats the iPhone for later analysis
 */
-(void)saveGameData
{    
    // create a dictionary with the sub-dictionaries and Commit This To Memory.
	[[NSUserDefaults standardUserDefaults] setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys: reinforcementData, @"reinforcement", decisionTreeData, @"decisionTree", shortestRouteData, @"shortestRoute", nil] forKey:kProjectName];
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
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"GameData.plist"];
    
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
}

@end
