//
//  GrpcViewController.h
//  GameSDK
//
//  Created by Nero-Macbook on 10/29/21.
//
#import <UIKit/UIKit.h>
#import "MainUIController.h"
#import "RTLabel.h"

@interface GrpcViewController : MainUIController<UITextFieldDelegate>
{
    BOOL isShowPwd;
    NSInteger pageIndex;
    //for
//    KBKeyboardHandler *keyboard;
    UITextField *fieldSelect;
    float sH;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *view0;
@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UIView *view2;
@property (nonatomic, weak) IBOutlet UIView *view3;
@property (nonatomic, weak) IBOutlet UIView *view4;
@property (nonatomic, weak) IBOutlet UIView *view5;
@property (nonatomic, weak) IBOutlet UIView *view6;
@property (nonatomic, weak) IBOutlet UIView *view7;
@property (nonatomic, weak) IBOutlet UIView *view8;
@property (nonatomic, weak) IBOutlet UIView *view_delete_user;
@property (weak, nonatomic) IBOutlet UIView *view_Register_active;
@property (weak, nonatomic) IBOutlet UIView *view_active_account;
@property (weak, nonatomic) IBOutlet UIView *view11_email_active;

//for view 0
@property (nonatomic, weak) IBOutlet UILabel *lblTitle0;
@property (nonatomic, weak) IBOutlet UIView   *viewAppleID;
@property (nonatomic, weak) IBOutlet UIButton *btnAppleID;
@property (nonatomic, weak) IBOutlet UIView   *viewFace;
@property (nonatomic, weak) IBOutlet UIButton *btnFace;
@property (nonatomic, weak) IBOutlet UIView   *viewGG;
@property (nonatomic, weak) IBOutlet UIButton *btnGG;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIButton *btnPlayNow;
@property (weak, nonatomic) IBOutlet UIImageView *view0_hr;

//for view 1
@property (nonatomic, weak) IBOutlet UILabel *lblTitle1;
@property (nonatomic, weak) IBOutlet UIButton *btnBack1;
@property (nonatomic, weak) IBOutlet UIButton *btnSignIn;
@property (nonatomic, weak) IBOutlet UIButton *btnSignUp;
@property (nonatomic, weak) IBOutlet UIButton *btnShowPass;
@property (nonatomic, weak) IBOutlet UIButton *btnForgot;
@property (nonatomic, weak) IBOutlet UITextField *edtName;
@property (nonatomic, weak) IBOutlet UITextField *edtPass;

//for view 2
@property (nonatomic, weak) IBOutlet RTLabel *lblWelcome;
@property (nonatomic, weak) IBOutlet UIButton *btnLogout;
@property (nonatomic, weak) IBOutlet UIButton *view2_btn_requestactive;

//for view 3
@property (nonatomic, weak) IBOutlet UILabel *lblTitle3;
@property (nonatomic, weak) IBOutlet UITextField *edtPhone;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmit3;

//for view 4
@property (nonatomic, weak) IBOutlet UILabel *lblTitle4;
@property (nonatomic, weak) IBOutlet UILabel *lblSDT;
@property (nonatomic, weak) IBOutlet UILabel *lblPhone;
@property (nonatomic, weak) IBOutlet UITextField *edtCode;
@property (nonatomic, weak) IBOutlet RTLabel *lblHelpCode;
@property (nonatomic, weak) IBOutlet UIButton *btnGetCode4;
@property (nonatomic, weak) IBOutlet UIButton *btnActive4;

//for view 5 (link tai khoan)
@property (nonatomic, weak) IBOutlet UILabel *lblTitle5;
@property (nonatomic, weak) IBOutlet UITextField *edtIDLink;
@property (nonatomic, weak) IBOutlet UITextField *edtNewIDLink;
@property (nonatomic, weak) IBOutlet UITextField *edtPassLink;
@property (nonatomic, weak) IBOutlet UITextField *edtEmailLink;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmit5;
@property (nonatomic, weak) IBOutlet UILabel *lblNote5;

//for view 6 (kiểm tra trạng thái active của account)
@property (nonatomic, weak) IBOutlet UILabel *lblTitle6;
//@property (nonatomic, weak) IBOutlet UITextField *edtName6;
//@property (nonatomic, weak) IBOutlet UIButton *btnSubmit6;
@property (weak, nonatomic) IBOutlet UITextField *txtRecovery_username;
@property (weak, nonatomic) IBOutlet UITextField *txtRecovery_password;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioRecovery_email;
@property (weak, nonatomic) IBOutlet UIButton *btnRadioRecovery_phone;
@property (weak, nonatomic) IBOutlet UIButton *btnRecovery_submit;

//for view 7 (phục hồi tài khoản)
@property (nonatomic, weak) IBOutlet UILabel *lblTitle7;
@property (nonatomic, weak) IBOutlet UITextField *edtNewPass;
@property (nonatomic, weak) IBOutlet UITextField *edtNewPassAgain;
@property (nonatomic, weak) IBOutlet UITextField *edtOTP;
@property (nonatomic, weak) IBOutlet UIView *smsOTPView;
@property (weak, nonatomic) IBOutlet UIView *smsOTPView1;

@property (nonatomic, weak) IBOutlet UIButton *btnSubmit7;
@property (weak, nonatomic) IBOutlet UITextField *txtRecoveryOTP;
@property (weak, nonatomic) IBOutlet UILabel *lblRecovery_timer;

//for view 8 (đky tk)
@property (nonatomic, weak) IBOutlet UILabel *lblTitle8;
@property (nonatomic, weak) IBOutlet RTLabel *lblTerm;
@property (nonatomic, weak) IBOutlet UIButton *btnRegister;
@property (nonatomic, weak) IBOutlet UITextField *edtNameRegis;
@property (nonatomic, weak) IBOutlet UITextField *edtPassRegis;
@property (nonatomic, weak) IBOutlet UITextField *edtEmailRegis;

//view 9
@property (weak, nonatomic) IBOutlet UITextField *edtRegister_otp;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnActiveAccount_submit;
@property (weak, nonatomic) IBOutlet UILabel *lblView9_countdown;
@property (weak, nonatomic) IBOutlet UIImageView *imageView9_countdown;
@property (weak, nonatomic) IBOutlet UIButton *btnView9_resendOTP;


//view 10
@property (weak, nonatomic) IBOutlet UILabel *view10_lbl_username;
@property (weak, nonatomic) IBOutlet UITextField *view10_txt_email;
@property (weak, nonatomic) IBOutlet UILabel *view10_lbl_activeaccount;

@property (weak, nonatomic) IBOutlet UIButton *view10_btn_submit;
//view 11
@property (weak, nonatomic) IBOutlet UILabel *view11_lbl_username;
@property (weak, nonatomic) IBOutlet UILabel *view11_lbl_mail;
@property (weak, nonatomic) IBOutlet UIImageView *view11_img_otp_circle;
@property (weak, nonatomic) IBOutlet UILabel *view11_lbl_otp_countdown;
@property (weak, nonatomic) IBOutlet UIView *view11_view_otp;
@property (weak, nonatomic) IBOutlet UITextField *view11_txt_otp;
@property (weak, nonatomic) IBOutlet UIButton *view11_btn_resendotp;
@property (weak, nonatomic) IBOutlet UILabel *view11_lbl_activeaccount;
@property (weak, nonatomic) IBOutlet UIButton *view11_btn_submit;

//for view delete user
@property (weak, nonatomic) IBOutlet RTLabel *lblAlertDeleteUser;


- (void)OrientationDidChange:(NSNotification*)notification;

//begin or end editing all text field
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
@end
