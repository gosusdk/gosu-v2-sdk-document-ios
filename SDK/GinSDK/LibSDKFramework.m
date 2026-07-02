//
//  LibSDKFramework.m
//  GinSDK
//
//  Created by Nero-Macbook on 2/15/23.
//

#import "LibSDKFramework.h"
#import "SdkConfig.h"
#import "SdkContainer.h"
#import "SdkLanguage.h"
#import "GrpcViewController.h"
#import "SdkHelper.h"
#import "GoogleSignInManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "ServerConnectionDelegate.h"
#import "GPayment.h"
#import "IdAppTracking.h"
#import "GlobalVariable.h"

#import "oPayViewController.h"

@interface LibSDKFramework()
{
    UIApplication *application;
    NSDictionary *launchOptions;
}

@end

@implementation LibSDKFramework

- (void) initSdk:(void(^)(NSString *))initStatus;
{
    [self initSdkWithOption:nil andInitStatus:initStatus];
}

-(void) initSdkWithOption:(SdkOption *)sdkOption andInitStatus:(void (^)(NSString *))initStatus
{
    if(sdkOption == nil){
        sdkOption = [SdkOption builderWithDefaultOption];
    }
    [[SdkConfig sharedInstance] setFeatureWithOption:sdkOption];
    
    [[SdkLanguage sharedInstance] loadLangConfig];
    [[SdkLanguage sharedInstance] setLangCode:[[SdkConfig sharedInstance] getDefaultLanguage]];
    [[SdkConfig sharedInstance] loadConfig:^(NSString *configStatus) {
        [[SdkContainer sharedInstance] requestIDFAWithCallback:^(NSString *callback) {
            if([callback isEqual:@"allow"]) {
                //tracking has been allowed
                [self IdfaAllowtracking];
            }
        }];
        
        if(initStatus) {
            initStatus(configStatus);
        }
        
        if([configStatus isEqual:@"success"]) {
            if(![[SdkConfig sharedInstance] appIsInstalled]) {
                [[IdAppTracking sharedInstance] idAppTrackingInstall:nil];
                [[SdkConfig sharedInstance] setAppLogInstall];
            }
            [[IdAppTracking sharedInstance] idAppTrackingOpen];
        }
        if ([configStatus isEqual:@"locked"]) {
            @try {
                UIViewController *rootView = [self topViewController:[self getKeyWindow]];
                [[SdkHelper sharedInstance] showAlertMessage:rootView
                                                andWithTitle:[[SdkLanguage sharedInstance] translate:@"t_alert_001"]
                                              andWithMessage:[[SdkLanguage sharedInstance] translate:@"t_account_305"]
                                                 andCallback:nil];
            } @catch (NSException *exception) {
                
            }
        }
    }];
}
#pragma mark - Show LoginView

- (void)showSignIn
{
    dispatch_block_t block = ^{
        @try {
            NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDKDataResource" withExtension:@"bundle"]];
            
            GrpcViewController *controller = [[GrpcViewController alloc] initWithNibName:@"GrpcViewController" bundle:bundle];
            controller.loginDelegate = self->_delegate;
            [[GTrackingManager sharedInstance] verifySDK];
            [[KGModal sharedInstance] showWithContentViewController:controller andAnimated:YES];
        } @catch (NSException *exception) {
            if(self->_delegate) {
                [self->_delegate loginFail:exception.reason];
            } else {
                [[SdkHelper sharedInstance] showAlertMessage:[self topViewController:[self getKeyWindow]] andWithTitle:@"Error" andWithMessage:exception.reason andCallback:nil];
            }
        }
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


- (void) showIAP:(IAPDataRequest *) iapData andMainView:(UIViewController *)mainView
{
    SdkConfig *sdkConfig = [SdkConfig sharedInstance];
    if (!sdkConfig.serverIsReady) {
        [self->_delegate IAPInitFailed:@"Sorry, Server is busy." andErrorCode:@"-1"];
        return;
    } else if (!sdkConfig.isProductReady)
    {
        [self->_delegate IAPInitFailed:@"Sorry, Server is busy(product list is empty)." andErrorCode:@"-2"];
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
            msg = @"UserName is nil or incorrect, please check your data.";
            isValid = false;
        }
        if(!isValid)
        {
            [self->_delegate IAPInitFailed:msg andErrorCode:@"-3"];
            @try {
                id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
                [connect sdkLog:[SdkConfig sharedInstance].clientID andActiveKey:@G_IAP_INIT_CLIENT_INPUT andData:@{
                    @"orderID": iapData.orderID,
                    @"orderInfo": iapData.orderInfo,
                    @"server": iapData.serverID,
                    @"amount": iapData.amount,
                    @"productId": iapData.appleProductId,
                    @"roleId": iapData.character,
                    @"extraInfo": iapData.extraInfo,
                    @"platform": @"ios"
                }];
            } @catch (NSException *exception) {
                
            }
            return;
        }
        dispatch_block_t block = ^{
            iapData.iapIsValid = YES;
            iapData.iAPDelegate = self->_delegate;
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

- (void) logout
{
    [self logout:self->_delegate];
}
- (void) logout:(id<LogoutDelegate>) logoutDelegate
{
    dispatch_block_t block = ^{
        @try {
            [[FacebookManager sharedInstance] signOut];
            [[SdkConfig sharedInstance] clearConfigFile];
            [self showSignIn];
            if([[SdkConfig sharedInstance].accesstoken length] > 0)
            {
                id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
                [connect requestLogout:[SdkConfig sharedInstance] andLogoutResponseCallback:^(RequestLogoutResponse *logoutResponse) {
                    if([logoutResponse.status isEqual:@"success"]) {
                        //[[SdkConfig sharedInstance] clearConfigFile];
                    }
                }];
            }
            if(logoutDelegate) {
                [logoutDelegate logoutSuccess];
                [[GTrackingManager sharedInstance] logout];
            }
        } @catch (NSException *exception) {
            
        }
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (@available(iOS 14, *)) {
        [[SdkContainer sharedInstance] requestIDFAWithCallback:^(NSString *callback) {
            if([callback isEqual:@"allow"])
            {
                //tracking has been allowed
                
                // [self trackingLaunchOnAF];
                [self IdfaAllowtracking];
            }
        }];
    }
}

- (void) IdfaAllowtracking
{
    @try {
        [[FacebookManager sharedInstance] FBTrackingEnable];
        [[FacebookManager sharedInstance] FBAppActive];
//        [[GTrackingManager sharedInstance] application:self->application didFinishLaunchingWithOptions:self->launchOptions];
    } @catch (NSException *exception) {
        
    }
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                             openURL:url
                                             options:options];
    return [[GoogleSignInManager sharedInstance] application:app openURL:url options:options];
}
- (BOOL)applicationDelegate:(id)appDelegate andApplication:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self->application = application;
    self->launchOptions = launchOptions;
    
    [[SdkContainer sharedInstance] requestIDFAWithCallback:^(NSString *callback) {
        [[GTrackingManager sharedInstance] application:self->application didFinishLaunchingWithOptions:self->launchOptions];
    }];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[FirebaseManager sharedInstance] applicationDelegate:appDelegate andApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return [[GoogleSignInManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[GTrackingManager sharedInstance] registerForRemoteNotifications:deviceToken];
}
- (BOOL) isAllowDelete
{
    return [SdkConfig sharedInstance].delAccountIsOpen;
}
- (void)deleteAccount:(void (^)(NSDictionary<NSString *, id> *))deleteCallback
{
    [self deleteAccount:deleteCallback andWithDialog:NO];
}
- (void)deleteAccount:(void (^)(NSDictionary<NSString *, id> *))deleteCallback andWithDialog:(Boolean)withDialog
{
//    [SdkConfig sharedInstance].delAccountIsOpen = YES;
    if([SdkConfig sharedInstance].delAccountIsOpen) {
        if(![SdkConfig sharedInstance].accesstoken || [[SdkConfig sharedInstance].accesstoken length] < 1) {
            NSDictionary *callbackData = @{
                @"status": @"failed",
                @"message": @"Please sign in"
            };
            deleteCallback(callbackData);
            return;
        }
        dispatch_block_t block = ^{
            [[SdkConfig sharedInstance] deleteAccountWithCallback:^(NSDictionary<NSString *,id> *callback) {
                NSString *status = @"failed";
                NSString *message = @"delete_account_failed";
                @try {
                    int code = [callback[@"code"] intValue];
                    if(code != 200) {
                        NSException *exception = [NSException exceptionWithName:@"Error" reason:@"delete_account_failed" userInfo:nil];
                        [exception raise];
                    }
                    status = @"success";
                    message = @"delete_account_success";
                    [self logout];
                } @catch (NSException *exception) {
                    message = exception.reason;
                }
                NSDictionary *callbackData = @{
                    @"status": status,
                    @"message": [[SdkLanguage sharedInstance] translate:message]
                };
                if(withDialog) {
                    [[SdkHelper sharedInstance] showAlertMessage:[[SdkLanguage sharedInstance] translate:@"t_alert_001"] andWithMessage:[[SdkLanguage sharedInstance] translate:message] andCallback:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                }
                if(deleteCallback) {
                    deleteCallback(callbackData);
                } else {
                    NSLog(@"delete account callback = %@", callbackData);
                }
            }];
        };
        if(!withDialog) {
            block();
        } else {
            [[SdkHelper sharedInstance] showConfirmMessage:[self topViewController:[self getKeyWindow]] andWithTitle:[[SdkLanguage sharedInstance] translate:@"t_alert_001"] andWithMessage:[[SdkLanguage sharedInstance] translate:@"delete_account_confirm"] andOkCallback:^(UIAlertAction * _Nonnull action) {
                block();
            } andCancelCallback:^(UIAlertAction * _Nonnull action) {
                NSDictionary *callbackData = @{
                    @"status": @"failed",
                    @"message": @"You have canceled the request"
                };
                deleteCallback(callbackData);
            }];
        }
    } else {
        NSDictionary *callbackData = @{
            @"status": @"failed",
            @"message": @"Coming Soon"
        };
        if(withDialog) {
            [[SdkHelper sharedInstance] showAlertMessage:[self topViewController:[self getKeyWindow]] andWithTitle:[[SdkLanguage sharedInstance] translate:@"t_alert_001"] andWithMessage:@"Coming soon" andCallback:nil];
        }
        if(deleteCallback) {
            deleteCallback(callbackData);
        } else {
            NSLog(@"delete account callback = %@", callbackData);
        }
    }
}


+ (FirebaseManager *) Firebase
{
    return [FirebaseManager sharedInstance];
}


+ (FacebookManager *) Facebook
{
    return [FacebookManager sharedInstance];
}
+ (AppleIAP *) AppleIAP
{
    return [AppleIAP sharedInstance];
}

- (UIWindow *)topWindow {
for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
        }
    }
    return nil;
}

-(UIViewController *)getKeyWindow
{
    UIViewController *keyWindowUIViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    if(!keyWindowUIViewController)
    {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
          if (window.isKeyWindow) {
              keyWindowUIViewController = [window rootViewController];
              break;
          }
        }
    }
    if(!keyWindowUIViewController) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                keyWindowUIViewController = [windowScene.windows.firstObject rootViewController];
                break;
            }
        }
    }
    return keyWindowUIViewController;
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
+ (GTrackingManager *) GTracking
{
    return [GTrackingManager sharedInstance];
}
@end
