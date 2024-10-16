//
//  GPayment.m
//  GinSDK
//
//  Created by Nero-Macbook on 9/7/23.
//

#import "GPayment.h"
#import "MBProgressHUD.h"
#import "SdkConfig.h"
#import "SdkHelper.h"
#import "MD5.h"
#import "ServerConnectionDelegate.h"
#import "GTrackingManager.h"
#import "AppleIAP.h"
#import "SdkLanguage.h"
#import "FacebookManager.h"
#import "TopWalletInfo.h"
#import "oPayViewController.h"
#import "GlobalVariable.h"

@interface GPayment()
{
    BOOL  iapProcessing;
    NSString *_extraInfo;
    UIViewController *loadingIndicator;
}

@end
static GPayment *sharedInstance;
@implementation GPayment
#pragma mark Singleton Methods
+ (GPayment *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
- (id) init
{
    self = [super init];
    self->iapProcessing = NO;
    return self;
}
- (void) showIAP:(IAPDataRequest *) iapData
{
    if(iapProcessing){
        NSString *msg =[NSString stringWithFormat:@"IAP Processing: %@", iapData.orderID];
        [self IAPInitDouble:@"-4" andErrorCode:msg];
        return;
    }
    [[AppleIAP sharedInstance] scanTransactionQueue];
    
    self->_isIAP = YES;
    self->iapProcessing = YES;
    self->_iAPDataRequest = iapData;
    self->_iAPDelegate = iapData.iAPDelegate;
    self->loadingIndicator = [self topViewController:_iAPDataRequest.mainViewController];
    [[SdkHelper sharedInstance] runInMainThread:^{
        [MBProgressHUD showHUDAddedTo:self->loadingIndicator.view animated:YES];
    }];
    
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSString *ClientID      = _sdkConfig.clientID;
    NSString *ServiceID     = _sdkConfig.serviceID;
    NSString *ServiceKey    = _sdkConfig.serviceKey;
    NSString *Platform      = @"ios";
    //truyen len tu game client
    NSString *Username      = _sdkConfig.username;
    NSString *OrderID       = iapData.orderID;
    NSString *OrderInfo     = iapData.orderInfo;
    NSString *Server        = iapData.serverID;
    NSString *Amount        = iapData.amount;
    NSString *Character     = iapData.character;
    NSString *ExtraInfo     = iapData.extraInfo;
    self->_extraInfo = ExtraInfo;
    NSString *ProductId     = iapData.appleProductId;
    NSString *RedirectUrl   = @"";
    NSString *PackageName   = [[NSBundle mainBundle] bundleIdentifier];
    //tao chu ky
    NSString *Method        = @"apple";
    NSString *Signature     = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",ClientID,ServiceID,OrderID,Amount,Method,RedirectUrl,ServiceKey];
    Signature = [MD5 md5:Signature];
    
    NSDictionary *initIAPDatas = @{
        @"UserName"     :Username,
       @"ClientID"     :ClientID,
       @"ServiceID"    :ServiceID,
       @"OrderID"      :OrderID,
       @"OrderInfo"    :OrderInfo,
       @"PaymentMethod":Method,
       @"RedirectUrl"  :RedirectUrl,
       @"Signature"    :Signature,
       @"ProductId"    :ProductId,
       @"PackageName"  :PackageName,
       @"Server"       :Server,
       @"Character"    :Character,
       @"Amount"       :Amount,
       @"Platform"     :Platform,
       @"ExtraInfo"    :ExtraInfo
    };
    NSLog(@"initIAPDatas = %@",initIAPDatas);
    dispatch_block_t block = ^{
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect IAPInitRequest:iapData andDataResponse:^(IAPDataResponse *iapDataResponse) {
            if([iapDataResponse.status isEqualToString:@"success"])
            {
                [[GTrackingManager sharedInstance] checkout:OrderID andProductId:ProductId andAmount:Amount andCurrency:_sdkConfig.currency andUsername:Username];
                
                UserRequireData *userRequireData = [UserRequireData sharedInstance:YES];
                userRequireData.orderID = iapDataResponse.orderID;
                NSDictionary *transactionData = nil;
                if(iapDataResponse.transactionData && [iapDataResponse.transactionData count] > 0) {
                    transactionData = iapDataResponse.transactionData[0];
                }
                @try {
                    int walletStatus = [[transactionData objectForKey:@"s"] intValue];
                    float labelBalance = [[transactionData objectForKey:@"b"] floatValue];
                    if(![[SdkConfig sharedInstance].environment isEqual:@"submit"] && walletStatus == 1 && labelBalance > 0) {
                        self->iapProcessing = NO;
                        TopWalletInfo *topWalletInfo = [[TopWalletInfo alloc] init];
                        topWalletInfo.transactionHashKey = [transactionData objectForKey:@"h"];
                        topWalletInfo.status = [transactionData objectForKey:@"s"];
                        topWalletInfo.labelTitle = [transactionData objectForKey:@"t"];
                        topWalletInfo.message = [transactionData objectForKey:@"m"];
                        topWalletInfo.labelPrice = [[transactionData objectForKey:@"a"] floatValue];
                        topWalletInfo.labelBalance = [[transactionData objectForKey:@"b"] floatValue];
                        topWalletInfo.transactionID = [transactionData objectForKey:@"transactionId"];
                        topWalletInfo.orderID = OrderID;
                        topWalletInfo.productID = ProductId;
                        [self showPayView:topWalletInfo];
                    } else {
                        [self inAppStartPurchase];
                    }
                } @catch (NSException *exception) {
                    [self->_iAPDelegate IAPInitFailed:@"SV-1" andErrorCode:@"Transaction is empty"];
                }
            } else {
                NSString *msg = [[SdkLanguage sharedInstance] translate:@"t_iap_002"];
                [self IAPInitFailed:msg andErrorCode:@"APPLE02"];
            }
        }];
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    
}

- (void) inAppStartPurchase
{
    if(self->_iAPDataRequest) {
        dispatch_block_t block = ^{
            NSString *msg = [[SdkLanguage sharedInstance] translate:@"t_iap_003"];
            [[AppleIAP sharedInstance] startPurchase:[self->_iAPDataRequest appleProductId] andSuccess:^(NSString *code, NSString *transactionId) {
                @try {
                    [self IAPVerifyTransaction:transactionId];
                } @catch (NSException *exception) {
                    [self IAPInitFailed:msg andErrorCode:code];
                    [self sdkLog:@G_IAP_APP_ERROR andData:@{
                        @"orderId": self->_iAPDataRequest.orderID ? self->_iAPDataRequest.orderID: @"",
                        @"roleId": self->_iAPDataRequest.character,
                        @"code": code,
                        @"message": exception.description,
                        @"exception": @"IAPVerifyTransaction",
                        @"platform": @"ios"
                    }];
                }
            } andFailed:^(NSString *code, NSString *message) {
                [self IAPInitFailed:message andErrorCode:code];
                [self sdkLog:@G_IAP_APP_ERROR andData:@{
                    @"orderId": self->_iAPDataRequest.orderID ? self->_iAPDataRequest.orderID: @"",
                    @"roleId": self->_iAPDataRequest.character,
                    @"code": code,
                    @"message": message,
                    @"platform": @"ios"
                }];
            }];
        };
        if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

- (void) IAPVerifyTransaction:(NSString *)transactionId
{
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSURL *receiptURL       = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt         = [NSData dataWithContentsOfURL:receiptURL];
    NSString *ReceiptData   = [receipt base64EncodedStringWithOptions:0];
    NSString *TransactionID = transactionId;
    NSString *ClientID      = _sdkConfig.clientID;
    NSString *ServiceID     = _sdkConfig.serviceID;
    NSString *ServiceKey    = _sdkConfig.serviceKey;
    NSString *OrderID       = self->_iAPDataRequest.orderID;
//    NSString *PartnerKey    = self->_iAPDataRequest.applesharesecret;
    NSString *Signature     = [NSString stringWithFormat:@"%@%@%@%@",ClientID,ServiceID,OrderID,ServiceKey];
    Signature = [MD5 md5:Signature];
    
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    userRequireData.username = _sdkConfig.username;
    userRequireData.transactionID = TransactionID;
    userRequireData.OrderToken = ReceiptData;
    userRequireData.ServiceEmail = @"";
    userRequireData.ExtraInfo = self->_extraInfo;
    userRequireData.ResultCode = 1;
    userRequireData.ErrorMessage = @"";
    userRequireData.AccessToken = _sdkConfig.accesstoken;
    userRequireData.orderID = OrderID;
    
    if(self->_isIAP) {
        [[GTrackingManager sharedInstance] purchase:OrderID
                                       andProductId:self->_iAPDataRequest.appleProductId
                                          andAmount:self->_iAPDataRequest.getAmount
                                        andCurrency:_sdkConfig.currency
                                        andUsername:self->_iAPDataRequest.getUsername];
    }
    
    
    userRequireData.callback = ^(IAPDataResponse *iapDataResponse) {
        NSString *msg = iapDataResponse.message;
        self->iapProcessing = NO;
        if([iapDataResponse.status isEqualToString:@"success"])
        {
            if(!self->_isIAP) {
                [[GTrackingManager sharedInstance] purchase:OrderID
                           andProductId:self->_iAPDataRequest.appleProductId
                              andAmount:self->_iAPDataRequest.getAmount
                            andCurrency:_sdkConfig.currency
                            andUsername:self->_iAPDataRequest.getUsername
                            andIsIAP:NO
                    ];
            }
            [[FacebookManager sharedInstance] FBLogPurchase:[self->_iAPDataRequest.amount doubleValue]
                                                andCurrency:[SdkConfig sharedInstance].currency];
            [self IAPCompleted:msg];
        } else {
            [self IAPPurchaseFailed:msg andErrorCode:[NSString stringWithFormat:@"%d",iapDataResponse.code]];
            [self sdkLog:@G_IAP_VERIFY_ERROR andData:@{
                @"request": @{
                    @"transactionId": transactionId,
                    @"orderId": self->_iAPDataRequest.orderID,
                    @"productId": self->_iAPDataRequest.appleProductId,
                    @"username": self->_iAPDataRequest.username,
                    @"platform": @"ios"
                },
                @"response": @{
                    @"status": iapDataResponse.status ? iapDataResponse.status: @"",
                    @"message": iapDataResponse.message ? iapDataResponse.message : @"",
                    @"code": iapDataResponse.code ? [NSString stringWithFormat:@"%d",iapDataResponse.code]: @""
                },
                @"roleId": self->_iAPDataRequest.character,
                @"platform": @"ios"
            }];
        }
    };
    dispatch_block_t block = ^{
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect IAPVerifyTransaction:_sdkConfig andUserRequireData:userRequireData];
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

-(void)verifyPayConfirm:(TopWalletInfo *)payInfo
{
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    NSString *transactionID = payInfo.transactionID;
    NSString *ClientID      = _sdkConfig.clientID;
    NSString *ServiceID     = _sdkConfig.serviceID;
    NSString *ServiceKey    = _sdkConfig.serviceKey;
    NSString *OrderID       = self->_iAPDataRequest.orderID;
    NSString *Signature     = [NSString stringWithFormat:@"%@%@%@%@",ClientID,ServiceID,OrderID,ServiceKey];
    Signature = [MD5 md5:Signature];
    
    UserRequireData *userRequireData = [UserRequireData sharedInstance];
    userRequireData.username = _sdkConfig.username;
    userRequireData.transactionID = transactionID;
    userRequireData.OrderToken = payInfo.transactionHashKey;
    userRequireData.ServiceEmail = @"";
    userRequireData.ExtraInfo = self->_extraInfo;
    userRequireData.ResultCode = 1;
    userRequireData.ErrorMessage = @"";
    userRequireData.AccessToken = _sdkConfig.accesstoken;
    userRequireData.orderID = OrderID;
    userRequireData.callback = ^(IAPDataResponse *iapDataResponse) {
        NSString *msg = iapDataResponse.message;
        self->iapProcessing = NO;
        if([iapDataResponse.status isEqualToString:@"success"])
        {
            [[GTrackingManager sharedInstance] purchase:OrderID
                                           andProductId:self->_iAPDataRequest.appleProductId
                                              andAmount:self->_iAPDataRequest.getAmount
                                            andCurrency:_sdkConfig.currency
                                            andUsername:self->_iAPDataRequest.getUsername
                                            andIsIAP:NO];
            
            [[FacebookManager sharedInstance] FBLogPurchase:[self->_iAPDataRequest.amount doubleValue] andCurrency:[SdkConfig sharedInstance].currency];
            [self IAPCompleted:msg];
        } else {
            [self IAPPurchaseFailed:msg andErrorCode:[NSString stringWithFormat:@"%d",iapDataResponse.code]];
            [self sdkLog:@G_IAP_VERIFY_ERROR andData:@{
                @"request": @{
                    @"transactionId": transactionID,
                    @"orderId": self->_iAPDataRequest.orderID,
                    @"productId": self->_iAPDataRequest.appleProductId,
                    @"username": self->_iAPDataRequest.username
                },
                @"response": @{
                    @"status": iapDataResponse.status ? iapDataResponse.status: @"",
                    @"message": iapDataResponse.message ? iapDataResponse.message : @"",
                    @"code": iapDataResponse.code ? [NSString stringWithFormat:@"%d",iapDataResponse.code]: @""
                },
                @"roleId": self->_iAPDataRequest.character,
                @"platform": @"ios"
            }];
        }
    };
    dispatch_block_t block = ^{
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect IAPVerifyTransaction:_sdkConfig andUserRequireData:userRequireData];
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void) showPayView:(TopWalletInfo *)topWalletInfo
{
    [[SdkHelper sharedInstance] runInMainThread:^{
        [MBProgressHUD hideHUDForView:self->loadingIndicator.view animated:YES];
    }];
    @try {
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDKDataResource" withExtension:@"bundle"]];
        oPayViewController *controller = [[oPayViewController alloc] initWithNibName:@"oPayViewController" bundle:bundle];
        controller.payInfo = topWalletInfo;
        [controller OrientationDidChange:nil];
        controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [_iAPDataRequest.mainViewController presentViewController:controller animated:YES completion:nil];
        [self sdkLog:@G_IAP_UI_SHOW andData:@{
            @"transactionId": topWalletInfo.transactionID,
            @"orderId": self->_iAPDataRequest.orderID,
            @"productId": self->_iAPDataRequest.appleProductId,
            @"username": self->_iAPDataRequest.username,
            @"roleId": self->_iAPDataRequest.character,
            @"platform": @"ios"
        }];
    } @catch (NSException *exception) {
        @try {
            id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
            [connect sdkLog:[SdkConfig sharedInstance].clientID andActiveKey:@G_IAP_UI_SHOW_ERROR andData:@{
                @"transactionId": [topWalletInfo getTransactionID],
                @"productId": self->_iAPDataRequest.appleProductId,
                @"username": self->_iAPDataRequest.username,
                @"roleId": self->_iAPDataRequest.character,
                @"exception": exception.description,
                @"platform": @"ios"
            }];
        } @catch (NSException *eLog) {}
        
    }
    
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
- (void) IAPInitDouble:(NSString *)message andErrorCode:(NSString *)errorCode
{
    if(self->_iAPDelegate) {
        [self->_iAPDelegate IAPInitFailed:message andErrorCode:errorCode];
    } else {
        NSLog(@"IAP IAPInitFailed: %@ (%@)", message, errorCode);
    }
}
- (void) IAPInitFailed:(NSString *)message andErrorCode:(NSString *)errorCode
{
    self->iapProcessing = NO;
    [[SdkHelper sharedInstance] runInMainThread:^{
        [MBProgressHUD hideHUDForView:self->loadingIndicator.view animated:YES];
    }];
    if(self->_iAPDelegate) {
        [self->_iAPDelegate IAPInitFailed:message andErrorCode:errorCode];
        self->_iAPDelegate = nil;
    } else {
        NSLog(@"IAP IAPInitFailed: %@ (%@)", message, errorCode);
    }
}
- (void) IAPPurchaseFailed:(NSString *)message andErrorCode:(NSString *)errorCode
{
    self->iapProcessing = NO;
    [[SdkHelper sharedInstance] runInMainThread:^{
        [MBProgressHUD hideHUDForView:self->loadingIndicator.view animated:YES];
    }];
    if(self->_iAPDelegate) {
        [self->_iAPDelegate IAPPurchaseFailed:message andErrorCode:errorCode];
        self->_iAPDelegate = nil;
    } else {
        NSLog(@"IAP IAPPurchaseFailed: %@ (%@)", message, errorCode);
    }
}
- (void) IAPCompleted:(NSString *)message
{
    self->iapProcessing = NO;
    [[SdkHelper sharedInstance] runInMainThread:^{
        [MBProgressHUD hideHUDForView:self->loadingIndicator.view animated:YES];
    }];
    if(self->_iAPDelegate) {
        [self->_iAPDelegate IAPCompleted:message];
        self->_iAPDelegate = nil;
    } else {
        NSLog(@"IAP IAPCompleted: %@", message);
    }
}

- (void) sdkLog:(NSString *)activeKey andData:(NSDictionary *)data
{
    @try {
        SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect sdkLog:[SdkConfig sharedInstance].clientID andActiveKey:activeKey andData:data andUsername:_sdkConfig.username];
    } @catch (NSException *exception) {
        NSLog(@"SDKLog Error = %@", exception);
    }
}
- (void) paymenCancel
{
//    [self IAPPurchaseFailed:[[SdkLanguage sharedInstance] translate:@"t_iap_007"] andErrorCode:@"-1"];
}

- (void)terminateIAP
{
    [[AppleIAP sharedInstance] terminateIAP];
}
@end
