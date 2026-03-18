//
//  MainUIController.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/1/21.
//

#import <Foundation/Foundation.h>
#import "MainUIController.h"
#import "SdkHelper.h"
#import "SdkLanguage.h"
#import "ServerFactory.h"
#import "ServerConnectionDelegate.h"
#import "MBProgressHUD.h"
#import "RequestActiveResponse.h"
#import "GTrackingManager.h"

@interface MainUIController() {
    UIViewController *loginViewController;
}

@end

@implementation MainUIController {
 
    
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self->loginViewController = self;
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (void) showProgress
{
    if(self->loginViewController)
    {
        [[SdkHelper sharedInstance] runInMainThread:^{
            [MBProgressHUD showHUDAddedTo:self->loginViewController.view animated:YES];
        }];
        
    }
}
- (void) hideProgress
{
    if(self->loginViewController)
    {
        [[SdkHelper sharedInstance] runInMainThread:^{
            [MBProgressHUD hideHUDForView:self->loginViewController.view animated:YES];
        }];
    }
}
- (void) loginWithId:(NSString *)username andPassword:(NSString *)password andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    if([self userValidate:username Pass:password])
    {
        [self showProgress];
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect requestLoginById:[SdkConfig sharedInstance] andUsername:username andPassword:password andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
            if([loginResponse.status isEqualToString:@"success"]) {
                [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
                [[SdkConfig sharedInstance] setOldAccount:username];
                // lấy thông tin tài khoản
                [[SdkConfig sharedInstance] updateNetwork:@"id"];
                [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                    [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback];
                }];
            } else {
                [self hideProgress];
                [[SdkHelper sharedInstance]
                        showAlertMessage:self
                 andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
                 andWithMessage:loginResponse.message
                 andCallback:nil];
                
                UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
                userProfile.status = @"failed";
                userProfileCallback(userProfile);
            }
        }];
    }
}

- (void) playNow:(void (^)(UserProfileResponse *))userProfileCallback
{
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestLoginByDeviceID:[SdkConfig sharedInstance] andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
        if([loginResponse.status isEqualToString:@"success"]) {
            [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
            // lấy thông tin tài khoản
            [[SdkConfig sharedInstance] updateNetwork:@"playnow"];
            [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback andNewAccount:YES];
            }];
        } else {
            [self hideProgress];
            NSString *message = [[SdkLanguage sharedInstance] translate:@"t_account_026"];
            if (loginResponse.code == -888) {
                message = [[SdkLanguage sharedInstance] translate:@"t_account_027"];
            }
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:[NSString stringWithFormat:message, loginResponse.code]
             andCallback:nil];
            
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"failed";
            userProfileCallback(userProfile);
        }
    }];
}

- (void) loginWithFacebook:(id)facebookLoginResult andAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestLoginByFacebook:[SdkConfig sharedInstance] andFacebookLoginResult:facebookLoginResult andAccessToken:accessToken andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
        if([loginResponse.status isEqualToString:@"success"]) {
            [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
            // lấy thông tin tài khoản
            [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback];
            }];
        } else {
            [self hideProgress];
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:loginResponse.message
             andCallback:nil];
            
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"failed";
            userProfileCallback(userProfile);
        }
    }];
}
- (void) loginWithGoogle:(id)googleUser andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestLoginByGoogleID:[SdkConfig sharedInstance] andUserId:[googleUser valueForKey:@"userID"] andEmail:[[googleUser valueForKey:@"profile"] valueForKey:@"email"] andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
        if([loginResponse.status isEqualToString:@"success"]) {
            [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
            // lấy thông tin tài khoản
            [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback];
            }];
        } else {
            [self hideProgress];
            NSString *message = [[SdkLanguage sharedInstance] translate:@"t_account_026"];
            if (loginResponse.code == -888) {
                message = [[SdkLanguage sharedInstance] translate:@"t_account_027"];
            }
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:[NSString stringWithFormat:message, loginResponse.code]
             andCallback:nil];
            
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"failed";
            userProfileCallback(userProfile);
        }
    }];
}
- (void) registerById:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andUserInfoCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    if(![self checkRuleUserName:username])
        return;
    if(![self checkRulePassword:password])
        return;
    if(![self validateEmail:email]){
        return;
    }
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestRegisterById:[SdkConfig sharedInstance] andUsername:username andPassword:password andEmail:email andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
        NSLog(@"loginResponse = %@", loginResponse);
        if([loginResponse.status isEqualToString:@"success"]) {
            [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
            [[SdkConfig sharedInstance] setOldAccount:username];
            [[SdkConfig sharedInstance] setUsername:username];
            // lấy thông tin tài khoản
            [[SdkConfig sharedInstance] updateNetwork:@"id"];
            [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                [self hideProgress];
                [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback andNewAccount:YES];
            }];
        } else if([loginResponse.status isEqualToString:@"success-active"]) {
            [self hideProgress];
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"success-active";
            userProfile.transactionID = loginResponse.transactionID;
            userProfile.message = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"t_alert_005"], email];
            userProfileCallback(userProfile);
        } else {
            [self hideProgress];
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:loginResponse.message
             andCallback:nil];
            
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"failed";
            userProfileCallback(userProfile);
        }
    }];
}

- (void) registerActiveAccount:(UserRequireData *)userRequireData andUserInfoCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    if (!userRequireData.OTPCode || [userRequireData.OTPCode length] < 2) {
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_alert_010_1"]
         andCallback:nil];
        return;
    }
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    NSString *username = userRequireData.username;
    userRequireData.callback = ^(RequestLoginResponse *loginResponse) {
        NSLog(@"loginResponse000 = %@", loginResponse);
        if([loginResponse.status isEqualToString:@"success"]) {
            [[SdkConfig sharedInstance] setUsername:username];
            [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
            [[SdkConfig sharedInstance] setOldAccount:username];
            // lấy thông tin tài khoản
            [[SdkConfig sharedInstance] updateNetwork:@"id"];
            [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                [self hideProgress];
                [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback andNewAccount:YES];
            }];
        } else {
            [self hideProgress];
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:loginResponse.message
             andCallback:nil];
            
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"failed";
            userProfileCallback(userProfile);
        }
    };
    [connect accountActivate:[SdkConfig sharedInstance] andUserRequireData:userRequireData];
}
- (void) requestActiveAccount:(UserRequireData *)userRequireData andUserInfoCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    if(![self validateEmail:userRequireData.email]){
        return;
    }
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestActiveByUsername:[SdkConfig sharedInstance] andUserRequireData:userRequireData andResponseCallback:^(RequestActiveResponse *response) {
        UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
        [self hideProgress];
        if ([response.status isEqual:@"success"]) {
            //gui ma kich hoat thanh cong
            userProfile.transactionID = response.transactionID;
            userProfile.username = userRequireData.username;
            userProfile.email = response.email;
            userProfile.status = @"success";
        } else {
            //khong the gui ma kich hoat
            userProfile.status = @"failed";
        }
        if(userProfileCallback) {
            userProfileCallback(userProfile);
        }
    }];
}

-(void) forgotPassword:(UserRequireData *)userRequireData
{
    if(userRequireData.username.length == 0){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_034"]
         andCallback:nil];
        return;
    }
    if(userRequireData.password.length == 0){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_alert_008"]
         andCallback:nil];
        return;
    }
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestForgotPassword:[SdkConfig sharedInstance] andUserRequireData:userRequireData andForgotResponseCallback:^(RequestForgotResponse *forgotResponseCallback) {
        [self hideProgress];
        if(userRequireData.callback)
        {
            userRequireData.callback(forgotResponseCallback);
        }
    }];
}

-(void) forgotPasswordSubmit:(UserRequireData *)userRequireData
{
    if(userRequireData.OTPCode.length <= 0){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_alert_010"]
         andCallback:nil];
        return;
    }
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestForgotPasswordWithResetPassword:[SdkConfig sharedInstance] andUserRequireData:userRequireData andForgotResponseCallback:^(RequestForgotResponse *forgotResponseCallback) {
        [self hideProgress];
        if(userRequireData.callback)
        {
            userRequireData.callback(forgotResponseCallback);
        }
    }];
}

- (void)resendOTP:(UserRequireData *)userRequireData
{
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect resendOTP:[SdkConfig sharedInstance] andUserRequireData:userRequireData andCallbackResult:^(id resendOtpCallback) {
        [self hideProgress];
        if(userRequireData.callback) {
            userRequireData.callback(resendOtpCallback);
        }
    }];
}

- (void)loginGoogleGetProfile:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
        [[SdkConfig sharedInstance] updateAccessToken:accessToken];
        [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback];
    }];
}

- (void) loginWithAppleByUserId:(NSString *)userID andEmail:(NSString *)email andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestLoginByAppleID:[SdkConfig sharedInstance] andUserId:userID andEmail:email andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
        if([loginResponse.status isEqualToString:@"success"]) {
            [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
            // lấy thông tin tài khoản
            [[SdkConfig sharedInstance] updateNetwork:@"apple"];
            [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback];
            }];
        } else {
            [self hideProgress];
            NSString *message = [[SdkLanguage sharedInstance] translate:@"t_account_026"];
            if (loginResponse.code == -888) {
                message = [[SdkLanguage sharedInstance] translate:@"t_account_027"];
            }
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:[NSString stringWithFormat:message, loginResponse.code]
             andCallback:nil];
            
            UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
            userProfile.status = @"failed";
            userProfileCallback(userProfile);
        }
    }];
}

- (void)requestBindAccount:(NSString *)newUsername andPassword:(NSString *)password andEmail:(NSString *)email andBindResponseCallback:(void (^)(BindAccountResponse *))bindResponseCallback
{
    if(![self checkRuleUserName:newUsername])
    {
        return;
    }
    if(![self checkRulePassword:password])
    {
        return;
    }
    if(![self validateEmail:email])
    {
        return;
    }
    UserRequireData *userRequireData = [UserRequireData sharedInstance:YES];
    userRequireData.username = newUsername;
    userRequireData.password = password;
    userRequireData.email = email;
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    [connect requestBindAccount:[SdkConfig sharedInstance] andUserRequireData:userRequireData andBindResponseCallback:^(BindAccountResponse *bindCallback) {
        [self hideProgress];
        if(bindResponseCallback){
            bindResponseCallback(bindCallback);
        }
    }];
}

- (void)requestAccessToken:(NSString *)accessToken andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    [self showProgress];
    id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
    @try {
        [connect requestAccessToken:[SdkConfig sharedInstance] andAccessToken:accessToken andLoginResponseCallback:^(RequestLoginResponse *loginResponse) {
            if([loginResponse.status isEqualToString:@"success"]) {
                [[SdkConfig sharedInstance] updateAccessToken:loginResponse.accessToken];
                // lấy thông tin tài khoản
                [connect requestProfile:[SdkConfig sharedInstance] andAccessToken:loginResponse.accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
                    [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback];
                }];
            } else {
                /*
                [[SdkHelper sharedInstance]
                        showAlertMessage:self
                 andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
                 andWithMessage:loginResponse.message
                 andCallback:nil];
                 */
                [self hideProgress];
                
                UserProfileResponse *userProfile = [[UserProfileResponse alloc] init];
                userProfile.status = @"failed";
                userProfileCallback(userProfile);
            }
        }];
    } @catch (NSException *exception) {
        [self hideProgress];
    }
}

- (void) showGame
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    SdkConfig *sdkConfig = [SdkConfig sharedInstance];
    [[SdkConfig sharedInstance] setLoggedInStatus:YES];
    [[KGModal sharedInstance] hideAnimated:YES];
    if(sdkConfig.checkAllowSignIn){
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect checkGameStatus:sdkConfig andGameStatusCallback:^(GameStatusResponse *gameStatus) {
            if([gameStatus.status isEqual:@"open"]) {
                [[GTrackingManager sharedInstance] login:sdkConfig.userID andUsername:sdkConfig.username andEmail:@""];
                
                [[GTrackingManager sharedInstance] verifyLogin];
                
                [self->_loginDelegate loginSuccess:sdkConfig.userID andUserName:sdkConfig.username andAccessToken:sdkConfig.accesstoken];
                [self clearNotification];
            } else {
                [[SdkHelper sharedInstance]
                        showAlertMessage:self
                 andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
                 andWithMessage:gameStatus.message
                 andCallback:nil];
            }
        }];
    } else {
        
        [self->_loginDelegate loginSuccess:sdkConfig.userID andUserName:sdkConfig.username andAccessToken:sdkConfig.accesstoken];
        [self clearNotification];
    }
}

- (void) userProfileResult:(UserProfileResponse *)userProfile andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback
{
    [self hideProgress];
    [self userProfileResult:userProfile andUserProfileCallback:userProfileCallback andNewAccount:NO];
}

- (void) userProfileResult:(UserProfileResponse *)userProfile andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback andNewAccount:(BOOL) isNewAccount
{
    if (![userProfile.status isEqual:@"success"]) {
        NSString *message = [[SdkLanguage sharedInstance] translate:@"t_account_024"];
        if ([userProfile.status isEqual:@"locked"]) {
            message = [[SdkLanguage sharedInstance] translate:@"t_account_305"];
        }
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:message
         andCallback:nil];
    } else {
        //tracking đăng nhập thành công
        // tracking appflyers
        [[SdkConfig sharedInstance] setUserID:userProfile.userID];
        [[SdkConfig sharedInstance] setEmailIngame:userProfile.email];
        [[GTrackingManager sharedInstance] setCustomerUserID:userProfile.userID];
        
        if(isNewAccount) {
            [[GTrackingManager sharedInstance] completeRegistration:userProfile.userID];
        }
        // tracking gm
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect idAppTrackingOpen];
    }
    userProfileCallback(userProfile);
}

- (void) signOutRequest:(void (^)(void)) signOutCallback
{
    if([[SdkConfig sharedInstance].accesstoken length] > 0)
    {
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect requestSignOut:[SdkConfig sharedInstance] andCallback:^(NSString *callback) {
            
        }];
    }
    if(signOutCallback) {
        signOutCallback();
    }
    [[SdkConfig sharedInstance] clearConfigFile];
    if(_logoutDelegate) {
        [_logoutDelegate logoutSuccess];
    }
}

- (BOOL) userValidate:(NSString *)name Pass:(NSString *)pwd
{
    BOOL isOk = YES;
    if(name.length == 0){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_001"]
         andCallback:nil];
        return NO;
    }
    //
    if(pwd.length == 0){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_002"]
         andCallback:nil];
        return NO;
    }
    //
    return isOk;
}

- (BOOL) checkRuleUserName:(NSString *)uName
{
    if(uName.length < 6){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_030"]
         andCallback:nil];
        return NO;
    }
    
    NSString *nameRegex = @"[a-zA-Z0-9]*";
    NSPredicate *nameNS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    if (![nameNS evaluateWithObject:uName]) {
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_031"]
         andCallback:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL) checkRulePassword:(NSString *)uPass
{
    if(uPass.length < 8){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_029"]
         andCallback:nil];
        return NO;
    }
    
    NSArray *arrFails = @[@"123456",@"1234567",@"12345678",@"123456789",@"1234567890",@"654321",@"7654321",@"87654321",@"987654321",@"0987654321",@"abcdef",@"qwerty",@"abc123",@"abc123456",@"abcd123",@"abcd1234",@"password",@"matkhau"];
    if([arrFails containsObject:uPass]){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_028"]
         andCallback:nil];
        return NO;
    }
    
    return YES;
}
- (BOOL)validateEmail:(NSString*)email
{
    if(!email || email.length == 0){
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_033"]
         andCallback:nil];
        return NO;
    } else {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:email]) {
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_032"]
             andCallback:nil];
            return NO;
        }
    }
    return YES;
}

-(UIToolbar *)addPasswordBoxTool:(UIViewController *)viewDelegate
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:viewDelegate action:@selector(keyboardDoneButtonPressed)];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:viewDelegate action:@selector(keyboardClearButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton, clearButton];
    
    return keyboardToolbar;
}

- (void) clearNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
