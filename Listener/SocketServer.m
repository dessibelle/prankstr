//
//  SocketServer.m
//  prankstr
//
//  Created by Simon Fransson on 03/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "SocketServer.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "PrankstrProtocolInterpreter.h"


@implementation SocketServer

- (id)init
{
    return [[SocketServer alloc] initWithPort:0];
}

- (id)initWithPort:(UInt16)port
{
    if (self = [super init])
    {
        self.listenerSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
        
        self.port = port;
        
        self.netService = [[NSNetService alloc] initWithDomain:@"local."
                                                          type:@"_prankstr._tcp."
                                                          name:@""
                                                          port:port];
        
        [self.netService setDelegate:self];
        [self.netService publish];
        
//        NSMutableDictionary *txtDict = [NSMutableDictionary dictionaryWithCapacity:2];
//        
//        [txtDict setObject:@"moo" forKey:@"cow"];
//        [txtDict setObject:@"quack" forKey:@"duck"];
//        
//        NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
//        [netService setTXTRecordData:txtData];
    }
    return self;
}

- (UInt16)listen
{
    NSError *error = nil;
    if ([self.listenerSocket acceptOnPort:self.port error:&error])
    {
        NSLog(@"Listening for connections on port %hu", self.listenerSocket.localPort);
        
    } else {
        NSLog(@"Error creating socket: %@", error);
    }
    
    return self.listenerSocket.localPort;
}

- (void)close
{
    [self.listenerSocket disconnect];
    
    @synchronized(self.connectedSockets)
    {
        NSUInteger i;
        for (i = 0; i < [self.connectedSockets count]; i++)
        {
            // Call disconnect on the socket,
            // which will invoke the socketDidDisconnect: method,
            // which will remove the socket from the list.
            [[self.connectedSockets objectAtIndex:i] disconnect];
        }
    }
}

- (void)readDataFromSocket:(GCDAsyncSocket *)socket
{
    [socket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:PrankstrTagRequest];
}

- (void)writeData:(NSData *)data toSocket:(GCDAsyncSocket *)socket
{
    NSMutableData *mutableData = [data mutableCopy];
    
    unsigned char zeroByte = 0;
    [mutableData appendBytes:&zeroByte length:1];
    
    [socket writeData:mutableData withTimeout:-1 tag:PrankstrTagResponse];
}

#pragma mark - CocoaAsyncSocket delegate methods

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    // This method is executed on the socketQueue (not the main thread)
    
    @synchronized(self.connectedSockets)
    {
        [self.connectedSockets addObject:newSocket];
    }
    
    NSString *host = [newSocket connectedHost];
    UInt16 port = [newSocket connectedPort];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            NSLog(@"Accepted client %@:%hu", host, port);
        }
    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // This method is executed on the socketQueue (not the main thread)
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {

            [PrankstrProtocolInterpreter interpretData:[data subdataWithRange:NSMakeRange(0, [data length] - 1)]];
        }
    });
    
    PrankstrMessage *message = [PrankstrProtocolInterpreter interpretData:data];
    PrankstrStatus status = [self.delegate socketServer:self didReceiveMessage:message];
    
    NSData *response = [NSData dataWithBytes:&status length:sizeof(PrankstrStatus)];
    [self writeData:response toSocket:sock];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (sock != self.listenerSocket)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            @autoreleasepool {
                NSString *errorString = err ? [NSString stringWithFormat:@" with error: %@", err.description] : @"";
                NSLog(@"Client socket disconnected%@", errorString);
            }
        });
        
        @synchronized(self.connectedSockets)
        {
            [self.connectedSockets removeObject:sock];
        }
    }
}

#pragma mark - NSNetServiceDelegate methods

- (void)netServiceDidPublish:(NSNetService *)ns
{
    NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)",
              [ns domain], [ns type], [ns name], (int)[ns port]);
}

- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict
{
    // Override me to do something here...
    //
    // Note: This method in invoked on our bonjour thread.
    
    NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
               [ns domain], [ns type], [ns name], errorDict);
}



@end
