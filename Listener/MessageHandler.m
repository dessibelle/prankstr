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

+ (MessageHandler *)defaultHandler
{
    return [[MessageHandler alloc] initWithPrefsController:[PrefsController defaultController]];
}

- (id)init {
    self = (id)[MessageHandler defaultHandler];
    return self;
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
        case PrankstrCommandInvertColors:
            [self.prefsController invertColors];
            break;
        case PrankstrCommandToggleCursorSize:
            [self.prefsController toggleCursorSize];
            break;
        case PrankstrCommandSetCursorSize:
            return PrankstrStatusError;
            break;
        case PrankstrCommandNoMessage:
            break;
    }
    
    return PrankstrStatusOK;
}


@end
