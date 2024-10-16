//
//  TopWalletInfo.m
//  GinSDK
//
//  Created by Nero-Macbook on 2/3/23.
//

#import <Foundation/Foundation.h>
#import "TopWalletInfo.h"

static TopWalletInfo *sharedInstance;
@implementation TopWalletInfo

#pragma mark Singleton Methods
+ (TopWalletInfo *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (NSString *) getTransactionID
{
    if (_transactionID && [_transactionID length] > 0) {
        return _transactionID;
    }
    return @"";
}

- (NSString *) getOrderID
{
    if (_orderID && [_orderID length] > 0) {
        return _orderID;
    }
    return @"";
}

- (NSString *) getProductID
{
    if (_productID && [_productID length] > 0) {
        return _productID;
    }
    return @"";
}

@end
