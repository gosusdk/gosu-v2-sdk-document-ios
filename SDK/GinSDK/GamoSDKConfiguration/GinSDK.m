//
//  GinSDK.m
//  GinSDK
//
//  Created by Nero-Macbook on 3/26/22.
//

#import "GinSDK.h"
#import "SdkConfig.h"
#import "SdkContainer.h"
#import "GrpcViewController.h"
#import "SdkHelper.h"
#import "SdkLanguage.h"
#import "GoogleSignInManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "oPayViewController.h"
#import "ServerFactory.h"
#import "GamoGrpcApi.h"
#import "GPayment.h"

@interface GinSDK()
@end
static GinSDK *sharedInstance;

@implementation GinSDK

#pragma mark Singleton Methods
+ (GinSDK *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil){
            sharedInstance = [[super alloc] init];
            [ServerFactory sharedInstance:[[GamoGrpcApi alloc] init]];
        }
    }
    return sharedInstance;
}

#pragma mark - Show LoginView
- (void)showSignInView:(UIViewController *)viewParent andResultDelegate:(id<LoginDelegate>) loginResultDelegate
{
    @try {
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDKDataResource" withExtension:@"bundle"]];
        
        GrpcViewController *controller = [[GrpcViewController alloc] initWithNibName:@"GrpcViewController" bundle:bundle];
        controller.loginDelegate = loginResultDelegate;
        [[KGModal sharedInstance] showWithContentViewController:controller andAnimated:YES];
    } @catch (NSException *exception) {
        [loginResultDelegate loginFail:@"fail"];
    }
}
- (void) IDSignOut:(id<LogoutDelegate>) logoutDelegate
{
    MainUIController *mainUI = [[MainUIController alloc] init];
    mainUI.logoutDelegate = logoutDelegate;
    [mainUI signOutRequest:^{
        
    }];
}

- (void) showIAP:(IAPDataRequest *) iapData andMainView:(UIViewController *) mainView andIAPDelegate:(id<IAPDelegate>) iAPDelegate
{
    SdkConfig *sdkConfig = [SdkConfig sharedInstance];
    if (!sdkConfig.serverIsReady) {
        [[SdkHelper sharedInstance]
                showAlertMessage:mainView
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:@"Sorry, Server is busy."
         andCallback:nil];
        return;
    } else if (!sdkConfig.isProductReady)
    {
        [[SdkHelper sharedInstance]
                showAlertMessage:mainView
         andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
         andWithMessage:@"Sorry, Server is busy(product list is empty)."
         andCallback:nil];
        return;
    } else {
        SdkConfig *sdkConfig = [SdkConfig sharedInstance];
        NSString *msg = @"";
        BOOL isValid = true;
        if(!iapData.appleProductId)
        {
            msg = @"ProductID is nil, please check your data.";
            isValid = false;
        } else if(![sdkConfig.iapProductID containsObject:iapData.appleProductId])
        {
            msg = @"ProductID is invalid, please check your data.";
            isValid = false;
        } else if(!iapData.applesharesecret){
            //NSLog(@"AppleSecret = nil");
            msg = @"AppleSecret is nil, please check your data.";
            isValid = false;
        } else if(!iapData.orderID){
            //NSLog(@"orderID = nil");
            msg = @"OrderID is nil, please check your data.";
            isValid = false;
        } else if(!iapData.orderInfo){
            //NSLog(@"orderInfo = nil");
            msg = @"OrderInfo is nil, please check your data.";
            isValid = false;
        } else if(!iapData.amount){
            //NSLog(@"amount = nil");
            msg = @"Amount is nil, please check your data.";
            isValid = false;
        } else if(!iapData.serverID){
            //NSLog(@"server = nil");
            msg = @"Server is nil, please check your data.";
            isValid = false;
        } else if(!iapData.username || ![iapData.username isEqualToString:sdkConfig.username]){
            //NSLog(@"username = nil");
            msg = @"UserName is nil or incorrect, please check your data.";
            isValid = false;
        }
        if(!isValid)
        {
            [[SdkHelper sharedInstance]
                    showAlertMessage:mainView
             andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"]
             andWithMessage:msg
             andCallback:nil];
            return;
        }
        dispatch_block_t block = ^{
            iapData.iapIsValid = YES;
            iapData.iAPDelegate = iAPDelegate;
            iapData.mainViewController = mainView;
            iapData.channelID = @"apple";
            [[GPayment sharedInstance] showIAP:iapData];
        };
        if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    }
}
@end
