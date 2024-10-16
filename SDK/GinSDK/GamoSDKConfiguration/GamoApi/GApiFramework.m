//
//  SDKGrpcApi.m
//  GameSDK
//
//  Created by Nero-Macbook on 12/15/21.
//

#import <Foundation/Foundation.h>
#import "GApiFramework.h"
#import "GameSDKGrpcServer-umbrella.h"
#import <GRPCClient/GRPCTransport.h>

@interface GApiFramework ()
{
    
}
@end

static GApiFramework *sharedInstance;
grpcMobileGatewayService *_service;

@implementation GApiFramework

#pragma mark Singleton Methods
+ (GApiFramework *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
        {
            sharedInstance = [[super alloc] init];
        }
    }
    return sharedInstance;
}

- (GApiFramework *) initWithClient:(NSString *)ClientKey andSdkSignature:(NSString *)SdkSignature andHost:(NSString *) grpcHost
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
        NSLog(@"sdkInit response = %@", response);
        if(response.returnCode == 200)
        {
            sdkInitCallback(@{
                @"status": @"success",
                @"data": response.initData
            });
        } else {
            sdkInitCallback(@{
                @"status": @"failed",
                @"code": [NSString stringWithFormat:@"%u", response.returnCode]
            });
        }
        
    } responseDispatchQueue:nil];
    
    // Do any additional setup after loading the view.
    SdkInit_Request *sdkInitData = [SdkInit_Request message];
    sdkInitData.clientId = _clientKey;
    sdkInitData.deviceId = DeviceID;
    sdkInitData.sdkSignature = _sdkSignature;
    NSLog(@"sdkInitData = %@", sdkInitData);
    
    GRPCUnaryProtoCall *call = [[self grpcService] sdkInitWithMessage:sdkInitData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) writeInstallGameLog:(NSString *)clientID andClientName:(NSString *)clientName andSdkVersion:(NSString *)sdkVersion andDeviceID:(NSString *)deviceID andGameID:(NSString *)gameid andGameVersion:(NSString *)gameVersion andFirebaseFcmToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andNationalId:(NSString *)nationalId andExtraInfo:(NSString *)andExtraInfo andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))installGameCallback
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
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        NSLog(@"installGameLog response = %@", response);
        if(installGameCallback){
            installGameCallback(@{
                @"code": [NSString stringWithFormat:@"%u", response.returnCode]
            });
        }
        
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] installGameLogWithMessage:installGameLog responseHandler:handler callOptions:nil];
    [call start];
}
- (void) writeOpenGameLogWithUsername:(NSString *)username andClientId:(NSString *)clientId andSdkVersion:(NSString *)sdkVersion andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andGameVersion:(NSString *)gameVersion andFirebaseFCMToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andServerID:(NSString *)serverId andRoleId:(NSString *)roleId andNationalId:(NSString *)nationalId andExtraInfo:(NSString *)ExtraInfo andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))openGameCallback
{
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        NSLog(@"writeOpenGameLogWithUsername response = %@", response);
        if(openGameCallback){
            openGameCallback(@{
                @"code": [NSString stringWithFormat:@"%u", response.returnCode]
            });
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
    
    GRPCUnaryProtoCall *call = [[self grpcService] openGameLogWithMessage:openGameLogData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) openGameLogWithUsername:(NSString *)username andClientId:(NSString *)clientId andSdkVersion:(NSString *)sdkVersion andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andGameVersion:(NSString *)gameVersion andFirebaseFCMToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andExtraInfo:(NSString *)ExtraInfo andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))installGameCallback {
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        NSLog(@"gamelog response = %@", response);
        installGameCallback(@{
            @"code": [NSString stringWithFormat:@"%u", response.returnCode]
        });
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
    Login_Request *loginData = [Login_Request message];
    loginData.userName = username;
    loginData.password = password;
    loginData.clientId = clientId;
    loginData.deviceId = deviceId;
    loginData.gameId = gameId;
    loginData.sdkSignature = sdkSignature;
    loginData.securityCode = securityCode;
    loginData.signature = sign;
    
    NSLog(@"loginData = %@", loginData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Login_Response *response, NSError *error) {
        if(loginCallback){
            loginCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"accessToken": response.accessToken
            });
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] loginWithMessage:loginData responseHandler:handler callOptions:nil];
    [call start];
}

- (void) registerAcountWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"" andAccountType:@"register" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithPlaynow:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"" andAccountType:@"playnow" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithFacebook:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andIdToken:(NSString *)idToken andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"facebook" andAccountType:@"openid" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithGoogle:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"google" andAccountType:@"openid" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId  andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAcountWithApple:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andIdToken:(NSString *)idToken andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    [self registerAccountWithPartner:@"apple" andAccountType:@"openid" andUsername:username andPassword:password andEmail:email andDeviceId:deviceId andGameId:gameId  andFirebaseFCMToken:fcmToken andSecurityCode:securityCode andSign:sign andCallback:registerCallback];
}
- (void) registerAccountWithPartner:(NSString *)partner andAccountType:(NSString *)accountType andUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback
{
    Register_Request *registerData = [Register_Request message];
    registerData.openIdpartner = partner; //facebook, google, apple
    registerData.userName = username;
    registerData.password = password;
    registerData.email = email;
    registerData.clientId = _clientKey;
    registerData.deviceId = deviceId;
    registerData.gameId = gameId;
    registerData.sdkSignature = _sdkSignature;
    registerData.accountType = accountType; //register, playnow, openid
    registerData.securityCode = securityCode;
    registerData.signature = sign;
    
    NSLog(@"=== register ===");
    NSLog(@"registerData = %@", registerData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Register_Response *response, NSError *error) {
        NSLog(@"dang ky response = %@", response);
        if(registerCallback){
            registerCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"transactionId": response.transactionId,
                @"accessToken": response.accessToken
            });
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
    
    NSLog(@"requestActive = %@", requestActive);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(RequestActive_Response *response, NSError *error) {
        NSLog(@"RequestActive_Response = %@", response);
        if(requestActiveCallback){
            requestActiveCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"contentFlag": response.contentFlag,
                @"email": response.email,
                @"phoneNumber": response.phoneNumber,
                @"transactionId": response.transactionId
            });
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] requestActiveWithMessage:requestActive responseHandler:handler callOptions:nil];
    [call start];
}

- (void) activeAccountUsername:(NSString *)username andActiveCode:(NSString *)activeCode andTransactionId:(NSString *)transactionId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerActivationCallback
{
    ActiveAccount_Request *activeData = [ActiveAccount_Request message];
    activeData.userName = username;
    activeData.deviceId = deviceId;
    activeData.gameId = gameId;
    activeData.activeCode = activeCode;
    activeData.transactionId = transactionId;
    activeData.signature = sign;
    activeData.clientId = _clientKey;
    
    NSLog(@"activeData = %@", activeData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(ActiveAccount_Response *response, NSError *error) {
        NSLog(@"register activation = %@", response);
        if(registerActivationCallback){
            registerActivationCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"accessToken": response.accessToken
            });
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
    
    NSLog(@"profileRequireData = %@ ", profileRequireData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(GetProfile_Response *response, NSError *error) {
        NSLog(@"profile data = %@", response);
        if(userProfileCallback){
            userProfileCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"status": [NSString stringWithFormat:@"%d", response.status],
                @"phoneStatus": [NSString stringWithFormat:@"%d", response.phoneStatus],
                @"customerID": response.customerId,
                @"username": response.userName,
                @"email": response.email
            });
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
    
    NSLog(@"loginData = %@", loginData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(LoginByAccessToken_Response *response, NSError *error) {
        NSLog(@"loginByAccessToken response = %@", response);
        if(loginCallback){
            loginCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"refreshToken": response.refreshAccessToken,
            });
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
    
    NSLog(@"resendOTPData = %@", resendOTPData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(ResendOTP_Response *response, NSError *error) {
        NSLog(@"resendOTP1 response = %@", response);
        if(resendCallback){
            resendCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"contentFlag": response.contentFlag,
                @"email": response.email,
                @"phoneNumber": response.phoneNumber
            });
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] resendOTPWithMessage:resendOTPData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) logOut:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))logoutCallback
{
    Logout_Request *logoutData = [Logout_Request message];
    logoutData.accessToken = accessToken;
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        NSLog(@"resendOTP response = %@", response);
        if(logoutCallback){
            logoutCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode]
            });
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
    
    NSLog(@"recoveryData = %@", recoveryData);
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(RecoveryPasswordRequest_Response *response, NSError *error) {
        NSLog(@"recoveryPasswordRequest response = %@", response);
        if(recoveryCallback){
            recoveryCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"transactionId": response.transactionId,
                @"email": response.email,
                @"phone": response.phoneNumber,
                @"otpNetwork": otpNetwork
            });
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
    
    NSLog(@"recoveryData = %@", recoveryData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        NSLog(@"recoveryPasswordSubmit response = %@", response);
        if(recoveryCallback){
            recoveryCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode]
            });
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
    
    NSLog(@"linkAccount = %@", linkData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(LinkAccount_Response *response, NSError *error) {
        NSLog(@"linkAccount response = %@", response);
        if(linkAccountCallback){
            linkAccountCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"transactionId": response.transactionId,
                @"accessToken": accessToken
            });
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
- (void) iapInitWithClientId:(NSString *)clientId andPartnerId:(NSString *)partnerId andUsername:(NSString *)username andCustomerId:(NSString *)customerId andNationalId:(NSString *)nationalId andRoleId:(NSString *)roleId andGameId:(NSString *)gameId andServerId:(NSString *)serverId andCurrencyUnit:(NSString *)currencyUnit andChannelID:(NSString *)channelID andPackageName:(NSString *)packageName andProductId:(NSString *)productId andProductName:(NSString *)productName andAmount:(NSString *) amount andExtraInfo:(NSString *)extraInfo andSignature:(NSString *)signature andDeviceId:(NSString *)deviceId andAccessToken:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))iapCallback
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
    
    NSLog(@"==== INIT IAP ====");
    NSLog(@"iapData = %@", iapData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(IAPInit_Response *response, NSError *error) {
        NSLog(@"iapData response = %@", response);
        if(iapCallback){
            iapCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode],
                @"orderId": response.orderId,
                @"data": @{}
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
    
    NSLog(@"iapData = %@", iapData);
    
    GRPCUnaryResponseHandler *handler = [[GRPCUnaryResponseHandler alloc] initWithResponseHandler:^(Empty_Response *response, NSError *error) {
        NSLog(@"finalizeIAPWithClientId response = %@", response);
        if(iapCallback){
            iapCallback(@{
                @"code": [NSString stringWithFormat:@"%d", response.returnCode]
            });
        }
    } responseDispatchQueue:nil];
    
    GRPCUnaryProtoCall *call = [[self grpcService] finalizeIAPWithMessage:iapData responseHandler:handler callOptions:nil];
    [call start];
}
- (void) deleteAccount:(NSString *)clientId andUsername:(NSString *)username andSignature:(NSString *)signature andAccessToken:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback
{
    
}
@end
