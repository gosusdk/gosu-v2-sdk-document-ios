//
//  FacebookManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/4/21.
//

#import <Foundation/Foundation.h>
#import "FacebookManager.h"
#import "ServerFactory.h"
#import "ServerConnectionDelegate.h"
#import "SdkHelper.h"
#import "SdkLanguage.h"
#import "GlobalVariable.h"

static FacebookManager *sharedInstance;
@implementation FacebookManager

#pragma mark Singleton Methods
+ (FacebookManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (void) facebookLogin:(UIViewController *)viewMain andFacebookLoginCallback:(void (^)(NSDictionary<NSString *, id> *))facebookLoginCallback
{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Đã đăng nhập");
        [self getFacebookInfo:facebookLoginCallback];
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        //[login setAuthType:@"rerequest"];
        //login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
        [login logInWithPermissions: @[@"public_profile",@"email"] fromViewController:viewMain
            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error) {
                    //if(DEBUG)
                        NSLog(@"FB Process error");
                    facebookLoginCallback(@{
                        @"status": @"failed",
                        @"message": @"FB Process error"
                    });
                } else if (result.isCancelled) {
                    //if(DEBUG)
                        NSLog(@"FB Cancelled");
                    facebookLoginCallback(@{
                        @"status": @"failed",
                        @"message": @"FB Cancelled"
                    });
                } else {
                    [self getFacebookInfo:facebookLoginCallback];
                }
            }];
    }
}
/*
- (void) facebookLogin2:(UIViewController *)viewMain andFacebookLoginCallback:(void (^)(NSDictionary<NSString *, id> *))facebookLoginCallback
{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Đã đăng nhập");
        [self getFacebookInfo:facebookLoginCallback];
    } else {
        FBSDKLoginManager *loginManager = [FBSDKLoginManager new];
        FBSDKLoginConfiguration *configuration =
          [[FBSDKLoginConfiguration alloc] initWithPermissions:@[@"email", @"public_profile"]
                                                      tracking:FBSDKLoginTrackingLimited
                                                         nonce:@"123"];
        [loginManager logInFromViewController:viewMain
                                configuration:configuration
                                   completion:^(FBSDKLoginManagerLoginResult * result, NSError *error) {
            if (error) {
                //if(DEBUG)
                    NSLog(@"FB Process error");
                facebookLoginCallback(@{
                    @"status": @"failed",
                    @"message": @"FB Process error"
                });
            } else if (result.isCancelled) {
                //if(DEBUG)
                    NSLog(@"FB Cancelled");
                facebookLoginCallback(@{
                    @"status": @"failed",
                    @"message": @"FB Cancelled"
                });
            } else {
                [self requestMeByApi:FBSDKAuthenticationToken.currentAuthenticationToken.tokenString andCallback:facebookLoginCallback];
            }
        }];
    }
}
*/
-(void) getFacebookInfo:(void (^)(NSDictionary<NSString *, id> *))facebookLoginCallback {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,email,token_for_business,ids_for_business"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe completion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
        if(result) {
            NSString *tokenForBusiness = result ? result[@"token_for_business"] : @"";
            if (!tokenForBusiness || [tokenForBusiness length] <= 6) {
                //lỗi và gửi request đến API
                if (!result) {
                    [self sdkLog:@G_FB_LOGIN_ERROR_NULL_INFO andData:@{
                        @"platform": @"ios"
                    }];
                } else {
                    [self sdkLog:@G_FB_LOGIN_ERROR_NULL_TOKEN andData:@{
                        @"token": [FBSDKAccessToken currentAccessToken].tokenString,
                        @"result": result,
                        @"platform": @"ios"
                    }];
                }
                [self requestMeByApi:[FBSDKAccessToken currentAccessToken].tokenString andCallback:facebookLoginCallback];
            } else {
                facebookLoginCallback(@{
                    @"status": @"success",
                    @"accessToken": [FBSDKAccessToken currentAccessToken].tokenString,
                    @"result": result
                });
            }
        } else {
            NSString *msg = @"Facebook app id incorrect or doesn't insert to info.plist, please check again.";
            if(error && error.description.length > 0)
                msg = error.description;
            NSLog(@"facebook login msg = %@", msg);
            
            facebookLoginCallback(@{
                @"status": @"failed",
                @"message": msg
            });
        }
    }];
    
    [connection start];
}

- (void)requestMeByApi:(NSString *)accessToken andCallback:(void (^)(NSDictionary<NSString *, id> *))facebookLoginCallback
{
    NSString *urlFb = @"https://graph.Facebook.com/v20.0/me?access_token=%@&fields=id,name,email,token_for_business,ids_for_business";
    NSString *urlString = [NSString stringWithFormat:urlFb, accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:nil
                                                     delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData *_Nullable data,
                                       NSURLResponse *_Nullable response,
                                       NSError *_Nullable error) {
            if(data) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *tokenForBusiness = result[@"token_for_business"];
                if (!tokenForBusiness || [tokenForBusiness length] <= 6) {
                    NSString *msg = [NSString stringWithFormat:@"%@(1)", [[SdkLanguage sharedInstance] translate:@"t_account_004_2"]];
                    facebookLoginCallback(@{
                        @"status": @"failed",
                        @"message": msg
                    });
                } else {
                    facebookLoginCallback(@{
                        @"status": @"success",
                        @"accessToken": [FBSDKAccessToken currentAccessToken].tokenString,
                        @"result": result
                    });
                }
            } else {
                NSString *msg = [NSString stringWithFormat:@"%@(2)", [[SdkLanguage sharedInstance] translate:@"t_account_004_2"]];
                
                facebookLoginCallback(@{
                    @"status": @"failed",
                    @"message": msg
                });
            }
        }];
    [dataTask resume];
}

- (void) signOut
{
    @try {
        FBSDKLoginManager *fbManager = [[FBSDKLoginManager alloc] init];
        [fbManager logOut];
    } @catch (NSException *exception) {
        
    }
}

- (void) sdkLog:(NSString *)activeKey andData:(NSDictionary *)data
{
    @try {
        id<ServerConnectionDelegate> connect = [[SdkConfig sharedInstance] apiConnect];
        [connect sdkLog:[SdkConfig sharedInstance].clientID andActiveKey:activeKey andData:data];
    } @catch (NSException *e) {
        
    }
    
}

//tracking
- (void) FBTrackingEnable
{
    [[FBSDKSettings sharedSettings] isAdvertiserTrackingEnabled];
//    [FBSDKSettings setAdvertiserTrackingEnabled:YES];
}
- (void) FBTrackingUnEnable
{
//    [FBSDKSettings setAdvertiserTrackingEnabled:NO];
}
- (void) FBAppActive
{
    [[FBSDKAppEvents shared] activateApp];
}
- (void) FBClickLogEvent:(NSString *)eventName parameters:(NSDictionary *)values
{
    [[FBSDKAppEvents shared] logEvent:eventName parameters:values];
}
- (void) FBLogEvent:(NSString *)eventName parameters:(NSDictionary *)values
{
//    [FBSDKAppEvents logEvent:eventName parameters:values];
}
- (void) FBLogPurchase:(double)amount andCurrency:(NSString *)currency
{
//    [FBSDKAppEvents logPurchase:amount currency:currency];
    NSDictionary<NSString *, id> *parameters = @{
      FBSDKAppEventParameterNameNumItems: [NSString stringWithFormat:@"%f",amount],
      @"currency": currency
    };
    [[FBSDKAppEvents shared] logEvent:FBSDKAppEventNamePurchased parameters:parameters];
}

@end
