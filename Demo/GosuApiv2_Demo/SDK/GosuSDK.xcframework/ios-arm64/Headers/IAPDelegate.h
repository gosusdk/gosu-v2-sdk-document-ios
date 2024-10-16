//
//  IAPDelegate.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/9/21.
//


@protocol IAPDelegate <NSObject>
@optional
- (void) IAPInitFailed:(NSString *)message andErrorCode:(NSString *)errorCode;
- (void) IAPPurchaseFailed:(NSString *)message andErrorCode:(NSString *)errorCode;
- (void) IAPCompleted:(NSString *)message;
@end
