//
//  AppDelegate.m
//  covrme
//
//  Created by Anthony Wong on 12-03-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "UAirship.h"
#import "UAPush.h"
#import "CMFrontDoorViewController.h"
#import "CMHistoryListViewController.h"
#import "CMSettingsViewController.h"
#import "CMRegistrationViewController.h"
#import "CMAPIClient.h"
#import "CMLoginViewController.h"
#import "UIColor+Helpers.h"

@implementation AppDelegate

- (void)customizeAppearance
{
    [[UIView appearance] setTintColor:[UIColor colorFromHexString:@"0f75bc"]];
    [[UINavigationBar appearance] setTitleTextAttributes:
        @{NSForegroundColorAttributeName : [UIColor colorFromHexString:@"ffffff"],
          NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:22]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexString:@"ffffff"]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"0f75bc"]];
}

- (void)registerPushTokenWithServer
{
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"userPushToken"];
    
    if (!pushToken.length) {
        return;
    }
    
    [[CMAPIClient sharedClient] registerPushToken:pushToken
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSLog(@"Successfully registered pushtoken %@", pushToken);
                                          }
                                          failure:^(NSHTTPURLResponse *response, NSError *error) {
                                              NSLog(@"Failed to register pushtoken %@", pushToken);
                                          }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];    
    
    [self customizeAppearance];
    
    // Urban Airship
    
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    
    
    // Register for notifications
    [[UAPush shared]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    
    // Setup CoreData
    [MagicalRecord setupCoreDataStack];
    
    // Front Door VC
    CMFrontDoorViewController *frontDoorVC = [[CMFrontDoorViewController alloc] initWithNibName:@"CMFrontDoorViewController"
                                                                                         bundle:nil];
    UINavigationController *frontDoorNavController = [[UINavigationController alloc] initWithRootViewController:frontDoorVC];
    frontDoorNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    // History List VC
    CMHistoryListViewController *historyListVC = [[CMHistoryListViewController alloc] initWithNibName:@"CMHistoryListViewController"
                                                                                               bundle:nil];
    UINavigationController *historyListNavController = [[UINavigationController alloc] initWithRootViewController:historyListVC];
    historyListNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;


    // Settings VC
    CMSettingsViewController *settingsVC = [[CMSettingsViewController alloc] initWithNibName:@"CMSettingsViewController"
                                                                                      bundle:nil];
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    settingsNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;


    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[frontDoorNavController, historyListNavController, settingsNavController];
    
    if ([launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        self.tabBarController.selectedIndex = 0;
    } else {
        self.tabBarController.selectedIndex = 1;
    }
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    // Maybe present registration if required
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"token"]){
        CMLoginViewController *loginVC =
            [[CMLoginViewController alloc] initWithNibName:@"CMLoginViewController"
                                                    bundle:nil];
        
        UINavigationController *loginNavController =
            [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.tabBarController presentViewController:loginNavController
                                            animated:YES
                                          completion:nil];
    }
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [MagicalRecord cleanUp];
    [UAirship land];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Push Token Received!
    self.tabBarController.selectedIndex = 0;
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store device id
    NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString* deviceTokenFormatted = [[[deviceToken description]
                                       stringByTrimmingCharactersInSet:characterSet]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceTokenFormatted forKey:@"userPushToken"];
    [defaults synchronize];
    
    if ([defaults valueForKey:@"userID"]) {
        [self registerPushTokenWithServer];
    }
    
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"FAILED TO REGISTER FOR PUSH: %@", err);
}


@end
