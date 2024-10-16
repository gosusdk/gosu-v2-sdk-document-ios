//
//  IAPDataRequest.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/9/21.
//

#import <Foundation/Foundation.h>
#import "IAPDataRequest.h"

@implementation IAPDataRequest

- (id) init
{
    self = [super init];
    self->_iapIsValid = NO;
    self->_character = @"";
    self->_extraInfo = @"";
    return self;
}

- (id) initWithData:(NSString *)username andServerID:(NSString *)serverID andAmount:(NSString *)amount andAppleProductID:(NSString *)productID andAppleShareSecrect:(NSString *)appleShareSecrect andRoleID:(NSString *)roleID andExtraInfo:(NSString *)extraInfo
{
    return [self initWithData:username andOrderId:@"" andOrderInfo:@"" andServerID:serverID andAmount:amount andAppleProductID:productID andAppleShareSecrect:appleShareSecrect andRoleID:roleID andExtraInfo:extraInfo];
}

- (id) initWithData:(NSString *)username andOrderId:(NSString *)orderID andOrderInfo:(NSString *)orderInfo andServerID:(NSString *)serverID andAmount:(NSString *)amount andAppleProductID:(NSString *)productID andAppleShareSecrect:(NSString *)appleShareSecrect andRoleID:(NSString *)roleID andExtraInfo:(NSString *)extraInfo
{
    self = [super init];
    self->_iapIsValid = NO;
    self->_username = username;
    self->_orderID = orderID;
    self->_orderInfo = orderInfo;
    self->_serverID = serverID;
    self->_amount = amount;
    self->_appleProductId = productID;
    self->_applesharesecret = appleShareSecrect;
    self->_character = roleID;
    self->_extraInfo = extraInfo;
    if(!self->_character) {
        self->_character = @"";
    }
    if(!self->_extraInfo) {
        self->_extraInfo = @"";
    }
    return self;
}

- (BOOL) validateUsername:(NSString *)usernameStore
{
    if(!_username || [_username isEqualToString:usernameStore])
    {
        return false;
    }
    return true;
}


- (NSString *)getUsername
{
    return [_username stringByRemovingPercentEncoding];
}

- (NSString *)getOrderId
{
    return [_orderID stringByRemovingPercentEncoding];
}

- (NSString *)getOrderInfo
{
    return [_orderInfo stringByRemovingPercentEncoding];
}

- (NSString *)getServerID
{
    return [_serverID stringByRemovingPercentEncoding];
}

- (NSString *)getAmount
{
    return [_amount stringByRemovingPercentEncoding];
}

- (NSString *)getProductId
{
    return [_appleProductId stringByRemovingPercentEncoding];
}

- (NSString *)getAppleShareSecrect
{
    return [_applesharesecret stringByRemovingPercentEncoding];
}

- (NSString *)getExtraInfo
{
    return [_extraInfo stringByRemovingPercentEncoding];
}

- (NSString *)getCharacter
{
    return [_character stringByRemovingPercentEncoding];
}
@end
