//
//  OpenIDDelegate.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/8/21.
//

#import "AppleLoginResponse.h"

@protocol OpenIDDelegate <NSObject>
@optional
- (void) loginGGFinished:(NSString *)accessToken;
- (void) loginGGFailed:(NSString *)message andErrorCode:(NSInteger)errorCode;
- (void) loginAppleSuccess:(AppleLoginResponse *) appleLogin;
- (void) loginAppleFailed:(AppleLoginResponse *)appleLogin;
- (void) loginAppleDisconnect;
@end
