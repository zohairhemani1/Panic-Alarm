//
//  AppDelegate.m
//  Panic AAlaram Application
//
//  Created by Zohair Hemani on 30/04/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Terms.h"
#import "FirstTab.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>

@implementation AppDelegate
BOOL contactsFetched;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // setting panicMessage in shared Preferences

    [UITabBar appearance].tintColor = [UIColor whiteColor];
        
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [Fabric with:@[[Digits class]]];
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"loggedIn"]isEqualToString:@"loggedIn"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
           
        self.window.rootViewController = secondView;
        [self.window makeKeyAndVisible];

    }
    
    
    Terms *a = [[Terms alloc] init];
    [a fetchContactList];
    
    [Parse setApplicationId:@"ydmTMKN3ZJ3UtKXrWipMk8Fd4nUfYfCgVJgb92lB"
                  clientKey:@"WddesaUPVKyD9H0oMbCikuP0sGR1aqev9HFBjikV"];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    //username and password
    
//        if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"username"] isEqualToString:@""])
//        {
//            NSLog(@"the username is: %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"username"]);
//    
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            UITabBarController *secondView = [storyboard instantiateViewControllerWithIdentifier:@"NavigationTime"];
//    
//            self.window.rootViewController = secondView;
//            
//            [self.window makeKeyAndVisible];
//            NSLog(@"on the second screen");
//        }
//        else{
//            [[NSUserDefaults standardUserDefaults ] setObject:@"" forKey:@"username"];
//            [[NSUserDefaults standardUserDefaults ] setObject:@"" forKey:@"password"];
//        }
    // end here
    
    
    
    
    
  //  NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
   
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// PARSE SDK Method.

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
