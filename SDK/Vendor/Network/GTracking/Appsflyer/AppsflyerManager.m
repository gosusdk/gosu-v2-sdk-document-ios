//
//  AppsflyerManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//


#import "AppsflyerManager.h"
//appflyer
#import "SdkConfig.h"
#import "GAppsflyer.h"

@interface AppsflyerManager()
{
    GAppsflyer *gAppsflyer;
}

@end
static AppsflyerManager *sharedInstance;
@implementation AppsflyerManager

#pragma mark Singleton Methods
+ (AppsflyerManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance = [[super alloc] init];
            sharedInstance->gAppsflyer = [[GAppsflyer alloc] init];
        }
    }
    return sharedInstance;
}
- (void) initAppsFlyer
{
    [gAppsflyer initSdkWithDevKey:[SdkConfig sharedInstance].appsflyerKey andAppId:[SdkConfig sharedInstance].appsflyerAppleID andSdkInfo:nil andListener:self];
}

- (void) startAppsflyerWithInterval
{
    // GAppsflyer handles ATT automatically
    // No explicit start method needed
}
- (void) startAppsflyer {
    // GAppsflyer handles ATT automatically
    
}
-(void) trackingUninstallOnAF:(NSData *)deviceToken {
    
}

- (void) trackingLaunchOnAF
{
    // App launch is tracked automatically by GAppsflyer
    NSLog(@"App launch tracked automatically by GAppsflyer");
}

- (void) setCustomerUserID:(NSString *)customerUserID {
    @try {
        [gAppsflyer setCustomerUserID:customerUserID];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:setCustomerUserID: Error: %@", exception.reason);
    }
}

- (void)completeRegistrationWithUserID:(NSString *)userID
{
    @try {
        [gAppsflyer completeRegistration:userID];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:completeRegistrationWithUserID: Error: %@", exception.reason);
    }
}

- (void)loginWithUserID:(NSString *)userID
               userName:(NSString *)userName
              userEmail:(NSString *)userEmail {
    @try {
        [gAppsflyer login:userID userName:userName userEmail:userEmail];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:loginWithUserID: Error: %@", exception.reason);
    }
}

- (void)createNewCharacterWithUserID:(NSString *)userID
                         characterID:(NSString *)characterID
                       characterName:(NSString *)characterName
                          serverInfo:(NSString *)serverInfo {
    @try {
        [gAppsflyer createNewCharacter:userID characterId:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:createNewCharacterWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)enterGameWithUserID:(NSString *)userID
                characterID:(NSString *)characterID
              characterName:(NSString *)characterName
                 serverInfo:(NSString *)serverInfo {
    @try {
        [gAppsflyer enterGame:userID characterId:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:enterGameWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)startTutorialWithUserID:(NSString *)userID
                    characterID:(NSString *)characterID
                  characterName:(NSString *)characterName
                     serverInfo:(NSString *)serverInfo {
    @try {
        [gAppsflyer startTutorial:userID characterId:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:startTutorialWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)completeTutorialWithUserID:(NSString *)userID
                       characterID:(NSString *)characterID
                     characterName:(NSString *)characterName
                        serverInfo:(NSString *)serverInfo {
    @try {
        [gAppsflyer completeTutorial:userID characterId:characterID characterName:characterName serverInfo:serverInfo];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:completeTutorialWithUserID: Error: %@", exception.reason);
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
        [gAppsflyer checkout:orderID userId:userID characterId:characterID serverInfo:serverInfo productId:productInfo brand:brand quantity:quantity category:category price:price currency:currency revenue:revenue];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:checkoutWithOrderID: Error: %@", exception.reason);
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
        [gAppsflyer purchase:orderID userId:userID characterId:characterID serverInfo:serverInfo productId:productInfo brand:brand quantity:quantity category:category price:price currency:currency revenue:revenue];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:purchaseWithOrderID: Error: %@", exception.reason);
    }
}

- (void)levelUpWithUserID:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                    level:(NSInteger)level {
    [gAppsflyer levelUp:userID characterId:characterID serverInfo:serverInfo level:@(level)];
}

- (void)vipUpWithUserID:(NSString *)userID
            characterID:(NSString *)characterID
             serverInfo:(NSString *)serverInfo
               vipLevel:(NSInteger)vipLevel {
    @try {
        [gAppsflyer vipUp:userID characterId:characterID serverInfo:serverInfo vipLevel:@(vipLevel)];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:vipUpWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)useItemWithUserID:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                   itemID:(NSString *)itemID
                 quantity:(NSInteger)quantity {
    @try {
        [gAppsflyer useItem:userID characterId:characterID serverInfo:serverInfo itemId:itemID quantity:@(quantity)];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:useItemWithUserID: Error: %@", exception.reason);
    }
    
}

- (void)trackActivityResultWithUserID:(NSString *)userID
                          characterID:(NSString *)characterID
                           serverInfo:(NSString *)serverInfo
                           activityID:(NSString *)activityID
                       activityResult:(NSString *)activityResult {
    
    @try {
        [gAppsflyer trackActivityResult:userID characterId:characterID serverInfo:serverInfo activityId:activityID activityResult:activityResult];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:trackActivityResultWithUserID: Error: %@", exception.reason);
    }
}

- (void)trackCustomEventWithEventName:(NSString *)eventName
                           properties:(NSDictionary*)properties {
    @try {
        [gAppsflyer trackCustomEvent:eventName jsonObject:properties];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:trackCustomEventWithEventName: Error: %@", exception.reason);
    }
    
}

- (void)logout {
    @try {
        [gAppsflyer logout];
    } @catch (NSException *exception) {
        NSLog(@"AppsflyerTrackingManager:logout: Error: %@", exception.reason);
    }
}
#pragma mark - GAppsflyerListener delegate methods

- (void)onInitializeSuccess
{
    NSLog(@"AppsFlyer initialization successful");
}

- (void)onInitializeError:(NSString *)errorMessage
{
    NSLog(@"AppsFlyer initialization error: %@", errorMessage);
}

- (void)onConversionDataSuccess:(NSDictionary *)conversionData
{
    NSLog(@"AppsFlyer conversion data success: %@", conversionData);
}

- (void)onConversionDataFail:(NSString *)errorMessage
{
    NSLog(@"AppsFlyer conversion data error: %@", errorMessage);
}

@end
