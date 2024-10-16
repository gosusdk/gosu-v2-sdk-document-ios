//
//  GoogleSignInManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//
#import "GoogleSignInManager.h"
#import "SdkHelper.h"
#import "SdkLanguage.h"
#import "ServerFactory.h"
#import "ServerConnectionDelegate.h"
@import GoogleSignIn;

@interface GoogleSignInManager(){
    GIDConfiguration *signInConfig;
}

@end
static GoogleSignInManager *sharedInstance;
@implementation GoogleSignInManager

#pragma mark Singleton Methods
+ (GoogleSignInManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL handled;

      handled = [GIDSignIn.sharedInstance handleURL:url];
      if (handled) {
        return YES;
      }

      // Handle other custom URL types.

      // If not handled by this app, return NO.
      return NO;
}
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GIDSignIn.sharedInstance restorePreviousSignInWithCompletion:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
          // Show the app's signed-out state.
        } else {
          // Show the app's signed-in state.
            NSLog(@"user = %@", user.profile.name);
            NSLog(@"user = %@", user.profile.email);
        }
    }];
      return YES;
}
- (void) showSignIn:(UIViewController *)viewMain andGoogleLoginCallback:(void (^)(NSDictionary<NSString *, id> *))googleLoginCallback
{
    NSString *GoogleAppID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GIDClientID"];
    if(!GoogleAppID || [GoogleAppID isEqual:[NSNull null]]) {
        GoogleAppID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GoogleAppID"];
    }
    
    if(!GoogleAppID || [GoogleAppID isEqual:[NSNull null]])
    {
        googleLoginCallback(@{
            @"status": @"failed",
            @"message": @"Google App ID is Invalid"
        });
        return;
    }
    signInConfig = [[GIDConfiguration alloc] initWithClientID:GoogleAppID];
    [GIDSignIn.sharedInstance signInWithPresentingViewController:viewMain completion:^(GIDSignInResult * _Nullable signInResult, NSError * _Nullable error) {
        if (error) {
            googleLoginCallback(@{
                @"status": @"failed",
                @"message": @"Sign in error"
            });
            return;
        }
        if (signInResult == nil) {
            googleLoginCallback(@{
                @"status": @"failed",
                @"message": @"Sign in error"
            });
            return;
        }
        
        [signInResult.user refreshTokensIfNeededWithCompletion:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                googleLoginCallback(@{
                    @"status": @"failed",
                    @"message": @"Sign in error"
                });
                return;
            }
            if (user == nil) {
                googleLoginCallback(@{
                    @"status": @"failed",
                    @"message": @"Sign in error"
                });
                return;
            }
            googleLoginCallback(@{
                @"status": @"success",
                @"result": user
            });
        }];
    }];
}
- (void) signOut
{
    [GIDSignIn.sharedInstance signOut];
}
@end

