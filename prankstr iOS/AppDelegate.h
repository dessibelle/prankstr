//
//  AppDelegate.h
//  prankstr iOS
//
//  Created by Simon Fransson on 2015-06-09.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceFinder, ClientController, ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) ServiceFinder *serviceFinder;
@property (strong, nonatomic) ClientController *clientController;

@end

