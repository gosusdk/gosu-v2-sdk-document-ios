//
//  GSApiFramework.h
//  GSApiFramework
//
//  Created by Nero-Macbook on 11/22/22.
//

#import <Foundation/Foundation.h>

@interface GSApiFramework : NSObject
{
    
}
@property (nonatomic, strong) NSString *grpcHost;
@property (nonatomic, strong) NSString *clientKey;
@property (nonatomic, strong) NSString *sdkSignature;

+ (GSApiFramework *) sharedInstance;
- (GSApiFramework *) initWithClient:(NSString *)ClientKey andSdkSignature:(NSString *)SdkSignature andHost:(NSString *) grpcHost;
- (void) sdkInit:(NSString *)DeviceID andInitCalback:(void (^)(NSDictionary<NSString *, id> *))sdkInitCallback;

//login
- (void) loginById:(NSString *)username andPassword:(NSString *)password andClientId:(NSString *)clientId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSdkSignature:(NSString *)sdkSignature andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *)) loginCallback;
//register
- (void) registerAcountWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback;
- (void) registerAcountWithPlaynow:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback;
- (void) registerAcountWithFacebook:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andIdToken:(NSString *)idToken andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback;
- (void) registerAcountWithGoogle:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback;
- (void) registerAcountWithApple:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andIdToken:(NSString *)idToken andFirebaseFCMToken:(NSString *)fcmToken andSecurityCode:(NSString *)securityCode andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerCallback;
- (void) requestActiveByUsername:(NSString *)username andContentFlag:(NSString *)contentFlag andAppToken:(NSString *)apptoken andChangeBy:(int)changeBy andEmail:(NSString *)email andPhoneNumber:(NSString *)phoneNumber andSignature:(NSString *)signature andCallback:(void (^)(NSDictionary<NSString *, id> *)) requestActiveCallback;
- (void) activeAccountUsername:(NSString *)username andActiveCode:(NSString *)activeCode andTransactionId:(NSString *)transactionId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))registerActivationCallback;

- (void) getProfile:(NSString *)username andAccessToken:(NSString *)accessToken andDeviceID:(NSString *)deviceId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))userProfileCallback;
- (void) loginByAccessToken:(NSString *)accessToken andUsername:(NSString *)username andDeviceID:(NSString *)deviceID andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))loginCallback;
- (void) resendOTP:(NSString *)username andTransactionId:(NSString *)transactionId andClientId:(NSString *)clientId andGameId:(NSString *)gameId andDeviceId:(NSString *)deviceId andContentFlag:(NSString *) contentFlag andFirebaseFCMToken:(NSString *)fcmToken andSign:(NSString *)sign andOTPNetwork:(NSString *)otpNetwork andCallback:(void (^)(NSDictionary<NSString *, id> *))resendCallback;
- (void) logOut:(NSString *)accessToken andDeviceID:deviceID andUserName:userName andSignature:signature andCallback:(void (^)(NSDictionary<NSString *, id> *))logoutCallback;

- (void) recoveryPasswordRequest:(NSString *)username andClientId:(NSString *)clientId andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSdkSignature:(NSString *)sdkSignature andNewPassword:(NSString *)newPassword andFirebaseFCMToken:(NSString *)fcmToken andOTPNetwork:(NSString *)otpNetwork andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))recoveryCallback;
- (void) recoveryPasswordSubmit:(NSString *)username andOTP:(NSString *)OTP andTransactionId:(NSString *)transactionId andDeviceId:(NSString *)deviceId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))recoveryCallback;
- (void) linkAccount:(NSString *)account andNewAccount:(NSString *)newAccount andPassword:(NSString *)password andEmail:(NSString *)email andAccessToken:(NSString *)accessToken andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andSign:(NSString *)sign andCallback:(void (^)(NSDictionary<NSString *, id> *))linkAccountCallback;

- (void)checkAccessToken:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))checkerCallback;
//iap
- (void) iapInitWithClientId:(NSString *)clientId andPartnerId:(NSString *)partnerId andUsername:(NSString *)username andCustomerId:(NSString *)customerId andNationalId:(NSString *)nationalId andRoleId:(NSString *)roleId andGameId:(NSString *)gameId andServerId:(NSString *)serverId andCurrencyUnit:(NSString *)currencyUnit andChannelID:(NSString *)channelID andPackageName:(NSString *)packageName andProductId:(NSString *)productId andProductName:(NSString *)productName andAmount:(NSString *) amount andExtraInfo:(NSString *)extraInfo andSignature:(NSString *)signature andDeviceId:(NSString *)deviceId andAccessToken:(NSString *)accessToken andOrderId:(NSString *)orderId andCallback:(void (^)(NSDictionary<NSString *, id> *))iapCallback;

- (void) finalizeIAPWithClientId:(NSString *)clientId andUsername:(NSString *)username andOrderId:(NSString *)orderId andTransactionID:(NSString *)transactionID andOrderToken:(NSString *)orderToken andServiceEmail:(NSString *)serviceEmail andExtraInfo:(NSString *)extraInfo andResultCode:(int)resultCode andErrorMessage:(NSString *)errorMessage andSignature:(NSString *)signature andAccessToken:(NSString *)accessToken andDeviceId:(NSString *)deviceId andCallback:(void (^)(NSDictionary<NSString *, id> *))iapCallback;

- (void) deleteAccount:(NSString *)clientId andUsername:(NSString *)username andSignature:(NSString *)signature andAccessToken:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback;
//log
- (void) writeInstallGameLog:(NSString *)clientID andClientName:(NSString *)clientName andSdkVersion:(NSString *)sdkVersion andDeviceID:(NSString *)deviceID andGameID:(NSString *)gameid andGameVersion:(NSString *)gameVersion andFirebaseFcmToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andNationalId:(NSString *)nationalId andIDFA:(NSString *)IDFA andExtraInfo:(NSString *)andExtraInfo andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))installGameCallback;

- (void) writeOpenGameLogWithUsername:(NSString *)username andCustomerId:(NSString *)customerId andClientId:(NSString *)clientId andSdkVersion:(NSString *)sdkVersion andDeviceId:(NSString *)deviceId andGameId:(NSString *)gameId andGameVersion:(NSString *)gameVersion andFirebaseFCMToken:(NSString *)fcmToken andPlatform:(NSString *)platform andPlatformVersion:(NSString *)platformVersion andDeviceBrand:(NSString *)deviceBrand andDeviceModel:(NSString *)deviceModel andMacAddress:(NSString *)macAddress andServerID:(NSString *)serverId andRoleId:(NSString *)roleId andNationalId:(NSString *)nationalId andExtraInfo:(NSString *)ExtraInfo andIDFA:(NSString *)IDFA andCallback:(void (^)(NSDictionary<NSString *, NSString *> *))openGameCallback;
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data;
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data andUsername:(NSString *)username;
@end
