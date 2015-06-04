//
//  MessageHandler.m
//  prankstr
//
//  Created by Simon Fransson on 2015-06-05.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "MessageHandler.h"
#import "PrankstrMessage.h"
#import "PrefsController.h"


@implementation MessageHandler

+ (id)defaultHandler
{
    return [[MessageHandler alloc] initWithPrefsController:[PrefsController defaultController]];
}

- (id)initWithPrefsController:(PrefsController *)prefsController;
{
    if (self = [super init])
    {
        self.prefsController = prefsController;
    }
    return self;
}

- (PrankstrStatus)executeCommand:(PrankstrMessage *)message
{
    switch (message.command) {
        case PrankstrMessageInvertColors:
            [self.prefsController invertColor];
            break;
        case PrankstrMessageToggleCursorSize:
            [self.prefsController toggleCursorSize];
            break;
        case PrankstrMessageSetCursorSize:
            return PrankstrStatusError;
            break;
        case PrankstrMessageNoMessage:
            break;
    }
    
    return PrankstrStatusOK;
}


@end
