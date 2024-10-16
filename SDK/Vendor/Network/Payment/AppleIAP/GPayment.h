//
//  GPayment.h
//  GinSDK
//
//  Created by Nero-Macbook on 9/7/23.
//

#import <UIKit/UIKit.h>
#import "IAPDataRequest.h"
#import "IAPDelegate.h"

@interface GPayment : NSObject {
    
}

@property (nonatomic, strong) id<IAPDelegate> iAPDelegate;
@property (nonatomic, strong) IAPDataRequest *iAPDataRequest;
@property (nonatomic, assign) BOOL isIAP;

+ (GPayment *) sharedInstance;
- (void) showIAP:(IAPDataRequest *) iapData;
- (void) inAppStartPurchase;
- (void) verifyPayConfirm:(id) payInfo;
- (void) terminateIAP;
- (void) paymenCancel;
@end
