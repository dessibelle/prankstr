//
//  SocketServer.h
//  prankstr
//
//  Created by Simon Fransson on 03/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrankstrProtocol.h"

typedef enum _PrankstrTag {
    PrankstrTagRequest = (long)0,
    PrankstrTagResponse
} PrankstrTag;


@class PrankstrMessage, SocketServer;

@protocol SocketServerDelegate <NSObject>
- (PrankstrStatus)socketServer:(SocketServer *)socketServer didReceiveMessage:(PrankstrMessage *)message;
@end


@class GCDAsyncSocket;

@interface SocketServer : NSObject <NSNetServiceDelegate>

@property (strong, nonatomic) GCDAsyncSocket *listenerSocket;
@property (strong, nonatomic) NSMutableArray *connectedSockets;
@property (strong, nonatomic) NSNetService *netService;
@property (assign, nonatomic) UInt16 port;
@property (weak, nonatomic) id <SocketServerDelegate> delegate;

- (UInt16)listen;
- (void)close;

@end