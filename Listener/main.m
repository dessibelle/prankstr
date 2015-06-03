//
//  main.m
//  CFPreferencesAppSynchronize
//
//  Created by Simon Fransson on 28/05/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefsController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        PrefsController *prefsController = [PrefsController defaultController];
        
        [prefsController invertColor];
        [prefsController toggleCursorSize];
    }
    return 0;
}
