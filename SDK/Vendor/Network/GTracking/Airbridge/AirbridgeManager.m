//
//  AirbridgeManager.m
//  GameSDK
//
//  Created by Nero-Macbook on 8/9/23.
//

#import "AirbridgeManager.h"
//appflyer
#import "SdkConfig.h"
#import <AirBridge/AirBridge.h>
#import <AirBridge/ABInAppEvent.h>
#import <AirBridge/ABUser.h>
#import <AirBridge/ABCategory.h>
#import <AirBridge/ABProduct.h>
#import <AirBridge/ABSemanticsKey.h>

@interface AirbridgeManager()
{
    
}

@end
static AirbridgeManager *sharedInstance;
@implementation AirbridgeManager

#pragma mark Singleton Methods
+ (AirbridgeManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AirBridge.setting.trackingAuthorizeTimeout = 30 * 1000;
    AirBridge.setting.isRestartTrackingAuthorizeTimeout = NO;
    [AirBridge setLogLevel:AB_LOG_ALL];
    NSString *airbridgeName = [SdkConfig sharedInstance].airbridgeName;
    NSString *airbridgeToken = [SdkConfig sharedInstance].airbridgeToken;
    [AirBridge getInstance:airbridgeToken appName:airbridgeName withLaunchOptions:launchOptions];
      return YES;
}
- (void) setCustomerUserID:(NSString *)customerUserID
{
    ABUser *user = [[ABUser alloc] init];
    [user setID:customerUserID];
    [AirBridge.state setUser:user];
}

- (void) trackingLogin:(NSString *)userId andUsername:(NSString *)username andEmail:(NSString *)email
{
    ABUser* user = [[ABUser alloc] init];
    user.ID = userId;
    user.email = email;
    user.alias = @{
        @"username": @"username",
    };

    [AirBridge.state setUser:user];

    ABInAppEvent* event = [[ABInAppEvent alloc] init];
    [event setCategory:ABCategory.signIn];

    [event send];
}

- (void) trackingCheckout:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    ABProduct *product = [[ABProduct alloc] init];
    product.idx = orderId;
    product.name = productId;
    product.quantity = @(1);
    product.currency = currency;
    product.orderPosition = @(1);
    NSNumber *amountNumber = [[[NSNumberFormatter alloc] init] numberFromString:amount];
    if(amountNumber != NULL) {
        product.price = amountNumber;
    } else {
        product.price = 0;
    }
    

    ABInAppEvent* event = [[ABInAppEvent alloc] init];

    [event setCategory:@"checkout"];
    [event setAction:NULL];
    [event setLabel:NULL];
    [event setValue:@(1)];
    [event setCustoms:@{@"username":username}];
    [event setSemantics:@{
        ABSemanticsKey.products: @[product.toDictionary]
    }];
    [event send];
}

- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username
{
    [self trackingPurchase:orderId andProductId:productId andAmount:amount andCurrency:currency andUsername:username andIsIAP:YES];
}

- (void) trackingPurchase:(NSString *)orderId andProductId:(NSString *)productId andAmount:(NSString *)amount andCurrency:(NSString *)currency andUsername:(NSString *)username andIsIAP:(BOOL) isInApp
{
    @try {
        ABProduct *product = [[ABProduct alloc] init];
        product.idx = orderId;
        product.name = productId;
        product.quantity = @(1);
        product.currency = currency;
        product.orderPosition = @(1);
        NSNumber *amountNumber = [[[NSNumberFormatter alloc] init] numberFromString:amount];
        if(amountNumber != NULL) {
            product.price = amountNumber;
        } else {
            product.price = 0;
            amountNumber = 0;
        }
        ABInAppEvent* event = [[ABInAppEvent alloc] init];

        [event setCategory:@"charged"];
        [event setAction:NULL];
        [event setLabel:NULL];
        [event setValue:@(1)];
        [event setCustoms:@{@"username":username}];
        [event setSemantics:@{
            ABSemanticsKey.products: @[product.toDictionary],
            @"totalValue": amountNumber,
            @"currency": currency,
            @"productListID": productId,
            @"inAppPurchase": @(isInApp)
        }];
        [event send];
    } @catch (NSException *exception) {
        NSLog(@"error tracking charged = %@", exception);
    }
}
- (void) trackingEvent:(NSString *)eventName withValues:(NSDictionary*)values
{
    ABInAppEvent* event = [[ABInAppEvent alloc] init];

    [event setCategory:eventName];
    [event setAction:NULL];
    [event setLabel:NULL];
    [event setValue:@(1)];
    [event setCustoms:values];
    [event send];
}

-(void) registerForRemoteNotifications:(NSData *)deviceToken
{
    [AirBridge registerPushToken:deviceToken];
}
@end
