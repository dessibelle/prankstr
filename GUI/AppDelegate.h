//
//  AppDelegate.h
//  PrefPaneTEst
//
//  Created by Simon Fransson on 29/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PrefsController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) PrefsController *prefsController;

@end

