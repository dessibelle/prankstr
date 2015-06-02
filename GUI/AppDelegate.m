//
//  AppDelegate.m
//  PrefPaneTEst
//
//  Created by Simon Fransson on 29/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import "UniversalAccessPref.h"
#import <mach/mach.h>
#import <mach/mach_time.h>


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


+ (NSTimeInterval)timestampSinceSystemStartup
{
    // get the timebase info -- different on phone and OSX
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    // get the time
    uint64_t absTime = mach_absolute_time();
    
    // apply the timebase info
    absTime *= info.numer;
    absTime /= info.denom;
    
    // convert nanoseconds into seconds and return
    return (NSTimeInterval) ((double) absTime / 1000000000.0);
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    NSString *pathToPrefPaneBundle = @"/System/Library/PreferencePanes/UniversalAccessPref.prefPane";
    
    NSLog(@"%@", pathToPrefPaneBundle);
    
    NSBundle *prefBundle = [NSBundle bundleWithPath: pathToPrefPaneBundle];
    Class prefPaneClass = [prefBundle principalClass];
    
    self.prefPaneObject = [[prefPaneClass alloc] initWithBundle:prefBundle];
    
    NSView *prefView;
    
    if ( [self.prefPaneObject loadMainView] ) {
        [self.prefPaneObject willSelect];
        prefView = [self.prefPaneObject mainView];

        [self.window.contentView addSubview:prefView];
        
        NSRect windowFrame = [self.window contentRectForFrameRect:[self.window frame]];
        
        NSRect newWindowFrame = [self.window frameRectForContentRect:
                                 NSMakeRect( NSMinX( windowFrame ), NSMaxY( windowFrame ) - prefView.frame.size.height, prefView.bounds.size.width, prefView.bounds.size.height  + 100)];
        
        [self.window setFrame:newWindowFrame display:YES animate:[self.window isVisible]];

        
        [self.prefPaneObject didSelect];
    } else {
        NSLog(@"loadMainView failed -- handle error");
    }
    
    NSLog(@"%@", [self.prefPaneObject debugDescription]);
    
    Ivar pcIvar = class_getInstanceVariable([self.prefPaneObject class], "_paneControllers");
    Ivar ccIvar = class_getInstanceVariable([self.prefPaneObject class], "_currentController");
    
    NSMutableDictionary *_paneControllers = object_getIvar(self.prefPaneObject, pcIvar);
    UAPOptionsViewController *_currentController = object_getIvar(self.prefPaneObject, ccIvar);
    
    NSLog(@"%@, %@", _currentController, _paneControllers);
    
//    Ivar colorCheckboxIvar = class_getInstanceVariable([self.prefPaneObject class], "_invertColorCheckbox");
//    NSButton *_invertColorCheckbox = object_getIvar((id)_currentController, colorCheckboxIvar);
//
//    NSLog(@"_invertColorCheckbox.state: %ld", (long)_invertColorCheckbox.state);
//    NSLog(@"action: %@", NSStringFromSelector([_invertColorCheckbox action]));
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////        [_currentController startListeningForChanges];
//////        [(UAPDisplayViewController *)_currentController invertColors:_invertColorCheckbox];
////        [_invertColorCheckbox performClick:_currentController];
////        [_currentController stopListeningForChanges];
//        
//        NSPoint point = [_invertColorCheckbox convertPoint:_invertColorCheckbox.frame.origin toView:nil];
//        NSLog(@"point: %@", NSStringFromPoint(point));
//        NSEvent *event = [NSEvent mouseEventWithType:NSLeftMouseUp location:point modifierFlags:NSDeviceIndependentModifierFlagsMask timestamp:[[self class] timestampSinceSystemStartup] windowNumber:[self.window windowNumber] context:[self.window graphicsContext] eventNumber:0 clickCount:1 pressure:1.0];
//        
//        [[NSApplication sharedApplication] postEvent:event atStart:YES];
//        
//        _invertColorCheckbox.enabled = NO;
//        self.testButton.enabled = NO;
//        
//        NSLog(@"_invertColorCheckbox.state: %ld", (long)_invertColorCheckbox.state);
//    });
//
//    Ivar cursorSizeSliderIvar = class_getInstanceVariable([self.prefPaneObject class], "_invertColorCheckbox");
//    NSButton *_cursorSizeSlider = object_getIvar(_currentController, cursorSizeSliderIvar);
//    
//    NSLog(@"_cursorSizeSlider.value: %@", _cursorSizeSlider.value);

//    NSPoint point = [self.testButton convertPoint:_invertColorCheckbox.frame.origin toView:nil];
//    NSLog(@"point: %@", NSStringFromPoint(point));
//    NSEvent *event = [NSEvent mouseEventWithType:NSLeftMouseUp location:point modifierFlags:NSDeviceIndependentModifierFlagsMask timestamp:[[self class] timestampSinceSystemStartup] windowNumber:[self.window windowNumber] context:[self.window graphicsContext] eventNumber:0 clickCount:1 pressure:1.0];
//    
//    [[NSApplication sharedApplication] postEvent:event atStart:YES];

//    NSLog(@"----------------------------------------------- Properties for object %@", self);
//    
//    @autoreleasepool {
//        unsigned int count;
//        Ivar *ivars = class_copyIvarList([_currentController class], &count);
//        for (unsigned int i = 0; i < count; i++) {
//            Ivar ivar = ivars[i];
//            
//            const char *name = ivar_getName(ivar);
//            const char *type = ivar_getTypeEncoding(ivar);
//            ptrdiff_t offset = ivar_getOffset(ivar);
//            
//            if (strncmp(type, "i", 1) == 0) {
//                int intValue = *(int*)((uintptr_t)_currentController + offset);
//                NSLog(@"%s = %i", name, intValue);
//            } else if (strncmp(type, "f", 1) == 0) {
//                float floatValue = *(float*)((uintptr_t)_currentController + offset);
//                NSLog(@"%s = %f", name, floatValue);
//            } else if (strncmp(type, "@", 1) == 0) {
//                id value = object_getIvar(_currentController, ivar);
//                NSLog(@"%s = %@", name, value);
//            }
//            // And the rest for other type encodings
//        }
//        free(ivars);
//    }
//    NSLog(@"-----------------------------------------------");
    
    
//    NSButton *invertCheckbox = [_currentController.view viewWithTag:4000];
//    [invertCheckbox performClick:_currentController];

    Ivar invertColorCheckboxIvar = class_getInstanceVariable([_currentController class], "_invertColorCheckbox");
    NSButton *_invertColorCheckbox = (NSButton *)object_getIvar(_currentController, invertColorCheckboxIvar);
    
    Ivar cursorSizeSliderIvar = class_getInstanceVariable([_currentController class], "_cursorSizeSlider");
    NSSlider *_cursorSizeSlider = (NSSlider *)object_getIvar(_currentController, cursorSizeSliderIvar);
    
    NSLog(@"_invertColorCheckbox: %@, _cursorSizeSlider: %@", _invertColorCheckbox, _cursorSizeSlider);
    
//    [_invertColorCheckbox performClick:_currentController];
    
    NSPoint point = [_cursorSizeSlider convertPoint:_cursorSizeSlider.frame.origin toView:nil];
    NSLog(@"point: %@", NSStringFromPoint(point));
    
//    NSRect debugRect = NSMakeRect(point.x, point.y, _cursorSizeSlider.frame.size.width, _cursorSizeSlider.frame.size.height);
//    NSLog(@"debugRect: %@", NSStringFromRect(debugRect));
//    NSView *debugView = [[NSView alloc] initWithFrame:debugRect];
//    CALayer *viewLayer = [CALayer layer];
//    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0)]; //RGB plus Alpha Channel
//    [debugView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
//    [debugView setLayer:viewLayer];
//    [self.window.contentView addSubview:debugView];
    
    point = CGPointMake(point.x + _cursorSizeSlider.frame.size.width / 2.0, point.y + _cursorSizeSlider.frame.size.height / 2.0);
//    NSEvent *event = [NSEvent mouseEventWithType:NSLeftMouseUp location:CGPointMake(464, 488) modifierFlags:0 timestamp:[[self class] timestampSinceSystemStartup] windowNumber:[self.window windowNumber] context:[self.window graphicsContext] eventNumber:0 clickCount:1 pressure:1.0];
//    [[NSApplication sharedApplication] postEvent:event atStart:YES];


    /*
    [_invertColorCheckbox performClick:_currentController];

    [_cursorSizeSlider setDoubleValue:4.0];
    [(UAPDisplayViewController *)_currentController adjustCursorSize:_cursorSizeSlider];
    */
    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        // Get the current mouse position
//        CGEventRef ourEvent = CGEventCreate(NULL);
//        CGPoint mouseLocation = CGEventGetLocation(ourEvent);
//        
////        CGPoint mouseLocation = [self.window convertRectToScreen:NSMakeRect(point.x, point.y, 1, 1)].origin;
//        
//        NSLog(@"mouseLocation: %@", NSStringFromPoint(mouseLocation));
//        
//        // Create and post the event
//        CGEventRef event = CGEventCreateMouseEvent(CGEventSourceCreate(kCGEventSourceStateHIDSystemState), kCGEventLeftMouseDown, mouseLocation, kCGMouseButtonLeft);
//        CGEventPost(kCGHIDEventTap, event);
//        CFRelease(event);
//        
//        event = CGEventCreateMouseEvent(CGEventSourceCreate(kCGEventSourceStateHIDSystemState), kCGEventLeftMouseUp, mouseLocation, kCGMouseButtonLeft);
//        CGEventPost(kCGHIDEventTap, event);
//        CFRelease(event);
//        
//        event = nil;
//        
//    });

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self.prefPaneObject willUnselect];
    [self.prefPaneObject didUnselect];
}

- (IBAction)testAction:(id)sender
{
    NSLog(@"Test: %ld", (long)((NSButton *)sender).state);
}

@end
