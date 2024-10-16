//
//  GTrackingManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 8/9/23.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GTrackingManager : NSObject {
    
}

+ (GTrackingManager *) sharedInstance;
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) setCustomerUserID:(NSString *)customerUserID;
- (void) showSignInSDK;
- (void) verifyLogin;
- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email;
- (void) checkout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isIAP;
- (void) trackingEvent:(NSString *)eventName;
- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values;

- (void) registerForRemoteNotifications:(NSData *)deviceToken;

- (void)doneNRU:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName;
- (void)trackingStartTrial;
- (void)trackingTurialCompleted;
@end
