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

+ (NSString *)nameForCommand:(PrankstrCommand)command
{
    return [NSString stringWithCString:prankstr_command_name(command) encoding:NSUTF8StringEncoding];
}

+ (NSUInteger)argumentsForCommand:(PrankstrCommand)command
{
    return prankstr_command_argc(command);
}

+ (NSDictionary *)availableCommands
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (PrankstrCommand cmd = PrankstrCommandNoCommand + 1; cmd <= PRANKSTR_LAST_COMMAND; cmd++)
    {
        [dict setValue:@{@"name": [PrankstrProtocolInterpreter nameForCommand:cmd], @"args": [NSNumber numberWithLong:[PrankstrProtocolInterpreter argumentsForCommand:cmd]]} forKey:[NSString stringWithFormat:@"%d", cmd]];
    }
    
    return [dict copy];
}

@end
