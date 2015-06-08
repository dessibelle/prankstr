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
- (NSString *)getServiceDomain;
- (void)processMessageQueue;
@end


@implementation ClientController

// https://github.com/robbiehanson/CocoaAsyncSocket/blob/master/GCD/Xcode/BonjourClient/BonjourClientAppDelegate.m

- (id)init
{
    if (self = [super init])
    {
        self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        [self.netServiceBrowser setDelegate:self];

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

- (void)findHosts
{
//    NSString *type = [NSString stringWithCString:PRANKSTR_NET_SERVICE_TYPE encoding:NSUTF8StringEncoding];
//    NSString *domain = [self getServiceDomain];
//    
//    [self.netServiceBrowser searchForServicesOfType:type inDomain:domain];
    
    self.serviceDomains = [NSMutableArray array];
    self.availableServices = [NSMutableArray array];
    self.availableServerAdresses = [NSMutableArray array];
    
    [self.netServiceBrowser searchForBrowsableDomains];
}

- (NSString *)getServiceDomain
{
    if ([self.serviceDomains count])
    {
        NSLog(@"Domains: %@", self.serviceDomains);
        
        return [self.serviceDomains objectAtIndex:0];
    }

    return [NSString stringWithCString:PRANKSTR_NET_SERVICE_DOMAIN encoding:NSUTF8StringEncoding];
}

- (void)connectToHost:(NSString *)host onPort:(uint16_t)port
{
    NSError *err;
    
    [self.socket connectToHost:host onPort:port error:&err];
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
            [self.socket writeData:message.data withTimeout:10.0 tag:0];
            [self.messageQueue removeObjectAtIndex:0];
        }
    }
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser
            didFindDomain:(NSString *)domainName
               moreComing:(BOOL)moreDomainsComing
{
    [self.serviceDomains addObject:domainName];
    
    if (!moreDomainsComing)
    {
        NSString *type = [NSString stringWithCString:PRANKSTR_NET_SERVICE_TYPE encoding:NSUTF8StringEncoding];
        NSString *domain = [self getServiceDomain];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
            [self.netServiceBrowser setDelegate:self];
        
            [self.netServiceBrowser searchForServicesOfType:type inDomain:domain];
        });
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo
{
    NSLog(@"DidNotSearch: %@", errorInfo);
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
           didFindService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
    NSLog(@"DidFindService: %@", [netService name]);
    NSLog(@"Resolving...");
        
    [netService setDelegate:self];
    [netService resolveWithTimeout:5.0];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing
{
    NSLog(@"DidRemoveService: %@", [netService name]);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender
{
    NSLog(@"DidStopSearch");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"DidNotResolve");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"DidResolve %@: %@", [sender name], [sender addresses]);
    
    if (![self.availableServices containsObject:sender])
    {
        [self.availableServices addObject:sender];
    }
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    
    [self processMessageQueue];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"SocketDidDisconnect:WithError: %@", err);
}




@end
