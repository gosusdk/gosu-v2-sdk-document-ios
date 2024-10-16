//
//  GinSDK.h
//  GinSDK
//
//  Created by Nero-Macbook on 3/26/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginDelegate.h"

#import "IdAppTracking.h"
#import "FacebookManager.h"
#import "FirebaseManager.h"
#import "LibSDKFramework.h"

@interface GinSDK : LibSDKFramework

+ (GinSDK *) sharedInstance;

- (void) initSdk:(void(^)(NSString *)) initStatus;
- (void)showSignInView:(UIViewController *)viewParent andResultDelegate:(id<LoginDelegate>) loginResultDelegate;
- (void) IDSignOut:(id<LogoutDelegate>) logoutDelegate;
//IAP
- (void) showIAP:(IAPDataRequest *) iapData andMainView:(UIViewController *) mainView andIAPDelegate:(id) iAPDelegate;
@end
