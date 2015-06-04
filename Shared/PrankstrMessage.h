//
//  PrankstrMessage.h
//  prankstr
//
//  Created by Simon Fransson on 2015-06-05.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrankstrProtocol.h"

@interface PrankstrMessage : NSObject

@property (strong, nonatomic) NSData *data;
@property (assign, nonatomic) PrankstrCommand command;
@property (copy, nonatomic) NSArray *arguments;

- (id)initWithData:(NSData *)data;

@end
