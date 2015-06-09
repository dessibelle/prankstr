//
//  main.m
//  prankstr
//
//  Created by Simon Fransson on 04/06/15.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "ClientController.h"
#import "ServiceFinder.h"
#import "PrankstrProtocol.h"
#import "PrankstrProtocolInterpreter.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        ServiceFinder *serviceFinder = [[ServiceFinder alloc] init];
        [serviceFinder findHosts];
        
        BOOL done = NO;
        do
        {
            // Start the run loop but return after each source is handled.
            SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, YES);
            
            done = serviceFinder.isDone;
            
            if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
                done = YES;
        }
        while (!done);
        
        NSUInteger idx = 0;
        NSNetService *service;
        for (service in serviceFinder.availableServices) {
            printf("%lu: %s\n", ++idx, [[service name] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        
        NSUInteger userInput;
        printf("\nPick a host: ");
        scanf("%lu", &userInput);
        
        service = [serviceFinder.availableServices objectAtIndex:userInput - 1];
        ClientController *clientController = [ServiceFinder clientControllerForNetService:service];
        [clientController connect];
        
        NSDictionary *commands = [PrankstrProtocolInterpreter availableCommands];
        NSMutableArray *commandList = [NSMutableArray array];
        
        for (NSString* key in commands) {
            NSDictionary *cmd = [commands objectForKey:key];
            
            [commandList addObject:[NSString stringWithFormat:@"%@: %@", key, [cmd objectForKey:@"name"]]];
        }
        
        [commandList sortUsingSelector:@selector(compare:)];
        
        done = NO;
        do
        {
            // Start the run loop but return after each source is handled.
            SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, YES);
            
            printf("%s\n", [[commandList componentsJoinedByString:@"\n"] cStringUsingEncoding:NSUTF8StringEncoding]);
            
            PrankstrCommand command;
            printf("\nCommand: ");
            scanf("%u", &command);
            
            NSMutableArray *arguments = [NSMutableArray array];
            NSUInteger argc = [PrankstrProtocolInterpreter argumentsForCommand:command];

            for (int i = 0; i < argc; i++)
            {
                char arg[256];
                printf("\nArguments %d: ", i + 1);
                scanf("%s", arg);

                [arguments addObject:[NSString stringWithCString:arg encoding:NSUTF8StringEncoding]];
            }
            
            [clientController sendCommand:command andArguments:[arguments copy]];
            
            if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
                done = YES;
        }
        while (!done);
        
//        [clientController sendCommand:PrankstrCommandToggleInvertColor andArguments:nil];
//        [clientController sendCommand:PrankstrCommandToggleCursorSize andArguments:nil];
//        [clientController sendCommand:PrankstrCommandToggleContrast andArguments:nil];
//        [clientController sendCommand:PrankstrCommandToggleGrayscale andArguments:nil];
//        [clientController sendCommand:PrankstrCommandToggleIncreaseContrast andArguments:nil];
//        [clientController sendCommand:PrankstrCommandToggleDifferentiateWithoutColor andArguments:nil];
//        [clientController sendCommand:PrankstrCommandToggleReduceTransparency andArguments:nil];

        
        
//        int counter = 0;
//        double cursorSize;
//        
//        done = NO;
//        do
//        {
//            // Start the run loop but return after each source is handled.
//            SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, YES);
//            
//            cursorSize = 2.5 + 1.5 * sin(counter++ / 20.0);
//            
//            [clientController sendCommand:PrankstrCommandSetCursorSize andArguments:[NSArray arrayWithObject:[NSString stringWithFormat:@"%f", cursorSize]]];
//            
//            if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
//                done = YES;
//        }
//        while (!done);

        
    }
    return 0;
}
