/*
 * Copyright (c) Olivier Goguel.  All rights reserved.
 * Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
 */

#import "MMWormhole.h"

// Until Apple gives a way to differentiate Apps!
#if (!defined(APPLEWATCHCONDUIT_APPLICATION) && !defined(APPLEWATCHCONDUIT_WATCHKITAPPLICATION))
#error "Requires APPLEWATCHCONDUIT_APPLICATION or APPLEWATCHCONDUIT_WATCHKITAPPLICATION"
#endif

@interface AppleWatchConduitLibrary : NSObject 
{
    MMWormhole* wormHole;
    NSString* groupId;
}

-(id)initWithGroupId:(NSString*)_groupId;
-(NSString*)getGroupId;

#ifdef APPLEWATCHCONDUIT_APPLICATION
-(void)sendMessage:(NSString*)_message;
#endif

#ifdef APPLEWATCHCONDUIT_WATCHKITAPPLICATION
-(void)sendCommand:(NSString*)_comnand;
-(void)onReceiveMessage:(void (^)(NSString* _message))_onReceiveMessage;
#endif

@end