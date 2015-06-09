//
//  ClientController.h
//  prankstr
//
//  Created by Simon Fransson on 04/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrankstrProtocol.h"

@class GCDAsyncSocket, PrankstrMessage;

@interface ClientController : NSObject

@property (copy, nonatomic) NSString *host;
@property (assign, nonatomic) uint16_t port;
@property (strong, nonatomic) NSMutableArray *messageQueue;
@property (strong, nonatomic) GCDAsyncSocket *socket;

- (id)initWithHost:(NSString *)host port:(uint16_t)port;
- (void)sendCommand:(PrankstrCommand)command andArguments:(NSArray *)arguments;
- (void)sendMessage:(PrankstrMessage *)message;
- (void)connect;
- (void)connectToHost:(NSString *)host onPort:(uint16_t)port;

@end
