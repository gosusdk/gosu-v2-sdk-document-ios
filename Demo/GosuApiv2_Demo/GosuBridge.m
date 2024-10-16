//
//  GosuBridge.m
//  GosuApiv2_Demo
//
//  Created by Nero-Macbook on 2/5/24.
//  Copyright © 2024 Phan Phuoc Luong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GosuBridge.h"
#import "GosuSDK.h"

@implementation GosuBridge

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];

    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhx", data[i]];
    }
    NSLog(@"device token = %@", token);
    [[GosuSDK sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

@end
