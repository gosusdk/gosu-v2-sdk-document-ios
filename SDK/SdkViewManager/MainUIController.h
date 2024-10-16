//
//  MainUIController.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/1/21.
//

#import <UIKit/UIKit.h>
#import "UserProfileResponse.h"
#import "LoginDelegate.h"
#import "RequestForgotResponse.h"
#import "BindAccountResponse.h"
#import "RTLabel.h"
#import "KGModal.h"
#import "UserRequireData.h"
#import "AppleLoginResponse.h"

@interface MainUIController : UIViewController<RTLabelDelegate>{
    
    RTLabel *rtOPT;
    RTLabel *rtOPTForgotAccount;
    
}

@property (nonatomic, strong) id<LoginDelegate> loginDelegate;
@property (nonatomic, strong) id<LogoutDelegate> logoutDelegate;
@property (nonatomic, strong) UIViewController *parentViewController;

- (void) showGame;
- (void) loginWithId:(NSString *)username andPassword:(NSString *)password andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) playNow:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) loginWithFacebook:(id)facebookLoginResult andAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) loginWithGoogle:(id)googleUser andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
//register
- (void) registerById:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andUserInfoCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) registerActiveAccount:(UserRequireData *)userRequireData andUserInfoCallback:(void (^)(UserProfileResponse *))userProfileCallback;
//forgot
-(void) forgotPassword:(NSString *)username andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;
-(void) forgotPasswordResetPass:(NSString *)username andOTP:(NSString *)otpCode andPassword:(NSString *)password andConfirmPassword:(NSString *)confirmPassword andForgotResponseCallback:(void (^)(RequestForgotResponse *))forgotResponseCallback;

//forgot password
-(void) forgotPassword:(UserRequireData *)userRequireData;
-(void) forgotPasswordSubmit:(UserRequireData *)userRequireData;

- (void) loginWithGoogleOAuth:(UIViewController *)parentView;
- (void)loginGoogleGetProfile:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) loginWithAppleByUserId:(NSString *)userID andEmail:(NSString *)email andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void)requestBindAccount:(NSString *)newUsername andPassword:(NSString *)password andEmail:(NSString *)email andBindResponseCallback:(void (^)(BindAccountResponse *))bindResponseCallback;
- (void)requestAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) signOutRequest:(void (^)(void)) signOutCallback;
- (void) requestActiveAccount:(UserRequireData *)userRequireData andUserInfoCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) userProfileResult:(UserProfileResponse *)userProfile andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) userProfileResult:(UserProfileResponse *)userProfile andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback andNewAccount:(BOOL) isNewAccount;
- (void)resendOTP:(UserRequireData *)userRequireData;

-(UIToolbar *)addPasswordBoxTool:(UIViewController *)viewDelegate;
@end
