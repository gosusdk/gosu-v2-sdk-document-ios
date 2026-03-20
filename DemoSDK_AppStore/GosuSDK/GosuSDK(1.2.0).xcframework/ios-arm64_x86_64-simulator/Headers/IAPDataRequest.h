//
//  IAPDataRequest.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/9/21.
//

#import "IAPDelegate.h"
#import <UIKit/UIKit.h>
@interface IAPDataRequest : NSObject


@property (nonatomic, strong) id<IAPDelegate> iAPDelegate;
@property (nonatomic, strong) UIViewController *mainViewController;

@property (nonatomic, strong, readonly) NSString        *username;
@property (nonatomic, strong, readonly) NSString        *orderID;
@property (nonatomic, strong, readonly) NSString        *orderInfo;
@property (nonatomic, strong, readonly) NSString        *serverID;
@property (nonatomic, strong, readonly) NSString        *amount;
@property (nonatomic, strong, readonly) NSString        *appleProductId;
@property (nonatomic, strong, readonly) NSString        *applesharesecret;
@property (nonatomic, strong, readonly) NSString        *character;
@property (nonatomic, strong, readonly) NSString        *extraInfo;
@property (nonatomic, assign) NSString        *channelID;
@property (nonatomic, assign) BOOL        iapIsValid;

- (id) init;
- (id) initWithData:(NSString *)username andServerID:(NSString *)serverID andAmount:(NSString *)amount andAppleProductID:(NSString *)productID andAppleShareSecrect:(NSString *)appleShareSecrect andRoleID:(NSString *)roleID andExtraInfo:(NSString *)extraInfo;

- (id) initWithData:(NSString *)username andOrderId:(NSString *)orderID andOrderInfo:(NSString *)orderInfo andServerID:(NSString *)serverID andAmount:(NSString *)amount andAppleProductID:(NSString *)productID andAppleShareSecrect:(NSString *)appleShareSecrect andRoleID:(NSString *)roleID andExtraInfo:(NSString *)extraInfo;

- (BOOL) validateUsername:(NSString *)usernameStore;
- (NSString *)getUsername;
- (NSString *)getOrderId;
- (NSString *)getOrderInfo;
- (NSString *)getServerID;
- (NSString *)getAmount;
- (NSString *)getProductId;
- (NSString *)getAppleShareSecrect;
- (NSString *)getExtraInfo;
- (NSString *)getCharacter;
@end
