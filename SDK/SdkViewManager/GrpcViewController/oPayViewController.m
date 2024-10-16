//
//  oPayViewController.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/3/22.
//

#import <Foundation/Foundation.h>
#import "oPayViewController.h"
#import <objc/runtime.h>
#import "GlobalVariable.h"
#import "GPayment.h"
#import "SdkHelper.h"
#import "SdkLanguage.h"
#import "SdkConfig.h"
#import "ServerConnectionDelegate.h"

@implementation oPayViewController

- (IBAction)clickPayIAP:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [GPayment sharedInstance].isIAP = YES;
        [[GPayment sharedInstance] inAppStartPurchase];
        [self sdkLog:@G_IAP_UI_INAPP];
    }];
}
- (IBAction)clickPayConfirm:(id)sender {
    if(_payInfo.status) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"click Confirm successed");
            [GPayment sharedInstance].isIAP = NO;
            [[GPayment sharedInstance] verifyPayConfirm:self->_payInfo];
            [self sdkLog:@G_IAP_UI_W];
        }];
    } else {
        [[SdkHelper sharedInstance] showAlertMessage:self andWithTitle:[[SdkLanguage sharedInstance] translate:@"t_alert_001"] andWithMessage:_payInfo.message andCallback:nil];
    }
}
- (IBAction)clickPayClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"click Close successed");
        [[GPayment sharedInstance] paymenCancel];
        [self sdkLog:@G_IAP_UI_CANCELLED];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"test: viewDidLoad");
//    self.modalPresentationStyle = UIModalPresentationCustom;
    self.view.frame = [UIScreen mainScreen].bounds;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
//    self.view.backgroundColor = UIColor.redColor;
    _view_pay.backgroundColor = UIColorFromRGB(0xFFFFFF, 0.1f);
    
    _view_pay_container.layer.cornerRadius = 15;
    _view_pay_container.layer.borderWidth = 1.0f;
    _view_pay_container.layer.borderColor = UIColorFromRGB(0x222222, 0.5f).CGColor;
    
    _btn_pay_confirm.backgroundColor = UIColorFromRGB(0x07A7F4, 1.0f);
    _btn_pay_confirm.layer.borderColor = UIColorFromRGB(0x07A7F4, 1.0f).CGColor;
    _btn_pay_confirm.layer.cornerRadius = 20;
    _btn_pay_confirm.layer.borderWidth = 2.0f;
    _btn_pay_iap.layer.borderColor = UIColorFromRGB(0x07A7F4, 0.85f).CGColor;
    _btn_pay_iap.layer.cornerRadius = 20;
    _btn_pay_iap.layer.borderWidth = 2.0f;
    
    [self reRenderView];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    NSLog(@"_payInfo = %@", _payInfo);
    NSString *balan = [NSString stringWithFormat:@"%ld", (long)(_payInfo.labelBalance)];
    NSString *price = [NSString stringWithFormat:@"%ld", (long)(_payInfo.labelPrice)];
    NSString *priceLable = [NSString stringWithFormat:@"<font face='HelveticaNeue' size=16 color='#222222'>%@</font><font face='HelveticaNeue' size=16 color='#e99215'><b>%@ G</b></font>", [[SdkLanguage sharedInstance] translate:@"t_iap_011"],price];
    NSString *blanceLabel = [NSString stringWithFormat:@"<font face='HelveticaNeue' size=16 color='#222222'>%@</font><font face='HelveticaNeue' size=16 color='#e99215'><b>%@ G</b></font>", [[SdkLanguage sharedInstance] translate:@"t_iap_014"], balan];
    NSString *btnTextPayIap = [[SdkLanguage sharedInstance] translate:@"t_iap_012"];
    NSString *btnTextPayW = [[SdkLanguage sharedInstance] translate:@"t_iap_013"];
    [self setRTLabel:_lbl_price andText:priceLable];
    [self setRTLabel:_lbl_sodu andText:blanceLabel];
    [_btn_pay_iap setTitle:btnTextPayIap forState:UIControlStateNormal];
    [_btn_pay_confirm setTitle:btnTextPayW forState:UIControlStateNormal];
    
//    [self reRenderView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) setRTLabel:(UIView *)viewLbale andText:(NSString *)text
{
    RTLabel *rtLB = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, viewLbale.frame.size.width, viewLbale.frame.size.height)];
    rtLB.textAlignment = RTTextAlignmentCenter;
    [rtLB setText:text];
    [viewLbale addSubview:rtLB];
}
-(void)OrientationDidChange:(NSNotification*)notification
{
//    [self reRenderView];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self reRenderView];
}

-(void)reRenderView
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    float maxWidth = 400;
    float maxHeight = 227;
    frame = _view_pay.frame;
    if(maxWidth > size.width) {
        maxWidth = size.width;
    }
    if(maxHeight > size.height) {
        maxHeight = size.height;
    }
    maxWidth = maxWidth - 40;
    frame.origin.x = (size.width - maxWidth)/2;
    frame.origin.y = (size.height - maxHeight)/2;
    frame.size.width = maxWidth;
    frame.size.height = maxHeight;
    _view_pay.frame = frame;
    
    frame = _view_pay_wrap.frame;
    frame.size.width = _view_pay.frame.size.width;
    frame.size.height = _view_pay.frame.size.height;
    _view_pay_wrap.frame = frame;
    
    frame = _view_pay_container.frame;
    frame.size.width = _view_pay_wrap.frame.size.width;
    frame.size.height = _view_pay_wrap.frame.size.height;
    _view_pay_container.frame = frame;
    
    frame = _view_pay_close.frame;
    frame.origin.x = maxWidth-30;
    frame.origin.y = 8;
    _view_pay_close.frame = frame;
    
    frame = _lbl_price.frame;
    frame.size.width = _view_pay_wrap.frame.size.width;
    _lbl_price.frame = frame;
    
    frame = _lbl_sodu.frame;
    frame.size.width = _view_pay_wrap.frame.size.width;
    _lbl_sodu.frame = frame;
    
    float maxWidthControl = _view_pay_container.frame.size.width;
    maxWidthControl = maxWidthControl*80/100;
    frame = _view_pay_control.frame;
    frame.size.width = maxWidthControl;
    frame.origin.x = (_view_pay_container.frame.size.width-maxWidthControl)/2;
    _view_pay_control.frame = frame;
    
    frame = _btn_pay_iap.frame;
    frame.size.width = _view_pay_control.frame.size.width;
    _btn_pay_iap.frame = frame;
    frame = _btn_pay_confirm.frame;
    frame.size.width = _view_pay_control.frame.size.width;
    _btn_pay_confirm.frame = frame;
}


- (void) sdkLog:(NSString *)activeKey
{
    @try {
        SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect sdkLog:[SdkConfig sharedInstance].clientID andActiveKey:activeKey andData:@{
            @"transactionID": [_payInfo getTransactionID],
            @"username": _sdkConfig.username,
            @"orderID": [_payInfo getOrderID],
            @"productID": [_payInfo getProductID],
            @"platform": @"ios"
        } andUsername:_sdkConfig.username];
    } @catch (NSException *exception) {
        
    }
}
@end
