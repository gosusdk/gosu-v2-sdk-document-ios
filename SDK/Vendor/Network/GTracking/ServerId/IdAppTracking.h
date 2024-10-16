//
//  IdAppTracking.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/11/21.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IdAppTracking : NSObject {
    
}

@property (nonatomic, strong) NSString                  *logOpenURL;

+ (IdAppTracking *) sharedInstance;
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
- (void) idAppTrackingOpen:(NSString *)serverID roleID:(NSString *)roleID roleName:(NSString *)roleName;
- (void) idAppTrackingInstall:(UIApplication *)application;
- (void) idAppTrackingAllowNotification:(NSString *)devicetoken;
- (void) idTrackingInstallUser;
@end
