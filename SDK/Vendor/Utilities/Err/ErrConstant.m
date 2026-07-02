//
//  ErrConstant.m
//  GosuSDK
//
//  Created by ITC on 5/6/26.
//

#import "ErrConstant.h"

@implementation ErrConstant

// Error code Common
const int ERR_RESPONSE_DATA = 2;
const int ERR_RESPONSE_FAILED = 3;
const int ERR_SERVER_INTERNAL = 500;
const int ERR_CLIENT_NOT_ACTIVE = 302;
const int ERR_WRONG_SIGNATURE = 303;
const int ERR_CLIENT_NOT_FOUND = 304;
const int ERR_BLOCK_DEVICE = 305;
const int ERR_TOKEN_EXPIRED = 999;
const int ERR_CUSTOM_CODE = 900;
//

// Common prefix
NSString *const PREF_TAG_COMMON = @"COMNx";
NSString *const PREF_TAG_SDK_INIT = @"SINTx";
NSString *const PREF_TAG_LOGIN = @"LGINx";
NSString *const PREF_TAG_GET_PROFILE = @"GPROx";
NSString *const PREF_TAG_LOGOUT = @"LGOTx";
NSString *const PREF_TAG_REGISTER = @"REGIx";
NSString *const PREF_TAG_LINK_ACCOUNT = @"LIACx";
NSString *const PREF_TAG_ACTIVE_ACCOUNT = @"ACACx";
NSString *const PREF_TAG_LOGIN_BY_TOKEN = @"LBATx";
NSString *const PREF_TAG_RECOVERY_PASS_REQ = @"REPRx";
NSString *const PREF_TAG_RECOVERY_PASS_SUB = @"REPSx";
NSString *const PREF_TAG_INSTALL_GAME_LOG = @"ISGLx";
NSString *const PREF_TAG_OPEN_GAME_LOG = @"OPGLx";
NSString *const PREF_TAG_RESEND_OTP = @"ROTPx";
NSString *const PREF_TAG_REQUEST_ACTIVE = @"RQACx";
NSString *const PREF_TAG_DELETE_ACCOUNT = @"DELAx";
NSString *const PREF_TAG_IAP_INIT = @"IAPIx";
NSString *const PREF_TAG_FINALIZE_IAP = @"FIAPx";
NSString *const PREF_TAG_REQUEST_BOOSTING = @"RBOSx";
NSString *const PREF_TAG_VERIFY_BOOSTING = @"VBOSx";

@end
