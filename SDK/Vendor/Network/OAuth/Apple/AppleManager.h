//
//  AppleManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/8/21.
//

#import <UIKit/UIKit.h>
#import "UserProfileResponse.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "OpenIDDelegate.h"

@interface AppleManager : NSObject {
    
}

@property (nonatomic, strong) id<OpenIDDelegate> openIDDelegate;

+ (AppleManager *) sharedInstance;
- (BOOL) showLoginView:(id<OpenIDDelegate>) openIDDelegate;
@end
