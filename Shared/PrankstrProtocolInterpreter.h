//
//  ProtocolParser.h
//  prankstr
//
//  Created by Simon Fransson on 2015-06-04.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrankstrProtocol.h"

@class PrankstrMessage;

@interface PrankstrProtocolInterpreter : NSObject

+ (PrankstrMessage *)interpretData:(NSData *)data;

@end
