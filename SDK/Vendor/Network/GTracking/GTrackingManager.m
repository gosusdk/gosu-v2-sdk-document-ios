//
//  GTrackingManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 8/9/23.
//

#import "GTrackingManager.h"
//#import "AirbridgeManager.h"
#import "SdkConfig.h"
#import "FirebaseManager.h"
#import "IdAppTracking.h"
#import "AppsflyerManager.h"
#import "CrashlyticsManager.h"
#import "ItsManager.h"

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
        [[FirebaseManager sharedInstance] initFirebase];
        
    } @catch (NSException *exception) {
        NSLog(@"Firebase: Error log exception %@", exception);
    }
    //
//    @try {
//        [[AirbridgeManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
//      
//    } @catch (NSException *exception) {
//        NSLog(@"Airbridge: Error log exception %@", exception);
//    }
    //
    @try {
        NSDictionary *customInfo = @{@"version": [[SdkConfig sharedInstance] getSDKVersionName ]};
        [[ItsManager sharedInstance] initializeSDKWithCustomInfo:customInfo completion:^(BOOL success, NSString *message) {
            if (!success) {
                NSLog(@"[ItsSDK] Initialization FAILED (%@)", message);
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"[ItsSDK] Initialization FAILED (%@)", exception);
    }
    return YES;
}

//deprecated, uses verifySDK() instead
- (void) showSignInSDK
{
    [self verifySDK];
}
- (void) verifySDK
{
    [self trackingEvent:@"verify_install" withValues:@{@"client_id":[SdkConfig sharedInstance].clientID}];
}
//

- (void) verifyLogin
{
    [self trackingEvent:@"verify_login" withValues:@{@"client_id":[SdkConfig sharedInstance].clientID}];
}

- (void) setCustomerUserID:(NSString *)customerUserID
{
    [[FirebaseManager sharedInstance] setCustomerID:customerUserID];
//    [[AirbridgeManager sharedInstance] setCustomerUserID:customerUserID];
    [[AppsflyerManager sharedInstance] setCustomerUserID:customerUserID];
}

- (void)completeRegistration:(NSString *)userID {
    [[ItsManager sharedInstance] completeRegistrationWithUserID:userID];
}

//deprecated, uses login() instead
- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email
{
    [self login:userId andUsername:username andEmail:email];
}
- (void) login:userId andUsername:(NSString *)username andEmail:(NSString *)email;
{
    [[FirebaseManager sharedInstance] trackingSignIn:userId andUsername:username andEmail:email];
//    [[AirbridgeManager sharedInstance] trackingLogin:userId andUsername:username andEmail:email];
    [[AppsflyerManager sharedInstance] trackingLogin:userId andUsername:username andEmail:email];
    [[ItsManager sharedInstance] loginWithUserID:userId userName:username userEmail:email];
}
//-----//

- (void) checkout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [[FirebaseManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername: username];
//   [[AirbridgeManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:(NSString *)username];
    [[AppsflyerManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username];
    float revenue = [amount floatValue];
    [[ItsManager sharedInstance] checkoutWithOrderID:orderId userID:username characterID:@"" serverInfo:@"" productInfo:productId brand:@"" quantity:1 category:@"" price:revenue  currency: currency revenue:revenue];
}

- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [self purchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username andIsIAP:YES];
}
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isIAP
{
//    [[AirbridgeManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:(NSString *)username andIsIAP:isIAP];
    [[FirebaseManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername: username];
    [[AppsflyerManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username];
    float revenue = [amount floatValue];
    [[ItsManager sharedInstance] purchaseWithOrderID:orderId userID:username characterID:@"" serverInfo:@"" productInfo:productId brand:@"" quantity:1 category:@"" price:revenue  currency: currency revenue:revenue];
}

//deprecated, user startTutorial() instead
- (void)trackingStartTrial
{
    [self startTutorial:@"" andCharacterID:@"" andCharacterName:@"" andServerInfo:@"" ];
}
- (void)startTutorial:(NSString *)userID andCharacterID:(NSString *)characterID andCharacterName:(NSString *)characterName andServerInfo:(NSString *)serverID
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    @try {
            if (userID.length == 0 && characterID.length == 0 && characterName.length == 0 && serverID.length == 0) {
                // Call from deprecated function
                NSDictionary *jsonObject = @{
                    @"customer_id": gameInfo.userID,
                    @"username": gameInfo.username,
                    @"game_id": gameInfo.gameId
                };
                [self trackingEvent:@"start_trial" withValues:jsonObject];
                [[ItsManager sharedInstance] trackCustomEventWithEventName:@"start_trial" properties:jsonObject];
            } else {
                NSDictionary *jsonObject = @{
                    @"customer_id": userID,
                    @"role_id": characterID,
                    @"role_name": characterName,
                    @"server_id": serverID
                };
                [self trackingEvent:@"start_trial" withValues:jsonObject];
                [[ItsManager sharedInstance] startTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverID];
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception.reason);
        }
}
//-------//
//deprecated, use completeTutorial() instead
- (void)trackingTurialCompleted
{
    [self completeTutorial:@"" andCharacterID:@"" andCharacterName:@"" andServerInfo:@""];
}
- (void)completeTutorial:(NSString *)userID andCharacterID:(NSString *)characterID andCharacterName:(NSString *)characterName andServerInfo:(NSString *)serverID
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    @try {
            if (userID.length == 0 && characterID.length == 0 && characterName.length == 0 && serverID.length == 0) {
                // Call from deprecated function
                NSDictionary *jsonObject = @{
                    @"customer_id": gameInfo.userID,
                    @"username": gameInfo.username,
                    @"game_id": gameInfo.gameId
                };
                [self trackingEvent:@"tutorial_completion" withValues:jsonObject];
                [[ItsManager sharedInstance] trackCustomEventWithEventName:@"tutorial_completion" properties:jsonObject];
            } else {
                NSDictionary *jsonObject = @{
                    @"customer_id": userID,
                    @"role_id": characterID,
                    @"role_name": characterName,
                    @"server_id": serverID
                };
                [self trackingEvent:@"tutorial_completion" withValues:jsonObject];
                [[ItsManager sharedInstance] completeTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverID];
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception.reason);
        }
}

//deprecated, uses createNewCharacter() instead
- (void)doneNRU:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName
{
    [self createNewCharacter:serverId andRoleId:roleId andRoleName:roleName];
}
- (void)createNewCharacter:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName
{

    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    [[ItsManager sharedInstance] createNewCharacterWithUserID:gameInfo.userID characterID:roleId characterName:roleName serverInfo:serverId];
    [self trackingEvent:@"done_nru" withValues:@{
        @"customer_id":gameInfo.userID,
        @"server_id":serverId,
        @"role_id":roleId,
        @"role_name":roleName}];
    [[IdAppTracking sharedInstance] idAppTrackingOpen:serverId roleID:roleId roleName:roleName];
}
//------//
- (void) trackingEvent:(NSString *)eventName
{
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    NSDictionary *values = @{@"customer_id":gameInfo.userID};
    [self trackingEvent:eventName withValues:values];
}

- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
   [self trackingCustomEvent:eventName withValues:values];
}
//
- (void) trackingCustomEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    [[FirebaseManager sharedInstance] trackingEventOnFirebase:eventName parameters:values];
//    [[AirbridgeManager sharedInstance] trackingEvent:eventName withValues:values];
    // Mapping to ITS Tracking Log
    if ([eventName isEqualToString:@"done_nru"] ||
        [eventName isEqualToString:@"start_trial"] ||
        [eventName isEqualToString:@"tutorial_completion"] ||
        [eventName hasPrefix:@"level"] ||
        [eventName hasPrefix:@"user_lv"] ||
        [eventName hasPrefix:@"vip_"] ||
        [eventName hasPrefix:@"user_vip"])
        {
        // Handled in root function
        return;
    }

    if ([eventName isEqualToString:@"verify_Install"] ||
        [eventName isEqualToString:@"verify_login"]) {
        [[ItsManager sharedInstance] trackCustomEventWithEventName:eventName properties:values];
        return;
    }
    [[ItsManager sharedInstance] trackCustomEventWithEventName:eventName properties:values];
}
//
-(void) registerForRemoteNotifications:(NSData *)deviceToken
{
//   [[AirbridgeManager sharedInstance] registerForRemoteNotifications:deviceToken];
    [[AppsflyerManager sharedInstance] trackingUninstallOnAF:deviceToken];
}

- (void)enterGame:(NSString *)userID
                characterID:(NSString *)characterID
              characterName:(NSString *)characterName
                 serverInfo:(NSString *)serverInfo {
    [[ItsManager sharedInstance] enterGameWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
}
- (void)levelUp:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
          level:(NSInteger)level {
    [[ItsManager sharedInstance] levelUpWithUserID:userID characterID:characterID serverInfo:serverInfo level: level];
    [self trackingEvent:[NSString stringWithFormat:@"user_lv%ld", (long)level]];

    
}

- (void)vipUp:(NSString *)userID
            characterID:(NSString *)characterID
             serverInfo:(NSString *)serverInfo
     vipLevel:(NSInteger)vipLevel {
    [[ItsManager sharedInstance] vipUpWithUserID:userID characterID:characterID serverInfo:serverInfo vipLevel:vipLevel];
    [self trackingEvent:[NSString stringWithFormat:@"user_vip%ld", (long)vipLevel]];
}

- (void)useItem:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                   itemID:(NSString *)itemID
       quantity:(NSInteger)quantity {
    [[ItsManager sharedInstance] useItemWithUserID:userID characterID:characterID serverInfo:serverInfo itemID:itemID quantity:quantity];
}

- (void)trackActivityResult:(NSString *)userID
                          characterID:(NSString *)characterID
                           serverInfo:(NSString *)serverInfo
                           activityID:(NSString *)activityID
                      activityResult:(NSString *)activityResult
{
    [[ItsManager sharedInstance] trackActivityResultWithUserID:userID characterID:characterID serverInfo:serverInfo activityID:activityID activityResult:activityResult];
}
- (void)logout {
    [[ItsManager sharedInstance] logout];
}
//CrashlyticsManager
+ (CrashlyticsManager *) crashlytics
{
    return [CrashlyticsManager sharedInstance];
}
@end
