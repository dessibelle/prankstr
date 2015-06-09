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
- (void)setSliderValue:(double)value forIvarNamed:(NSString *)ivarName usingSelector:(SEL)action;
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

- (void)toggleCheckboxForIvarNamed:(NSString *)ivarName
{
    Ivar invertColorCheckboxIvar = class_getInstanceVariable([self.displayViewController class], [ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    NSButton *_invertColorCheckbox = (NSButton *)object_getIvar(self.displayViewController, invertColorCheckboxIvar);
    
    [_invertColorCheckbox performClick:self.displayViewController];
}

- (void)setSliderValue:(double)value forIvarNamed:(NSString *)ivarName usingSelector:(SEL)action
{
    Ivar sliderIvar = class_getInstanceVariable([self.displayViewController class], [ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    NSSlider *slider = (NSSlider *)object_getIvar(self.displayViewController, sliderIvar);
        
    if (value < slider.minValue)
    {
        value = (slider.doubleValue > slider.minValue ? slider.minValue : slider.maxValue);
    }
    
    [slider setDoubleValue:MAX(slider.minValue, MIN(slider.maxValue, value))];
    
//    [self.displayViewController performSelector:action withObject:slider];
    IMP imp = [self.displayViewController methodForSelector:action];
    void (*func)(id, SEL) = (void *)imp;
    func(self.displayViewController, action);

}

- (void)toggleReduceTransparency
{
    [self toggleCheckboxForIvarNamed:@"_reduceTransparencyCheckbox"];
}

- (void)toggleIncreaseContrast
{
    [self toggleCheckboxForIvarNamed:@"_increaseContrastCheckbox"];
}

- (void)toggleDifferentiateWithoutColor
{
    [self toggleCheckboxForIvarNamed:@"_differentiateWithoutColorCheckbox"];
}

- (void)toggleInvertColor
{
    [self toggleCheckboxForIvarNamed:@"_invertColorCheckbox"];
}

- (void)toggleGrayscale
{
    [self toggleCheckboxForIvarNamed:@"_grayscaleCheckbox"];
}

- (void)toggleContrast
{
    [self setContrast:-1];
}

- (void)setContrast:(double)contrast
{
    [self setSliderValue:contrast forIvarNamed:@"_enhanceContrastSlider" usingSelector:@selector(adjustContrast:)];
}

- (void)toggleCursorSize
{
    [self setCursorSize:-1];
}

- (void)setCursorSize:(double)cursorSize
{
    [self setSliderValue:cursorSize forIvarNamed:@"_cursorSizeSlider" usingSelector:@selector(adjustCursorSize:)];
}

@end
