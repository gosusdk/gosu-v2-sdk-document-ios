//
//  SdkContainer.h
//  GameSDK
//
//  Created by Nero-Macbook on 3/25/22.
//

@interface SdkContainer : NSObject {
    
}
+ (SdkContainer *) sharedInstance;

- (void)getRequestIDFAWithCallback:(void(^)(NSString *))callback;
- (void)requestIDFAWithCallback:(void(^)(NSString *))callback;
@end
