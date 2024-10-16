//
//  AirbridgeManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 8/9/23.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AirbridgeManager : NSObject {
    
}

+ (AirbridgeManager *) sharedInstance;
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) setCustomerUserID:(NSString *)customerUserID;
- (void) trackingLogin:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email;
- (void) trackingCheckout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isInApp;
- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values;

- (void) registerForRemoteNotifications:(NSData *)deviceToken;
@end
