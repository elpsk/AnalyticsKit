//
//  AnalyticsKitLocalyitcsProvider.m
//  Whatcha-Watchin
//
//  Created by Todd Huss on 10/17/11.
//  Copyright (c) 2011 Two Bit Labs. All rights reserved.
//

#import "AnalyticsKitLocalyitcsProvider.h"
#import "LocalyticsSession.h"

@implementation AnalyticsKitLocalyitcsProvider

-(id<AnalyticsKitProvider>)initWithAPIKey:(NSString *)localyticsKey {
    self = [super init];
    if (self) {
        [[LocalyticsSession sharedLocalyticsSession] startSession:localyticsKey];
    }
    return self;
}

-(void)applicationWillEnterForeground {
    INFO(@"");
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

-(void)applicationDidEnterBackground {
    INFO(@"");
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

-(void)applicationWillTerminate {
    INFO(@"");    
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

-(void)uncaughtException:(NSException *)exception {
    INFO(@"%@", exception);
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Uncaught Exceptions" attributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
          [exception name], @"ename",
          [exception reason], @"reason",
          [exception userInfo], @"userInfo",
      nil]];

}

-(void)logScreen:(NSString *)screenName {    
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:[@"Screen - " stringByAppendingString:screenName]];
}

-(void)logEvent:(NSString *)event {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:event];
}

-(void)logEvent:(NSString *)event withProperties:(NSDictionary *)dict {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:event attributes:dict];
}

-(void)logEvent:(NSString *)event withProperty:(NSString *)key andValue:(NSString *)value {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:event attributes:[NSDictionary dictionaryWithObject:value forKey:key]];
}

-(void)logError:(NSString *)name message:(NSString *)message exception:(NSException *)exception {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Exceptions" attributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
        name, @"name",
        message, @"message",        
        [exception name], @"ename",
        [exception reason], @"reason",
        [exception userInfo], @"userInfo",
      nil]];
}

-(void)logError:(NSString *)name message:(NSString *)message error:(NSError *)error {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Errors" attributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
          name, @"name",
          message, @"message",        
          [error localizedDescription], @"description",
          [error code], @"code",
          [error domain], @"domain",
          [error userInfo], @"userInfo",
      nil]];
}

@end