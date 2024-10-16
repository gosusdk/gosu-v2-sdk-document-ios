//
//  oPayViewController.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/3/22.
//

#import <UIKit/UIKit.h>
#import "MainUIController.h"
#import "TopWalletInfo.h"
@interface oPayViewController : MainUIController
{
    
}

@property (nonatomic, strong) TopWalletInfo *payInfo;

@property (weak, nonatomic) IBOutlet UIView *view_pay;
@property (weak, nonatomic) IBOutlet UIView *view_pay_wrap;
@property (weak, nonatomic) IBOutlet UIView *view_pay_container;
@property (weak, nonatomic) IBOutlet UIView *view_pay_close;
@property (weak, nonatomic) IBOutlet UIView *lbl_price;
@property (weak, nonatomic) IBOutlet UIView *lbl_sodu;
@property (weak, nonatomic) IBOutlet UIView *view_pay_control;
@property (weak, nonatomic) IBOutlet UIButton *btn_pay_iap;
@property (weak, nonatomic) IBOutlet UIButton *btn_pay_confirm;

- (void)OrientationDidChange:(NSNotification*)notification;
@end
