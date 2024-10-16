//
//  GinAppPurchase.m
//  GinSDK
//
//  Created by Nero-Macbook on 9/7/23.
//

#import "AppleIAP.h"
#import "SdkLanguage.h"
#import "GTrackingManager.h"

@interface AppleIAP()<GinAppPurchaseCallback>
{
}

@end
static AppleIAP *sharedInstance;
@implementation AppleIAP
#pragma mark Singleton Methods
+ (AppleIAP *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (void) scanTransactionQueue
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    for(SKPaymentTransaction *transactionPending in [SKPaymentQueue defaultQueue].transactions){
         [[SKPaymentQueue defaultQueue] finishTransaction:transactionPending];
    }
}
- (void) startPurchase:(NSString *)productId andSuccess:(void (^)(NSString *, NSString *)) successBlock andFailed:(void (^)(NSString *, NSString *)) failBlock
{
    self->_successBlock = successBlock;
    self->_failBlock = failBlock;
    self->_delegate = self;
    
    if([SKPaymentQueue canMakePayments]){
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        NSString *msg = [[SdkLanguage sharedInstance] translate:@"t_iap_003"];
        [self->_delegate initFailed:@"APPLE03" andMessage:msg];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSString *msg = [[SdkLanguage sharedInstance] translate:@"t_iap_005"];
    [self->_delegate initFailed:@"APPLE04" andMessage:msg];
}

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0) {
        NSArray<SKProduct *> *products = response.products;
        for(int i=0;i<[products count];i++)
        {
            NSLog(@"IAP products[%d] = %@",i,products[i].productIdentifier);
        }
        validProduct = [response.products objectAtIndex:0];
        SKPayment *payment = [SKPayment paymentWithProduct:validProduct];
        for(SKPaymentTransaction *transactionPending in [SKPaymentQueue defaultQueue].transactions){
             [[SKPaymentQueue defaultQueue] finishTransaction:transactionPending];
        }
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else if(!validProduct) {
        NSString *msg = [[SdkLanguage sharedInstance] translate:@"t_iap_004"];
        [self->_delegate initFailed:@"APPLE01" andMessage:msg];
    }
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for(SKPaymentTransaction *transaction in transactions){
        switch((int)transaction.transactionState){
            case SKPaymentTransactionStatePurchasing:
//                [self->_delegate purchaseFailed:@"APPLE07" andMessage:[[SdkLanguage sharedInstance] translate:@"t_iap_010"]];
                break;
            case SKPaymentTransactionStatePurchased: {
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    if(!transaction) {
                        [self->_delegate purchaseFailed:@"APPLE06" andMessage:[[SdkLanguage sharedInstance] translate:@"t_iap_007"]];
                    } else {
                        [self->_delegate purchaseSucceed:transaction.transactionIdentifier];
                    }
                }
                break;
            case SKPaymentTransactionStateRestored:{
                //==== SDK callback restore for game ===//
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                if(!transaction) {
                    [self->_delegate purchaseFailed:@"APPLE07" andMessage:[[SdkLanguage sharedInstance] translate:@"t_iap_006"]];
                } else {
                    [self->_delegate purchaseSucceed:transaction.transactionIdentifier];
                }
                break;
            }
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self->_delegate purchaseFailed:@"APPLE05" andMessage:[[SdkLanguage sharedInstance] translate:@"t_iap_007"]];
                break;
            }
        }
    }
}

- (void)terminateIAP
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)initFailed:(NSString *)code andMessage:(NSString *)message {
    if(self->_failBlock) {
        self->_failBlock(code, message);
    } else {
        NSLog(@"IAP:error: %@-%@", code, message);
    }
}

- (void)purchaseFailed:(NSString *)code andMessage:(NSString *)message {
    if(self->_failBlock) {
        self->_failBlock(code, message);
    } else {
        NSLog(@"IAP:error: %@-%@", code, message);
    }
}

- (void)purchaseSucceed:(NSString *)transactionId {
    if(self->_successBlock) {
        self->_successBlock(@"1", transactionId);
    } else {
        NSLog(@"IAP:success: %@", transactionId);
    }
}

@end
