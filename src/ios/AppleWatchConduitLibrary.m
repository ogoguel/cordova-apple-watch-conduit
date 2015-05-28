/*
 * Copyright (c) Olivier Goguel.  All rights reserved.
 * Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
 */


#include "AppleWatchConduitLibrary.h"
#import <WatchKit/WatchKit.h>


@implementation AppleWatchConduitLibrary


-(id)initWithGroupId:(NSString*)_groupId
{

    if ([_groupId length] == 0)
    {
        
#ifdef APPLEWATCHCONDUIT_APPLICATION
        groupId = [NSString stringWithFormat:@"group.%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
#else
        NSString* fullBundleId =[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
        NSString* bundleId = [fullBundleId stringByDeletingPathExtension];
        groupId = [NSString stringWithFormat:@"group.%@", bundleId];
#endif
    }
    else
        groupId = _groupId;

    NSLog(@"Using groupId:%@",groupId);
    wormHole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:groupId optionalDirectory:nil];
    
    if (wormHole==nil)
        return nil;
    else
        return self;
   
}


-(NSString*)getGroupId
{
    return groupId;
}

#ifdef APPLEWATCHCONDUIT_APPLICATION
-(void)sendMessage:(NSString*)_message
{
    NSString* identifier = [NSString stringWithFormat:@"conduit"];
    NSLog(@"Send Message : %@ for identifier %@",_message,identifier);
    [wormHole passMessageObject:_message identifier:identifier];
}
#endif

#ifdef APPLEWATCHCONDUIT_WATCHKITAPPLICATION

-(void)onReceiveMessage:(void (^)(NSString* _message))_onReceiveMessage
{
    [wormHole listenForMessageWithIdentifier:@"conduit" listener:_onReceiveMessage];
}

-(void)sendCommand:(NSString*)_command
{

    NSLog(@"sending command:%@",_command);
    NSDictionary* request = [NSDictionary dictionaryWithObject:_command forKey:@"command"];
    [WKInterfaceController openParentApplication:request reply:^(NSDictionary *replyInfo, NSError *error) {

    if (error) {
        NSLog(@"sendCommand Error:%@", error);
   
    }
    
    }];
}
#endif

@end
