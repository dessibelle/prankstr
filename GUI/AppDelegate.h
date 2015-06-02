//
//  AppDelegate.h
//  PrefPaneTEst
//
//  Created by Simon Fransson on 29/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UniversalAccessPref.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak, nonatomic) IBOutlet NSButton *testButton;
@property (strong, nonatomic) UniversalAccessPref *prefPaneObject;

- (IBAction)testAction:(id)sender;
+ (NSTimeInterval)timestampSinceSystemStartup;

@end

