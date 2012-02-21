//
//  ShortestRouteAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning using a shortest route policy
//
//  18/02/2012: Created class
//

#import "AgentStats.h"
#import "CogitoAgent.h"
#import "Route.h"
#import "State.h"

@interface ShortestRouteAgent : CogitoAgent

{
    CCArray* routes;        // list of all taken routes
    Route* currentRoute;    // the current route
    
    // shortest route vars
    Route* optimumRoute;  
    int optimumRouteIndex;    
}

@end