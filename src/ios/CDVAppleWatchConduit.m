/*
 * Copyright (c) Olivier Goguel.  All rights reserved.
 * Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
 */

#include "CDVAppleWatchConduit.h"

#define APPLEWATCHCONDUIT_PLUGIN_VERSION "1.0.0"

static CDVAppleWatchConduit* singleton;
static NSMutableArray* lastCommands;

@implementation AppDelegate(AppleWatchConduit)

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    
    NSString* command = [userInfo objectForKey:@"command"];
    NSLog(@"received Command %@",command);
    
    if (!singleton)
    {
        NSLog(@"Error plugin not initialized!");
    }
    else
    if (singleton->awLibrary==nil)
    {
        NSLog(@"Waiting for init");
        [lastCommands addObject: command];
    }
    else
    {
        NSString* jsString = [NSString stringWithFormat:@"applewatchconduit.onCommand(\"%@\");", command];
        [singleton.commandDelegate evalJs:jsString];
    }
    
    NSDictionary *response = @{@"response" : command};
    reply(response);

}

@end


@implementation CDVAppleWatchConduit

- (void)pluginInitialize
{
    lastCommands =[[NSMutableArray alloc] init];
    singleton = self;
}

- (void) init:(CDVInvokedUrlCommand*)command;
{

    NSString *param = [command.arguments objectAtIndex:0];
    CDVPluginResult* pluginResult;
    
    awLibrary = [[AppleWatchConduitLibrary alloc] initWithGroupId:param];
    if (awLibrary == nil)
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"Cannot share data betwwen app and extension - check your AppGroupId settings"];
    else
    {
        NSString* groupId =[awLibrary getGroupId];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:groupId];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) sendMessage:(CDVInvokedUrlCommand*)command;
{
    NSString *data = [command.arguments objectAtIndex:0];
   
    [awLibrary sendMessage:data];
    CDVPluginResult* pluginResult = pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)checkCommand:(CDVInvokedUrlCommand*)command
{
    NSLog(@"lastCommands : %@",lastCommands);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK  messageAsArray:lastCommands ];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    [lastCommands removeAllObjects];

}



@end
