#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ItsSDK/ItsSDK.h"
@interface ItsManager : NSObject
@property (nonatomic, weak) id<ItsSDKDelegate> delegate;

+ (instancetype)sharedInstance;

//- (void)initializeSDK;

- (void)initializeSDKWithCustomInfo:(NSDictionary *)customInfo completion:(void (^)(BOOL success, NSString *message))completion;

- (void)completeRegistrationWithUserID:(NSString *)userID;

- (void)loginWithUserID:(NSString *)userID
               userName:(NSString *)userName
              userEmail:(NSString *)userEmail;

- (void)createNewCharacterWithUserID:(NSString *)userID
                         characterID:(NSString *)characterID
                       characterName:(NSString *)characterName
                          serverInfo:(NSString *)serverInfo;

- (void)enterGameWithUserID:(NSString *)userID
                characterID:(NSString *)characterID
              characterName:(NSString *)characterName
                 serverInfo:(NSString *)serverInfo;

- (void)startTutorialWithUserID:(NSString *)userID
                    characterID:(NSString *)characterID
                  characterName:(NSString *)characterName
                     serverInfo:(NSString *)serverInfo;

- (void)completeTutorialWithUserID:(NSString *)userID
                       characterID:(NSString *)characterID
                     characterName:(NSString *)characterName
                        serverInfo:(NSString *)serverInfo;

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
                    revenue:(float)revenue;

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
                    revenue:(float)revenue;

- (void)levelUpWithUserID:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                    level:(NSInteger)level;

- (void)vipUpWithUserID:(NSString *)userID
            characterID:(NSString *)characterID
             serverInfo:(NSString *)serverInfo
                vipLevel:(NSInteger)vipLevel;

- (void)useItemWithUserID:(NSString *)userID
              characterID:(NSString *)characterID
               serverInfo:(NSString *)serverInfo
                   itemID:(NSString *)itemID
                 quantity:(NSInteger)quantity;

- (void)trackActivityResultWithUserID:(NSString *)userID
                          characterID:(NSString *)characterID
                           serverInfo:(NSString *)serverInfo
                           activityID:(NSString *)activityID
                      activityResult:(NSString *)activityResult;

- (void)trackCustomEventWithEventName:(NSString *)eventName
                           properties:(NSDictionary<NSString *, id> *)properties;

- (void)logout;

@end
