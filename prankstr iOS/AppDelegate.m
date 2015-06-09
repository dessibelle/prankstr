//
//  AppDelegate.m
//  prankstr iOS
//
//  Created by Simon Fransson on 2015-06-09.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "ServiceFinder.h"
#import "ClientController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.viewController = (ViewController *)self.window.rootViewController;
    
    self.serviceFinder = [[ServiceFinder alloc] init];
    [self.serviceFinder findHosts];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.clientController disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.serviceFinder findHosts];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.clientController disconnect];
}

@end
