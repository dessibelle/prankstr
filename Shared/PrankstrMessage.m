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

- (void)initialize
{
    if ([self.data length]) {
        const unsigned char *bytes = [self.data bytes];
        
        self.command = bytes[0];
        
        if ([self.data length] > 1) {
            NSString *args = [[NSString alloc] initWithData:[self.data subdataWithRange:NSMakeRange(1, [self.data length] - 1)] encoding:NSUTF8StringEncoding];
            
            self.arguments = [args componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else {
            self.arguments = [NSArray array];
        }
    }
}

@end
