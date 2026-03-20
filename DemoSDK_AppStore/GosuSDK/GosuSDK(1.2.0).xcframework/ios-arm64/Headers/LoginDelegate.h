//
//  LoginDelegate.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/3/21.
//

#pragma Login Delegate
@protocol LoginDelegate <NSObject>
@required
- (void) loginSuccess:(NSString *)userID andUserName:(NSString *)userName andAccessToken:(NSString *)access_token;
- (void) loginFail:(NSString *) message;
@end

#pragma Logout Delegate
@protocol LogoutDelegate <NSObject>
@required
- (void) logoutSuccess;
- (void) logoutFail:(NSString *) message;
@end
