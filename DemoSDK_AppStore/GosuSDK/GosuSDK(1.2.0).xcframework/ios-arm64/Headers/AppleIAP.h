//
//  GinAppPurchase.h
//  GinSDK
//
//  Created by Nero-Macbook on 9/7/23.
//

#import <UIKit/UIKit.h>
//use IAP
#import <StoreKit/StoreKit.h>

@protocol GinAppPurchaseCallback <NSObject>

- (void) initFailed:(NSString *) code andMessage:(NSString *) message;
- (void) purchaseFailed:(NSString *) code andMessage:(NSString *) message;
- (void) purchaseSucceed:(NSString *) transactionId;

@end
@interface AppleIAP : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
}
typedef void (^CallbackBlock) (NSString *code, NSString *message);
@property (nonatomic, strong) id<GinAppPurchaseCallback> delegate;
@property (nonatomic, strong) CallbackBlock successBlock;
@property (nonatomic, strong) CallbackBlock failBlock;

+ (AppleIAP *) sharedInstance;
- (void) scanTransactionQueue;
- (void) startPurchase:(NSString *)productId andSuccess:(void (^)(NSString *, NSString *)) successBlock andFailed:(void (^)(NSString *, NSString *)) failBlock;
- (void) terminateIAP;
@end
