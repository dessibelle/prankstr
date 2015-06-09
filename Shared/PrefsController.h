//
//  PrefsController.h
//  prankstr
//
//  Created by Simon Fransson on 03/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversalAccessPref.h"


@interface PrefsController : NSObject

@property (copy, nonatomic) NSString *prefPanePath;
@property (strong, nonatomic) NSBundle *prefPaneBundle;
@property (strong, nonatomic) UniversalAccessPref *prefPaneObject;
@property (strong, nonatomic) UAPDisplayViewController *displayViewController;


+ (PrefsController *)defaultController;
- (id)initWithPath:(NSString *)path;

- (void)invertColors;
- (void)toggleCursorSize;

@end
