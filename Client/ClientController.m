//
//  ClientController.m
//  prankstr
//
//  Created by Simon Fransson on 04/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "ClientController.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "PrankstrMessage.h"


@interface ClientController (Private)
- (void)processMessageQueue;
@end


@implementation ClientController

- (id)init
{
    if (self = [super init])
    {
        self.messageQueue = [NSMutableArray array];
        
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (id)initWithHost:(NSString *)host port:(uint16_t)port
{
    if (self = [self init])
    {
        self.host = host;
        self.port = port;
    }
    return self;
}

- (void)connect
{
    NSError *err;

    [self.socket connectToHost:self.host onPort:self.port error:&err];
    
    if (err)
    {
        NSLog(@"Error: %@", err);
    }
}

- (void)connectToHost:(NSString *)host onPort:(uint16_t)port
{
    self.host = host;
    self.port = port;
    
    [self connect];
}

- (BOOL)isConnected
{
    return self.socket.isConnected;
}

- (void)disconnect
{
    if (self.socket.isConnected)
    {
        [self.socket disconnectAfterWriting];
    }
}

- (void)sendCommand:(PrankstrCommand)command andArguments:(NSArray *)arguments
{
    PrankstrMessage *message = [[PrankstrMessage alloc] initWithCommand:command andArguments:arguments];
    [self sendMessage:message];
}

- (void)sendMessage:(PrankstrMessage *)message {
    [self.messageQueue addObject:message];
    [self processMessageQueue];
}

- (void)processMessageQueue
{
    if ([self.socket isConnected])
    {
        while ([self.messageQueue count])
        {
            PrankstrMessage *message = [self.messageQueue objectAtIndex:0];
            
//            NSLog(@"Sending message: %@", message.data);
            
            [self.socket writeData:message.data withTimeout:10.0 tag:0];
            [self.messageQueue removeObjectAtIndex:0];
        }
    }
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    
    [self processMessageQueue];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    NSLog(@"SocketDidDisconnect:WithError: %@", err);
}




@end
