//
//  main.m
//  CFPreferencesAppSynchronize
//
//  Created by Simon Fransson on 28/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversalAccessPref.h"
#import <objc/runtime.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *pathToPrefPaneBundle = @"/System/Library/PreferencePanes/UniversalAccessPref.prefPane";

        NSBundle *prefBundle = [NSBundle bundleWithPath: pathToPrefPaneBundle];
        Class prefPaneClass = [prefBundle principalClass];

        UniversalAccessPref *prefPaneObject = [[prefPaneClass alloc]
                                            initWithBundle:prefBundle];

        NSView *prefView;

        if ( [prefPaneObject loadMainView] ) {
            [prefPaneObject willSelect];
            prefView = [prefPaneObject mainView];
            /* Add view to window */
            [prefPaneObject didSelect];
            
            Ivar ccIvar = class_getInstanceVariable([prefPaneObject class], "_currentController");
            UAPOptionsViewController *_currentController = object_getIvar(prefPaneObject, ccIvar);
            
            Ivar invertColorCheckboxIvar = class_getInstanceVariable([_currentController class], "_invertColorCheckbox");
            NSButton *_invertColorCheckbox = (NSButton *)object_getIvar(_currentController, invertColorCheckboxIvar);
            
            Ivar cursorSizeSliderIvar = class_getInstanceVariable([_currentController class], "_cursorSizeSlider");
            NSSlider *_cursorSizeSlider = (NSSlider *)object_getIvar(_currentController, cursorSizeSliderIvar);
            
            [_invertColorCheckbox performClick:_currentController];
            
            [_cursorSizeSlider setDoubleValue:(_cursorSizeSlider.integerValue > 1 ? 1.0 : 4.0)];
            [(UAPDisplayViewController *)_currentController adjustCursorSize:_cursorSizeSlider];
            
            [prefPaneObject willUnselect];
            [prefPaneObject didUnselect];
        } else {
            NSLog(@"loadMainView failed -- handle error");
        }
        
    }
    return 0;
}
