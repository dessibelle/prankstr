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
        case PrankstrCommandToggleReduceTransparency:
            [self.prefsController toggleReduceTransparency];
            break;
        case PrankstrCommandToggleIncreaseContrast:
            [self.prefsController toggleIncreaseContrast];
            break;
        case PrankstrCommandToggleDifferentiateWithoutColor:
            [self.prefsController toggleDifferentiateWithoutColor];
            break;
        case PrankstrCommandToggleInvertColor:
            [self.prefsController toggleInvertColor];
            break;
        case PrankstrCommandToggleGrayscale:
            [self.prefsController toggleGrayscale];
            break;
        case PrankstrCommandToggleContrast:
            [self.prefsController toggleContrast];
            break;
        case PrankstrCommandSetContrast:
            [self.prefsController setContrast:[[message.arguments objectAtIndex:0] doubleValue]];
            break;
        case PrankstrCommandToggleCursorSize:
            [self.prefsController toggleCursorSize];
            break;
        case PrankstrCommandSetCursorSize:
            [self.prefsController setCursorSize:[[message.arguments objectAtIndex:0] doubleValue]];
            break;
        case PrankstrCommandNoCommand:
            return PrankstrStatusError;
            break;
    }
    
    return PrankstrStatusOK;
}


@end
