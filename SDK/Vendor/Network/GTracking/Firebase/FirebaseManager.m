//
//  FirebaseManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//

#import "FirebaseManager.h"
#import "SdkConfig.h"

@interface FirebaseManager()
{
    BOOL firebaseIsInit;
}

@end
static FirebaseManager *sharedInstance;
@implementation FirebaseManager
#pragma mark Singleton Methods
+ (FirebaseManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil){
            sharedInstance = [[super alloc] init];
            sharedInstance->firebaseIsInit = NO;
        }
    }
    return sharedInstance;
}

- (void) initFirebase
{
    if (!self->firebaseIsInit) {
        self->firebaseIsInit = YES;
        [FIRApp configure];
    }
}

- (void) setCustomerID:(NSString *)userId
{
    [FIRAnalytics setUserID:userId];
}
- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email
{
    [self trackingEventOnFirebase:@"login" parameters:@{
        @"customerId": userId,
        @"username": username,
        @"email": email
    }];
}

- (void) trackingCheckout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [self trackingEventOnFirebase:@"checkout" parameters:@{
        @"transaction_id": orderId,
        @"item_id": productId,
        @"item_name": productId,
        @"price": amount,
        @"currency": currency
    }];
}

- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [self trackingEventOnFirebase:@"charged" parameters:@{
        @"transaction_id": orderId,
        @"item_id": productId,
        @"item_name": productId,
        @"price": amount,
        @"currency": currency
    }];
}

- (void)trackingEventOnFirebase:(NSString *)name parameters:(NSDictionary<NSString *,id> *)parameters
{
    [FIRAnalytics logEventWithName:name parameters:parameters];
}

- (void)trackingScreenOnFirebase:(NSString *)screenName
{
    [FIRAnalytics logEventWithName:kFIREventScreenView parameters:@{kFIRParameterScreenName: screenName}];
}

- (void)trackingScreenOnFirebase:(NSString *)screenName screenClass:(NSString *)screenClass
{
    [FIRAnalytics logEventWithName:kFIREventScreenView parameters:@{kFIRParameterScreenName: screenName}];
}

- (void)setUserPropertiesOnFirebase:(NSString *)value forName:(NSString *)name
{
    [FIRAnalytics setUserPropertyString:value forName:name];
}

- (void)setUserIdOnFirebase:(NSString *)userID
{
    [FIRAnalytics setUserID:userID];
}
//Register for remote notifications
- (void)applicationDelegate:(id) appDelegate andApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FirebaseManager sharedInstance] initFirebase];
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = appDelegate;
    // [START register_for_notifications]
    if (@available(iOS 10.0, *)) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
        
      [UNUserNotificationCenter currentNotificationCenter].delegate = appDelegate;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    }

    [application registerForRemoteNotifications];
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    [[SdkConfig sharedInstance] setFirebaseFCMToken:fcmToken];
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *token, NSError *error) {
      if (error != nil) {
        NSLog(@"Error getting FCM registration token: %@", error);
      } else {
        NSLog(@"FCM registration token: %@", token);
      }
    }];
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void) showInAppMessage:(NSDictionary *)userInfo
{
    NSLog(@"APNs showInAppMessage %@", userInfo);
    dispatch_block_t block = ^{
        NSDictionary *dicAps = [userInfo objectForKey:@"aps"];
        NSDictionary *dicAlert = [dicAps objectForKey:@"alert"];
        NSString *title = [dicAlert objectForKey:@"title"];
        NSString *message = [dicAlert objectForKey:@"body"];
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@", message] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
#pragma mark - Firebase subscribe & unsubscribe
- (void) FirebaseSubscribeToTopic:(NSString *)topic{
    [[FIRMessaging messaging] subscribeToTopic:topic
                                    completion:^(NSError * _Nullable error){
        NSLog(@"Nero _Subscire to topic");
    }];
}

- (void) FirebaseUnSubscribeToTopic:(NSString *)topic{
    [[FIRMessaging messaging] unsubscribeFromTopic:topic
                                        completion:^(NSError * _Nullable error){
        NSLog(@"Nero _UnSubscire to topic");
    }];
}
@end
