//
//  AppsflyerManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//

#import <Foundation/Foundation.h>
//#import <AppsFlyerLib/AppsFlyerLib.h>

@interface AppsflyerManager : NSObject {
    
}

+ (AppsflyerManager *) sharedInstance;
- (void) initAppsFlyer;
- (void) initAppsFlyer:(NSString *)appFlyerKey andAppleId:(NSString *)appFlyerAppleID;
- (void) startAppsflyer;
- (void) startAppsflyerWithInterval;
- (void) setCustomerUserID:(NSString *)customerUserID;
- (void) trackingLaunchOnAF;
- (void) trackingLogin:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email;
- (void) trackingCheckout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username;
- (void) trackingUninstallOnAF:(NSData *)deviceToken;
- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values;
//call from game client
- (void)trackingStartTrial;
- (void) trackingTurialCompleted;
@end
