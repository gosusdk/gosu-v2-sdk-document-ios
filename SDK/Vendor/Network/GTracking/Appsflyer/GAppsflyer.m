//
//  GAppsflyer.m
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import "GAppsflyer.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <APPTRACKINGTRANSPARENCY/ATTrackingManager.h>

static NSString * const TAG = @"GAppsflyer";

@implementation GAppsflyer

- (BOOL)isAvailable {
    return self.appsFlyerLib != nil;
}

- (void)initSdkWithDevKey:(NSString *)devKey
                 andAppId:(NSString *)appId
            andSdkInfo:(NSDictionary *)sdkInfo
           andListener:(id<GAppsflyerListener>)listener  {
    @try {
        self.devKey = devKey;
        self.listener = listener;
        self.appId = appId;
        self.appsFlyerLib = [AppsFlyerLib shared];
        
        // Configure AppsFlyer
        [self.appsFlyerLib setAppsFlyerDevKey:devKey];
        [self.appsFlyerLib setAppleAppID:appId];
        [self.appsFlyerLib setDelegate:self];
        //
        [self.appsFlyerLib setIsDebug:YES];
        //
        [self.appsFlyerLib waitForATTUserAuthorizationWithTimeoutInterval:60];
        // Start AppsFlyer
        [self.appsFlyerLib start];
        
        if (@available(iOS 14, *)) {
            
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                NSLog(@"Status: %lu", (unsigned long)status);
            }];
        }
    
        // Success callback
        if (listener && [listener respondsToSelector:@selector(onInitializeSuccess)]) {
            [listener onInitializeSuccess];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@: Error initializing AppsFlyer SDK: %@", TAG, exception.reason);
        if (listener && [listener respondsToSelector:@selector(onInitializeError:)]) {
            AppsflyerException *error = [AppsflyerException exceptionWithMessage:exception.reason code:1];
            [listener onInitializeError:error];
        }
    }
}

-(void) setCustomerUserID:(NSString *)customerUserID
{
    if (![self isAvailable]) return;
    [AppsFlyerLib shared].customerUserID = customerUserID;
}

#pragma mark - Tracking Methods

- (void)completeRegistration:(NSString *)userId {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.COMPLETE_REGISTRATION eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging completeRegistration: %@", TAG, exception.reason);
    }
}

- (void)login:(NSString *)userId
     userName:(NSString *)userName
    userEmail:(NSString *)userEmail {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @"",
            @"af_user_name": userName ?: @"",
            @"af_user_email": userEmail ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.LOGIN eventValues:eventValues completionHandler:nil];
        [self.appsFlyerLib setCustomerUserID:userId];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging login: %@", TAG, exception.reason);
    }
}

- (void)createNewCharacter:(NSString *)userId
               characterId:(NSString *)characterId
             characterName:(NSString *)characterName
                serverInfo:(NSString *)serverInfo {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_character_name": characterName ?: @"",
            @"af_server_info": serverInfo ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.CREATE_NEW_CHARACTER eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging createNewCharacter: %@", TAG, exception.reason);
    }
}

- (void)enterGame:(NSString *)userId
      characterId:(NSString *)characterId
    characterName:(NSString *)characterName
       serverInfo:(NSString *)serverInfo {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_character_name": characterName ?: @"",
            @"af_server_info": serverInfo ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.ENTER_GAME eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging enterGame: %@", TAG, exception.reason);
    }
}

- (void)startTutorial:(NSString *)userId
          characterId:(NSString *)characterId
        characterName:(NSString *)characterName
           serverInfo:(NSString *)serverInfo {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_character_name": characterName ?: @"",
            @"af_server_info": serverInfo ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.START_TUTORIAL eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging startTutorial: %@", TAG, exception.reason);
    }
}

- (void)completeTutorial:(NSString *)userId
             characterId:(NSString *)characterId
           characterName:(NSString *)characterName
              serverInfo:(NSString *)serverInfo {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_character_name": characterName ?: @"",
            @"af_server_info": serverInfo ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.COMPLETE_TUTORIAL eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging completeTutorial: %@", TAG, exception.reason);
    }
}




- (void)checkout:(NSString *)orderId
          userId:(NSString *)userId
     characterId:(NSString *)characterId
      serverInfo:(NSString *)serverInfo
       productId:(NSString *)productId
           brand:(NSString *)brand
        quantity:(NSInteger)quantity
        category:(NSString *)category
           price:(float)price
        currency:(NSString *)currency
         revenue:(float)revenue {
    if (![self isAvailable]) return;
    @try {
        NSMutableDictionary *eventValues = [@{
            @"af_order_id": orderId ?: @"",
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_server_info": serverInfo ?: @"",
            @"af_content_id": productId ?: @"",
            @"af_brand": brand ?: @"",
            @"af_category": category ?: @"",
            @"af_currency": currency ?: @"USD"
        } mutableCopy];
        
        if(quantity) eventValues[@"af_quantity"] = @(quantity);
        if (price) eventValues[@"af_price"] = @(price);
        if (revenue) eventValues[AFEventParamRevenue] = @(revenue);
        
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.CHECKOUT eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging checkout: %@", TAG, exception.reason);
    }
}

- (void)purchase:(NSString *)orderId
          userId:(NSString *)userId
     characterId:(NSString *)characterId
      serverInfo:(NSString *)serverInfo
       productId:(NSString *)productId
           brand:(NSString *)brand
        quantity:(NSInteger)quantity
        category:(NSString *)category
           price:(float)price
        currency:(NSString *)currency
         revenue:(float)revenue; {
    if (![self isAvailable]) return;
    @try {
        NSMutableDictionary *eventValues = [@{
            @"af_order_id": orderId ?: @"",
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_server_info": serverInfo ?: @"",
            @"af_content_id": productId ?: @"",
            @"af_brand": brand ?: @"",
            @"af_category": category ?: @"",
            @"af_currency": currency ?: @"USD"
        } mutableCopy];
        
        if (quantity) eventValues[@"af_quantity"] = @(quantity);
        if (price) eventValues[@"af_price"] = @(price);
        if (revenue) eventValues[AFEventParamRevenue] = @(revenue);
        
        [self.appsFlyerLib logEventWithEventName:AFEventPurchase eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging purchase: %@", TAG, exception.reason);
    }
}

- (void)levelUp:(NSString *)userId
    characterId:(NSString *)characterId
     serverInfo:(NSString *)serverInfo
          level:(NSNumber *)level {
    if (![self isAvailable]) return;
    @try {
        NSMutableDictionary *eventValues = [@{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_server_info": serverInfo ?: @""
        } mutableCopy];
        
        if (level) eventValues[AFEventParamLevel] = level;
        
        [self.appsFlyerLib logEventWithEventName:AFEventLevelAchieved eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging levelUp: %@", TAG, exception.reason);
    }
}

- (void)vipUp:(NSString *)userId
  characterId:(NSString *)characterId
   serverInfo:(NSString *)serverInfo
     vipLevel:(NSNumber *)vipLevel {
    if (![self isAvailable]) return;
    @try {
        NSMutableDictionary *eventValues = [@{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_server_info": serverInfo ?: @""
        } mutableCopy];
        
        if (vipLevel) eventValues[@"af_vip_level"] = vipLevel;
        
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.VIP_ACHIEVED eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging vipUp: %@", TAG, exception.reason);
    }
}

- (void)useItem:(NSString *)userId
    characterId:(NSString *)characterId
     serverInfo:(NSString *)serverInfo
         itemId:(NSString *)itemId
       quantity:(NSNumber *)quantity {
    if (![self isAvailable]) return;
    @try {
        NSMutableDictionary *eventValues = [@{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_server_info": serverInfo ?: @"",
            @"af_item_id": itemId ?: @""
        } mutableCopy];
        
        if (quantity) eventValues[@"af_quantity"] = quantity;
        
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.USE_ITEM eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging useItem: %@", TAG, exception.reason);
    }
}

- (void)trackActivityResult:(NSString *)userId
                characterId:(NSString *)characterId
                 serverInfo:(NSString *)serverInfo
                 activityId:(NSString *)activityId
             activityResult:(NSString *)activityResult {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_user_id": userId ?: @"",
            @"af_character_id": characterId ?: @"",
            @"af_server_info": serverInfo ?: @"",
            @"af_activity_id": activityId ?: @"",
            @"af_activity_result": activityResult ?: @""
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.ACTIVITY_TRACKING eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging trackActivityResult: %@", TAG, exception.reason);
    }
}

- (void)trackCustomEvent:(NSString *)eventName
              jsonObject:(NSDictionary *)jsonObject {
    if (![self isAvailable]) return;
    @try {
        [self.appsFlyerLib logEventWithEventName:eventName eventValues:jsonObject completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging trackCustomEvent: %@", TAG, exception.reason);
    }
}

- (void)logout {
    if (![self isAvailable]) return;
    @try {
        NSDictionary *eventValues = @{
            @"af_logout_time": [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]
        };
        [self.appsFlyerLib logEventWithEventName:GAppsflyerInAppEventName.LOGOUT eventValues:eventValues completionHandler:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@: Error logging logout: %@", TAG, exception.reason);
    }
}

#pragma mark - AppsFlyerLibDelegate

- (void)onConversionDataSuccess:(NSDictionary *)conversionInfo {
    if (self.listener && [self.listener respondsToSelector:@selector(onConversionDataSuccess:)]) {
        [self.listener onConversionDataSuccess:conversionInfo];
    }
}

- (void)onConversionDataFail:(NSError *)error {
    if (self.listener && [self.listener respondsToSelector:@selector(onConversionDataFail:)]) {
        [self.listener onConversionDataFail:error.localizedDescription];
    }
}

@end

#pragma mark - Event Names Implementation

@implementation GAppsflyerInAppEventName

+ (NSString *)LEVEL_ACHIEVED { return AFEventLevelAchieved; }
+ (NSString *)VIP_ACHIEVED { return @"af_vip_achieved"; }
+ (NSString *)ADD_PAYMENT_INFO { return AFEventAddPaymentInfo; }
+ (NSString *)ADD_TO_CART { return AFEventAddToCart; }
+ (NSString *)ADD_TO_WISH_LIST { return AFEventAddToWishlist; }
+ (NSString *)REQUEST_REFERRER { return @"af_req_referrer"; }
+ (NSString *)RECEIVE_REFERRER { return @"af_receive_referrer"; }
+ (NSString *)COMPLETE_REGISTRATION { return AFEventCompleteRegistration; }
+ (NSString *)START_TUTORIAL { return @"af_start_tutorial"; }
+ (NSString *)COMPLETE_TUTORIAL { return @"af_complete_tutorial"; }
+ (NSString *)ENTER_GAME { return @"af_enter_game"; }
+ (NSString *)CHECKOUT { return @"af_checkout"; }
+ (NSString *)PURCHASE { return AFEventPurchase; }
+ (NSString *)RATE { return AFEventRate; }
+ (NSString *)SEARCH { return AFEventSearch; }
+ (NSString *)ACHIEVEMENT_UNLOCKED { return AFEventAchievementUnlocked; }
+ (NSString *)CONTENT_VIEW { return AFEventContentView; }
+ (NSString *)SHARE { return AFEventShare; }
+ (NSString *)INVITE { return AFEventInvite; }
+ (NSString *)LOGIN { return AFEventLogin; }
+ (NSString *)IDENTIFY { return @"af_identify"; }
+ (NSString *)LOGOUT { return @"af_logout"; }
+ (NSString *)RE_ENGAGE { return AFEventReEngage; }
+ (NSString *)UPDATE { return AFEventUpdate; }
+ (NSString *)OPENED_FROM_PUSH_NOTIFICATION { return @"af_opened_from_push_notification"; }
+ (NSString *)LOCATION_CHANGED { return @"af_location_changed"; }
+ (NSString *)LOCATION_COORDINATES { return @"af_location_coordinates"; }
+ (NSString *)ORDER_ID { return @"af_order_id"; }
+ (NSString *)CUSTOMER_SEGMENT { return @"af_customer_segment"; }
+ (NSString *)LIST_VIEW { return @"af_list_view"; }
+ (NSString *)SUBSCRIBE { return AFEventSubscribe; }
+ (NSString *)START_TRIAL { return @"af_start_trial"; }
+ (NSString *)AD_CLICK { return @"af_ad_click"; }
+ (NSString *)AD_VIEW { return @"af_ad_view"; }
+ (NSString *)USE_ITEM { return @"af_use_item"; }
+ (NSString *)CREATE_NEW_CHARACTER { return @"af_new_character"; }
+ (NSString *)ACTIVITY_TRACKING { return @"af_activity_tracking"; }

@end


