//
//  AppDelegate.h
//  covrme
//
//  Created by Anthony Wong on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

- (void)registerPushTokenWithServer;
- (void)reconfigureTabBarController;
@end
