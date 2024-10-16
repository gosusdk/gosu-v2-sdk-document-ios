//
//  GTrackingManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 8/9/23.
//

#import "GTrackingManager.h"
#import "AirbridgeManager.h"
#import "SdkConfig.h"
#import "FirebaseManager.h"
#import "IdAppTracking.h"
#import "AppsflyerManager.h"

@interface GTrackingManager()
{
    
}

@end
static GTrackingManager *sharedInstance;
@implementation GTrackingManager

#pragma mark Singleton Methods
+ (GTrackingManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    @try {
        [[AirbridgeManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
        [[FirebaseManager sharedInstance] initFirebase];
    } @catch (NSException *exception) {
        NSLog(@"Airbridge: Error log exception %@", exception);
    }
    return YES;
}
- (void) showSignInSDK
{
    [self trackingEvent:@"verify_install" withValues:@{@"client_id":[SdkConfig sharedInstance].clientID}];
}

- (void) verifyLogin
{
    [self trackingEvent:@"verify_login" withValues:@{@"client_id":[SdkConfig sharedInstance].clientID}];
}
- (void) setCustomerUserID:(NSString *)customerUserID
{
    [[FirebaseManager sharedInstance] setCustomerID:customerUserID];
    [[AirbridgeManager sharedInstance] setCustomerUserID:customerUserID];
    [[AppsflyerManager sharedInstance] setCustomerUserID:customerUserID];
}

- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email
{
    [[FirebaseManager sharedInstance] trackingSignIn:userId andUsername:username andEmail:email];
    [[AirbridgeManager sharedInstance] trackingLogin:userId andUsername:username andEmail:email];
    [[AppsflyerManager sharedInstance] trackingLogin:userId andUsername:username andEmail:email];
}

- (void) checkout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [[FirebaseManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername: username];
    [[AirbridgeManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:(NSString *)username];
    [[AppsflyerManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username];
}
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [self purchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username andIsIAP:YES];
}
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isIAP
{
    [[FirebaseManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername: username];
    [[AirbridgeManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:(NSString *)username andIsIAP:isIAP];
    [[AppsflyerManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username];
}
- (void)trackingStartTrial
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    [self trackingEvent:@"start_trial" withValues:@{@"customer_id":gameInfo.userID,
                                                      @"username":gameInfo.username,
                                                      @"game_id":gameInfo.gameId}];
}

- (void)trackingTurialCompleted
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    [self trackingEvent:@"tutorial_completion" withValues:@{@"customer_id":gameInfo.userID,
                                                            @"username":gameInfo.username,
                                                            @"game_id":gameInfo.gameId}];
}
- (void)doneNRU:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    [self trackingEvent:@"done_nru" withValues:@{
        @"customer_id":gameInfo.userID,
        @"server_id":serverId,
        @"role_id":roleId,
        @"role_name":roleName}];
    [[IdAppTracking sharedInstance] idAppTrackingOpen:serverId roleID:roleId roleName:roleName];
}
- (void) trackingEvent:(NSString *)eventName
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    NSDictionary *values = @{@"customer_id":gameInfo.userID};
    [self trackingEvent:eventName withValues:values];
}

- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    [[FirebaseManager sharedInstance] trackingEventOnFirebase:eventName parameters:values];
    [[AirbridgeManager sharedInstance] trackingEvent:eventName withValues:values];
    [[AppsflyerManager sharedInstance] trackingEvent:eventName withValues:values];
}

-(void) registerForRemoteNotifications:(NSData *)deviceToken
{
    [[AirbridgeManager sharedInstance] registerForRemoteNotifications:deviceToken];
    [[AppsflyerManager sharedInstance] trackingUninstallOnAF:deviceToken];
}
//CrashlyticsManager
+ (CrashlyticsManager *) crashlytics
{
    return [CrashlyticsManager sharedInstance];
}
@end
