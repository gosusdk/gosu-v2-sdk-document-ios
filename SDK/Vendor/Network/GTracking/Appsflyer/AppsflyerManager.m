//
//  AppsflyerManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//


#import "AppsflyerManager.h"
//appflyer
#import "SdkConfig.h"

@interface AppsflyerManager() /*<AppsFlyerLibDelegate>*/
{
    
}

@end
static AppsflyerManager *sharedInstance;
@implementation AppsflyerManager

#pragma mark Singleton Methods
+ (AppsflyerManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
//Khởi tạo appsflyer trong didFinishLaunchingWithOptions
- (void) initAppsFlyer
{
    NSLog(@"appflyerDevkey1 = %@",[SdkConfig sharedInstance].appFlyerKey);
    NSLog(@"appflyerAppleID = %@",[SdkConfig sharedInstance].appFlyerAppleID);
    //Khởi tạo Appsflyer
    //source [[AppsFlyerLib shared] setAppsFlyerDevKey:[SdkConfig sharedInstance].appFlyerKey ];
    //source [[AppsFlyerLib shared] setAppleAppID:[SdkConfig sharedInstance].appFlyerAppleID];
    /* Uncomment the following line to see AppsFlyer debug logs */
    //source [AppsFlyerLib shared].isDebug = true;
  
    // Must be called AFTER setting appsFlyerDevKey and appleAppID
    //source [AppsFlyerLib shared].delegate = self;
}
- (void) initAppsFlyer:(NSString *)appFlyerKey andAppleId:(NSString *)appFlyerAppleID
{
    //Khởi tạo Appsflyer
    //source  [[AppsFlyerLib shared] setAppsFlyerDevKey:appFlyerKey];
    //source [[AppsFlyerLib shared] setAppleAppID:appFlyerAppleID];
    /* Uncomment the following line to see AppsFlyer debug logs */
    //source [AppsFlyerLib shared].isDebug = true;
  
    // Must be called AFTER setting appsFlyerDevKey and appleAppID
    //source  [AppsFlyerLib shared].delegate = self;
}
//bắt đầu chạy appsflyer trong applicationDidBecomeActive
- (void) startAppsflyer
{
    NSLog(@"appflyerDevkey start");
    //source  [[AppsFlyerLib shared] start];
}
- (void) startAppsflyerWithInterval
{
    //source [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:60];
    //source [[AppsFlyerLib shared] start];
}

- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    @try {
        /* source
        [[AppsFlyerLib shared] logEventWithEventName:eventName eventValues:values completionHandler:^(NSDictionary<NSString *,id>  * _Nullable dataLog, NSError * _Nullable errorLog){
            if(dataLog != nil) {
                NSLog(@"trackingEvent callback success:");
                for(id key in dataLog){
                    NSLog(@"trackingEvent Callback response: key=%@ value=%@", key, [dataLog objectForKey:key]);
                }
            }
            NSLog(@"trackingEvent %@ = %@", eventName, errorLog);
        }];
        */
        /*
         10    "Event timeout. Check 'minTimeBetweenSessions' param"
         11    "Skipping event because 'isStopTracking' enabled"
         40    Network error: Error description comes from Android
         41    "No dev key"
         50    "Status code failure" + actual response code from the server
         */
    } @catch (NSException *e) {
        NSLog(@"AF Error = %@", e);
    }
    
}
- (void) setCustomerUserID:(NSString *)customerUserID
{
    //source [AppsFlyerLib shared].customerUserID = customerUserID;
    [self startAppsflyer];
}

- (void) trackingLogin:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email
{
    /* source
    [self trackingEvent:AFEventLogin withValues:@{
        AFEventParamCustomerUserId:userId,
        AFEventParamContent:username,
        AFEventParamDescription:email}];
     */
}

- (void) trackingCheckout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
     /* source
    [self trackingEvent:AFEventInitiatedCheckout withValues:@{
        AFEventParamRevenue:amount,
        AFEventParamOrderId:orderId,
        AFEventParamContentId:productId,
        AFEventParamCurrency:currency,
        AFEventParamCustomerUserId:username}];
      */
}

- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
     /* source
    [self trackingEvent:AFEventPurchase withValues:@{
        AFEventParamRevenue:amount,
        AFEventParamOrderId:orderId,
        AFEventParamContentId:productId,
        AFEventParamCurrency:currency,
        AFEventParamCustomerUserId:username}];
      */
}

- (void) trackingUninstallOnAF:(NSData *)deviceToken
{
     /* source
    [[AppsFlyerLib shared] registerUninstall:deviceToken];
      */
}

//call from game client
- (void)trackingStartTrial
{
     /* source
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    [self trackingEvent:AFEventStartTrial
                 withValues:@{AFEventParamCustomerUserId:_sdkConfig.userID,
                              AFEventParamContent:_sdkConfig.username,
                              AFEventParamDescription:_sdkConfig.gameId}];
      */
}

- (void)trackingTurialCompleted
{
     /* source
    SdkConfig *_sdkConfig = [SdkConfig sharedInstance];
    [self trackingEvent:AFEventTutorial_completion
                 withValues:@{AFEventParamCustomerUserId:_sdkConfig.userID,
                              AFEventParamContent:_sdkConfig.username,
                              AFEventParamDescription:_sdkConfig.gameId}];
      */
}
@end
