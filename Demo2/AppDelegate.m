//
//  AppDelegate.m
//  Demo2
//
//  Created by Andoni Dan on 07/06/16.
//  Copyright © 2016 GSMA. All rights reserved.
//

#import "AppDelegate.h"
#import <MobileConnectSDK/MobileConnectSDK-Swift.h>

#define kClientKey @"a25e91c5-ab1e-4f9e-9fd9-4cd1482c0a48"

#define kClientSecret @"1d95d440-49fe-455e-8fd4-b5903b8c78ec"

#define kSandboxEndpoint @"http://discovery.sandbox2.mobileconnect.io/v2/discovery"

#define kRedirectURL @"http://test.test.com"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MobileConnectSDK setRedirect:[NSURL URLWithString:kRedirectURL]];
    [MobileConnectSDK setClientKey:kClientKey];
    [MobileConnectSDK setClientSecret:kClientSecret];
    [MobileConnectSDK setApplicationEndpoint:kSandboxEndpoint];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
