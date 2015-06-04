//
//  Listener.h
//  prankstr
//
//  Created by Simon Fransson on 2015-06-05.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageHandler.h"
#import "SocketServer.h"

@interface Listener : NSObject <SocketServerDelegate>

@property (strong, nonatomic) MessageHandler *messageHandler;
@property (strong, nonatomic) SocketServer *socketServer;

- (void)listen;
- (void)close;

@end
