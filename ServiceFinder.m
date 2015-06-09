//
//  ServiceFinder.m
//  prankstr
//
//  Created by Simon Fransson on 09/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "ServiceFinder.h"
#import "PrankstrMessage.h"
#import "ClientController.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


@interface ServiceFinder (Private)
- (NSString *)getServiceDomain;
+ (NSString *)addressForData:(NSData *)data;
+ (uint16_t)portForData:(NSData *)data;
@end

@implementation ServiceFinder

- (id)init
{
    if (self = [super init])
    {
        self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        [self.netServiceBrowser setDelegate:self];
        
        _isDone = NO;
        _numResolvedHosts = 0;
    }
    return self;
}

- (void)findHosts
{
    _isDone = NO;
    _numResolvedHosts = 0;
    
    self.serviceDomains = [NSMutableArray array];
    self.availableServices = [NSMutableArray array];
    
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

+ (NSString *)addressForData:(NSData *)data
{
    struct sockaddr *address = (struct sockaddr *)[data bytes];
    
    switch( address->sa_family ) {
        case AF_INET: {
            struct sockaddr_in *ip4;
            char dest[INET_ADDRSTRLEN];
            ip4 = (struct sockaddr_in *) [data bytes];
            return [NSString stringWithCString:inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest) encoding:NSUTF8StringEncoding];
        }
            break;
        case AF_INET6: {
            struct sockaddr_in6 *ip6;
            char dest[INET6_ADDRSTRLEN];
            ip6 = (struct sockaddr_in6 *) [data bytes];
            return [NSString stringWithCString:inet_ntop(AF_INET6, &ip6->sin6_addr, dest, sizeof dest) encoding:NSUTF8StringEncoding];
        }
            break;
    }
    
    return nil;
}

+ (uint16_t)portForData:(NSData *)data
{
    struct sockaddr *address = (struct sockaddr *)[data bytes];
    
    switch( address->sa_family ) {
        case AF_INET: {
            struct sockaddr_in *ip4;
            ip4 = (struct sockaddr_in *) [data bytes];
            return ntohs(ip4->sin_port);
        }
            break;
        case AF_INET6: {
            struct sockaddr_in6 *ip6;
            ip6 = (struct sockaddr_in6 *) [data bytes];
            return ntohs(ip6->sin6_port);
        }
            break;
    }
    
    return 0;
}

+ (ClientController *)clientControllerForNetService:(NSNetService *)netService
{
    if ([[netService addresses] count])
    {
        NSData *addressData = [[netService addresses] objectAtIndex:0];
        
        NSString *address = [ServiceFinder addressForData:addressData];
        uint16_t port = [ServiceFinder portForData:addressData];
        
        ClientController *clientController = [[ClientController alloc] initWithHost:address port:port];
        return clientController;
    }
    
    return nil;
}

- (ClientController *)bestClientController
{
    if (self.isDone && [self.availableServices count])
    {
        NSNetService *netService = [self.availableServices objectAtIndex:0];
        return [ServiceFinder clientControllerForNetService:netService];
    }
    
    return nil;
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
        
        self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
        [self.netServiceBrowser setDelegate:self];
        
        [self.netServiceBrowser searchForServicesOfType:type inDomain:domain];
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
    
    if (![self.availableServices containsObject:netService])
    {
        [self.availableServices addObject:netService];
        
        [netService setDelegate:self];
        [netService resolveWithTimeout:5.0];
    }
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

- (void)netServiceDidStop:(NSNetService *)sender
{
    NSLog(@"netServiceDidStop");
    
    _isDone = YES;
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"DidResolve %@ (%@): %@", [sender name], [sender domain], [sender addresses]);
    
    for (NSData *addressData in [sender addresses])
    {
        NSString *addressString = [NSString stringWithFormat: @"%@:%d",  [ServiceFinder addressForData:addressData], [ServiceFinder portForData:addressData]];
        
        NSLog(@"%@", addressString);
    }
    
    _isDone = ++_numResolvedHosts == [self.availableServices count];
}


@end
