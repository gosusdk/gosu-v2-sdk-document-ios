//
//  LibSDKFramework.h
//  GinSDK
//
//  Created by Nero-Macbook on 2/15/23.
//

#import <Foundation/Foundation.h>
#import "LoginDelegate.h"
#import "IAPDelegate.h"
#import "IAPDataRequest.h"
#import "AppleIAP.h"

#import "FirebaseManager.h"
#import "FacebookManager.h"
#import "GTrackingManager.h"

@interface LibSDKFramework : NSObject

@property (nonatomic, strong) id<LoginDelegate, LogoutDelegate, IAPDelegate> delegate;

+ (GTrackingManager *) GTracking;
+ (FirebaseManager *) Firebase;
+ (AppleIAP *) AppleIAP;
+ (FacebookManager *) Facebook;

//with delegate
- (void) initSDK;
- (void) onlyInitSDK;
- (void) showSignIn;
- (void) showIAP:(IAPDataRequest *) iapData andMainView:(UIViewController *)mainView;
- (void) logout;

//tracking
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
- (BOOL)applicationDelegate:(id)appDelegate andApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)deleteAccount:(void (^)(NSDictionary<NSString *, id> *))deleteCallback;
- (void)deleteAccount:(void (^)(NSDictionary<NSString *, id> *))deleteCallback andWithDialog:(Boolean)withDialog;
@end
