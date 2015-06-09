//
//  AppDelegate.m
//  PrefPaneTEst
//
//  Created by Simon Fransson on 29/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "AppDelegate.h"
#import "PrefsController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


- (id)init
{
    if (self = [super init])
    {
        self.prefsController = [PrefsController defaultController];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window.contentView addSubview:self.prefsController.prefPaneObject.mainView];
    [self.prefsController toggleInvertColor];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}


@end
