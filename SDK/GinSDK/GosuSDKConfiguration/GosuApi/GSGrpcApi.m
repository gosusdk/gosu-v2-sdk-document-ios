//
//  GosuGrpcApi.m
//  GameSDK
//
//  Created by Nero-Macbook on 12/23/21.
//
#import "GSGrpcApi.h"
#import "SdkConfig.h"
#import "SdkLanguage.h"
#import "MD5.h"
#import <sys/utsname.h>
#import "GSApiFramework.h"
#import "GlobalVariable.h"
#import "ErrManager.h"

GSApiFramework *_gssdkGrpcApi;

@implementation GSGrpcApi

- (GSApiFramework *) serverApi
{
    NSString *testApi = @"103.9.207.65:5001";
    NSString *liveApi = @"mobilegateway.gosu.vn:5001";
    if(_gssdkGrpcApi == nil)
    {
        _gssdkGrpcApi = [[GSApiFramework alloc] initWithClient:[[SdkConfig sharedInstance] clientID] andSdkSignature:[[SdkConfig sharedInstance] sdkSignature] andHost:liveApi];
    }
    return _gssdkGrpcApi;
}

- (void) loadServerConfig:(SdkConfig *)_sdkConfig andCallback:(void (^)(LoadServerConfigResponse *))loadServerCallback {
    
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    [[self serverApi] sdkInit:deviceID andInitCalback:^(NSDictionary<NSString *, id> *initCallback) {
        GDLog(@"initCallback2 gosu = %@", initCallback);
        NSData *data = [[initCallback objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *status = [initCallback objectForKey:@"status"];
        int code = [[initCallback objectForKey:@"code"] intValue];
        LoadServerConfigResponse *cf = [[LoadServerConfigResponse alloc] init];
        if([status isEqualToString:@"success"])
        {
            NSDictionary *jsonConfig = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            cf.status = @"success";
            cf.message = @"Tải dữ liệu thành công";
            cf.gameID = (NSString *)[jsonConfig objectForKey:@"GameID"];
            cf.clientID = (NSString *)[jsonConfig objectForKey:@"ClientID"];
            cf.secrectID = (NSString *)[jsonConfig objectForKey:@"SecretKey"];
            cf.serviceID = (NSString *)[jsonConfig objectForKey:@"ServiceID"];
            cf.serviceKey = (NSString *)[jsonConfig objectForKey:@"ServiceKey"];
            cf.googleID = (NSString *)[jsonConfig objectForKey:@"GoogleID"];
            cf.providerID = (NSString *)[jsonConfig objectForKey:@"ProviderID"];
            cf.currencyUnit = (NSString *)[jsonConfig objectForKey:@"CurrencyUnit"];
            cf.language = (NSString *)[jsonConfig objectForKey:@"Language"];
            cf.priceType = (NSString *)[jsonConfig objectForKey:@"PriceType"];
            cf.partnerID = (NSString *)[jsonConfig objectForKey:@"PartnerID"];
            cf.appsFlyerDevKey = (NSString *)[jsonConfig objectForKey:@"AppsFlyer_DevKey"];
            cf.appsFlyerAppleAppID = (NSString *)[jsonConfig objectForKey:@"AppsFlyer_AppleAppID"];
            cf.idAdsAppKey = (NSString *)[jsonConfig objectForKey:@"IDAds_App_Key"];
            cf.idAdsAppKey = (NSString *)[jsonConfig objectForKey:@"IDAds_App_Signature"];
            cf.delAccountAllow = (NSString *)[jsonConfig objectForKey:@"delAcc"];
            cf.environment = (NSString *)[jsonConfig objectForKey:@"environment"];
            cf.topupwallet = (NSString *)[jsonConfig objectForKey:@"topupwallet"];
            cf.serviceKey = cf.secrectID;
            NSString *productIDs =jsonConfig[@"IAP_ProductID"];
            if (productIDs && [productIDs length] > 0) {
                NSCharacterSet *separators = [NSCharacterSet characterSetWithCharactersInString:@",;"];
                NSArray *components = [productIDs componentsSeparatedByCharactersInSet:separators];
                if(components) {
                    cf.productIDs = components;
                }
            }
            NSString *fbAllow = [NSString stringWithFormat:@"%@", [jsonConfig objectForKey:@"facebookAllow"]];
            cf.isFbAllow = [fbAllow isEqual:@"1"];
        } else {
            cf.status = @"failed";
            NSString * remoteMessage = [initCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]) {
                remoteMessage = @"";
            }
            cf.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.SdkInit andErrCode:code andRemoteMessage:remoteMessage];
            [[ErrManager sharedInstance] showErrDialogWithErrGroup:ErrCodeGroup.SdkInit andErrCode:code andRemoteMessage:remoteMessage andCallback:nil];
        }
        
        GDLog(@"cf.status = %@", cf.status);
        loadServerCallback(cf);
    }];
}

//login
- (void) requestLoginById:(SdkConfig *)_sdkConfig andUsername:(NSString *)username andPassword:(NSString *)password andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    NSString *md5Password = [MD5 md5:password];
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, md5Password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.secrectKey];
    hashCode = [MD5 md5:hashCode];
    NSString *sdkSignature = _sdkConfig.sdkSignature;
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] loginById:username andPassword:md5Password andClientId:_sdkConfig.clientID andDeviceId:deviceID andGameId:_sdkConfig.gameId andSdkSignature:sdkSignature andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *loginCallback) {
        NSString *code = [loginCallback objectForKey:@"code"];
        GDLog(@"GSGrpcApi loginCallback = %@",loginCallback);
        RequestLoginResponse *loginResponse = [[RequestLoginResponse alloc] init];
        if (![code isEqualToString:@"200"]) {
            loginResponse.status = @"failed";
            NSString *remoteMsg = [loginCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]){
                remoteMsg = @"";
            }
            loginResponse.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Login andErrCode:[code intValue] andRemoteMessage:remoteMsg];
        } else {
            NSString *accessToken = [loginCallback objectForKey:@"accessToken"];
            loginResponse.status = @"success";
            loginResponse.message = [[SdkLanguage sharedInstance] translate:@"t_account_023"];
            loginResponse.accessToken = accessToken;
            loginResponse.refreshToken = accessToken;
            [_sdkConfig setUsername:username];
        }
        loginResponseCallback(loginResponse);
    }];
}

//register
- (void) requestRegisterById:(SdkConfig *)_sdkConfig andUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    password = [MD5 md5:password];
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.wsPassword];
    hashCode = [MD5 md5:hashCode];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] registerAcountWithUsername:username andPassword:password andEmail:email andDeviceId:deviceID andGameId:_sdkConfig.gameId andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *registerCallback) {
        NSString *code = [registerCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"registerCallback = %@", registerCallback);
        if([code isEqualToString:@"200"]){
//            lr.status = @"success-active";
            lr.status = @"success";
            lr.accessToken = [registerCallback objectForKey:@"accessToken"];
            lr.message = [registerCallback objectForKey:@"transactionId"];
            lr.transactionID = [registerCallback objectForKey:@"transactionId"];
        } else {
            lr.status = @"failed";
            NSString *remoteMsg = [registerCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]){
                remoteMsg = @"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Register andErrCode:[code intValue] andRemoteMessage:remoteMsg];
        }
        loginResponseCallback(lr);
    }];
}
//request active
- (void) requestActiveByUsername:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData  andResponseCallback:(void (^)(RequestActiveResponse *))responseCallback
{
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, userRequireData.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] requestActiveByUsername:userRequireData.username andContentFlag:@"1" andAppToken:_sdkConfig.firebaseFCMToken andChangeBy:1 andEmail:userRequireData.email andPhoneNumber:userRequireData.phoneNumber andSignature:sign andCallback:^(NSDictionary<NSString *,id> *responseData) {
        NSString *code = [responseData objectForKey:@"code"];
        RequestActiveResponse *rq = [[RequestActiveResponse alloc] init];
        rq.code = code;
        if([code isEqualToString:@"200"]){
            rq.status = @"success";
            rq.contentFlag = [responseData objectForKey:@"contentFlag"];
            rq.email = [responseData objectForKey:@"email"];
            rq.phoneNumber = [responseData objectForKey:@"phoneNumber"];
            rq.transactionID = [responseData objectForKey:@"transactionId"];
        } else {
            rq.status = @"failed";
            NSString * remoteMessage = [responseData objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]){
                remoteMessage =@"";
            }
            rq.errMessage = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.RequestActive andErrCode:[code intValue] andRemoteMessage:remoteMessage];
        }
        if(responseCallback){
            responseCallback(rq);
        }
    }];
}
//active account
- (void) accountActivate:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, userRequireData.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    
    [[self serverApi] activeAccountUsername:userRequireData.username andActiveCode:userRequireData.OTPCode andTransactionId:userRequireData.transactionID andDeviceId:deviceID andGameId:_sdkConfig.gameId andSign:sign andCallback:^(NSDictionary<NSString *,id> *activeCallback) {
        NSString *code = [activeCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"registerActiveCallback = %@", activeCallback);
        if([code isEqualToString:@"200"]){
            NSString *accessToken = [activeCallback objectForKey:@"accessToken"];
            lr.status = @"success";
            lr.message = [[SdkLanguage sharedInstance] translate:@"t_account_053"];
            lr.accessToken = accessToken;
        } else {
            lr.status = @"failed";
            lr.message = [[SdkLanguage sharedInstance] translateWithCode:@"t_account_055" andCode:[code intValue]];

            NSString * remoteMessage = [activeCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]) {
                remoteMessage = @"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.ActiveAccount andErrCode:[code intValue] andRemoteMessage:remoteMessage];
        }
        if(userRequireData.callback){
            userRequireData.callback(lr);
        }
    }];
}
//login with facebook
- (void) requestLoginByFacebook:(SdkConfig *)_sdkConfig andFacebookLoginResult:(NSDictionary *)facebookLoginResult andAccessToken:(NSString *) accessToken andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    NSString *deviceName = [[UIDevice currentDevice] name];
    deviceName = [deviceName stringByRemovingPercentEncoding];
    
    GDLog(@"token_for_business = %@", facebookLoginResult[@"token_for_business"]);
    NSString *username = facebookLoginResult[@"token_for_business"];
    NSString *token_for_business=facebookLoginResult[@"token_for_business"];
    if(token_for_business && [token_for_business length] > 0) {
        username = token_for_business;
    }
    username = [NSString stringWithFormat:@"%@@facebook", username];
    NSString *password = @"";
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.wsPassword];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    NSString *idToken = accessToken;
    [[self serverApi] registerAcountWithFacebook:username andPassword:password andEmail:@"" andDeviceId:deviceID andGameId:_sdkConfig.gameId  andIdToken:idToken andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *registerCallback) {
        NSString *code = [registerCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"register facebook Callback = %@", registerCallback);
        if([code isEqualToString:@"200"]){
            NSString *accessToken = [registerCallback objectForKey:@"accessToken"];
            lr.status = @"success";
            lr.accessToken = accessToken;
            lr.refreshToken = nil;
            [_sdkConfig setUsername:username];
        } else {
            NSString * remoteMessage = [registerCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]){
                remoteMessage =@"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Register andErrCode:[code intValue] andRemoteMessage:remoteMessage];
            lr.status = @"failed";
        }
        loginResponseCallback(lr);
    }];
}
//login with google
- (void) requestLoginByGoogleID:(SdkConfig *)_sdkConfig andUserId:(NSString *)userID andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *platform = [[UIDevice currentDevice] name];
    platform = [platform stringByRemovingPercentEncoding];
    
    GDLog(@"google login: email - userID = %@ - %@", email, userID);
    NSString *username = email;
    NSString *password = @"";
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.wsPassword];
    hashCode = [MD5 md5:hashCode];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] registerAcountWithGoogle:username andPassword:password andEmail:email andDeviceId:deviceID andGameId:_sdkConfig.gameId andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *registerCallback) {
        NSString *code = [registerCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"register google Callback = %@", registerCallback);
        if([code isEqualToString:@"200"]){
            NSString *accessToken = [registerCallback objectForKey:@"accessToken"];
            lr.status = @"success";
            lr.accessToken = accessToken;
            lr.refreshToken = nil;
            [_sdkConfig setUsername:username];
        } else {
            NSString * remoteMessage = [registerCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]){
                remoteMessage =@"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Register andErrCode:[code intValue] andRemoteMessage:remoteMessage];
            lr.status = @"failed";
        }
        loginResponseCallback(lr);
    }];
}
- (void) requestLoginByAppleID:(SdkConfig *)_sdkConfig andUserId:(NSString *)userID andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *platform = [[UIDevice currentDevice] name];
    platform = [platform stringByRemovingPercentEncoding];
    
    NSString *username = [NSString stringWithFormat:@"%@@apple", userID];
    NSString *password = @"";
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.wsPassword];
    
    GDLog(@"apple login: email - username = %@ - %@", email, username);
    hashCode = [MD5 md5:hashCode];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    NSString *idToken = @"";
    [[self serverApi] registerAcountWithApple:username andPassword:password andEmail:email andDeviceId:deviceID andGameId:_sdkConfig.gameId  andIdToken:idToken andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *registerCallback) {
        NSString *code = [registerCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"register apple Callback = %@", registerCallback);
        if([code isEqualToString:@"200"]){
            NSString *accessToken = [registerCallback objectForKey:@"accessToken"];
            lr.status = @"success";
            lr.accessToken = accessToken;
            lr.refreshToken = nil;
            [_sdkConfig setUsername:username];
        } else {
            NSString * remoteMessage = [registerCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]){
                remoteMessage =@"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Register andErrCode:[code intValue] andRemoteMessage:remoteMessage];
            lr.status = @"failed";
        }
        loginResponseCallback(lr);
    }];
}
- (void) requestLoginByAppleID:(AppleLoginResponse *) appleUser andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *platform = [[UIDevice currentDevice] name];
    platform = [platform stringByRemovingPercentEncoding];
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSString *username = [NSString stringWithFormat:@"%@@apple", appleUser.userID];
    NSString *password = @"";
    NSString *email = appleUser.email;
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.wsPassword];
    
    GDLog(@"apple login: email - username = %@ - %@", appleUser.email, username);
    hashCode = [MD5 md5:hashCode];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    NSString *idToken = appleUser.identityToken;
    [[self serverApi] registerAcountWithApple:username andPassword:password andEmail:email andDeviceId:deviceID andGameId:_sdkConfig.gameId  andIdToken:idToken andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *registerCallback) {
        NSString *code = [registerCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"register apple Callback = %@", registerCallback);
        if([code isEqualToString:@"200"]){
            NSString *accessToken = [registerCallback objectForKey:@"accessToken"];
            lr.status = @"success";
            lr.accessToken = accessToken;
            lr.refreshToken = nil;
            [_sdkConfig setUsername:username];
        } else {
            NSString * remoteMessage = [registerCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]){
                remoteMessage =@"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Register andErrCode:[code intValue] andRemoteMessage:remoteMessage];
            lr.status = @"failed";
        }
        loginResponseCallback(lr);
    }];
}
- (void) requestLoginByDeviceID:(SdkConfig *)_sdkConfig andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];

    NSString *username = deviceID;
    NSString *password = @"";
    NSString *hashCode = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                          username, password, _sdkConfig.clientID, deviceID, _sdkConfig.gameId, _sdkConfig.secrectKey];
    
    GDLog(@"gosu playnow login: %@", deviceID);
    hashCode = [MD5 md5:hashCode];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] registerAcountWithPlaynow:username andPassword:password andEmail:@"" andDeviceId:deviceID andGameId:_sdkConfig.gameId andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSecurityCode:hashCode andSign:sign andCallback:^(NSDictionary<NSString *,id> *registerCallback) {
        NSString *code = [registerCallback objectForKey:@"code"];
        RequestLoginResponse *lr = [[RequestLoginResponse alloc] init];
        GDLog(@"register playnow Callback = %@", registerCallback);
        if([code isEqualToString:@"200"]){
            NSString *accessToken = [registerCallback objectForKey:@"accessToken"];
            lr.status = @"success";
            lr.accessToken = accessToken;
            lr.refreshToken = nil;
            [_sdkConfig setUsername:username];
        } else {
            NSString * remoteMessage = [registerCallback objectForKey:@"message"];
            if(!remoteMessage || [remoteMessage isEqual:[NSNull null]]){
                remoteMessage =@"";
            }
            lr.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Register andErrCode:[code intValue] andRemoteMessage:remoteMessage];
            lr.status = @"failed";
        }
        loginResponseCallback(lr);
    }];
}
- (void)requestProfile:(SdkConfig *)_sdkConfig andAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, _sdkConfig.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    GDLog(@"requestProfile accessToken = %@", accessToken);
    [[self serverApi] getProfile:[SdkConfig sharedInstance].username andAccessToken:accessToken andDeviceID:deviceID andSign:sign andCallback:^(NSDictionary<NSString *,id> *profileCallback) {
        GDLog(@"profileCallback = %@", profileCallback);
        NSString *code = [profileCallback objectForKey:@"code"];
        NSString *status = [profileCallback objectForKey:@"status"];
        NSString *customerID = [profileCallback objectForKey:@"customerID"];
        NSString *username = [profileCallback objectForKey:@"username"];
        NSString *phoneStatus = [profileCallback objectForKey:@"phoneStatus"];
        NSString *email = [profileCallback objectForKey:@"email"];
        UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
        if([code isEqualToString:@"200"]){
            if (customerID == nil || [customerID isEqual:[NSNull null]]) {
                userProfile.status = @"failed";
                userProfile.message = [NSString stringWithFormat:@"Loi ma khach hang rong %@", code];
            } else {
                [SdkConfig sharedInstance].userID = customerID;
                [SdkConfig sharedInstance].username = username;
                [SdkConfig sharedInstance].userStatus = status;
                [SdkConfig sharedInstance].userSmsStatus = phoneStatus;
                [SdkConfig sharedInstance].userEmail = email;
                [[SdkConfig sharedInstance] setUserID:customerID];
                
                userProfile.status = @"success";
                userProfile.userID = customerID;
                userProfile.username = username;
                userProfile.userStatus = status ? status : 0;
                userProfile.userSmsStatus = phoneStatus;
                userProfile.email = email;
            }
        } else {
            NSString *remoteMsg = [profileCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]){
                remoteMsg = @"";
            }
            userProfile.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.GetProfile andErrCode:[code intValue] andRemoteMessage: remoteMsg];
            userProfile.status = @"failed";
            
            if ([code isEqual:@"305"]) {
                userProfile.status = @"locked";
            }
            @try {
                [self sdkLog:_sdkConfig.clientID andActiveKey:@G_GETPROFILE_SERVER_ERROR andData:profileCallback andUsername:username];
            } @catch (NSException *exception) {
                
            }
        }
        userProfileCallback(userProfile);
    }];
}
- (void) requestAccessToken:(SdkConfig *)_sdkConfig andAccessToken:(NSString *)accessToken andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, _sdkConfig.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    
    [[self serverApi] loginByAccessToken:accessToken andUsername:_sdkConfig.username andDeviceID:deviceID andSign:sign andCallback:^(NSDictionary<NSString *,id> *loginCallback) {
        NSString *code = [loginCallback objectForKey:@"code"];
        NSString *refreshToken = [loginCallback objectForKey:@"refreshToken"];
        RequestLoginResponse *loginResponse = [[RequestLoginResponse alloc] init];
        if([code isEqualToString:@"200"]){
            loginResponse.status = @"success";
            loginResponse.message = [[SdkLanguage sharedInstance] translate:@"t_account_023"];
            loginResponse.accessToken = refreshToken;
            loginResponse.refreshToken = refreshToken;
        } else {
            loginResponse.status = @"failed";
            
            NSString *remoteMsg = [loginCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]){
                remoteMsg = @"";
            }
            NSString *message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.LoginByAccessToken andErrCode:[code intValue] andRemoteMessage:remoteMsg];
            loginResponse.message = message;
            
            [[ErrManager sharedInstance] showErrDialogWithErrGroup:ErrCodeGroup.LoginByAccessToken andErrCode:[code intValue] andRemoteMessage:remoteMsg andCallback:nil];
            
            @try {
                [self sdkLog:_sdkConfig.clientID andActiveKey:@G_LOGIN_BYTOKEN_SV_ERROR andData:loginCallback];
            } @catch (NSException *exception) {
                
            }
        }
        loginResponseCallback(loginResponse);
    }];
}
- (void) requestForgotPasswordById:(SdkConfig *)_sdkConfig andUsername:(NSString *)username andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback
{
    RequestForgotResponse *forgotResponse = [[RequestForgotResponse alloc] init];
    forgotResponse.status = @"failed";
    forgotResponse.message = @"error";
    forgotResponse.code = 500;
    if(forgotResponseCallback) {
        forgotResponseCallback(forgotResponse);
    } else {
        GDLog(@"requestForgotPasswordById = %@", forgotResponse);
    }
    
}

- (void) requestForgotPassword:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *newPassword = [MD5 md5:userRequireData.password];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, userRequireData.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] recoveryPasswordRequest:userRequireData.username   andClientId:_sdkConfig.clientID andDeviceId:deviceID andGameId:_sdkConfig.gameId andSdkSignature:_sdkConfig.sdkSignature andNewPassword:newPassword andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andOTPNetwork:userRequireData.OTPNetwork andSign:sign andCallback:^(NSDictionary<NSString *,id> *recoveryPasswordCallback) {
        GDLog(@"recoveryPasswordCallback = %@", recoveryPasswordCallback);
        int code = [[recoveryPasswordCallback objectForKey:@"code"] intValue];
        RequestForgotResponse *forgotResponse = [[RequestForgotResponse alloc] init];
        NSString *message = @"";
        if(code == 200){
            forgotResponse.status = @"success";
            forgotResponse.isRichText = TRUE;
            NSString *email = [recoveryPasswordCallback objectForKey:@"email"];
            NSString *phone = [recoveryPasswordCallback objectForKey:@"phone"];
            if ([userRequireData.OTPNetwork isEqual:@"phone"]) {
                message = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"t_alert_005"], phone];
            } else {
                message = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"t_alert_005"], email];
            }
            userRequireData.transactionID = [recoveryPasswordCallback objectForKey:@"transactionId"];
        } else {
            forgotResponse.status = @"failed";
            NSString *remoteMsg = [recoveryPasswordCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]) {
                remoteMsg = @"";
            }
            message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.RecoveryPasswordRequest andErrCode:code andRemoteMessage:remoteMsg];
        }
        forgotResponse.message = message;
        if(forgotResponseCallback)
        {
            forgotResponseCallback(forgotResponse);
        }
    }];
}
- (void) requestForgotPasswordWithResetPassword:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, userRequireData.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] recoveryPasswordSubmit:userRequireData.username andOTP:userRequireData.OTPCode andTransactionId:userRequireData.transactionID andDeviceId:deviceID andSign:sign andCallback:^(NSDictionary<NSString *,id> *recoveryCallback) {
        int code = [[recoveryCallback objectForKey:@"code"] intValue];
        RequestForgotResponse *forgotResponse = [[RequestForgotResponse alloc] init];
        if(code == 200){
            forgotResponse.status = @"success";
            forgotResponse.message = [[SdkLanguage sharedInstance] translate:@"t_account_035"];
        } else {
            forgotResponse.status = @"failed";
            NSString *remoteMsg = [recoveryCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]) {
                remoteMsg = @"";
            }
            forgotResponse.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.RecoveryPasswordSubmit andErrCode:code andRemoteMessage:remoteMsg];
        }
        if(forgotResponseCallback){
            forgotResponseCallback(forgotResponse);
        } else {
            GDLog(@"forgotResponse = %@", forgotResponse);
        }
    }];
}
- (void) requestBindAccount:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andBindResponseCallback:(void (^)(BindAccountResponse *))bindResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    NSString *md5Password = [MD5 md5:userRequireData.password];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, _sdkConfig.accesstoken, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    
    [[self serverApi] linkAccount:_sdkConfig.username andNewAccount:userRequireData.username andPassword:md5Password andEmail:userRequireData.email andAccessToken:_sdkConfig.accesstoken andDeviceId:deviceID andGameId:_sdkConfig.gameId andSign:sign andCallback:^(NSDictionary<NSString *,id> *linkAccountCallback) {
        int code = [[linkAccountCallback objectForKey:@"code"] intValue];
        NSString *message = @"";
        BindAccountResponse *bindAccount = [[BindAccountResponse alloc] init];
        if(code == 200) {
            bindAccount.status = @"success-active";
            bindAccount.transactionID = [linkAccountCallback objectForKey:@"transactionId"];
            message = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"t_alert_005"], userRequireData.email];

            /*
            message = [[SdkLanguage sharedInstance] translate:@"t_account_043"];
            if([linkAccountCallback objectForKey:@"accessToken"])
            {
                [[SdkConfig sharedInstance] updateUserName:newAccount];
                [[SdkConfig sharedInstance] updateAccessToken:[linkAccountCallback objectForKey:@"accessToken"]];
            }
             */
        } else {
            @try {
                [self sdkLog:_sdkConfig.clientID andActiveKey:@G_LINKACCOUNT_SV_ERROR andData:linkAccountCallback andUsername:_sdkConfig.username];
            } @catch (NSException *exception) {
                
            }
            bindAccount.status = @"failed";
            NSString *remoteMsg = [linkAccountCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]) {
                remoteMsg = @"";
            }
            message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.LinkAccount andErrCode:code andRemoteMessage:remoteMsg];
        }
        bindAccount.message = message;
        bindResponseCallback(bindAccount);
    }];
}
- (void) IAPInitData:(NSDictionary *)iapDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse
{
    
}
- (void) IAPInitRequest:(IAPDataRequest *) iapDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    GDLog(@"thanh toan");
    NSString *clientId = _sdkConfig.clientID;
    NSString *partnerId = _sdkConfig.partnerID;
    NSString *username = _sdkConfig.username;
    NSString *customerId = _sdkConfig.userID;
    NSString *nationalId = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString *roleId = iapDataRequest.getCharacter;
    NSString *gameId = _sdkConfig.gameId;
    NSString *serverId = iapDataRequest.serverID;
    NSString *currencyUnit = _sdkConfig.currency;
    NSString *packageName = [[NSBundle mainBundle] bundleIdentifier];
    NSString *productId = iapDataRequest.appleProductId;
    NSString *productName = iapDataRequest.appleProductId;
    NSString *amount = iapDataRequest.amount;
    NSString *extraInfo = iapDataRequest.extraInfo;
    NSString *channelID = iapDataRequest.channelID;
    NSString *orderId = iapDataRequest.getOrderId;
    NSString *accessToken = [SdkConfig sharedInstance].accesstoken;
    NSString *secrectKet = [SdkConfig sharedInstance].secrectKey;
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                      amount, productId, gameId, roleId, username, secrectKet];
    GDLog(@"sign = %@",sign);
    sign = [MD5 md5:sign];
    
    [[self serverApi] iapInitWithClientId:clientId andPartnerId:partnerId andUsername:username andCustomerId:customerId andNationalId:nationalId andRoleId:roleId andGameId:gameId andServerId:serverId andCurrencyUnit:currencyUnit andChannelID:channelID andPackageName:packageName andProductId:productId andProductName:productName andAmount:amount andExtraInfo:extraInfo andSignature:sign andDeviceId:deviceID andAccessToken:accessToken  andOrderId:orderId andCallback:^(NSDictionary<NSString *,id> *iapCallback) {
        GDLog(@"iapCallback = %@", iapCallback);
        IAPDataResponse *iapData = [[IAPDataResponse alloc] init];
        int code = -99;
        @try {
            code = [[iapCallback objectForKey:@"code"] intValue];
            iapData.code = code;
            if(code != 200) {
                NSException *exception = [NSException exceptionWithName:@"Error" reason:@"Error" userInfo:nil];
                [exception raise];
            }
            iapData.status = @"success";
            iapData.orderID = [iapCallback objectForKey:@"orderId"];
            iapData.transactionData = [iapCallback objectForKey:@"data"];
        } @catch (NSException *exception) {
            iapData.status = @"failed";
            NSString *remoteMsg = [iapCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]) {
                remoteMsg = @"";
            }
            iapData.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.IAPInit andErrCode:code andRemoteMessage:remoteMsg];
            @try {
                [self sdkLog:clientId andActiveKey:@G_IAP_INIT_ERROR andData:@{
                    @"request": @{
                        @"clientId": clientId,
                        @"partnerId": partnerId,
                        @"username": username,
                        @"customerId": customerId,
                        @"nationalId": nationalId,
                        @"roleId": roleId,
                        @"gameId": gameId,
                        @"serverId": serverId,
                        @"currencyUnit": currencyUnit,
                        @"productId": productId,
                        @"productName": productName,
                        @"amount": amount,
                        @"extraInfo": extraInfo,
                        @"channelID": channelID,
                        @"orderId": orderId,
                        @"accessToken": accessToken,
                        @"sign": sign
                    },
                    @"response": iapCallback,
                    @"exception": exception ? exception.description: @"",
                    @"platform": @"ios"
                } andUsername:username];
            } @catch (NSException *exception) {
                
            }
        }
        iapDataResponse(iapData);
    }];
}
- (void) IAPVerifyTransaction:(NSDictionary *)iapVerifyDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse
{
    GDLog(@"iapVerifyDataRequest = %@", iapVerifyDataRequest);
}
- (void) IAPVerifyTransaction:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString * signature = [NSString stringWithFormat:@"%@%@%@%@", userRequireData.username,  _sdkConfig.clientID, userRequireData.orderID, _sdkConfig.secrectKey];
    signature = [MD5 md5:signature];
    [[self serverApi] finalizeIAPWithClientId: _sdkConfig.clientID andUsername:userRequireData.username andOrderId:userRequireData.orderID  andTransactionID:userRequireData.transactionID andOrderToken:userRequireData.OrderToken andServiceEmail:userRequireData.ServiceEmail andExtraInfo:userRequireData.ExtraInfo andResultCode:userRequireData.ResultCode andErrorMessage:userRequireData.ErrorMessage andSignature:signature andAccessToken:userRequireData.AccessToken andDeviceId:deviceID andCallback:^(NSDictionary<NSString *,id> *response) {
        int code = [[response objectForKey:@"code"] intValue];
        IAPDataResponse *iapData = [[IAPDataResponse alloc] init];
        iapData.code = code;
        if(code == 200){
            //==== SDK callback success for game ===//
            iapData.status = @"success";
            iapData.message =[[SdkLanguage sharedInstance] translate:@"t_iap_008"];
        } else {
            iapData.status = @"failed";
            NSString *remoteMsg = [response objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]) {
                remoteMsg = @"";
            }
            iapData.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.FinalizeIAP andErrCode:code andRemoteMessage:remoteMsg];
        }
        if(userRequireData.callback){
            userRequireData.callback(iapData);
        } else {
            GDLog(@"iapData response = %@", iapData);
        }
    }];
}

-(void) resendOTP:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andCallbackResult:(void(^)(ResendOtpResponse *))resendOtpCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *clientID =  _sdkConfig.clientID;
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", clientID, userRequireData.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    
    [[self serverApi] resendOTP:userRequireData.username andTransactionId:userRequireData.transactionID andClientId:clientID andGameId:_sdkConfig.gameId andDeviceId:deviceID andContentFlag:[NSString stringWithFormat:@"%u", [userRequireData getActionTypeNumber]] andFirebaseFCMToken:_sdkConfig.firebaseFCMToken andSign:sign andOTPNetwork:userRequireData.OTPNetwork andCallback:^(NSDictionary<NSString *,id> *response) {
        ResendOtpResponse *otpResponse = [[ResendOtpResponse alloc] init];
        int code = [[response objectForKey:@"code"] intValue];
        if(code == 200){
            //==== SDK callback success for game ===//
            otpResponse.status = @"success";
            otpResponse.phoneNumber = [response objectForKey:@"phoneNumber"];
            otpResponse.email = [response objectForKey:@"email"];
            NSString *msg1 = [userRequireData.OTPNetwork isEqual:@"phone"]?@" phone ":@" email ";
            NSString *msg2 = [userRequireData.OTPNetwork isEqual:@"phone"]?otpResponse.phoneNumber:otpResponse.email;
            otpResponse.message =[NSString stringWithFormat:@"%@%@%@", [[SdkLanguage sharedInstance] translate:@"t_account_052"], msg1, msg2];
        } else {
            otpResponse.status = @"failed";
            NSString *remoteMsg = [response objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]) {
                remoteMsg = @"";
            }
            otpResponse.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.ResendOTP andErrCode:code andRemoteMessage:remoteMsg];
        }
        if(resendOtpCallback){
            resendOtpCallback(otpResponse);
        } else {
            GDLog(@"resendOTP response = %@", otpResponse);
        }
    }];
}

- (void)checkGameStatus:(SdkConfig *)_sdkConfig andGameStatusCallback:(void(^)(GameStatusResponse *))gameStatusCallback
{
    GameStatusResponse *gameStatus = [[GameStatusResponse alloc] init];
    gameStatus.status = @"open";
    gameStatusCallback(gameStatus);
}

- (void) requestLogout:(SdkConfig *)_sdkConfig andLogoutResponseCallback:(void (^)(RequestLogoutResponse *))logoutResponseCallback
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, _sdkConfig.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    
    [[self serverApi] logOut:_sdkConfig.accesstoken andDeviceID:deviceID andUserName:_sdkConfig.username andSignature:sign andCallback:^(NSDictionary<NSString *,id> *logoutCallback) {
        NSString *code = [logoutCallback objectForKey:@"code"];
        
        GDLog(@"logoutCallback = %@",logoutCallback);
        RequestLogoutResponse *logoutResponse = [[RequestLogoutResponse alloc] init];
        if (![code isEqualToString:@"200"]) {
            logoutResponse.status = @"failed";
            NSString *remoteMsg = [logoutCallback objectForKey:@"message"];
            if(!remoteMsg || [remoteMsg isEqual:[NSNull null]]){
                remoteMsg = @"";
            }
            logoutResponse.message = [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.Logout andErrCode:[code intValue] andRemoteMessage:remoteMsg];
        } else {
            logoutResponse.status = @"success";
            logoutResponse.message = @"";
            [_sdkConfig setAccesstoken:@""];
        }
        logoutResponseCallback(logoutResponse);
    }];
}

- (void) idAppTrackingOpen:(NSString *)serverID roleID:(NSString *)roleID roleName:(NSString *)roleName andLogOpenUrl:(NSString *)logOpenUrl andDevideModel:(NSString *)deviceModel
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSString *clientID =  _sdkConfig.clientID;
    NSString *sdkVersion = @"";
    NSString *gameId = _sdkConfig.gameId;
    NSString *gameVersion = @"";
    NSString *appToken = [_sdkConfig firebaseFCMToken];
    NSString *platform = [NSString stringWithFormat:@"%@-%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] model]];
    NSString *platformVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceBrand = [[UIDevice currentDevice] model];
//    NSString *deviceModel = [self deviceModel];
    NSString *macAddress = @"";
    NSString *extraInfo = @"";
    NSString *idfa = [_sdkConfig getAdId];
    NSString *nationalId = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    [[self serverApi] writeOpenGameLogWithUsername:[SdkConfig sharedInstance].username andCustomerId:[SdkConfig sharedInstance].userID andClientId:clientID andSdkVersion:sdkVersion andDeviceId:deviceID andGameId:gameId andGameVersion:gameVersion andFirebaseFCMToken:appToken andPlatform:platform andPlatformVersion:platformVersion andDeviceBrand:deviceBrand andDeviceModel:deviceModel andMacAddress:macAddress andServerID:serverID andRoleId:roleID andNationalId:nationalId andExtraInfo:extraInfo andIDFA:idfa andCallback:^(NSDictionary<NSString *,NSString *> *callback) {
        
        int code = [[callback objectForKey:@"code"] intValue];
        NSString *remoteMsg = [callback objectForKey:@"message"];
        if(remoteMsg == nil || [remoteMsg isEqual:[NSNull null]]) {
            remoteMsg = @"";
        }
        if(code != 200) {
            GDLog(@"Error idAppTrackingOpen: %@",
                  [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.OpenGameLog
                                                                      andErrCode:code
                                                                andRemoteMessage:remoteMsg]);
        }
    }];
}

- (void) idAppTrackingOpen
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSString *clientID =  _sdkConfig.clientID;
    NSString *sdkVersion = @"";
    NSString *gameId = _sdkConfig.gameId;
    NSString *gameVersion = @"";
    NSString *appToken = [_sdkConfig firebaseFCMToken];
    NSString *platform = [NSString stringWithFormat:@"%@-%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] model]];
    NSString *platformVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceBrand = [[UIDevice currentDevice] model];
    NSString *deviceModel = [self deviceModel];
    NSString *macAddress = @"";
    NSString *extraInfo = @"";
    NSString *idfa = [_sdkConfig getAdId];
    NSString *nationalId = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    [[self serverApi] writeOpenGameLogWithUsername:[SdkConfig sharedInstance].username andCustomerId:[SdkConfig sharedInstance].userID andClientId:clientID andSdkVersion:sdkVersion andDeviceId:deviceID andGameId:gameId andGameVersion:gameVersion andFirebaseFCMToken:appToken andPlatform:platform andPlatformVersion:platformVersion andDeviceBrand:deviceBrand andDeviceModel:deviceModel andMacAddress:macAddress andServerID:@"" andRoleId:@"" andNationalId:nationalId andExtraInfo:extraInfo andIDFA:idfa andCallback:^(NSDictionary<NSString *,NSString *> *callback) {
        
        int code = [[callback objectForKey:@"code"] intValue];
        NSString *remoteMsg = [callback objectForKey:@"message"];
        if(remoteMsg == nil || [remoteMsg isEqual:[NSNull null]]) {
            remoteMsg = @"";
        }
        if(code != 200) {
            GDLog(@"Error idAppTrackingOpen: %@",
                  [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.OpenGameLog
                                                                      andErrCode:code
                                                                andRemoteMessage:remoteMsg]);
        }
    }];
}
- (void) idAppTrackingInstall:(SdkConfig *)_sdkConfig andAppVersion:(NSString *)appVersion
{
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    deviceID = [deviceID lowercaseString];
    NSString *clientID =  _sdkConfig.clientID;
    NSString *clientName = @"";
    NSString *sdkVersion = appVersion;
    NSString *gameId = _sdkConfig.gameId;
    NSString *gameVersion = appVersion;
    NSString *appToken = _sdkConfig.firebaseFCMToken;
    NSString *platform = [NSString stringWithFormat:@"%@-%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] model]];
    platform = @"ios";
    NSString *platformVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceBrand = [[UIDevice currentDevice] model];
    NSString *deviceModel = [self deviceModel];
    NSString *macAddress = @"";
    NSString *extraInfo = @"";
    NSString *idfa = [_sdkConfig getAdId];
    NSString *nationalId = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    [[self serverApi] writeInstallGameLog:clientID andClientName:clientName andSdkVersion:sdkVersion andDeviceID:deviceID andGameID:gameId andGameVersion:gameVersion andFirebaseFcmToken:appToken andPlatform:platform andPlatformVersion:platformVersion andDeviceBrand:deviceBrand andDeviceModel:deviceModel andMacAddress:macAddress andNationalId:nationalId andIDFA:idfa andExtraInfo:extraInfo andCallback:^(NSDictionary<NSString *,NSString *> *callback) {
        
        int code = [[callback objectForKey:@"code"] intValue];
        NSString *remoteMsg = [callback objectForKey:@"message"];
        if(remoteMsg == nil || [remoteMsg isEqual:[NSNull null]]) {
            remoteMsg = @"";
        }
        if(code != 200) {
            GDLog(@"Error idAppTrackingInstall: %@",
                  [[ErrManager sharedInstance] getContentErrMessageWithCodeGroup:ErrCodeGroup.InstallGameLog
                                                                      andErrCode:code
                                                                andRemoteMessage:remoteMsg]);
        }
    }];
}
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data
{
    [self sdkLog:clientID andActiveKey:activeKey andData:data andUsername:@""];
}
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data andUsername:(NSString *)username
{
    [[self serverApi] sdkLog:clientID andActiveKey:activeKey andData:data andUsername:username];
}
- (NSString *) deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void) deleteAccount:(UserRequireData *)userRequireData andCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback
{
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", _sdkConfig.clientID, userRequireData.username, _sdkConfig.secrectKey];
    sign = [MD5 md5:sign];
    [[self serverApi] deleteAccount:_sdkConfig.clientID andUsername:userRequireData.username andSignature:sign andAccessToken:_sdkConfig.accesstoken andCallback:deleteCallback];
}
@end
