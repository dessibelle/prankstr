//
//  Listener.m
//  prankstr
//
//  Created by Simon Fransson on 2015-06-05.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "Listener.h"

@implementation Listener

- (id)init
{
    if (self = [super init])
    {
        self.messageHandler = [MessageHandler defaultHandler];
        self.socketServer = [[SocketServer alloc] init];
        self.socketServer.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [self close];
}

- (void)listen
{
    [self.socketServer listen];
}

- (void)close
{
    [self.socketServer close];
}

- (PrankstrStatus)socketServer:(SocketServer *)socketServer didReceiveMessage:(PrankstrMessage *)message
{
    return [self.messageHandler executeCommand:message];
}

@end
