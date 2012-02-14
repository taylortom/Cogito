//
//  AppDelegate.h
//  Author: Thomas Taylor
//
//  13/11/2011: Created class
//

#import "GameManager.h"
#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> 

{
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic,retain) UIWindow *window;

@end