//
//  main.m
//  CFPreferencesAppSynchronize
//
//  Created by Simon Fransson on 28/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Listener.h"

#import "PrankstrMessage.h"
#import "MessageHandler.h"
#import "PrefsController.h"

#import "PrankstrProtocolInterpreter.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        Listener *listener = [[Listener alloc] init];
        [listener listen];
        
        BOOL done = NO;
        do
        {
            // Start the run loop but return after each source is handled.
            SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, YES);
            
            if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
                done = YES;
        }
        while (!done);
    }
    return 0;
}
