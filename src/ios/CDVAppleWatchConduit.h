/*
 * Copyright (c) Olivier Goguel.  All rights reserved.
 * Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
 */

#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import "AppDelegate.h"
#import "AppleWatchConduitLibrary.h"

@interface AppDelegate (AppleWatchConduit)

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply;

@end

@interface CDVAppleWatchConduit : CDVPlugin 
{
@public
  AppleWatchConduitLibrary* awLibrary;
}


@end
