//
//  GSApiFramework.m
//  GameSDK
//
//  Created by Nero-Macbook on 12/15/21.
//

#import <Foundation/Foundation.h>
#import "GSApiFramework.h"
#import "GSSDKGrpcServer-umbrella.h"
#import <GRPCClient/GRPCTransport.h>
#import "GlobalVariable.h"
#import "ErrConstant.h"

@interface GSApiFramework ()
{
    
}
@end

static GSApiFramework *sharedInstance;
grpcMobileGatewayService *_service;

@implementation GSApiFramework

#pragma mark Singleton Methods
+ (GSApiFramework *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
        {
            sharedInstance = [[super alloc] init];
        }
    }
    return sharedInstance;
}

- (GSApiFramework *) initWithClient:(NSString *)ClientKey andSdkSignature:(NSString *)SdkSignature andHost:(NSString *) grpcHost
{
    self = [self init];
    if(self){
        _clientKey = ClientKey;
        _sdkSignature = SdkSignature;
        _grpcHost = grpcHost;
    }
    return self;
}

- (grpcMobileGatewayService *)grpcService
{
    if(nil == _service)
    {
        GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
        options.transport = GRPCDefaultTransportImplList.core_insecure;
        _service = [[grpcMobileGatewayService alloc] initWithHost:_grpcHost callOptions:options];
    }
    return _service;
}
- (void) sdkInit:(NSString *)DeviceID andInitCalback:(void (^)(NSDictionary<NSString *, id> *))sdkInitCallback
{
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(SdkInit_Response *response, NSError *error){
        GDLog(@"sdkInit gosu response = %@", response);
        id data = response.initData;
        if(response.returnCode == 200) {
            sdkInitCallback(@{
                @"status": @"success",
                @"data": data
            });
        } else {
            if (response) {
                sdkInitCallback(@{
                    @"code": [NSString stringWithFormat:@"%u", response.returnCode],
                    @"message": response.msgCode,
                    @"status": @"failed"
                });
            } else {
                sdkInitCallback(@{
                    @"code": [NSString stringWithFormat:@"%u", ERR_RESPONSE_DATA],
                    @"message": @"",
                    @"status": @"failed"
                });
            }
        }
        
    } responseDispatchQueue:nil];
    
    // Do any additional setup after loading the view.
    SdkInit_Request *sdkInitData = [SdkInit_Request message];
    sdkInitData.clientId = _clientKey;
    sdkInitData.deviceId = DeviceID;
    sdkInitData.sdkSignature = _sdkSignature;
    GDLog(@"sdkInitData = %@", sdkInitData);
    
    GRPCUnaryProtoCall *call = [[self grpcService] sdkInitWithMessage:sdkInitData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) writeInstallGameLog:(NSString *)clientID andClientName:(NSString *)clientName andSdkVersion:(NSString *)sdkVersion andDeviceID:(NSString *)deviceID andGameID:(NSString *)gameid andGameVersion:(NSString *)gameVersion andFirebaseFcmToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andNationalId:(NSString *)nationalId andIDFA:(NSString *)IDFA andExtraInfo:(NSString *)andExtraInfo andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))installGameCallback
{
    InstallGameLog_Request *installGameLog = [InstallGameLog_Request message];
    installGameLog.clientId = clientID;
    installGameLog.sdkVersion = sdkVersion;
    installGameLog.deviceId = deviceID;
    installGameLog.gameId = gameid;
    installGameLog.gameVersion = gameVersion;
    installGameLog.platform = platform;
    installGameLog.deviceBrand = deviceBrand;
    installGameLog.deviceModel = deviceModel;
    installGameLog.macaddress = macAddress;
    installGameLog.nationalId = nationalId;
    installGameLog.adsid = IDFA;
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        GDLog(@"installGameLog response = %@", response);
        if(installGameCallback) {
            if(response) {
                installGameCallback(@{
                    @"code": [NSString stringWithFormat:@"%u", response.returnCode],
                    @"message": response.msgCode
                });
            } else {
                installGameCallback(@{
                    @"status": @"failed",
                    @"code": [NSString stringWithFormat:@"%u", ERR_RESPONSE_DATA],
                    @"message": @""
                });
            }
        }
        
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] installGameLogWithMessage:installGameLog responseHandler:handler callOptions:nil];
    [call start];
}
- (void) writeOpenGameLogWithUsername:(NSString *)username andCustomerId:(NSString *)customerId andClientId:(NSString *)clientId andSdkVersion:(NSString *)sdkVersion andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andGameVersion:(NSString *)gameVersion andFirebaseFCMToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andServerID:(NSString *)serverId andRoleId:(NSString *)roleId andNationalId:(NSString *)nationalId andExtraInfo:(NSString *)ExtraInfo andIDFA:(NSString *)IDFA andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))openGameCallback
{
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        GDLog(@"writeOpenGameLogWithUsername response = %@", response);
        if(openGameCallback){
            if(response) {
                openGameCallback(@{
                    @"code": [NSString stringWithFormat:@"%u", response.returnCode],
                    @"message": response.msgCode
                });
            } else {
                openGameCallback(@{
                    @"status": @"failed",
                    @"code": [NSString stringWithFormat:@"%u", ERR_RESPONSE_DATA],
                    @"message": @""
                });
            }
        }
        
    } responseDispatchQueue:nil];
    OpenGameLog_Request *openGameLogData = [OpenGameLog_Request message];
    openGameLogData.userName = username;
    openGameLogData.clientId = clientId;
    openGameLogData.sdkVersion = sdkVersion;
    openGameLogData.deviceId = deviceId;
    openGameLogData.gameId = gameId;
    openGameLogData.gameVersion = gameVersion;
    openGameLogData.appToken = fcmToken;
    openGameLogData.platform = platform;
    openGameLogData.platformVersion = platformVersion;
    openGameLogData.deviceBrand = deviceBrand;
    openGameLogData.deviceModel = deviceModel;
    openGameLogData.macaddress = macAddress;
    openGameLogData.extraInfo = ExtraInfo;
    openGameLogData.serverId = serverId;
    openGameLogData.characterId = roleId;
    openGameLogData.nationalId = nationalId;
    openGameLogData.customerId = customerId;
    openGameLogData.adsid = IDFA;
    
    GDLog(@"openGameLogData = %@", openGameLogData);
    
    GRPCUnaryProtoCall *call = [[self grpcService] openGameLogWithMessage:openGameLogData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) openGameLogWithUsername:(NSString *)username andClientId:(NSString *)clientId andSdkVersion:(NSString *)sdkVersion andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andGameVersion:(NSString *)gameVersion andFirebaseFCMToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andExtraInfo:(NSString *)ExtraInfo andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))installGameCallback {
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        GDLog(@"gamelog response = %@", response);
        if(response) {
            installGameCallback(@{
                @"code": [NSString stringWithFormat:@"%u", response.returnCode]
            });
        } else {
            installGameCallback(@{
                @"status": @"failed",
                @"code": [NSString stringWithFormat:@"%u", ERR_RESPONSE_DATA],
                @"message": @""
            });
        }
    } responseDispatchQueue:nil];
    OpenGameLog_Request *openGameLogData = [OpenGameLog_Request message];
    openGameLogData.clientId = clientId;
    openGameLogData.userName = username;
    openGameLogData.sdkVersion = sdkVersion;
    openGameLogData.deviceId = deviceId;
    openGameLogData.gameId = gameId;
    openGameLogData.gameVersion = gameVersion;
    openGameLogData.appToken = fcmToken;
    openGameLogData.platform = platform;
    openGameLogData.platformVersion = platformVersion;
    openGameLogData.deviceBrand = deviceBrand;
    openGameLogData.deviceModel = deviceModel;
    openGameLogData.macaddress = macAddress;
    openGameLogData.extraInfo = ExtraInfo;
    GRPCUnaryProtoCall *call = [[self grpcService] openGameLogWithMessage:openGameLogData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) loginById:(NSString *)username andPassword:(NSString *)password andClientId:(NSString *)clientId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSdkSignature:(NSString *)sdkSignature andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *)) loginCallback
{
    NSString *deviceBrand = [[UIDevice currentDevice] model];
    Login_Request *loginData = [Login_Request message];
    loginData.userName = username;
    loginData.password = password;
    loginData.clientId = clientId;
    loginData.deviceBrand = deviceBrand;
    loginData.deviceId = deviceId;
    loginData.gameId = gameId;
    loginData.sdkSignature = sdkSignature;
    loginData.securityCode = securityCode;
    loginData.signature = sign;
    
    GDLog(@"loginData = %@", loginData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Login_Response *response, NSError *error) {
        if(response) {
            loginCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"accessToken": response.accessToken,
                @"message": response.msgCode,
            });
        } else {
            loginCallback(@{
                @"status": @"failed",
                @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                @"message": @"",
            });
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] loginWithMessage:loginData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) registerAcountWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"" andIdToken:@"" andAccountType:@"register" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithPlaynow:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"" andIdToken:@"" andAccountType:@"playnow" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithFacebook:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andIdToken:(NSString *)idToken andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"facebook" andIdToken:idToken andAccountType:@"openid" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithGoogle:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"google" andIdToken:@"" andAccountType:@"openid" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId  andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithApple:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andIdToken:(NSString *)idToken andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"apple" andIdToken:idToken andAccountType:@"openid" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId  andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAccountWithPartner:(NSString *)partner andIdToken:(NSString *)idToken andAccountType:(NSString *)accountType andUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    NSString *deviceBrand = [[UIDevice currentDevice] model];
    Register_Request *registerData = [Register_Request message];
    registerData.openIdpartner = partner; //facebook, google, apple
    registerData.userName = username;
    registerData.password = password;
    registerData.email = email;
    registerData.clientId = _clientKey;
    registerData.deviceBrand = deviceBrand;
    registerData.deviceId = deviceId;
    registerData.gameId = gameId;
    registerData.appToken = fcmToken;
    registerData.sdkSignature = _sdkSignature;
    registerData.accountType = accountType; //register, playnow, openid
    registerData.securityCode = securityCode;
    registerData.signature = sign;
    registerData.openIdtoken = idToken;
    
    GDLog(@"=== register ===");
    GDLog(@"gosu:registerData:request = %@", registerData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Register_Response *response, NSError *error) {
        GDLog(@"gosu:registerData:response = %@", response);
        if(registerCallback){
            if (response) {
                registerCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"transactionId": response.transactionId,
                    @"accessToken": response.accessToken,
                    @"message": response.msgCode
                });
            } else {
                registerCallback(@{
                    @"status": @"failed",
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"message": @""
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] registerWithMessage:registerData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) requestActiveByUsername:(NSString *)username andContentFlag:(NSString *)contentFlag andAppToken:(NSString *)apptoken andChangeBy:(int)changeBy andEmail:(NSString *)email andPhoneNumber:(NSString *)phoneNumber andSignature:(NSString *)signature andCallback:(void (^)(NSDictionary<NSString *, id> *)) requestActiveCallback
{
    RequestActive_Request *requestActive = [RequestActive_Request message];
    requestActive.userName = username;
    requestActive.clientId = _clientKey;
    requestActive.contentFlag = contentFlag;
    requestActive.appToken = apptoken;
    requestActive.changeBy = changeBy;
    requestActive.email = email;
    requestActive.phoneNumber = phoneNumber;
    requestActive.signature = signature;
    
    GDLog(@"requestActive = %@", requestActive);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(RequestActive_Response *response, NSError *error) {
        GDLog(@"RequestActive_Response = %@", response);
        if(requestActiveCallback) {
            if(response) {
                requestActiveCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"contentFlag": response.contentFlag,
                    @"email": response.email,
                    @"phoneNumber": response.phoneNumber,
                    @"transactionId": response.transactionId,
                    @"message": response.msgCode
                });
            } else {
                requestActiveCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @""
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] requestActiveWithMessage:requestActive responseHandler:handler callOptions:nil];
    [call start];
}

- (void) activeAccountUsername:(NSString *)username andActiveCode:(NSString *)activeCode andTransactionId:(NSString *)transactionId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerActivationCallback
{
    NSString *deviceBrand = [[UIDevice currentDevice] model];
    ActiveAccount_Request *activeData = [ActiveAccount_Request message];
    activeData.userName = username;
    activeData.clientId = _clientKey;
    activeData.deviceBrand = deviceBrand;
    activeData.deviceId = deviceId;
    activeData.gameId = gameId;
    activeData.activeCode = activeCode;
    activeData.transactionId = transactionId;
    activeData.signature = sign;
    
    GDLog(@"activeData = %@", activeData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(ActiveAccount_Response *response, NSError *error) {
        GDLog(@"register activation = %@", response);
        if(registerActivationCallback){
            if(response) {
                registerActivationCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"accessToken": response.accessToken,
                    @"message": response.msgCode
                });
            } else {
                registerActivationCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @""
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] activeAccountWithMessage:activeData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) getProfile:(NSString *)username andAccessToken:(NSString *)accessToken andDeviceID:(NSString *)deviceId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))userProfileCallback
{
    GetProfile_Request *profileRequireData = [GetProfile_Request message];
    profileRequireData.userName = username;
    profileRequireData.accessToken = accessToken;
    profileRequireData.clientId = _clientKey;
    profileRequireData.deviceId = deviceId;
    profileRequireData.signature = sign;
    
    GDLog(@"SDK:profile:request = %@ ", profileRequireData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(GetProfile_Response *response, NSError *error) {
        GDLog(@"SDK:profile:response = %@", response);
        if(userProfileCallback) {
            if (response) {
                userProfileCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"status": [NSString stringWithFormat:@"%d", response.status],
                    @"phoneStatus": [NSString stringWithFormat:@"%d", response.phoneStatus],
                    @"customerID": response.customerId,
                    @"username": response.userName,
                    @"email": response.email,
                    @"platform": @"ios",
                    @"message": response.msgCode
                });
            } else {
                userProfileCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @"",
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] getProfileWithMessage:profileRequireData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) loginByAccessToken:(NSString *)accessToken andUsername:(NSString *)username andDeviceID:(NSString *)deviceID andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))loginCallback
{
    LoginByAccessToken_Request *loginData = [LoginByAccessToken_Request message];
    loginData.accessToken = accessToken;
    loginData.userName = username;
    loginData.deviceId = deviceID;
    loginData.signature = sign;
    loginData.clientId = _clientKey;
    
    GDLog(@"SDK:token:request = %@", loginData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(LoginByAccessToken_Response *response, NSError *error) {
        GDLog(@"SDK:token:response = %@", response);
        if(loginCallback) {
            if (response) {
                loginCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"refreshToken": response.refreshAccessToken,
                    @"platform": @"ios",
                    @"message": response.msgCode
                });
            } else {
                loginCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @"",
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] loginByAccessTokenWithMessage:loginData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) resendOTP:(NSString *)username andTransactionId:(NSString *)transactionId andClientId:(NSString *)clientId andGameId:(NSString *)gameId andDeviceId:(NSString *)deviceId andContentFlag:(NSString *) contentFlag andFirebaseFCMToken:(NSString *)fcmToken andSign:(NSString *)sign andOTPNetwork:(NSString *)otpNetwork andCallback:(void (^)(NSDictionary<NSString *, id> *))resendCallback
{
    ResendOTP_Request *resendOTPData = [ResendOTP_Request message];
    resendOTPData.userName = username;
    resendOTPData.transactionId = transactionId;
    resendOTPData.gameId = gameId;
    resendOTPData.deviceId = deviceId;
    resendOTPData.contentFlag = contentFlag;
    resendOTPData.clientId = _clientKey;
    resendOTPData.signature = sign;
    resendOTPData.clientId = clientId;
    resendOTPData.appToken = fcmToken;
    resendOTPData.changeBy = [otpNetwork isEqual:@"phone"] ? 2 : 1;
    
    GDLog(@"resendOTPData = %@", resendOTPData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(ResendOTP_Response *response, NSError *error) {
        GDLog(@"resendOTP1 response = %@", response);
        if(resendCallback) {
            if(response) {
                resendCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"contentFlag": response.contentFlag,
                    @"email": response.email,
                    @"phoneNumber": response.phoneNumber,
                    @"message": response.msgCode,
                });
            } else {
                resendCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @"",
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] resendOTPWithMessage:resendOTPData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) logOut:(NSString *)accessToken andDeviceID:deviceID andUserName:userName andSignature:signature andCallback:(void (^)(NSDictionary<NSString *, id> *))logoutCallback
{
    Logout_Request *logoutData = [Logout_Request message];
    logoutData.accessToken = accessToken;
    logoutData.clientId = _clientKey;
    logoutData.userName = userName;
    logoutData.deviceId = deviceID;
    logoutData.signature = signature;
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        GDLog(@"resendOTP response = %@", response);
        if(logoutCallback) {
            if(response) {
                logoutCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode]
                });
            } else {
                logoutCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @"",
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] logoutWithMessage:logoutData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) recoveryPasswordRequest:(NSString *)username andClientId:(NSString *)clientId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSdkSignature:(NSString *)sdkSignature andNewPassword:(NSString *)newPassword andFirebaseFCMToken:(NSString *)fcmToken andOTPNetwork:(NSString *)otpNetwork andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))recoveryCallback
{
    RecoveryPasswordRequest_Request *recoveryData = [RecoveryPasswordRequest_Request message];
    recoveryData.userName = username;
    recoveryData.clientId = _clientKey;
    recoveryData.deviceId = deviceId;
    recoveryData.gameId = gameId;
    recoveryData.apkSignature = sdkSignature;
    recoveryData.newPassword = newPassword;
    recoveryData.appToken = fcmToken;
    recoveryData.changeBy = [otpNetwork isEqual:@"phone"] ? 2 : 1;
    recoveryData.signature = sign;
    
    GDLog(@"recoveryData = %@", recoveryData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(RecoveryPasswordRequest_Response *response, NSError *error) {
        GDLog(@"recoveryPasswordRequest response = %@", response);
        if(recoveryCallback) {
            if(response) {
                recoveryCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"transactionId": response.transactionId,
                    @"message": response.msgCode,
                    @"email": response.email,
                    @"phone": response.phoneNumber,
                    @"otpNetwork": otpNetwork
                });
            } else {
                recoveryCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @""
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] recoveryPasswordRequestWithMessage:recoveryData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) recoveryPasswordSubmit:(NSString *)username andOTP:(NSString *)OTP andTransactionId:(NSString *)transactionId andDeviceId:(NSString *)deviceId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))recoveryCallback
{
    RecoveryPasswordSubmit_Request *recoveryData = [RecoveryPasswordSubmit_Request message];
    recoveryData.userName = username;
    recoveryData.otp = OTP;
    recoveryData.transactionId = transactionId;
    recoveryData.clientId = _clientKey;
    recoveryData.deviceId = deviceId;
    recoveryData.signature = sign;
    
    GDLog(@"recoveryData = %@", recoveryData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        GDLog(@"recoveryPasswordSubmit response = %@", response);
        if(recoveryCallback) {
            if (response) {
                recoveryCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"message": response.msgCode
                });
            } else {
                recoveryCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @""
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] recoveryPasswordSubmitWithMessage:recoveryData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) linkAccount:(NSString *)account andNewAccount:(NSString *)newAccount andPassword:(NSString *)password andEmail:(NSString *)email andAccessToken:(NSString *)accessToken andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))linkAccountCallback
{
    LinkAccount_Request *linkData = [LinkAccount_Request message];
    linkData.deviceId = deviceId;
    linkData.gameId = gameId;
    linkData.oldAccount = account;
    linkData.newAccount = newAccount;
    linkData.password = password;
    linkData.email = email;
    linkData.accessToken = accessToken;
    linkData.signature = sign;
    linkData.clientId = _clientKey;
    
    GDLog(@"linkAccount = %@", linkData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(LinkAccount_Response *response, NSError *error) {
        GDLog(@"linkAccount response = %@", response);
        if(linkAccountCallback) {
            if(response) {
                linkAccountCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"transactionId": response.transactionId,
                    @"message": response.msgCode,
                    @"accessToken": accessToken,
                    @"platform": @"ios"
                });
            } else {
                linkAccountCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"status": @"failed",
                    @"message": @""
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] linkAccountWithMessage:linkData responseHandler:handler callOptions:nil];
    [call start];
}
- (void)checkAccessToken:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))checkerCallback
{
    if(checkerCallback){
        checkerCallback(@{
            @"code": @200
        });
    }
}
- (void) iapInitWithClientId:(NSString *)clientId andPartnerId:(NSString *)partnerId andUsername:(NSString *)username andCustomerId:(NSString *)customerId andNationalId:(NSString *)nationalId andRoleId:(NSString *)roleId andGameId:(NSString *)gameId andServerId:(NSString *)serverId andCurrencyUnit:(NSString *)currencyUnit andChannelID:(NSString *)channelID andPackageName:(NSString *)packageName andProductId:(NSString *)productId andProductName:(NSString *)productName andAmount:(NSString *) amount andExtraInfo:(NSString *)extraInfo andSignature:(NSString *)signature andDeviceId:(NSString *)deviceId andAccessToken:(NSString *)accessToken andOrderId:(NSString *)orderId andCallback:(void (^)(NSDictionary<NSString *, id> *))iapCallback
{
    IAPInit_Request *iapData = [IAPInit_Request message];
    iapData.clientId = clientId;
    iapData.partnerId = partnerId;
    iapData.userName = username;
    iapData.customerId = customerId;
    iapData.nationalId = nationalId;
    iapData.characterId = roleId;
    iapData.gameId = gameId;
    iapData.serverId = serverId;
    iapData.currencyUnit = currencyUnit;
    iapData.channelId = channelID; //google, apple, huawei, wallet
    iapData.packageName = packageName;
    iapData.productId = productId;
    iapData.productName = productName;
    iapData.amount = amount;
    iapData.platform = @"ios";
    iapData.extraInfo = extraInfo;
    iapData.signature = signature;
    iapData.accessToken = accessToken;
    iapData.deviceId = deviceId;
    iapData.channelId = channelID;
    iapData.orderId = orderId;
    
    GDLog(@"==== INIT IAP ====");
    GDLog(@"iapData = %@", iapData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(IAPInit_Response *response, NSError *error) {
        GDLog(@"iapData response = %@", response);
        @try {
            if(response == NULL) {
                NSException *exception = [NSException exceptionWithName:@"Error" reason:@"Init response is null" userInfo:nil];
                [exception raise];
            }
            NSMutableArray<NSDictionary *> *initDataArray = [[NSMutableArray<NSDictionary *> alloc] init];
            for (grpcIAPInit *item in response.initDataArray) {
                @try {
                    NSDictionary *data = @{
                        @"transactionId": item.transactionId,
                        @"a": @(item.a),
                        @"b": @(item.b),
                        @"h": item.h,
                        @"m": item.m,
                        @"s": @(item.s),
                        @"t": item.t
                    };
                    [initDataArray setObject:data atIndexedSubscript:0];
                } @catch (NSException *exception) {
                    
                }
                
            }
            if(iapCallback){
                if (response) {
                    iapCallback(@{
                        @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                        @"data": initDataArray,
                        @"message": response.msgCode
        //                @"orderId": response.orderId
                    });
                } else {
                    iapCallback(@{
                        @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                        @"status": @"failed",
                        @"message": @""
                    });
                }
            }
        } @catch (NSException *exception) {
            iapCallback(@{
                @"code": @"-1",
                @"data": exception.reason
            });
        }
        
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] iAPInitWithMessage:iapData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) finalizeIAPWithClientId:(NSString *)clientId andUsername:(NSString *)username andOrderId:(NSString *)orderId andTransactionID:(NSString *)transactionID andOrderToken:(NSString *)orderToken andServiceEmail:(NSString *)serviceEmail andExtraInfo:(NSString *)extraInfo andResultCode:(int)resultCode andErrorMessage:(NSString *)errorMessage andSignature:(NSString *)signature andAccessToken:(NSString *)accessToken andDeviceId:(NSString *)deviceId andCallback:(void (^)(NSDictionary<NSString *, id> *))iapCallback
{
    FinalizeIAP_Request *iapData = [FinalizeIAP_Request message];
    iapData.clientId = clientId;
    iapData.userName = username;
    iapData.orderId = orderId;
    iapData.orderToken = orderToken;
    iapData.serviceEmail = serviceEmail;
    iapData.resultCode = resultCode;
    iapData.errorMessage = errorMessage;
    iapData.extraInfo = extraInfo;
    iapData.signature = signature;
    iapData.accessToken = accessToken;
    iapData.transactionId = transactionID;
    iapData.deviceId = deviceId;
    
    GDLog(@"iapData = %@", iapData);
    __block int count = 0;
    
    __block dispatch_block_t iap_block;
    __block dispatch_block_t strongIap_block;
    
    strongIap_block = iap_block = ^{
        GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
            GDLog(@"finalizeIAPWithClientId response = %@", response);
            int returnCode = response && response != NULL ? response.returnCode : -9;
            NSString *msgCode = response && response != NULL ? response.msgCode : @"NaN";
            @try {
                if (response == NULL) {
                    if (count < 1) {
                        count++;
                        __weak dispatch_block_t weakIap_block = strongIap_block;
                        if (weakIap_block) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [NSThread sleepForTimeInterval:2];
                                weakIap_block();
                            });
                        }
                    }
                    @throw [NSException exceptionWithName:@"Error IAP verify" reason:[NSString stringWithFormat:@"Response is Empty"] userInfo:nil];
                }
                if(response.returnCode != 200) {
                    @throw [NSException exceptionWithName:@"Error IAP verify" reason:[NSString stringWithFormat:@"error code: %d", response.returnCode] userInfo:nil];
                }
            } @catch (NSException *error) {
                @try {
                    [self sdkLog:clientId andActiveKey:@G_IAP_VERIFY_ERROR andData:@{
                        @"request": @{
                            @"clientId": clientId,
                            @"username": username,
                            @"orderId": orderId,
                            @"orderToken": orderToken,
                            @"serviceEmail": serviceEmail,
                            @"errorMessage": errorMessage,
                            @"signature": signature,
                            @"accessToken": accessToken,
                            @"transactionID": transactionID,
                            @"deviceId": deviceId
                        },
                        @"response": @{
                            @"returnCode": [NSString stringWithFormat:@"%d", returnCode],
                            @"msgCode": msgCode
                        },
                        @"platform": @"ios"
                    } andUsername:username];
                } @catch (NSException *exception) {
                    NSLog(@"nero error =%@", exception.description);
                }
            }
            if(iapCallback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    iapCallback(@{
                        @"code": [NSString stringWithFormat:@"%d", returnCode]
                    });
                });
            }
        } responseDispatchQueue:nil];
        
        GRPCUnaryProtoCall *call = [[self grpcService] finalizeIAPWithMessage:iapData responseHandler:handler callOptions:nil];
        [call start];
    };
    
    dispatch_async(dispatch_get_main_queue(), iap_block);
}

- (void) deleteAccount:(NSString *)clientId andUsername:(NSString *)username andSignature:(NSString *)signature andAccessToken:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback
{
    DeleteAccount_Request *userData = [DeleteAccount_Request message];
    userData.clientId = clientId;
    userData.userName = username;
    userData.accessToken = accessToken;
    userData.signature = signature;
    
    GDLog(@"SDK:deleteAccount:request = %@", userData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        GDLog(@"SDK:deleteAccount:response = %@", response);
        if(deleteCallback) {
            if (response) {
                deleteCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                    @"message": response.msgCode
                });
            } else {
                deleteCallback(@{
                    @"code": [NSString stringWithFormat:@"%d", ERR_RESPONSE_DATA],
                    @"message": @"",
                    @"status": @"failed"
                });
            }
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] deleteAccountWithMessage:userData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data
{
    [self sdkLog:clientID andActiveKey:activeKey andData:data andUsername:@""];
}
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data andUsername:(NSString *)username
{
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *jsonString = @"";
            NSData *jsonData = NULL;
            @try {
                NSError *error;
                jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
                if (error != nil) {
                    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
            } @catch (NSException *e2)
            {
                jsonString = @"";
            }
            
            if(jsonData) {
                @try {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    CatchLogSDK_Request *request = [CatchLogSDK_Request message];
                    request.clientId = clientID;
                    request.activeKey = activeKey;
                    request.userName = username;
                    [request setData_p:jsonString];
                    GDLog(@"NERO:sdkLog:request = %@", request);
                    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
                        GDLog(@"NERO:sdkLog:response = %@", response);
                    } responseDispatchQueue:nil];
                    GRPCUnaryProtoCall *call = [[self grpcService] catchLogSDKWithMessage:request responseHandler:handler callOptions:nil];
                    [call start];
                } @catch (NSException *e) {
                    
                }
                
            } else {
                GDLog(@"NERO:sdkLog:json error = %@", data);
            }
        });
    } @catch (NSException *e) {
        
    }
    
}
@end
