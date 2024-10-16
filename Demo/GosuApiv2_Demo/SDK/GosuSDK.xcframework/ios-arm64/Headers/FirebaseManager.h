//
//  FirebaseManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//
#import <Foundation/Foundation.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@interface FirebaseManager : NSObject {
    
}

+ (FirebaseManager *) sharedInstance;
- (void) initFirebase;
- (void) setCustomerID:(NSString *)userId;
- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email;
- (void) trackingCheckout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;

- (void) trackingEventOnFirebase:(NSString *)name parameters:(NSDictionary<NSString *, id> *)parameters;
- (void) trackingScreenOnFirebase:(NSString *)screenName screenClass:(NSString *)screenClass;
- (void) setUserPropertiesOnFirebase:(NSString *)value forName:(NSString *)name;
- (void) setUserIdOnFirebase:(NSString *)userID;
//messaging
- (void)applicationDelegate:(id) appDelegate andApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void) showInAppMessage:(NSDictionary *)userInfo;
//sub
- (void) FirebaseSubscribeToTopic:(NSString *)topic;
- (void) FirebaseUnSubscribeToTopic:(NSString *)topic;
@end
