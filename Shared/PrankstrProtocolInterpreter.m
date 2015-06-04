//
//  ProtocolParser.m
//  prankstr
//
//  Created by Simon Fransson on 2015-06-04.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "PrankstrProtocolInterpreter.h"
#import "PrankstrMessage.h"

@implementation PrankstrProtocolInterpreter

+ (PrankstrMessage *)interpretData:(NSData *)data
{
    return [[PrankstrMessage alloc] initWithData:data];
}

@end
