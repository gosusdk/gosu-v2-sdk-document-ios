//
//  ErrCodeGroup.h
//  GosuSDK
//
//  Created by ITC on 5/6/26.
//

#import <Foundation/Foundation.h>

@interface ErrCodeGroup : NSObject

+ (NSString *)Common;
+ (NSString *)SdkInit;
+ (NSString *)Login;
+ (NSString *)GetProfile;
+ (NSString *)Logout;
+ (NSString *)Register;
+ (NSString *)LinkAccount;
+ (NSString *)ActiveAccount;
+ (NSString *)LoginByAccessToken;
+ (NSString *)RecoveryPasswordRequest;
+ (NSString *)RecoveryPasswordSubmit;
+ (NSString *)InstallGameLog;
+ (NSString *)OpenGameLog;
+ (NSString *)ResendOTP;
+ (NSString *)RequestActive;
+ (NSString *)IAPInit;
+ (NSString *)FinalizeIAP;
+ (NSString *)RequestBoosting;
+ (NSString *)VerifyBoosting;

@end
