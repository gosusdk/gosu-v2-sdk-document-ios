//
//  MainViewController.m
//  DemoGosuSDK
//
//  Created by Phan Phuoc Luong on 11/25/15.
//  Copyright © 2015 Phan Phuoc Luong. All rights reserved.
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE (!IS_IPAD)

#import "MainViewController.h"
#import "GosuSDK.h"

@interface MainViewController ()<LoginDelegate, LogoutDelegate,IAPDelegate>

@end

@implementation MainViewController

#pragma Login Delegate
- (void)loginSuccess:(NSString *)userID andUserName:(NSString *)userName andAccessToken:(NSString *)access_token
{
    //result for game
    /*
     userID
     userName
     access_token
     */
    _userID         = userID;
    _userName       = userName;
    _access_token   = access_token;
    NSLog(@"loginSuccess = %@", userName);
    dispatch_block_t block = ^{
        //======== TEST =========//
        /*
        GameInfo *info = [GosuSDK sharedInstance].gameInfo;
        NSLog(@"ProviderID = %@, userID = %@, userName=%@", info.providerid, userID, userName);
         */
        
        //=== use for testDemo SDK ===//
        if (true) {
            self.lblName.text = userID;
            //set hidden all button
            [self.viewVaoGame setHidden:YES];
            [self.btn_report setHidden:NO];
            [self.btn_shareVideo setHidden:NO];
            [self.btn_clear setHidden:NO];
            [self.btn_IAP setHidden:NO];
            
            [self.btn_clear setTitle:@"(9) Logout" forState:UIControlStateNormal];
            
            [self callGTrackingExample];
        }
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)loginFail:(NSString *)message
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Fail" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
#pragma Logout Delegate
- (void) logoutSuccess{
    dispatch_block_t block = ^{
        NSLog(@"Logout thanh cong");
        
        [self->_viewVaoGame setHidden:NO];
        [self->_btn_report setHidden:YES];
        [self->_btn_shareVideo setHidden:YES];
        [self->_btn_clear setHidden:YES];
        [self->_btn_IAP setHidden:YES];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)logoutFail:(NSString *)message {
    NSLog(@"logout fail");
}

- (void)viewDidLoad
{
    NSLog(@"load view");
    [super viewDidLoad];
    [GosuSDK sharedInstance].delegate = self;
    
    //set hidden all button
    [_btn_report setHidden:YES];
    [_btn_shareVideo setHidden:YES];
    [_btn_clear setHidden:YES];
    [_btn_IAP setHidden:YES];
    [_aiv_loading stopAnimating];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayFCMToken:) name:@"FCMToken" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void) displayFCMToken:(NSNotification *) notification {
    NSString* message = [NSString stringWithFormat:@" FCM token: %@ ", notification.userInfo[@"token"]];
    NSLog(@"%@", message);
    //_edtTokenPush.hidden = NO;
    //_edtTokenPush.text = message;
    //[_edtTokenPush sizeToFit];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)OrientationDidChange:(NSNotification*)notification
{
    //    CGSize size = [[UIScreen mainScreen] bounds].size;
    //    CGRect frame = self.view.frame;
    //    if(size.width == frame.size.width)
    //        return;
    
    //NSLog(@"w = %f, h = %f", size.width, size.height);
}

//=========== Payment Apple IAP ==============//
- (IBAction) callIAP:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select ProductID" delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:
                            @"ProductID 1 ($0.99)",
                            @"ProductID 2 ($1.99)",
                            @"ProductID 3 ($2.99)",
                            nil];
    if(!IS_IPAD)
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    else
        [popup showFromRect:_btn_IAP.frame inView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex >= 3)
        return;
    
    NSString *productID = @"com.gmstd.theshams.pack1"; //649
    productID = @"package.1"; //616
    productID = @"com.mystic.realms.gp1";
    /* password from apple share secret (chuỗi thông tin khi tạo các gói Automatically Renewable Subscription) - dùng để verify iap, trường hợp không phải gói Automatically Renewable Subscription thì để trống */
    NSString *appleSecret = @"";
    //orderID was gernarate from server game and only one (mã hoá đơn là duy nhất không được trùng)
    NSString *orderID = [NSString stringWithFormat:@"%i_10095276_2_13_11", (int)[[NSDate date] timeIntervalSince1970]];
    //description package will purchase (mô tả gói cần mua)
    NSString *orderInfo = @"Item 300 gold";
    //amount
    NSString *amount = @"0.99";//this is amount of money (VNĐ)
    switch (buttonIndex) {
        case 0:
            amount = @"22000";
            orderInfo = @"Item 200 gold";
            break;
        case 1:
            amount = @"45000";
            orderInfo = @"Item 700 gold";
            break;
        case 2:
            amount = @"69000";
            orderInfo = @"Item 1000 gold";
            break;
    }
//    amount = @"25000";
    amount = @"0,99";
    orderInfo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)orderInfo, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    //server
    NSString *server = @"22";
    NSString *character = @"Character_Name";
    NSString *extraInfo = @"Extra_Info";
    //Show log value of parameters
    NSLog(@"product_id:%@, apple_secret:%@, order_id:%@, orderInfo:%@, amount:%@, server:%@, username:%@", productID, appleSecret, orderID, orderInfo, amount, server, _userName);
    //
    NSNumber *amountNumber = [[[NSNumberFormatter alloc] init] numberFromString:amount];
    NSDictionary *a = @{
        @"totalValue": amountNumber
    };
    IAPDataRequest *iapData = [[IAPDataRequest alloc] initWithData:_userName andOrderId:orderID andOrderInfo:orderInfo andServerID:server andAmount:amount andAppleProductID:productID andAppleShareSecrect:appleSecret andRoleID:character andExtraInfo:extraInfo];
    [[GosuSDK sharedInstance] showIAP:(IAPDataRequest *)iapData andMainView:self];
    
}
- (void) IAPInitFailed:(NSString *)message andErrorCode:(NSString *)errorCode
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Init IAP Failed!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
- (void) IAPPurchaseFailed:(NSString *)message andErrorCode:(NSString *)errorCode
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase IAP Failed!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
- (void) IAPCompleted:(NSString *)message
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Success!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void) loadAppleItemInfo
{
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (NSString *invalidId in response.invalidProductIdentifiers) {
        NSLog(@"Item invalid %@", invalidId);
        //show invalid
        break;
    }
    
    NSArray *rsProduct = response.products;
    for(SKProduct *product in rsProduct){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        NSLog(@"ProductId: %@ - Price: %@", product.productIdentifier, formattedPrice);
        //
        //update Game UI with price, currency, ...
    }
}

#pragma Click PlayGame
- (IBAction) call_VaoGame:(id)sender
{
    //    [_viewVaoGame setHidden:YES];
    //    [[GameSDK sharedInstance] showSignInView:self andResultDelegate:self];
    
    [[GosuSDK sharedInstance] showSignIn];
}

#pragma Logout
- (IBAction) call_refresh:(id)sender
{
    _lblName.text = @"";
//    [[GosuSDK sharedInstance] logout];
//    [[GosuSDK sharedInstance] showSignIn];
    
    
    @try {
        @[][1];
    } @catch (NSException *exception) {
        [[GTrackingManager crashlytics] setUserId:@"123456"];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-9001 userInfo:nil];
        [[GTrackingManager crashlytics] crashLog:error andLogMessage:@"day la test crash" andData:@{
            @"iap_data": @"produc_123",
            @"role_name": @"role 122222"
        }];
    }
}

- (IBAction)call_invitefriends:(id)sender
{
    
}

- (IBAction) call_sharePhoto:(id)sender
{
    NSURL *photoURL = [NSURL URLWithString:@"http://taikinh.vn/cpanel/static/uploads/hinh-the-tuong_360x469/bach-ho_1.png"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:data];
    //maybe you can load image from your device to share
    
}

- (IBAction) call_shareLink:(id)sender
{
    [[GosuSDK sharedInstance] deleteAccount:^(NSDictionary<NSString *,id> *callback) {
        NSLog(@"delete account = %@",callback);
    } andWithDialog:YES];
    //    [[GosuSDK sharedInstance] FirebaseSubscribeToTopic:@"titi"];
    NSLog(@"Nero FirebaseSubscribeToTopic");
}

- (IBAction) call_shareVideo:(id)sender
{
    
}

- (IBAction) call_appopenreport:(id)sender
{
    NSString *serverID = @"1";
    NSString *roleID = @"1234567";
    NSString *roleName = @"Hoàng Thanh Hà";
    //encode roleName
    roleName = [roleName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //call to SDK
    [[GosuSDK GTracking] doneNRU:serverID andRoleId:roleID andRoleName:roleName];
}

- (IBAction) call_Floating:(id)sender
{
}

- (void) callGTrackingExample {
    //tracking start trial
    [[GosuSDK GTracking] trackingStartTrial];
    
    //tracking Turial Completion
    [[GosuSDK GTracking] trackingTurialCompleted];
    
    [[GosuSDK GTracking] trackingEvent:@"level_20"];
    
    [[GosuSDK GTracking] trackingEvent:[NSString stringWithFormat:@"level_%d", 20]];
    
//    [[GosuSDK GTracking] doneNRU:@"server_id" andRoleId:@"role_id" andRoleName:@"role_name"];
    
    [[GosuSDK GTracking] trackingEvent:@"level_20" withValues:@{@"customerId": @"12345"}];
    
    [[GosuSDK GTracking] trackingEvent:@"user_checkinday_1"];
    
   
    [[GosuSDK GTracking] createNewCharacter:@"server01" andRoleId:@"character01" andRoleName:@"character01Name"];
    [[GosuSDK GTracking] enterGame:@"toantest" characterID:@"character01" characterName:@"character01Name" serverInfo:@"server01"];
    [[GosuSDK GTracking] startTutorial: @"user01"  andCharacterID:@"character01" andCharacterName:@"character01Name" andServerInfo:@"server01"];
    [[GosuSDK GTracking] completeTutorial: @"user01"  andCharacterID:@"character01" andCharacterName:@"character01Name" andServerInfo:@"server01"];
    [[GosuSDK GTracking] checkout:@"orderid_001" andProductId:@"product_id001" andAmount:@"10000" andCurrency:@"VND" andUsername:@"toantest"];
    [[GosuSDK GTracking] purchase:@"orderid_001" andProductId:@"product_id001" andAmount:@"10000" andCurrency:@"VND" andUsername:@"toantest"];
    [[GosuSDK GTracking] levelUp:@"toantest" characterID:@"character01" serverInfo:@"server01" level:10];
    [[GosuSDK GTracking] vipUp:@"toantest" characterID:@"character01" serverInfo:@"server01" vipLevel:2];
    [[GosuSDK GTracking] useItem:@"toantest" characterID:@"character01" serverInfo:@"server01" itemID:@"item01" quantity:1];
    [[GosuSDK GTracking] trackActivityResult:@"toantest" characterID:@"character01" serverInfo:@"server01" activityID: @"activityid_01" activityResult:@"success!"];
    [[GosuSDK GTracking] trackingEvent:@"user_checkinday_1"];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
