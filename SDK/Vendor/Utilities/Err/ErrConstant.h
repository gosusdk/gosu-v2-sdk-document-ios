//
//  ErrConstant.h
//  GosuSDK
//
//  Created by ITC on 5/6/26.
//

#import <Foundation/Foundation.h>

@interface ErrConstant : NSObject

// Error code Common
extern const int ERR_RESPONSE_DATA;
extern const int ERR_RESPONSE_FAILED;
extern const int ERR_SERVER_INTERNAL;
extern const int ERR_CLIENT_NOT_ACTIVE;
extern const int ERR_WRONG_SIGNATURE;
extern const int ERR_CLIENT_NOT_FOUND;
extern const int ERR_BLOCK_DEVICE;
extern const int ERR_TOKEN_EXPIRED;
extern const int ERR_CUSTOM_CODE;


// Common
extern NSString *const PREF_TAG_COMMON;
extern NSString *const PREF_TAG_SDK_INIT;
extern NSString *const PREF_TAG_LOGIN;
extern NSString *const PREF_TAG_GET_PROFILE;
extern NSString *const PREF_TAG_LOGOUT;
extern NSString *const PREF_TAG_REGISTER;
extern NSString *const PREF_TAG_LINK_ACCOUNT;
extern NSString *const PREF_TAG_ACTIVE_ACCOUNT;
extern NSString *const PREF_TAG_LOGIN_BY_TOKEN;
extern NSString *const PREF_TAG_RECOVERY_PASS_REQ;
extern NSString *const PREF_TAG_RECOVERY_PASS_SUB;
extern NSString *const PREF_TAG_INSTALL_GAME_LOG;
extern NSString *const PREF_TAG_OPEN_GAME_LOG;
extern NSString *const PREF_TAG_RESEND_OTP;
extern NSString *const PREF_TAG_REQUEST_ACTIVE;
extern NSString *const PREF_TAG_DELETE_ACCOUNT;
extern NSString *const PREF_TAG_IAP_INIT;
extern NSString *const PREF_TAG_FINALIZE_IAP;
extern NSString *const PREF_TAG_REQUEST_BOOSTING;
extern NSString *const PREF_TAG_VERIFY_BOOSTING;

@end
