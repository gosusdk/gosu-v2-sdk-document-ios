//
//  GSGrpcApi.h
//  GameSDK
//
//  Created by Nero-Macbook on 12/23/21.
//

#import <UIKit/UIKit.h>
#import "ServerConnectionDelegate.h"
#import "LoadServerConfigResponse.h"
#import "RequestLoginResponse.h"
#import "UserProfileResponse.h"
#import "GameStatusResponse.h"
#import "RequestForgotResponse.h"
#import "BindAccountResponse.h"
#import "IAPDataResponse.h"
#import "SdkConfig.h"
#import "UserRequireData.h"
#import "ResendOtpResponse.h"
#import "RequestActiveResponse.h"
#import "IAPDataRequest.h"
#import "AppleLoginResponse.h"

@interface GSGrpcApi : NSObject<ServerConnectionDelegate>

- (id) serverApi;
- (void) loadServerConfig:(SdkConfig *)SdkConfig andCallback:(void (^)(LoadServerConfigResponse *))loadServerCallback;
- (void) requestLoginById:(SdkConfig *)SdkConfig andUsername:(NSString *)username andPassword:(NSString *)password andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByDeviceID:(SdkConfig *)SdkConfig andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestRegisterById:(SdkConfig *)SdkConfig andUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) accountActivate:(SdkConfig *)SdkConfig andUserRequireData:(UserRequireData *)userRequireData;
- (void) requestForgotPasswordById:(SdkConfig *)SdkConfig andUsername:(NSString *)username andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;
- (void) requestForgotPasswordWithResetPassword:(SdkConfig *)SdkConfig andUsername:(NSString *)username andOTP:(NSString *)OTPCode andNewPassword:(NSString *)newPassword andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;
//forgot password
- (void) requestForgotPassword:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;
- (void) requestForgotPasswordWithResetPassword:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;

- (void) requestBindAccount:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andBindResponseCallback:(void (^)(BindAccountResponse *))bindResponseCallback;

- (void) requestAccessToken:(SdkConfig *)SdkConfig andAccessToken:(NSString *)accessToken andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
//social login
- (void) requestLoginByFacebook:(SdkConfig *)_sdkConfig andFacebookLoginResult:(NSDictionary *)facebookLoginResult andAccessToken:(NSString *) accessToken andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByAppleID:(SdkConfig *)SdkConfig andUserId:(NSString *)userID andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByAppleID:(AppleLoginResponse *) appleUser andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestLoginByGoogleID:(SdkConfig *)SdkConfig andUserId:(NSString *)userID andEmail:(NSString *)email andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) requestActiveByUsername:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData  andResponseCallback:(void (^)(RequestActiveResponse *))responseCallback;

- (void)requestProfile:(SdkConfig *)_sdkConfig andAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) requestSignOut:(SdkConfig *)_sdkConfig andCallback:(void (^)(NSString *))logoutCallback;
- (void)checkGameStatus:(SdkConfig *)SdkConfig andGameStatusCallback:(void(^)(GameStatusResponse *))gameStatusCallback;
-(void) resendOTP:(SdkConfig *)_sdkConfig andUserRequireData:(UserRequireData *)userRequireData andCallbackResult:(void(^)(ResendOtpResponse *))resendOtpCallback;
//IAP
- (void) IAPInitData:(NSDictionary *)iapDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse;
- (void) IAPInitRequest:(IAPDataRequest *) iapDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse;

- (void) IAPVerifyTransaction:(NSDictionary *)iapVerifyDataRequest andDataResponse:(void (^)(IAPDataResponse *))iapDataResponse;
- (void) IAPVerifyTransaction:(SdkConfig *)SdkConfig andUserRequireData:(UserRequireData *)userRequireData;
//id tracking
- (void) idAppTrackingOpen:(NSString *)serverID roleID:(NSString *)roleID roleName:(NSString *)roleName andLogOpenUrl:(NSString *)logOpenUrl andDevideModel:(NSString *)deviceModel;
- (void) idAppTrackingOpen;
- (void) idAppTrackingAllowNotification:(NSString *)devicetoken;
- (void) idTrackingInstallUser:(NSString *)deviceModel;
- (void) accountActivate:(SdkConfig *)SdkConfig andActiveCode:(NSString *)activeCode andLoginResponseCallback:(void (^)(RequestLoginResponse *))loginResponseCallback;
- (void) idAppTrackingInstall:(SdkConfig *)SdkConfig andAppVersion:(NSString *)appVersion;
- (void) deleteAccount:(UserRequireData *)userRequireData andCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback;

- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data;
- (void) sdkLog:(NSString *)clientID andActiveKey:(NSString *)activeKey andData:(NSDictionary *)data andUsername:(NSString *)username;
@end
