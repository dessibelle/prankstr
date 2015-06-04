//
//  MessageHandler.h
//  prankstr
//
//  Created by Simon Fransson on 2015-06-05.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrankstrProtocol.h"

@class PrefsController, PrankstrMessage;

@interface MessageHandler : NSObject

@property (strong, nonatomic) PrefsController *prefsController;

- (id)initWithPrefsController:(PrefsController *)prefsController;
+ (id)defaultHandler;
- (PrankstrStatus)executeCommand:(PrankstrMessage *)message;

@end
