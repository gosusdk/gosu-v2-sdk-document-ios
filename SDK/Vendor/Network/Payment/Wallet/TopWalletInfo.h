//
//  TopWalletInfo.h
//  GinSDK
//
//  Created by Nero-Macbook on 2/3/23.
//

#import <Foundation/Foundation.h>

@interface TopWalletInfo : NSObject

@property (nonatomic, strong) NSString *labelTitle;
@property (nonatomic, strong) NSString *transactionHashKey;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString * productID;
@property (nonatomic, assign) float labelBalance;//so du
@property (nonatomic, assign) float labelPrice;//gia goi

@property (nonatomic, assign) BOOL      status;
@property (nonatomic, strong) NSString *message;

+ (TopWalletInfo *)sharedInstance;
- (NSString *) getTransactionID;
- (NSString *) getOrderID;
- (NSString *) getProductID;
@end
