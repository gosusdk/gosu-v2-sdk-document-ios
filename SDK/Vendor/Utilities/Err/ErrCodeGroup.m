//
//  ErrCodeGroup.m
//  GosuSDK
//
//  Created by ITC on 5/6/26.
//

#import "ErrCodeGroup.h"

@implementation ErrCodeGroup

+ (NSString *)Common {
    return @"Common";
}

+ (NSString *)SdkInit {
    return @"SdkInit";
}

+ (NSString *)Login {
    return @"Login";
}

+ (NSString *)GetProfile {
    return @"GetProfile";
}

+ (NSString *)Logout {
    return @"Logout";
}

+ (NSString *)Register {
    return @"Register";
}

+ (NSString *)LinkAccount {
    return @"LinkAccount";
}

+ (NSString *)ActiveAccount {
    return @"ActiveAccount";
}

+ (NSString *)LoginByAccessToken {
    return @"LoginByAccessToken";
}

+ (NSString *)RecoveryPasswordRequest {
    return @"RecoveryPasswordRequest";
}

+ (NSString *)RecoveryPasswordSubmit {
    return @"RecoveryPasswordSubmit";
}

+ (NSString *)InstallGameLog {
    return @"InstallGameLog";
}

+ (NSString *)OpenGameLog {
    return @"OpenGameLog";
}

+ (NSString *)ResendOTP {
    return @"ResendOTP";
}

+ (NSString *)RequestActive {
    return @"RequestActive";
}

+ (NSString *)IAPInit {
    return @"IAPInit";
}

+ (NSString *)FinalizeIAP {
    return @"FinalizeIAP";
}

+ (NSString *)RequestBoosting {
    return @"RequestBoosting";
}

+ (NSString *)VerifyBoosting {
    return @"VerifyBoosting";
}
@end
