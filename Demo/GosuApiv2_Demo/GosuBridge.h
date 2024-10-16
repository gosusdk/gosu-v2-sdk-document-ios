//
//  GosuBridge.h
//  GosuApiv2_Demo
//
//  Created by Nero-Macbook on 2/5/24.
//  Copyright © 2024 Phan Phuoc Luong. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GosuBridge : NSObject

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
@end
