//
//  FacebookManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/4/21.
//

#import <UIKit/UIKit.h>
#import "UserProfileResponse.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookManager : NSObject {
    
}
+ (FacebookManager *) sharedInstance;
- (void) facebookLogin:(UIViewController *)viewMain andFacebookLoginCallback:(void (^)(NSDictionary<NSString *, id> *))facebookLoginCallback;
- (void) signOut;
//tracking
- (void) FBTrackingEnable;
- (void) FBTrackingUnEnable;
- (void) FBAppActive;
- (void) FBLogEvent:(NSString *)eventName parameters:(NSDictionary *)values;
- (void) FBLogPurchase:(double)amount andCurrency:(NSString *)currency;

//=============== share Facebook ==============//
/*
- (void) inviteFacebookFriends:(UIViewController *)viewController andImageUrl:(NSString *)imageURL andAppLink:(NSString *)appLink FBInviteDelegate:(id) inviteDelegate;
#pragma mark - share photos to facebook, size less than 12MB
- (void) sharePhotoToFacebook:(UIViewController *)viewController andImage:(UIImage *)image andCaption:(NSString *)caption FBShareDelegate:(id<FBSDKSharingDelegate>) shareDelegate;
- (void) shareLinkToFacebook:(UIViewController *)viewController andLink:(NSURL *) linkURL andContentTitle:(NSString *)contentTitle andDescription:(NSString *)desc FBShareDelegate:(id<FBSDKSharingDelegate>) shareDelegate;
- (void) shareVideoToFacebook:(UIViewController *)viewController andVideoURL:(NSURL *) urlVideo FBShareDelegate:(id<FBSDKSharingDelegate>) shareDelegate;
 */
@end
