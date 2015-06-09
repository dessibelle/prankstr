//
//  PrankstrMessage.m
//  prankstr
//
//  Created by Simon Fransson on 2015-06-05.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "PrankstrMessage.h"

@interface PrankstrMessage (Private)
- (void)initialize;
- (void)initializeWithData;
- (void)initializeWithCommand;
@end

@implementation PrankstrMessage

- (id)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        self.data = data;
        [self initialize];
    }
    return self;
}

- (id)initWithCommand:(PrankstrCommand)command andArguments:(NSArray *)arguments
{
    if (self = [super init])
    {
        self.command = command;
        self.arguments = arguments == nil ? [NSArray array] : arguments;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (self.command != PrankstrCommandNoCommand)
    {
        [self initializeWithCommand];
    } else if ([self.data length])
    {
        [self initializeWithData];
    }
}

- (void)initializeWithData
{
    const unsigned char *bytes = [self.data bytes];
    
    self.command = (PrankstrCommand)bytes[0];
    
    if ([self.data length] > 1) {
        NSString *args = [[NSString alloc] initWithData:[self.data subdataWithRange:NSMakeRange(1, [self.data length] - 1)] encoding:NSUTF8StringEncoding];
        
        self.arguments = [args componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        self.arguments = [NSArray array];
    }
}

- (void)initializeWithCommand
{
    const char *bytes = (const char *)self.command;
    
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:&bytes length:1];
    NSString *argumentsString = [self.arguments componentsJoinedByString:@" "];
    [data appendData:[argumentsString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.data = [data copy];
}

@end
