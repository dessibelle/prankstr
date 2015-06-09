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
        
//        Ivar pcIvar = class_getInstanceVariable([self.prefPaneObject class], "_paneControllers");
//        NSMutableDictionary *paneControllers = (NSMutableDictionary *)object_getIvar(self.prefPaneObject, pcIvar);
//        NSLog(@"paneControllers: %@", paneControllers);
//        
//        Ivar ftcIvar = class_getInstanceVariable([self.prefPaneObject class], "_featureTableContents");
//        NSMutableArray *featureTableContents = (NSMutableArray *)object_getIvar(self.prefPaneObject, ftcIvar);
//        NSLog(@"featureTableContents: %@", featureTableContents);
//        
//        UAPDisplayViewController *dvc = [self.prefPaneObject _viewControllerForEntity:@1];
//        NSLog(@"dvc: %@", dvc);
        
        Ivar ftIvar = class_getInstanceVariable([self.prefPaneObject class], "_featureTable");
        NSTableView *featureTable = (NSTableView *)object_getIvar(self.prefPaneObject, ftIvar);
        [featureTable selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
        
        Ivar ccIvar = class_getInstanceVariable([self.prefPaneObject class], "_currentController");
        self.displayViewController = (UAPDisplayViewController *)object_getIvar(self.prefPaneObject, ccIvar);
    } else {
        return NO;
    }
    
    return YES;
}

- (void)invertColors
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
