#import "ItsManager.h"
#import "SdkConfig.h"

@implementation ItsManager

+ (instancetype)sharedInstance {
    static ItsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
//


- (void)initializeSDK{
    
}

- (void)initializeSDKWithCustomInfo:(NSDictionary *)customInfo completion:(void (^)(BOOL success, NSString *message))completion {
    @try {
        
        [[ItsSDK shared] initializeSDKWithWriteKey:[SdkConfig sharedInstance].itsWritekey
                                        signingKey:[SdkConfig sharedInstance].itsSigningKey
                                        customInfo:customInfo
                                        completion:^(BOOL success, NSString * _Nonnull message) {
            if(completion) {
                completion(success, message);
            }
        }];
        
    } @catch (NSException *exception) {
        //NSLog(@"ITSTrackingManager:initializeSDKWithCompletion: Error: %@", exception.reason);
        if (completion) {
            completion(NO, exception.reason);
        }}
}

- (void)completeRegistrationWithUserID:(NSString *)userID {
    @try {
        [[ItsSDK shared] completeRegistrationWithUserID:userID];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:completeRegistrationWithUserID: Error: %@", exception.reason);
    }
}

- (void)loginWithUserID:(NSString *)userID
               userName:(NSString *)userName
              userEmail:(NSString *)userEmail {
    @try {
        [[ItsSDK shared] loginWithUserID:userID userName:userName userEmail:userEmail];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:loginWithUserID: Error: %@", exception.reason);
    }
}

- (void)createNewCharacterWithUserID:(NSString *)userID
                         characterID:(NSString *)characterID
                       characterName:(NSString *)characterName
                          serverInfo:(NSString *)serverInfo {
    @try {
        [[ItsSDK shared] createNewCharacterWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:createNewCharacterWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)enterGameWithUserID:(NSString *)userID
                characterID:(NSString *)characterID
              characterName:(NSString *)characterName
                 serverInfo:(NSString *)serverInfo {
    @try {
        [[ItsSDK shared] enterGameWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:enterGameWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)startTutorialWithUserID:(NSString *)userID
                    characterID:(NSString *)characterID
                  characterName:(NSString *)characterName
                     serverInfo:(NSString *)serverInfo {
    @try {
        [[ItsSDK shared] startTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:startTutorialWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)completeTutorialWithUserID:(NSString *)userID
                       characterID:(NSString *)characterID
                     characterName:(NSString *)characterName
                        serverInfo:(NSString *)serverInfo {
    @try {
        [[ItsSDK shared] completeTutorialWithUserID:userID characterID:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:completeTutorialWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)checkoutWithOrderID:(NSString *)orderID
                     userID:(NSString *)userID
                characterID:(NSString *)characterID
                 serverInfo:(NSString *)serverInfo
                productInfo:(NSString *)productInfo
                      brand:(NSString *)brand
                   quantity:(NSInteger)quantity
                   category:(NSString *)category
                      price:(float)price
                   currency:(NSString *)currency
                    revenue:(float)revenue {
    
    @try {
        [[ItsSDK shared] checkoutWithOrderID:orderID userID:userID characterID:characterID serverInfo:serverInfo productInfo:productInfo brand:brand quantity:quantity category:category price:price currency:currency revenue:revenue];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:checkoutWithOrderID: Error: %@", exception.reason);
    }
}

- (void)purchaseWithOrderID:(NSString *)orderID
                     userID:(NSString *)userID
                characterID:(NSString *)characterID
                 serverInfo:(NSString *)serverInfo
                productInfo:(NSString *)productInfo
                      brand:(NSString *)brand
                   quantity:(NSInteger)quantity
                   category:(NSString *)category
                      price:(float)price
                   currency:(NSString *)currency
                    revenue:(float)revenue {
    @try {
        [[ItsSDK shared] purchaseWithOrderID:orderID userID:userID characterID:characterID serverInfo:serverInfo productInfo:productInfo brand:brand quantity:quantity category:category price:price currency:currency revenue:revenue];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:purchaseWithOrderID: Error: %@", exception.reason);
    }
}

- (void)levelUpWithUserID:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                    level:(NSInteger)level {
    [[ItsSDK shared] levelUpWithUserID:userID characterID:characterID serverInfo:serverInfo level:level];
}

- (void)vipUpWithUserID:(NSString *)userID
            characterID:(NSString *)characterID
             serverInfo:(NSString *)serverInfo
               vipLevel:(NSInteger)vipLevel {
    @try {
        [[ItsSDK shared] vipUpWithUserID:userID characterID:characterID serverInfo:serverInfo vipLevel:vipLevel];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:vipUpWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)useItemWithUserID:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                   itemID:(NSString *)itemID
                 quantity:(NSInteger)quantity {
    @try {
        [[ItsSDK shared] useItemWithUserID:userID characterID:characterID serverInfo:serverInfo itemID:itemID quantity:quantity];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:useItemWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)trackActivityResultWithUserID:(NSString *)userID
                          characterID:(NSString *)characterID
                           serverInfo:(NSString *)serverInfo
                           activityID:(NSString *)activityID
                       activityResult:(NSString *)activityResult {
    
    @try {
        [[ItsSDK shared] trackActivityResultWithUserID:userID characterID:characterID serverInfo:serverInfo activityID:activityID activityResult:activityResult];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:trackActivityResultWithUserID: Error: %@", exception.reason);
    }
}

- (void)trackCustomEventWithEventName:(NSString *)eventName
                           properties:(NSDictionary*)properties {
    @try {
        [[ItsSDK shared] trackCustomEventWithEventName:eventName properties:properties];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:trackCustomEventWithEventName: Error: %@", exception.reason);
    }
    
}

- (void)logout {
    @try {
        [[ItsSDK shared] logout];
    } @catch (NSException *exception) {
        NSLog(@"ITSTrackingManager:logout: Error: %@", exception.reason);
    }
    
}
@end

