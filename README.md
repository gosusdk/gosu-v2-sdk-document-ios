# iOS GosuSDK
> **⚠️ BREAKING CHANGES in v1.1.0**: AppsFlyer and Airbridge tracking modules have been removed. New ITS tracking module integrated.

[![Platforms](https://img.shields.io/cocoapods/p/FBSDKCoreKit.svg)]()

**This guide shows you how to integrate your iOS app using the GosuSDK for iOS. The GosuSDK for iOS consists of the following component SDKs:**
  - The GosuSDK Core
  - Third-party framework: 
      - GoogleSignin SDK, Firebase SDK, Facebook SDK
      - ITS SDK (New analytics and tracking framework)
      - Grpc Framework (GRPCClient, ProtoBuf, ProtoRPC, RxLibrary, ...)
      - Download at: [Required Frameworks](https://drive.google.com/file/d/1ceQ8zDDSZ0w0imZy1rICJx7d86tLhdvW/view?usp=sharing)
  - iOS version support: 13+
  
### FEATURES:
  - Login: Authenticate people with their server ID, Google and Facebook credentials
  - Payment IAP: Pay to buy products from in-app purchases
  - Track Events: Track events with ITS analytics framework
  - **Enhanced Privacy Compliance**: App Store privacy manifest and enhanced data protection
  - **Improved Performance**: 40% smaller SDK size with faster initialization
  - You will need some included keys: GameClientID, GameSdkSignature, GoogleAppID, FacebookAppID, FacebookClientToken, ITS configuration keys, and GoogleService-Info.plist file

# Try It Out

**Download the official version: [click here](https://github.com/itcgosucorp/GOSUv2-SDK-ios/releases)**
* GoogleService-Info.plist: send via mail
* Install the following: App Tracking Transparency framework only available starting from Xcode 12 or later - The SDK supports iOS 13+

# Integrate

- Embed GosuSDK latest version and Third party framework into your project
- Some other libraries: 
  - **AuthenticationServices.framework**
  - **MediaPlayer.framework**
  - **MobileCoreServices.framework**
  - **SystemConfiguration.framework**
  - **MessageUI.framework**
  - **Accelerate.framework**
  - **AdSupport.framework**
  - **AppTrackingTransparency.framework**
  - **AdServices.framework**
  - **StoreKit.framework**
  - **iAd.framework**
- Adding Capabilities: Sign-in with Apple, Push Notifications

### With Facebook iOS SDK version 17 or latest
  - Create a swift file (arbitrary name), confirm "Create Bridging Header" when prompt appear
  - Enable Modules (C and Objective-C) set to YES: Target --> Build Settings --> Enable Modules (C and Objective-C)

# Configuration
- Insert -ObjC -lc++ -lz to "Other Linker Flags" on Xcode Project: Main target -> build settings -> search "other linker flags"
- Configure Tracking Usage Description into .plist file (default: info.plist).
  Open with source and insert code: 
  ```xml
  <key>NSUserTrackingUsageDescription</key>
  <string>This identifier will be used to deliver personalized ads to you.</string>
  ```

- Configure GameClientID into .plist file (default: info.plist). In the <string> tag, key GameClientID will be provided privately via email
```xml
<key>GameClientID</key>
<string>GameClientID-value</string>
```

- Configure GameSdkSignature into .plist file (default: info.plist). In the <string> tag, key GameSdkSignature will be provided privately via email
```xml
<key>GameSdkSignature</key>
<string>GameSDKSignature-value</string>
```

### Configure ITS SDK in your project (default info.plist)
- Configure ITS SDK module tracking into .plist file (default: info.plist). In the <string> tag, keys config will be provided privately via email
  ```xml
  <key>ItsSigningKey</key>
  <string>your_its_signing_key</string>
  <key>ItsWriteKey</key>
  <string>your_its_write_key</string>
  ```

### Configure GoogleSignIn in your project (default info.plist)
  **Refer [Get started with Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating)**
  ```xml
   <key>GIDClientID</key>
   <string>1234567890-abcdefg.apps.googleusercontent.com</string>
   <key>CFBundleURLTypes</key>
   <array>
    <dict>
       <key>CFBundleURLSchemes</key>
       <array>
          <string>com.googleusercontent.apps.1234567890-abcdefg</string>
       </array>
    </dict>
   </array>
  ```

### Configure FacebookSDK in your project (default info.plist)
**Refer [Facebook get started](https://developers.facebook.com/docs/ios/getting-started#step-2---configure-your-project)**
```xml
<key>FacebookAppID</key>
<string>FacebookAppID</string>
<key>FacebookClientToken</key>
<string>CLIENT-TOKEN</string>
<key>FacebookDisplayName</key>
<string>FacebookDisplayName</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbFacebookAppID</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fbapi20130214</string>
  <string>fbapi20130410</string>
  <string>fbapi20130702</string>
  <string>fbapi20131010</string>
  <string>fbapi20131219</string>
  <string>fbapi20140410</string>
  <string>fbapi20140116</string>
  <string>fbapi20150313</string>
  <string>fbapi20150629</string>
  <string>fbapi20160328</string>
  <string>fbauth</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```
* Replace FacebookAppID with your Facebook App ID
* In the key FacebookClientToken, replace CLIENT-TOKEN 
* In the key FacebookDisplayName, replace with the name provided

* NOTE: Use only 1 CFBundleURLSchemes key for both GoogleSignIn and FacebookSignIn URLs.
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbFacebookAppID</string>
            <string>com.googleusercontent.apps.1234567890-abcdefg</string>
        </array>
    </dict>
</array>
```

### Add a Bridging Header file if your project does not use Swift.
- Xcode -> New -> File from Template... -> Header File -> Done

### If your project uses SignIn with AppleID, add the following key-value pairs to your .entitlements file.
```xml
    <key>com.apple.developer.applesignin</key>
    <array>
        <string>Default</string>
    </array>
```

### Add services and SDK related resource library
1. The file AppDelegate.m configuration instructions are as follows:
```objectivec
#import "GosuSDK.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate()<FIRMessagingDelegate, UNUserNotificationCenterDelegate>
@end
```

2. Add openURL
```objectivec
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (@available(iOS 9.0, *)) {
        BOOL handled = [[GosuSDK sharedInstance] application:application openURL:url options:options];
        return handled;
    } else {
        return YES;
    }
}
```

3. Add didFinishLaunchingWithOptions
```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //your code
    
    //GosuSDK - Use onlyInitSDK for better ATT control
    [[GosuSDK sharedInstance] onlyInitSDK];
    [[GosuSDK sharedInstance] applicationDelegate:self andApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}
```

4. Add applicationDidBecomeActive
```objectivec
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    [[GosuSDK sharedInstance] applicationDidBecomeActive:application];
       
    application.applicationIconBadgeNumber = 0;
}
```

5. Add applicationWillTerminate
```objectivec
- (void)applicationWillTerminate:(UIApplication *)application {
    //reset owner billing had payment
    [[GosuSDK AppleIAP] terminateIAP];
}
```

6. Registration FCM token and message
```objectivec
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    [[GosuSDK Firebase] messaging:messaging didReceiveRegistrationToken:fcmToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"APNs Unable to register for remote notifications: %@", error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[GosuSDK sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    [[GosuSDK GTracking] registerForRemoteNotifications:deviceToken];
}
- (void)application:(UIApplication *)application 
        didReceiveRemoteNotification:(NSDictionary *) userInfo {
    NSLog(@"APNs full message. %@", userInfo);
}
- (void)application:(UIApplication *)application 
      didReceiveRemoteNotification:(NSDictionary *) userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Print full message.
    NSLog(@"APNs receive_message %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}
// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = notification.request.content.userInfo;
    // Print full message.
    [[GosuSDK Firebase] showInAppMessage:userInfo];
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
    [[GosuSDK Firebase] showInAppMessage:userInfo];
  completionHandler();
}
// [END ios_10_message_handling]

//Block Landscape
- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*) window {
    return UIInterfaceOrientationMaskLandscape;
}

```

# API description and usage

## Initialize GosuSDK
```objectivec
#import "GosuSDK.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Use onlyInitSDK for better control over ATT timing
    [[GosuSDK sharedInstance] onlyInitSDK];
    //...
}
```

## Initialize SDK delegate
```objectivec
//MainViewController.h
@interface MainViewController:UIViewController<UIActionSheetDelegate, SKProductsRequestDelegate, LoginDelegate, LogoutDelegate, IAPDelegate> {
}
```
```objectivec
//MainViewController.m
#pragma Login Delegate
- (void)loginSuccess:(NSString *)userID andUserName:(NSString *)userName andAccessToken:(NSString *)access_token {
    // Your implementation here
    NSLog(@"Login Success - UserID: %@, UserName: %@, AccessToken: %@", userID, userName, access_token);
}
- (void)loginFail:(NSString *)message {
    NSLog(@"Login Failed: %@", message);
}
#pragma Logout Delegate  
- (void) logoutSuccess{
    NSLog(@"Logout Success");
}
#pragma IAP Delegate
- (void) IAPInitFailed:(NSString *)message andErrorCode:(NSString *)errorCode {
    NSLog(@"IAP Init Failed: %@ - Code: %@", message, errorCode);
}
- (void) IAPPurchaseFailed:(NSString *)message andErrorCode:(NSString *)errorCode {
    NSLog(@"IAP Purchase Failed: %@ - Code: %@", message, errorCode);
}
- (void) IAPCompleted:(NSString *)message{
    NSLog(@"IAP Completed: %@", message);
}
```

## Show Login/Logout Interface
```objectivec
[[GosuSDK sharedInstance] showSignInView:self andResultDelegate:self];
//showSignInView: use as main view controller
//andResultDelegate: use as Login Delegate

[[GosuSDK sharedInstance] IDSignOut:self];
//use as Logout Delegate
```

## Delete Account API
```objectivec
[[GosuSDK sharedInstance] deleteAccount:self andCallback:^(NSDictionary *response) {
    NSLog(@"Delete Account Response = %@", response);
}];
```

## Using IAP
*** appleSecret default is empty (ex: @""), this will change when we send the request to you
  
```objectivec
IAPDataRequest *iapData = [[IAPDataRequest alloc] 
          initWithData:_userName 
          andOrderId:orderID 
          andOrderInfo:orderInfo 
          andServerID:server 
          andAmount:amount 
          andAppleProductID:productID 
          andAppleShareSecrect:appleSecret 
          andRoleID:character 
          andExtraInfo:extraInfo];
[[GosuSDK sharedInstance] showIAP:(IAPDataRequest *)iapData andMainView:self andIAPDelegate:self];
//andMainView: use as main view controller
//andIAPDelegate: use as IAP Delegate
```

# API Tracking Events (New ITS Integration)

```
USAGE TRACKING WITH ITS
--------------------
The SDK now supports enhanced tracking through the ITS analytics framework. To use it, implement the tracking methods as shown below.
```

## Basic Tracking Events
Using module GTracking, example:

```objectivec
// Registration tracking
[[GosuSDK GTracking] completeRegistration:@"user_id"];
```

For detailed information on tracking events and ITS analytics integration, please refer to the [Tracking Guide](./TRACKING_GUIDE.md).

---

