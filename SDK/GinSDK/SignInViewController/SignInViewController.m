//
//  SignInViewController.m
//  GameSDK
//
//  Created by Nero-Macbook on 10/29/21.
//

#import "SignInViewController.h"
#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>
#import "GlobalVariable.h"
#import "SdkLanguage.h"
#import "SdkConfig.h"
#import "SdkHelper.h"
#import "FacebookManager.h"
#import "GoogleSignInManager.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "AppleManager.h"
#import "UserRequireData.h"

@interface SignInViewController ()<OpenIDDelegate>
{
    NSTimer *timerDelay;
    //
    BOOL isRegisTracking;
    UITextField *activeTextField;
}
@end


@implementation SignInViewController


- (IBAction) clickLogin:(id)sender
{
    _view1.hidden = NO;
    _view0.hidden = YES;
}


- (IBAction) clickSignin:(id)sender
{
    NSString *name = [_edtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pass = [_edtPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self loginWithId:name andPassword:pass andUserProfileCallback:^(UserProfileResponse *userProfile) {
        if([userProfile.status isEqual:@"success"]) {
            NSLog(@"UserProfileResponse = %@", userProfile.username);
            [[SdkConfig sharedInstance] setIsPlayNow];
            [self showWelcomeModal:^{
                [self showGame];
            }];
        }
    }];
}

- (IBAction) clickPlayNow:(id)sender
{
    [self playNow:^(UserProfileResponse *userProfile) {
        if([userProfile.status isEqual:@"success"]) {
            NSLog(@"UserProfileResponse = %@", userProfile.userID);
            NSLog(@"UserProfileResponse = %@", userProfile.username);
            [[SdkConfig sharedInstance] setIsPlayNow];
            [self showPlayNowWelcomeModal:^{
                [self showGame];
            }];
        }
    }];
}

- (IBAction) focusRegisView:(id)sener
{
    [self moveToViewIndex:7];
}

- (IBAction) clickRegister:(id)sender
{
    //call register
    NSString *name = [_edtNameRegis.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pass = [_edtPassRegis.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [_edtEmailRegis.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self registerById:name andPassword:pass andEmail:email andUserInfoCallback:^(UserProfileResponse *userProfile) {
        if([userProfile.status isEqual:@"success"]) {
            [[SdkConfig sharedInstance] setNotPlayNow];
            [self showWelcomeModal:^{
                [self showGame];
            }];
        } else if([userProfile.status isEqual:@"success-active"]) {
            UserRequireData *userRequireData = [UserRequireData sharedInstance:YES];
            userRequireData.username = name;
            userRequireData.transactionID = userProfile.transactionID;
            [self moveToViewIndex:8];
        }
    }];
}
- (IBAction)clickRegister_active:(id)sender {
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    userRequireData.OTPCode = [_edtRegister_otp.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self registerActiveAccount:userRequireData andUserInfoCallback:^(UserProfileResponse *userProfile) {
        if([userProfile.status isEqual:@"success"]) {
            [[SdkConfig sharedInstance] setNotPlayNow];
            [[UserRequireData sharedInstance] clear];
            [self showWelcomeModal:^{
                [self showGame];
            }];
        }
    }];
}
- (IBAction)clickLinker_active:(id)sender {
    NSLog(@"Linker account");
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    userRequireData.OTPCode = [_edtRegister_otp.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self registerActiveAccount:userRequireData andUserInfoCallback:^(UserProfileResponse *userProfile) {
        if([userProfile.status isEqual:@"success"]) {
            [[SdkConfig sharedInstance] setNotPlayNow];
            [[UserRequireData sharedInstance] clear];
            [self showWelcomeModal:^{
                [self showGame];
            }];
        }
    }];
}

- (IBAction) clickForgotPwd:(id)sender
{
    [self moveToViewIndex:5];
}
- (IBAction)clickRecoveryRequest:(id)sender {
    [_txtRecovery_username resignFirstResponder];
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    userRequireData.username = [_txtRecovery_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userRequireData.password = [_txtRecovery_password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"recovery request = %@", userRequireData);
    NSLog(@"recovery otp = %@", userRequireData.OTPNetwork);
    userRequireData.callback = ^(RequestForgotResponse *forgotResponse) {
        if(forgotResponse.isRichText) {
            [self->rtOPT setText:forgotResponse.message];
            [self moveToViewIndex:6];
        } else {
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:forgotResponse.message
             andCallback:nil];
        }
    };
    [self forgotPassword:userRequireData];
}
- (IBAction)clickRecoverySubmit:(id)sender {
    NSString *otpCode = [_txtRecoveryOTP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    NSLog(@"otpCode = %@", otpCode);
    userRequireData.OTPCode = otpCode;
    userRequireData.callback = ^(RequestForgotResponse *forgotResponse) {
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:forgotResponse.message
         andCallback:nil];
        if([forgotResponse.status isEqual:@"success"]) {
            [[UserRequireData sharedInstance] clear];
            [self moveToViewIndex:0];
        }
    };
    NSLog(@"abc data = %@", userRequireData.OTPCode);
    [self forgotPasswordSubmit:userRequireData];
}
- (IBAction)clickResendOTP:(id)sender {
    NSLog(@"resend OTP");
}

- (IBAction)clickCheckActive6:(id)sender//lấy trạng thái active của account
{
    [_txtRecovery_username resignFirstResponder];
    NSString *name = [_txtRecovery_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self forgotPassword:name andForgotResponseCallback:^(RequestForgotResponse *forgotResponse) {
        if(forgotResponse.isRichText) {
            [self->rtOPT setText:forgotResponse.message];
            [self moveToViewIndex:6];
        } else {
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:forgotResponse.message
             andCallback:nil];
        }
    }];
}

- (IBAction) clickShowPwd:(id)sender
{
    isShowPwd = !isShowPwd;
    [self changeStatusEdtPwd];
}
- (void) changeStatusEdtPwd
{
    [_edtPass setSecureTextEntry:isShowPwd];
    [_btnShowPass setSelected:!isShowPwd];
}
- (IBAction)clickUpdateNewPass:(id)sender
{
    NSString *username = [_txtRecovery_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newPassword = [_edtNewPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPassword = [_edtNewPassAgain.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *otpCode = [_edtOTP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self forgotPasswordResetPass:username andOTP:otpCode andPassword:newPassword andConfirmPassword:confirmPassword andForgotResponseCallback:^(RequestForgotResponse *forgotResponse) {
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:forgotResponse.message
         andCallback:nil];
        if([forgotResponse.status isEqual:@"success"]) {
            [self moveToViewIndex:0];
        }
    }];
}
#pragma Sign in with social network
- (IBAction) clickFacebook:(id)sender
{
    [[FacebookManager sharedInstance] facebookLogin:self andUserProfileCallback:^(UserProfileResponse *userProfile) {
        if([userProfile.status isEqual:@"success"]) {
            NSLog(@"UserProfileResponse = %@", userProfile.username);
            [[SdkConfig sharedInstance] updateNetwork:@"facebook"];
            [[SdkConfig sharedInstance] setNotPlayNow];
            [self showWelcomeModal:^{
                NSLog(@"da dang nhap fb xong");
                [self showGame];
            }];
        }
    }];
}



- (IBAction)clickLogout:(id)sender
{
    if([SdkConfig sharedInstance].isPlayNow) {
        //lien ket tai khoan
        NSLog(@"[SdkConfig sharedInstance].userID = %@", [SdkConfig sharedInstance].userID);
        _edtIDLink.text = [SdkConfig sharedInstance].userID;
        [self moveToViewIndex:4];
    } else {
        [[FacebookManager sharedInstance] signOut];
        [self signOutRequest:^{
            [self moveToViewIndex:0];
        }];
    }
}

- (IBAction) clickGoogle:(id)sender
{
    NSLog(@"clickGoogle");
    /*
     1. login by google app
     */
    /**/
    [[GoogleSignInManager sharedInstance] showSignIn:self andUserProfileCallback:^(UserProfileResponse *userProfileResponse) {
        [self userProfileResult:userProfileResponse andUserProfileCallback:^(UserProfileResponse *userProfile) {
            if([userProfile.status isEqual:@"success"]) {
                NSLog(@"UserProfileResponse = %@", userProfile.username);
                [[SdkConfig sharedInstance] setNotPlayNow];
                [self showWelcomeModal:^{
                    NSLog(@"da dang nhap google xong");
                    [self showGame];
                }];
            }
        }];
    }];
    /*
     2. login by OAuth ID
     */
    /*
    [self loginWithGoogleOAuth:self];
    */
}

- (void)loginGGFinished:(NSString *)accessToken
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loginGoogleGetProfile:accessToken andUserProfileCallback:^(UserProfileResponse *userProfile) {
            if([userProfile.status isEqual:@"success"]) {
                NSLog(@"Google UserProfileResponse = %@", userProfile.username);
                [[SdkConfig sharedInstance] setNotPlayNow];
                [self showWelcomeModal:^{
                    [self showGame];
                }];
            }
        }];
    });
}

- (IBAction) clickAppleID:(id)sender
{
    _btnAppleID.enabled = NO;
    if(![[AppleManager sharedInstance] showLoginView:self]) {
        _btnAppleID.enabled = YES;
        [[SdkHelper sharedInstance]
                showAlertMessage:self
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:[[SdkLanguage sharedInstance ] translate:@"t_account_040"]
         andCallback:nil];
    }
}

- (void) loginAppleSuccess:(AppleLoginResponse *) appleLogin
{
    _btnAppleID.enabled = YES;
    if([appleLogin.status isEqualToString:@"authenticate-success"])
    {
        [self loginWithAppleByUserId:appleLogin.userID andEmail:appleLogin.email andUserProfileCallback:^(UserProfileResponse *userProfile) {
            [[SdkConfig sharedInstance] setNotPlayNow];
            if([userProfile.status isEqual:@"success"]) {
                NSLog(@"UserProfileResponse = %@", userProfile.userID);
                NSLog(@"UserProfileResponse = %@", userProfile.username);
                [self showWelcomeModal:^{
                    [self showGame];
                }];
            }
        }];
    } else {
        NSLog(@"appleLogin = %@", appleLogin.status);
        NSLog(@"appleLogin = %@", appleLogin.message);
    }
}
- (void) loginAppleFailed:(AppleLoginResponse *)appleLogin
{
    _btnAppleID.enabled = YES;
    [[SdkHelper sharedInstance]
            showAlertMessage:self
     andWithTitle: appleLogin.errorTitle
     andWithMessage:appleLogin.message
     andCallback:nil];
}

- (void) perfomExistingAccountSetupFlows {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest  *authAppleIDRequest = [appleIDProvider createRequest];
        ASAuthorizationPasswordRequest *passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];
        //
        NSMutableArray <ASAuthorizationRequest *>* mArr = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [mArr addObject:authAppleIDRequest];
        }
        if (passwordRequest) {
            [mArr addObject:passwordRequest];
        }
        //
        NSArray <ASAuthorizationRequest *>* requests = [mArr copy];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
    }
}


- (IBAction) clickBack1:(UIButton *)btn
{
    if(btn.tag == 0){//from view1 to view0
        _view1.hidden = YES;
        _view0.hidden = NO;
    } else if(btn.tag == 1){//from view8 to view1
        [self moveToViewIndex:0];
    }
}
- (IBAction)clickBackTo0:(id)sender
{
    [self moveToViewIndex:0];
}
- (IBAction)clickBackTo1:(id)sender
{
    [self showPlayNowWelcomeModal:^{
        [self showGame];
    }];
}
- (IBAction)clickBackTo6:(id)sender
{
    [self moveToViewIndex:5];
}

- (IBAction)clickSendLink:(id)sender
{
    // lien ket tai khoan
    NSString *name = [_edtNewIDLink.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pass = [_edtPassLink.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [_edtEmailLink.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self requestBindAccount:name andPassword:pass andEmail:email andBindResponseCallback:^(BindAccountResponse *bindAccount) {
        if([bindAccount.status isEqualToString:@"success-active"]) {
            UserRequireData *userRequireData = [UserRequireData sharedInstance:YES];
            userRequireData.username = name;
            userRequireData.email = email;
            userRequireData.transactionID = bindAccount.transactionID;
            [self moveToViewIndex:8];
        } else {
            [[SdkHelper sharedInstance]
                    showAlertMessage:self
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:bindAccount.message
             andCallback:nil];
        }
    }];
}

#pragma KBKeyboard Delegate
- (void)keyboardSizeChanged:(CGSize)delta
{
    NSLog(@"keyboardSizeChanged");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ALO: - viewDidLoad");
    self.view.frame = [UIScreen mainScreen].bounds;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    keyboard = [[KBKeyboardHandler alloc] init];
//    keyboard.delegate = self;
    
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    pageIndex = 0;
    //for view 0
    _view0.layer.cornerRadius = 5;
    _view0.layer.borderWidth = 1.0f;
    _view0.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85f);
    _view0.layer.borderColor = UIColorFromRGB(0x222222, 0.5f).CGColor;
    //_view0.layer.borderColor = UIColorFromRGB(0x000000, 0.99f).CGColor;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view0 addGestureRecognizer:tap0];
    
    //for view 1
    _view1.layer.cornerRadius = 5;
    _view1.layer.borderWidth = 1.0f;
    _view1.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85f);
    _view1.layer.borderColor = UIColorFromRGB(0x222222, 0.5f).CGColor;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view1 addGestureRecognizer:tap1];
    _view1.hidden = YES;
    
    UIColor *hideColor = [UIColor colorWithWhite:0.2f alpha:0.85f];
    //[_edtName setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //for iOS 13
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(_edtName, ivar);
    placeholderLabel.textColor = hideColor;
    //
    placeholderLabel = object_getIvar(_edtPass, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtPass setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _edtName.delegate = self;
    _edtPass.delegate = self;
    
    isShowPwd = YES;
    
    //for view 2
    _view2.layer.cornerRadius = 5;
    _view2.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.99f);

    [_lblWelcome setTextAlignment:RTTextAlignmentLeft];
    _btnLogout.layer.borderWidth = 1.0f;
    _btnLogout.layer.borderColor = UIColorFromRGB(0xE99215, 1).CGColor;
    
    //for view 3
    _view3.layer.cornerRadius = 5;
    _view3.layer.borderWidth = 1.0f;
    _view3.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85);
    _view3.layer.borderColor = UIColorFromRGB(0x222222, 0.5).CGColor;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view3 addGestureRecognizer:tap3];
    
    placeholderLabel = object_getIvar(_edtPhone, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtPhone setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _edtPhone.delegate = self;
    
    //for view 4
    _view4.layer.cornerRadius = 5;
    _view4.layer.borderWidth = 1.0f;
    _view4.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85);
    _view4.layer.borderColor = UIColorFromRGB(0x222222, 0.5).CGColor;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view4 addGestureRecognizer:tap4];
    
    placeholderLabel = object_getIvar(_edtCode, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtCode setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _edtCode.delegate = self;
    
    //for view 5
    _view5.layer.cornerRadius = 5;
    _view5.layer.borderWidth = 1.0f;
    _view5.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85);
    _view5.layer.borderColor = UIColorFromRGB(0x222222, 0.5).CGColor;
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view5 addGestureRecognizer:tap5];
    
    placeholderLabel = object_getIvar(_edtIDLink, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtNewIDLink, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtPassLink, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtEmailLink, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtIDLink setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtNewIDLink setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtPassLink setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtEmailLink setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _edtIDLink.delegate = self;
    _edtNewIDLink.delegate = self;
    _edtPassLink.delegate = self;
    _edtEmailLink.delegate = self;
    
    //for view 6
    _view6.layer.cornerRadius = 5;
    _view6.layer.borderWidth = 1.0f;
    _view6.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85);
    _view6.layer.borderColor = UIColorFromRGB(0x222222, 0.5).CGColor;
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view6 addGestureRecognizer:tap6];
    
    placeholderLabel = object_getIvar(_txtRecovery_username, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtName6 setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _txtRecovery_username.delegate = self;
    
    placeholderLabel = object_getIvar(_txtRecovery_password, ivar);
    placeholderLabel.textColor = hideColor;
    [_btnRadioRecovery_email addTarget:self action:@selector(radioButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRadioRecovery_phone addTarget:self action:@selector(radioButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //for view 7
    _view7.layer.cornerRadius = 5;
    _view7.layer.borderWidth = 1.0f;
    _view7.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85);
    _view7.layer.borderColor = UIColorFromRGB(0x222222, 0.5).CGColor;
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view7 addGestureRecognizer:tap7];
    
    placeholderLabel = object_getIvar(_edtNewPass, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtNewPassAgain, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtOTP, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtNewPass setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtNewPassAgain setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtOTP setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _edtNewPass.delegate = self;
    _edtNewPassAgain.delegate = self;
    _edtOTP.delegate = self;
    
    //for view 8
    _view8.layer.cornerRadius = 5;
    _view8.layer.borderWidth = 1.0f;
    _view8.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85f);
    _view8.layer.borderColor = UIColorFromRGB(0x222222, 0.5f).CGColor;
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view8 addGestureRecognizer:tap8];

    placeholderLabel = object_getIvar(_edtNameRegis, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtPassRegis, ivar);
    placeholderLabel.textColor = hideColor;
    placeholderLabel = object_getIvar(_edtEmailRegis, ivar);
    placeholderLabel.textColor = hideColor;
    //[_edtNameRegis setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtPassRegis setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    //[_edtEmailRegis setValue:hideColor forKeyPath:@"_placeholderLabel.textColor"];
    _edtNameRegis.delegate = self;
    _edtPassRegis.delegate = self;
    _edtEmailRegis.delegate = self;
    
    //for view _view_Register_active
    _view_Register_active.layer.cornerRadius = 5;
    _view_Register_active.layer.borderWidth = 1.0f;
    _view_Register_active.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.85);
    _view_Register_active.layer.borderColor = UIColorFromRGB(0x222222, 0.5).CGColor;
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_view_Register_active addGestureRecognizer:tap9];
    placeholderLabel = object_getIvar(_edtRegister_otp, ivar);
    placeholderLabel.textColor = hideColor;
    _edtRegister_otp.delegate = self;
    
    [_lblTerm setText:[NSString stringWithFormat:@"%@", [[SdkLanguage sharedInstance] translate:@"t_account_policy_001"]]];
    
    [_lblTerm setTextAlignment:RTTextAlignmentCenter];
    _lblTerm.delegate = self;
    
    //view0
    _lblTitle0.text = [[SdkLanguage sharedInstance] translate:@"t_account_003"];
    [_btnAppleID setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_021"] forState:UIControlStateNormal];
    [_btnFace setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_004"] forState:UIControlStateNormal];
    [_btnGG setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_005"] forState:UIControlStateNormal];
    [_btnLogin setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_006"] forState:UIControlStateNormal];
    [_btnPlayNow setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_007"] forState:UIControlStateNormal];
    //view1
    _lblTitle1.text = [[SdkLanguage sharedInstance] translate:@"t_account_003"];
    [_edtName setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_008"]];
    [_edtPass setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_009"]];
    [_btnSignIn setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_003"] forState:UIControlStateNormal];
    [_btnSignUp setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_010"] forState:UIControlStateNormal];
    [_btnForgot setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_011"] forState:UIControlStateNormal];
    //view2
    [_btnLogout setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_001"] forState:UIControlStateNormal];
    [_btnLogout setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_002"] forState:UIControlStateSelected];
    //view3
    _lblTitle3.text = [[SdkLanguage sharedInstance] translate:@"t_account_012"];
    [_edtPhone setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_013"]];
    [_btnSubmit3 setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_003"] forState:UIControlStateNormal];
    //view4
    _lblTitle4.text = [[SdkLanguage sharedInstance] translate:@"t_account_012"];
    _lblSDT.text = [[SdkLanguage sharedInstance] translate:@"t_account_013"];
    [_edtCode setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_014"]];
    [_btnActive4 setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_003"] forState:UIControlStateNormal];
    [_btnGetCode4 setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_004"] forState:UIControlStateNormal];
    //view5
    _lblTitle5.text = [[SdkLanguage sharedInstance] translate:@"t_account_015"];
    _lblNote5.text = [[SdkLanguage sharedInstance] translate:@"t_alert_002"];
    [_edtNewIDLink setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_016"]];
    [_edtPassLink setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_009"]];
    [_edtEmailLink setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_017"]];
    [_btnSubmit5 setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_003"] forState:UIControlStateNormal];
    //_view6
    _lblTitle6.text = [[SdkLanguage sharedInstance] translate:@"t_account_011"];
    [_txtRecovery_username setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_008"]];
    [_btnRecovery_submit setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_003"] forState:UIControlStateNormal];
    //view7
    _lblTitle7.text = [[SdkLanguage sharedInstance] translate:@"t_account_018"];
    [_edtOTP setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_014"]];
    [_edtNewPass setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_019"]];
    [_edtNewPassAgain setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_020"]];
    [_btnSubmit7 setTitle:[[SdkLanguage sharedInstance] translate:@"t_common_003"] forState:UIControlStateNormal];
    //view8
    _lblTitle8.text = [[SdkLanguage sharedInstance] translate:@"t_account_010"];
    [_edtNameRegis setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_008"]];
    [_edtPassRegis setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_009"]];
    [_edtEmailRegis setPlaceholder:[[SdkLanguage sharedInstance] translate:@"t_account_017"]];
    [_btnRegister setTitle:[[SdkLanguage sharedInstance] translate:@"t_account_010"] forState:UIControlStateNormal];
    
    //
    [_scrollView setContentSize:CGSizeMake(8*_scrollView.frame.size.width, _scrollView.frame.size.height)];
    
    
    ///////keyboard
    self.edtName.inputAccessoryView = [self addPasswordBoxTool:self];
    self.edtPass.inputAccessoryView = [self addPasswordBoxTool:self];
    self.txtRecovery_username.inputAccessoryView = [self addPasswordBoxTool:self];
    self.txtRecovery_password.inputAccessoryView = [self addPasswordBoxTool:self];
    ///end keyboard
    //kiêm tra trạng thái login trước đó để bỏ qua bước login
    if([[SdkConfig sharedInstance] isLoggedIn]){//refresh token
        [self requestAccessToken:[SdkConfig sharedInstance].accesstoken andUserProfileCallback:^(UserProfileResponse *userProfile) {
            if([userProfile.status isEqual:@"success"] && [userProfile.userID length] > 2) {
                NSLog(@"UserProfileResponse = %@", userProfile.username);
                [[SdkConfig sharedInstance] setNotPlayNow];
                [self showWelcomeModal:^{
                    [self showGame];
                }];
            } else {
                [[SdkConfig sharedInstance] updateAccessToken:nil];
                [[SdkConfig sharedInstance] setLoggedInStatus:false];
            }
        }];
    } else {
        _edtName.text = [[SdkConfig sharedInstance] getOldAccount];
    }
}

- (void)radioButtonEvent:(id)sender
{
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:_btnRadioRecovery_email,_btnRadioRecovery_phone, nil];
    for (UIButton *button in buttonArray) {
        if (@available(iOS 13.0, *)) {
            [button setImage:[UIImage systemImageNamed:@"circle" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleMedium]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
    }
    if (@available(iOS 13.0, *)) {
        [sender setImage:[UIImage systemImageNamed:@"largecircle.fill.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:UIImageSymbolScaleMedium]] forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
    }
    NSInteger buttonTag = (long)[sender tag];
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    switch (buttonTag) {
        case 111: //phone click
            userRequireData.OTPNetwork = @"phone";
            break;
        case 110: //email click
        default:
            userRequireData.OTPNetwork = @"email";
            break;
    }
}

- (void)keyboardDoneButtonPressed {
    NSLog(@"done done done");
    [self hideKeyboard];
}

- (void)keyboardClearButtonPressed {
    NSLog(@"clear button");
    if(activeTextField && ![activeTextField isEqual:[NSNull null]] && [activeTextField isEditing]) {
        activeTextField.text = @"";
    }
}

//begin or end editing all text field
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    activeTextField = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeTextField = nil;
}

- (void) handleTap:(UITapGestureRecognizer *)gestureRecognizer{
    [_view1 endEditing:NO];
    [_view3 endEditing:NO];
    [_view4 endEditing:NO];
    [_view5 endEditing:NO];
    [_view6 endEditing:NO];
    [_view7 endEditing:NO];
    [_view8 endEditing:NO];
    [_view_Register_active endEditing:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ALO: OrientationDidChange");
    [super viewWillAppear:animated];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    float w = 250;
    if(IS_IPAD)
        w = w*2;
    else
        w = MIN(size.width, size.height);
    
    CGRect frame = _scrollView.frame;
    frame.size.width = w;
    frame.size.height = w;
    frame.origin.x = (size.width - w)/2;
    frame.origin.y = (size.height - w)/2;
    _scrollView.frame = frame;
    [_scrollView setContentSize:CGSizeMake(9*w, _scrollView.frame.size.height)];

    //update for view
    frame = _view1.frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size.width = w-20;
    frame.size.height = w-20;
    _view1.frame = frame;
    
    /*frame = _view2.frame;
    frame.origin.x = w + 10;
    frame.origin.y = 5;
    _view2.frame = frame;*/
    
    frame = _view3.frame;
    frame.origin.x = 2*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view3.frame = frame;
    
    frame = _view4.frame;
    frame.origin.x = 3*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view4.frame = frame;
    
    frame = _view5.frame;
    frame.origin.x = 4*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view5.frame = frame;
    
    frame = _view6.frame;
    frame.origin.x = 5*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view6.frame = frame;
    
    frame = _view7.frame;
    frame.origin.x = 6*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view7.frame = frame;
    
    frame = _view8.frame;
    frame.origin.x = 7*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view8.frame = frame;
    
    frame = _view_Register_active.frame;
    frame.origin.x = 8*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view_Register_active.frame = frame;
    
    //cập nhật vị trí số phone và tên tài khoản
    CGSize s = [_lblSDT.text sizeWithAttributes:@{NSFontAttributeName:_lblSDT.font}];
    frame = _lblSDT.frame;
    frame.size.width = s.width + 3;
    _lblSDT.frame = frame;
    
    frame = _lblPhone.frame;
    frame.origin.x = _lblSDT.frame.origin.x + _lblSDT.frame.size.width;
    _lblPhone.frame = frame;
    
    //set border
    _viewAppleID.layer.borderColor = UIColorFromRGB(0x666666, 0.85).CGColor;
    _viewAppleID.layer.borderWidth = 1;
    _viewAppleID.layer.cornerRadius = 4;
    
    _viewFace.layer.cornerRadius = 4;
    _viewGG.layer.cornerRadius   = 4;
    _btnLogin.layer.cornerRadius = 4;
    //
    _btnPlayNow.layer.cornerRadius = _btnPlayNow.frame.size.height/2;
    _btnSignUp.layer.cornerRadius = _btnSignUp.frame.size.height/2;
    _btnSignIn.layer.cornerRadius = _btnSignIn.frame.size.height/2;
    _btnLogout.layer.cornerRadius = _btnLogout.frame.size.height/2;
    _btnRegister.layer.cornerRadius = _btnRegister.frame.size.height/2;
    _btnSubmit3.layer.cornerRadius = _btnSubmit3.frame.size.height/2;
    _btnActive4.layer.cornerRadius = _btnActive4.frame.size.height/2;
    _btnSubmit5.layer.cornerRadius = _btnSubmit5.frame.size.height/2;
    _btnRecovery_submit.layer.cornerRadius = _btnRecovery_submit.frame.size.height/2;
    _btnSubmit7.layer.cornerRadius = _btnSubmit7.frame.size.height/2;
    
    [self moveToViewIndex:pageIndex];
}

- (IBAction)txtPasswordBeginEditing:(id)sender {
    CGRect frame = _scrollView.frame;
    frame.origin.y = frame.origin.y - 50;
    _scrollView.frame = frame;
}

- (IBAction)txtPasswordEndEditing:(id)sender {
    CGRect frame = _scrollView.frame;
    frame.origin.y = frame.origin.y + 50;
    _scrollView.frame = frame;
}
- (IBAction)txtRecoveryPasswordDidBegin:(id)sender {
    /*
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait)
    {
        
    }
    NSLog(@"deviceOrientation = %ld", (long)[[UIDevice currentDevice] orientation]);CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)
     */
    CGRect frame = _scrollView.frame;
    frame.origin.y = frame.origin.y - 100;
    _scrollView.frame = frame;
}
- (IBAction)txtRecoveryPasswordDidEnd:(id)sender {
    CGRect frame = _scrollView.frame;
    frame.origin.y = frame.origin.y + 100;
    _scrollView.frame = frame;
}
- (void) scrollViewTopPosition{
    CGRect frame = _scrollView.frame;
    CGSize size = [[UIScreen mainScreen] bounds].size;float w = 250;
    if(IS_IPAD)
        w = w*2;
    else
        w = MIN(size.width, size.height);
    frame.origin.x = (size.width - w)/2;
    frame.origin.y = (size.height - w)/2;
    frame.origin.y = frame.origin.y - 50;
    _scrollView.frame = frame;
}

- (void) showWelcomeModal:(void (^)(void))afterWelcomeCallback
{
    [self hideKeyboard];
    _view2.hidden = YES;
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*1, 0);
    
    CGRect welcomeFrame = _lblWelcome.frame;
    SdkConfig *sdkConfig = [SdkConfig sharedInstance];
    NSString *name = sdkConfig.username;
    //xu ly cho th login = appleID
    NSString *network = [NSString stringWithFormat:@"%@",[SdkConfig sharedInstance].network];
    NSLog(@"network = %@", network);
    if(network && [network isEqualToString:@"apple"])
    {
        name = sdkConfig.userID;
    }
//    if(sdkConfig.userStatus && [sdkConfig.userStatus isEqualToString:@"-9"])
//        name = sdkConfig.userID;
    //
    [_lblWelcome setText:[NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"t_alert_003"], name]];
    
    _btnLogout.selected = NO;
    welcomeFrame.size.height = 21;
    welcomeFrame.origin.y = (_view2.frame.size.height - welcomeFrame.size.height)/2;
    
    [self designWelcomeModal:afterWelcomeCallback];
}

- (void) showPlayNowWelcomeModal:(void (^)(void))afterWelcomeCallback
{
    [self hideKeyboard];
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*1, 0);
    
    CGRect welcomeFrame = _lblWelcome.frame;
    SdkConfig *sdkConfig = [SdkConfig sharedInstance];
    
    NSString *name = [NSString stringWithFormat:@"%@_%@", sdkConfig.gameId, [[SdkLanguage sharedInstance] translate:@"t_account_025"]];
    
    [_lblWelcome setText:[NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"t_alert_004"], name]];
    _btnLogout.selected = YES;
    welcomeFrame.size.height = _view2.frame.size.height - 20;
    welcomeFrame.origin.y = 10;
    [self designWelcomeModal:afterWelcomeCallback];
}

- (void) designWelcomeModal:(void (^)(void))afterWelcomeCallback
{
    
    _view2.hidden = NO;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect view2Frame = _view2.frame;
    int w = 250;
    if(IS_IPAD)
        w = w*2;
    else if(size.width < size.height)
        w = size.width - 4;
    else if(size.width > size.height)
        w = w*2;
    view2Frame.size.width = w;
    view2Frame.origin.x = (size.width - w)/2;
    _view2.frame = view2Frame;
    
    //call count down
    if(timerDelay)
        [timerDelay invalidate];
    
    timerDelay = [NSTimer scheduledTimerWithTimeInterval:3 repeats:FALSE block:^(NSTimer * _Nonnull timer) {
        afterWelcomeCallback();
    }];
}

- (void) hideKeyboard
{
    //grab the main window of the application
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //call our recursive method below
    [self resignResponderForView:window];
}

- (void) resignResponderForView:(UIView *)view {
    [view resignFirstResponder];
    //if it has no subviews, then return back up the stack
    if (view.subviews.count == 0)
        return;
    //go through all of its subviews
    for (UIView *subview in view.subviews) {
        //recursively call the method on those subviews
        [self resignResponderForView:subview];
    }
}
- (void) moveToViewIndex:(NSInteger) index
{
    pageIndex = index;
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*index, 0);
    _view2.hidden = YES;
    if(timerDelay)
        [timerDelay invalidate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"ALO: viewDidAppear");
    if(!rtOPT){
        rtOPT = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, _smsOTPView.frame.size.width, _smsOTPView.frame.size.height)];
        //rtOPT.delegate = self;
        rtOPT.lineBreakMode = RTTextLineBreakModeWordWrapping;
        rtOPT.lineSpacing = 2.0f;
        [_smsOTPView addSubview:rtOPT];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return TRUE;
}

-(void)OrientationDidChange:(NSNotification*)notification
{
    NSLog(@"ALO: OrientationDidChange");
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.view.frame;
    //NSLog(@"sw1: %f, sh1: %f", frame.size.width, frame.size.height);
    if(size.width == frame.size.width && size.height == frame.size.height)
        return;
    
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
    //NSLog(@"sw2: %f, sh2: %f", self.view.frame.size.width, self.view.frame.size.height);
    //update for scrollView size
    float w = 250;
    if(IS_IPAD)
        w = w*2;
    else
        w = MIN(size.width, size.height);

    //NSLog(@"w: %f", w);
    frame = _scrollView.frame;
    frame.size.width = w;
    frame.size.height = w;
    frame.origin.x = (size.width - w)/2;
    frame.origin.y = (size.height - w)/2;
    _scrollView.frame = frame;
    [_scrollView setContentSize:CGSizeMake(9*w, _scrollView.frame.size.height)];
    
    //update for view
    frame = _view0.frame;
    frame.origin.x = 10;
    frame.origin.y = 25;
    frame.size.width = w-20;
    frame.size.height = w-35;
    _view0.frame = frame;
    
    frame = _view1.frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size.width = w-20;
    frame.size.height = w-20;
    _view1.frame = frame;
    
    /*frame = _view2.frame;
    frame.origin.x = w + 10;
    frame.origin.y = 5;
    _view2.frame = frame;*/
    
    frame = _view3.frame;
    frame.origin.x = 2*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view3.frame = frame;
    
    frame = _view4.frame;
    frame.origin.x = 3*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view4.frame = frame;
    
    frame = _view5.frame;
    frame.origin.x = 4*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view5.frame = frame;
    
    frame = _view6.frame;
    frame.origin.x = 5*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view6.frame = frame;
    
    frame = _view7.frame;
    frame.origin.x = 6*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view7.frame = frame;
    
    frame = _view8.frame;
    frame.origin.x = 7*w + 10;
    frame.origin.y = (w - frame.size.height)/2;
    _view8.frame = frame;
    
    if(notification){
        [[KGModal sharedInstance] showWithContentViewController:self andAnimated:NO];
    }
}

- (IBAction)btnDeleteUser:(id)sender {
    NSLog(@"xoa tai khoan");
}


@end
