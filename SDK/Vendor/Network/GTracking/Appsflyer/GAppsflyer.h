//
//  GAppsflyer.h
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import <Foundation/Foundation.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "GAppsflyerListener.h"
#import "AppsflyerException.h"
@interface GAppsflyer : NSObject <AppsFlyerLibDelegate>

@property (nonatomic, strong) AppsFlyerLib *appsFlyerLib;
@property (nonatomic, weak) NSString *devKey;
@property (nonatomic, weak) NSString *appId;
@property (nonatomic, weak) id<GAppsflyerListener> listener;

// Core methods
- (BOOL)isAvailable;
- (void)initSdkWithDevKey:(NSString *)devKey
            andAppId:(NSString *)appId
       andSdkInfo:(NSDictionary *)sdkInfo
      andListener:(id<GAppsflyerListener>)listener;
-(void) setCustomerUserID:(NSString *)customerUserID;

// Tracking methods
- (void)completeRegistration:(NSString *)userId;
//
- (void)login:(NSString *)userId
     userName:(NSString *)userName
    userEmail:(NSString *)userEmail;
    
- (void)createNewCharacter:(NSString *)userId
               characterId:(NSString *)characterId
             characterName:(NSString *)characterName
                serverInfo:(NSString *)serverInfo;

- (void)enterGame:(NSString *)userId
      characterId:(NSString *)characterId
    characterName:(NSString *)characterName
       serverInfo:(NSString *)serverInfo;

- (void)startTutorial:(NSString *)userId
          characterId:(NSString *)characterId
        characterName:(NSString *)characterName
           serverInfo:(NSString *)serverInfo;

- (void)completeTutorial:(NSString *)userId
             characterId:(NSString *)characterId
           characterName:(NSString *)characterName
              serverInfo:(NSString *)serverInfo;
              
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
         revenue:(float)revenue;

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
         revenue:(float)revenue;

- (void)levelUp:(NSString *)userId
    characterId:(NSString *)characterId
     serverInfo:(NSString *)serverInfo
          level:(NSNumber *)level;

- (void)vipUp:(NSString *)userId
  characterId:(NSString *)characterId
   serverInfo:(NSString *)serverInfo
     vipLevel:(NSNumber *)vipLevel;

- (void)useItem:(NSString *)userId
    characterId:(NSString *)characterId
     serverInfo:(NSString *)serverInfo
         itemId:(NSString *)itemId
       quantity:(NSNumber *)quantity;

- (void)trackActivityResult:(NSString *)userId
                characterId:(NSString *)characterId
                 serverInfo:(NSString *)serverInfo
                 activityId:(NSString *)activityId
             activityResult:(NSString *)activityResult;

- (void)trackCustomEvent:(NSString *)eventName
              jsonObject:(NSDictionary *)jsonObject;

- (void)logout;

@end

// Constants for event names
@interface GAppsflyerInAppEventName : NSObject

@property (nonatomic, class, readonly) NSString *LEVEL_ACHIEVED;
@property (nonatomic, class, readonly) NSString *VIP_ACHIEVED;
@property (nonatomic, class, readonly) NSString *ADD_PAYMENT_INFO;
@property (nonatomic, class, readonly) NSString *ADD_TO_CART;
@property (nonatomic, class, readonly) NSString *ADD_TO_WISH_LIST;
@property (nonatomic, class, readonly) NSString *REQUEST_REFERRER;
@property (nonatomic, class, readonly) NSString *RECEIVE_REFERRER;
@property (nonatomic, class, readonly) NSString *COMPLETE_REGISTRATION;
@property (nonatomic, class, readonly) NSString *START_TUTORIAL;
@property (nonatomic, class, readonly) NSString *COMPLETE_TUTORIAL;
@property (nonatomic, class, readonly) NSString *ENTER_GAME;
@property (nonatomic, class, readonly) NSString *CHECKOUT;
@property (nonatomic, class, readonly) NSString *PURCHASE;
@property (nonatomic, class, readonly) NSString *RATE;
@property (nonatomic, class, readonly) NSString *SEARCH;
@property (nonatomic, class, readonly) NSString *ACHIEVEMENT_UNLOCKED;
@property (nonatomic, class, readonly) NSString *CONTENT_VIEW;
@property (nonatomic, class, readonly) NSString *SHARE;
@property (nonatomic, class, readonly) NSString *INVITE;
@property (nonatomic, class, readonly) NSString *LOGIN;
@property (nonatomic, class, readonly) NSString *IDENTIFY;
@property (nonatomic, class, readonly) NSString *LOGOUT;
@property (nonatomic, class, readonly) NSString *RE_ENGAGE;
@property (nonatomic, class, readonly) NSString *UPDATE;
@property (nonatomic, class, readonly) NSString *OPENED_FROM_PUSH_NOTIFICATION;
@property (nonatomic, class, readonly) NSString *LOCATION_CHANGED;
@property (nonatomic, class, readonly) NSString *LOCATION_COORDINATES;
@property (nonatomic, class, readonly) NSString *ORDER_ID;
@property (nonatomic, class, readonly) NSString *CUSTOMER_SEGMENT;
@property (nonatomic, class, readonly) NSString *LIST_VIEW;
@property (nonatomic, class, readonly) NSString *SUBSCRIBE;
@property (nonatomic, class, readonly) NSString *START_TRIAL;
@property (nonatomic, class, readonly) NSString *AD_CLICK;
@property (nonatomic, class, readonly) NSString *AD_VIEW;
@property (nonatomic, class, readonly) NSString *USE_ITEM;
@property (nonatomic, class, readonly) NSString *CREATE_NEW_CHARACTER;
@property (nonatomic, class, readonly) NSString *ACTIVITY_TRACKING;

@end


