
#import "LoadServerConfigResponse.h"
#import "RequestLoginResponse.h"
#import "RequestLogoutResponse.h"
#import "UserProfileResponse.h"
#import "GameStatusResponse.h"
#import "RequestForgotResponse.h"
#import "BindAccountResponse.h"
#import "SdkConfig.h"
#import "IAPDataResponse.h"
#import "UserRequireData.h"
#import "RequestActiveResponse.h"

@protocol ServerConnectionDelegate

@required
//load server config
- (void) loadServerConfig:(SdkConfig *)_sdkConfig andCallback:(void (^)(LoadServerConfigResponse *))loadServerCallback;
- (void) requestLoginById:(SdkConfig *)_sdkConfig andUsername:(NSString *)username andPassword:(NSString *)password andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByDeviceID:(SdkConfig *)_sdkConfig andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestRegisterById:(SdkConfig *)_sdkConfig andUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) accountActivate:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData;

//forgotpassword
- (void) requestForgotPassword:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;
- (void) requestForgotPasswordWithResetPassword:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;
//forgotpassword

- (void) requestBindAccount:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andBindResponseCallback:(void (^)(BindAccountResponse *))bindResponseCallback;
- (void) requestAccessToken:(SdkConfig *)_sdkConfig andAccessToken:(NSString *)accessToken andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
//social login
- (void) requestLoginByFacebook:(SdkConfig *)_sdkConfig andFacebookLoginResult:(NSDictionary *)facebookLoginResult andAccessToken:(NSString *) accessToken andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByAppleID:(SdkConfig *)_sdkConfig andUserId:(NSString *)userID andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByGoogleID:(SdkConfig *)_sdkConfig andUserId:(NSString *)userID andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;

- (void) requestActiveByUsername:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData  andResponseCallback:(void (^)(RequestActiveResponse *))responseCallback;
- (void)requestProfile:(SdkConfig *)_sdkConfig andAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;;
- (void) requestLogout:(SdkConfig *)_sdkConfig andLogoutResponseCallback:(void (^)(RequestLogoutResponse *))logoutResponseCallback;
- (void)checkGameStatus:(SdkConfig *)_sdkConfig andGameStatusCallback:(void(^)(GameStatusResponse *))gameStatusCallback;
-(void) resendOTP:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andCallbackResult:(void(^)(id))resendOtpCallback;
//iap
- (void) IAPInitData:(NSDictionary *)iapDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse;
- (void) IAPInitRequest:(id) iapDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse;
- (void) IAPVerifyTransaction:(NSDictionary *)iapVerifyDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse;
- (void) IAPVerifyTransaction:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData;
//id tracking
- (void) idAppTrackingOpen:(NSString *)serverID roleID:(NSString *)roleID roleName:(NSString *)roleName andLogOpenUrl:(NSString *)logOpenUrl andDevideModel:(NSString *)deviceModel;
- (void) idAppTrackingOpen;
- (void) idAppTrackingAllowNotification:(NSString *)devicetoken;
- (void) idTrackingInstallUser:(NSString *)deviceModel;
- (void) idAppTrackingInstall:(SdkConfig *)_sdkConfig andAppVersion:(NSString *)appVersion;
- (void) idAppTrackingInstall:(SdkConfig *)_sdkConfig andServerId:(NSString *)serverID roleID:(NSString *)roleID roleName:(NSString *)roleName andLogOpenUrl:(NSString *)logOpenUrl andFirebaseFCMToken:(NSString *)fcmToken andAppVersion:(NSString *)appVersion;

- (void) deleteAccount:(id)_sdkConfig andCallback:(void (^)(NSDictionary<NSString *, id> *)) callback;

- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data;
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data andUsername:(NSString *)username;
@end
