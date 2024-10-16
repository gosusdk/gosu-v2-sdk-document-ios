//
//  SdkContainer.m
//  GinSDK
//
//  Created by Nero-Macbook on 3/25/22.
//

#import <Foundation/Foundation.h>
#import "SdkContainer.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface SdkContainer()
{
    
    bool isLoadIDFA;
}

@end
static SdkContainer *sharedInstance;
@implementation SdkContainer

#pragma mark Singleton Methods
+ (SdkContainer *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

//================= Request Tracking Permision =====//
#pragma mark - action request tracking permisions
- (void)getRequestIDFAWithCallback:(void(^)(NSString *))callback
{
    if(!isLoadIDFA)
    {
        [self requestIDFAWithCallback:callback];
    }
}
- (void)requestIDFAWithCallback:(void(^)(NSString *))callback {
    __block NSString *allowTracking = @"error";
    if (@available(iOS 14, *)){
        isLoadIDFA = YES;
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    //người dùng cho phép ủy quyền tracking
                    //code = 3
                    allowTracking = @"allow";
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                    //người dùng ko cho phép ủy quyền tracking
                    // code = 2
                    allowTracking = @"notallow";
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    //người dùng chưa nhận đc yêu cầu ủy quyền
                    //code = 0
                    allowTracking = @"unallow";
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    //được đồng ý ủy quyền nhưng bị hạn chế quyền
                    //code = 1
                    allowTracking = @"allow";
                    break;
                    
                default:
                    break;
            }
            
          // Tracking authorization completed. Start loading ads here.
          // [self loadAd];
        }];
    }
    
    NSLog(@"allowTracking = %@", allowTracking);
    if(callback){
        callback(allowTracking);
    }
}
@end
