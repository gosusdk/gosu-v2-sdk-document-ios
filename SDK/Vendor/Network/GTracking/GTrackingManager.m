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
+ (GTrackingManager *) sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initTrackingModules];
    return YES;
}

- (void) initTrackingModules
{
    //Firebase Init
    if([[SdkConfig sharedInstance] isEnableFirebase] == YES) {
        @try {
            [[FirebaseManager sharedInstance] initFirebase];
            
        } @catch (NSException *exception) {
            NSLog(@"Firebase: Error log exception %@", exception);
        }
    }
    
    //Appsflyer Init
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        @try {
            [[AppsflyerManager sharedInstance] initAppsFlyer];
        } @catch (NSException *exception) {
            NSLog(@"Appsflyer: Error log exception %@", exception);
        }
    }
    
    //Its Init
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
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
    }
    
}

- (void) verifySDK
{
    [self trackingEvent:@"verify_install" withValues:@{@"client_id":[SdkConfig sharedInstance].clientID}];
}

- (void) verifyLogin
{
    [self trackingEvent:@"verify_login" withValues:@{@"client_id":[SdkConfig sharedInstance].clientID}];
}

- (void) setCustomerUserID:(NSString *)customerUserID
{
    if([[SdkConfig sharedInstance] isEnableFirebase] == YES)
    {
        [[FirebaseManager sharedInstance] setCustomerID:customerUserID];
    }
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES)
    {
        [[AppsflyerManager sharedInstance] setCustomerUserID:customerUserID];
    }
    //Airbridge Removed
    //[[AirbridgeManager sharedInstance] setCustomerUserID:customerUserID];
    //[[AppsflyerManager sharedInstance] setCustomerUserID:customerUserID];
}

- (void) completeRegistration:(NSString *)userID {
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] completeRegistrationWithUserID:userID];
    }
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] completeRegistrationWithUserID:userID];
    }
}

//deprecated, uses login() instead
- (void) trackingSignIn:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email
{
    [self login:userId andUsername:username andEmail:email];
}
- (void) login:userId andUsername:(NSString *)username andEmail:(NSString *)email;
{
    if([[SdkConfig sharedInstance] isEnableFirebase] == YES){
        [[FirebaseManager sharedInstance] trackingSignIn:userId andUsername:username andEmail:email];
    }
    
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] loginWithUserID:userId userName:username userEmail:email];
    }
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] loginWithUserID:userId userName:username userEmail:email];
    }
    
    //Airbridge Removed
    //[[AirbridgeManager sharedInstance] trackingLogin:userId andUsername:username andEmail:email];
    //[[AppsflyerManager sharedInstance] trackingLogin:userId andUsername:username andEmail:email];
    //
}

- (void) checkout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    if([[SdkConfig sharedInstance] isEnableFirebase] == YES){
        [[FirebaseManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername: username];
    }

    float revenue = [amount floatValue];
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        //float revenue = [amount floatValue];
        [[ItsManager sharedInstance] checkoutWithOrderID:orderId userID:username characterID:@"" serverInfo:@"" productInfo:productId brand:@"" quantity:1 category:@"" price:revenue  currency: currency revenue:revenue];
    }
    
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] checkoutWithOrderID:orderId userID:username characterID: @"" serverInfo: @"" productInfo:productId brand:@"" quantity:1 category:@"" price:revenue currency:currency revenue:revenue];
    }
    
    //Airbridge Removed
    //   [[AirbridgeManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:(NSString *)username];
    //    [[AppsflyerManager sharedInstance] trackingCheckout:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username];
}

- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [self purchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username andIsIAP:YES];
}
- (void) purchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isIAP
{
    if([[SdkConfig sharedInstance] isEnableFirebase] == YES){
        [[FirebaseManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername: username];
    }
    
    float revenue = [amount floatValue];
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] purchaseWithOrderID:orderId userID:username characterID:@"" serverInfo:@"" productInfo:productId brand:@"" quantity:1 category:@"" price:revenue  currency: currency revenue:revenue];
    }
    
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] purchaseWithOrderID:orderId userID:username characterID:@"" serverInfo:@"" productInfo:productId brand:@"" quantity:1 category:@"" price:revenue currency:currency revenue: revenue];
    }
    
    //Airbridge Removed
    //    [[AirbridgeManager sharedInstance] trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:(NSString *)username andIsIAP:isIAP];
}

//deprecated, user startTutorial() instead
- (void)trackingStartTrial
{
    [self startTutorial:@"" andCharacterID:@"" andCharacterName:@"" andServerInfo:@"" ];
}
- (void) startTutorial:(NSString *)userID andCharacterID:(NSString *)characterID andCharacterName:(NSString *)characterName andServerInfo:(NSString *)serverID
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
            if([[SdkConfig sharedInstance] isEnableIts] == YES){
                [[ItsManager sharedInstance] trackCustomEventWithEventName:@"start_trial" properties:jsonObject];
            }
            if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
                [[AppsflyerManager sharedInstance] trackCustomEventWithEventName:@"start_trial" properties:jsonObject];
            }
        } else {
            NSDictionary *jsonObject = @{
                @"customer_id": userID,
                @"role_id": characterID,
                @"role_name": characterName,
                @"server_id": serverID
            };
            [self trackingEvent:@"start_trial" withValues:jsonObject];
            if([[SdkConfig sharedInstance] isEnableIts] == YES){
                [[ItsManager sharedInstance] startTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverID];
            }
            if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
                [[AppsflyerManager sharedInstance] startTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverID];
            }
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

- (void) completeTutorial:(NSString *)userID andCharacterID:(NSString *)characterID andCharacterName:(NSString *)characterName andServerInfo:(NSString *)serverID
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
            if([[SdkConfig sharedInstance] isEnableIts] == YES){
                [[ItsManager sharedInstance] trackCustomEventWithEventName:@"tutorial_completion" properties:jsonObject];
            }
            if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
                [[AppsflyerManager sharedInstance] trackCustomEventWithEventName:@"tutorial_completion" properties:jsonObject];
            }
        } else {
            NSDictionary *jsonObject = @{
                @"customer_id": userID,
                @"role_id": characterID,
                @"role_name": characterName,
                @"server_id": serverID
            };
            [self trackingEvent:@"tutorial_completion" withValues:jsonObject];
            if([[SdkConfig sharedInstance] isEnableIts] == YES){
                [[ItsManager sharedInstance] completeTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverID];
            }
            if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
                [[AppsflyerManager sharedInstance] completeTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverID];
            }
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
- (void) createNewCharacter:(NSString *)serverId andRoleId:(NSString *)roleId andRoleName:(NSString *)roleName
{
    
    SdkConfig *gameInfo = [SdkConfig sharedInstance];
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] createNewCharacterWithUserID:gameInfo.userID characterID:roleId characterName:roleName serverInfo:serverId];
    }
    
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] createNewCharacterWithUserID:gameInfo.userID characterID:roleId characterName:roleName serverInfo:serverId];
    }
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

- (void) trackingCustomEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    [self trackingEvent:eventName withValues:values];
}

- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    if([[SdkConfig sharedInstance] isEnableFirebase] == YES){
        [[FirebaseManager sharedInstance] trackingEventOnFirebase:eventName parameters:values];
    }
    //Airbridge Removed
    //[[AirbridgeManager sharedInstance] trackingEvent:eventName withValues:values];
    // Mapping to ITS Tracking  &  Appslyer Log
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
    
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        if ([eventName isEqualToString:@"verify_Install"] ||
            [eventName isEqualToString:@"verify_login"]) {
            [[ItsManager sharedInstance] trackCustomEventWithEventName:eventName properties:values];
            return;
        }
        [[ItsManager sharedInstance] trackCustomEventWithEventName:eventName properties:values];
    }
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        if ([eventName isEqualToString:@"verify_Install"] ||
            [eventName isEqualToString:@"verify_login"]) {
            [[AppsflyerManager sharedInstance] trackCustomEventWithEventName:eventName properties:values];
            return;
        }
        [[AppsflyerManager sharedInstance] trackCustomEventWithEventName:eventName properties:values];
    }
}

-(void) registerForRemoteNotifications:(NSData *)deviceToken
{
    //   [[AirbridgeManager sharedInstance] registerForRemoteNotifications:deviceToken];
    //  [[AppsflyerManager sharedInstance] trackingUninstallOnAF:deviceToken];
}

- (void) enterGame:(NSString *)userID
       characterID:(NSString *)characterID
     characterName:(NSString *)characterName
        serverInfo:(NSString *)serverInfo {
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] enterGameWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
    }
    
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] enterGameWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
    }
}

- (void) levelUp:(NSString *)userID
     characterID:(NSString *)characterID
      serverInfo:(NSString *)serverInfo
           level:(NSInteger)level
{
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] levelUpWithUserID:userID characterID:characterID serverInfo:serverInfo level: level];
    }
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] levelUpWithUserID:userID characterID:characterID serverInfo:serverInfo level: level];
    }
    [self trackingEvent:[NSString stringWithFormat:@"user_lv%ld", (long)level]];
}

- (void) vipUp:(NSString *)userID
   characterID:(NSString *)characterID
    serverInfo:(NSString *)serverInfo
      vipLevel:(NSInteger)vipLevel
{
    //Its
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] vipUpWithUserID:userID characterID:characterID serverInfo:serverInfo vipLevel:vipLevel];
    }
    //Appsflyer
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] vipUpWithUserID:userID characterID:characterID serverInfo:serverInfo vipLevel: vipLevel];
    }
    //
    [self trackingEvent:[NSString stringWithFormat:@"user_vip%ld", (long)vipLevel]];
}

- (void) useItem:(NSString *)userID
     characterID:(NSString *)characterID
      serverInfo:(NSString *)serverInfo
          itemID:(NSString *)itemID
        quantity:(NSInteger)quantity
{
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] useItemWithUserID:userID characterID:characterID serverInfo:serverInfo itemID:itemID quantity:quantity];
    }
    //Appsflyer
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[AppsflyerManager sharedInstance] useItemWithUserID:userID characterID:characterID serverInfo:serverInfo itemID:itemID quantity:quantity];
    }
}


- (void) trackActivityResult:(NSString *)userID
                 characterID:(NSString *)characterID
                  serverInfo:(NSString *)serverInfo
                  activityID:(NSString *)activityID
              activityResult:(NSString *)activityResult
{
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] trackActivityResultWithUserID:userID characterID:characterID serverInfo:serverInfo activityID:activityID activityResult:activityResult];
    }
    //Appsflyer
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] trackActivityResultWithUserID:userID characterID:characterID serverInfo:serverInfo activityID:activityID activityResult:activityResult];
    }
}

- (void) logout
{
    if([[SdkConfig sharedInstance] isEnableIts] == YES){
        [[ItsManager sharedInstance] logout];
    }
    if([[SdkConfig sharedInstance] isEnableAppsflyer] == YES){
        [[AppsflyerManager sharedInstance] logout];
    };
}

//CrashlyticsManager
+ (CrashlyticsManager *) crashlytics
{
    return [CrashlyticsManager sharedInstance];
}
@end
