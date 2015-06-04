//
//  PrefsController.m
//  prankstr
//
//  Created by Simon Fransson on 03/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "PrefsController.h"
#import <objc/runtime.h>


@interface PrefsController (Private)
- (BOOL)initialize;
@end


@implementation PrefsController

+ (PrefsController *)defaultController
{
    return [[self alloc] initWithPath:@"/System/Library/PreferencePanes/UniversalAccessPref.prefPane"];
}

- (id)initWithPath:(NSString *)path
{
    if (self = [super init])
    {
        self.prefPanePath = path;
        BOOL retval = [self initialize];
        
        if (!retval)
        {
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    [self.prefPaneObject willUnselect];
    [self.prefPaneObject didUnselect];
}

- (BOOL)initialize
{
    self.prefPaneBundle = [NSBundle bundleWithPath:self.prefPanePath];
    Class prefPaneClass = [self.prefPaneBundle principalClass];
    
    self.prefPaneObject = [[prefPaneClass alloc]
                                           initWithBundle:self.prefPaneBundle];
    
    if ( [self.prefPaneObject loadMainView] ) {
        [self.prefPaneObject willSelect];
        [self.prefPaneObject didSelect];
        
        Ivar ccIvar = class_getInstanceVariable([self.prefPaneObject class], "_currentController");
        self.displayViewController = (UAPDisplayViewController *)object_getIvar(self.prefPaneObject, ccIvar);
    } else {
        return NO;
    }
    
    return YES;
}

- (void)invertColor
{
    Ivar invertColorCheckboxIvar = class_getInstanceVariable([self.displayViewController class], "_invertColorCheckbox");
    NSButton *_invertColorCheckbox = (NSButton *)object_getIvar(self.displayViewController, invertColorCheckboxIvar);

    
    [_invertColorCheckbox performClick:self.displayViewController];
}

- (void)toggleCursorSize
{
    Ivar cursorSizeSliderIvar = class_getInstanceVariable([self.displayViewController class], "_cursorSizeSlider");
    NSSlider *_cursorSizeSlider = (NSSlider *)object_getIvar(self.displayViewController, cursorSizeSliderIvar);

    [_cursorSizeSlider setDoubleValue:(_cursorSizeSlider.integerValue > 1 ? 1.0 : 4.0)];
    
    [self.displayViewController adjustCursorSize:_cursorSizeSlider];
}




@end
