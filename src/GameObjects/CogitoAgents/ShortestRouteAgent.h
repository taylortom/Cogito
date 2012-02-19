//
//  ShortestRouteAgent.h
//  Author: Thomas Taylor
//
//  Handles the machine learning using a shortest route policy
//
//  18/02/2012: Created class
//

#import "Lemming.h"
#import "Route.h"
#import "State.h"

@interface ShortestRouteAgent : Lemming

{
    CCArray* routes;        // list of all taken routes
    Route* currentRoute;    // the current route
    
    // shortest route vars
    Route* shortestRoute;  
    int shortestRouteIndex;
    
    BOOL learningMode;
}

@end