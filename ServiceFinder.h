//
//  ServiceFinder.h
//  prankstr
//
//  Created by Simon Fransson on 09/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClientController;

@interface ServiceFinder : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
    @protected
    int _numResolvedHosts;
}



@property (strong, nonatomic) NSNetServiceBrowser *netServiceBrowser;
@property (strong, nonatomic) NSMutableArray *serviceDomains;
@property (strong, nonatomic) NSMutableArray *availableServices;
@property (readonly, nonatomic) BOOL isDone;

- (void)findHosts;
+ (ClientController *)clientControllerForNetService:(NSNetService *)netService;
- (ClientController *)bestClientController;

@end
