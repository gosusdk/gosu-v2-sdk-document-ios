//
//  ErrManager.m
//  GosuSDK
//
//  Created by ITC on 5/6/26.
//

#import "ErrManager.h"
#import "SdkHelper.h"
#import <Foundation/Foundation.h>
#import "SdkLanguage.h"

#define IS_EMPTY_STRING(s) ((s) == nil || [(s) isKindOfClass:[NSNull class]] || [(s) length] == 0)
@interface ErrManager ()


@end
static ErrManager *sharedInstance;
@implementation ErrManager

+ (ErrManager *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (NSString *) getPrefixWithCodeGroup: (NSString *) codeGroup {
    
    if([codeGroup isEqualToString:ErrCodeGroup.Common]) return PREF_TAG_COMMON;
    if([codeGroup isEqualToString:ErrCodeGroup.SdkInit]) return PREF_TAG_SDK_INIT;
    if([codeGroup isEqualToString:ErrCodeGroup.InstallGameLog]) return PREF_TAG_INSTALL_GAME_LOG;
    if([codeGroup isEqualToString:ErrCodeGroup.OpenGameLog]) return PREF_TAG_OPEN_GAME_LOG;
    if([codeGroup isEqualToString:ErrCodeGroup.Register]) return PREF_TAG_REGISTER;
    if([codeGroup isEqualToString:ErrCodeGroup.Login]) return PREF_TAG_LOGIN;
    if([codeGroup isEqualToString:ErrCodeGroup.LoginByAccessToken]) return PREF_TAG_LOGIN_BY_TOKEN;
    if([codeGroup isEqualToString:ErrCodeGroup.GetProfile]) return PREF_TAG_GET_PROFILE;
    if([codeGroup isEqualToString:ErrCodeGroup.LinkAccount]) return PREF_TAG_LINK_ACCOUNT;
    if([codeGroup isEqualToString:ErrCodeGroup.ActiveAccount]) return PREF_TAG_ACTIVE_ACCOUNT;
    if([codeGroup isEqualToString:ErrCodeGroup.RequestActive]) return PREF_TAG_REQUEST_ACTIVE;
    if([codeGroup isEqualToString:ErrCodeGroup.RecoveryPasswordRequest]) return PREF_TAG_RECOVERY_PASS_REQ;
    if([codeGroup isEqualToString:ErrCodeGroup.RecoveryPasswordSubmit]) return PREF_TAG_RECOVERY_PASS_SUB;
    if([codeGroup isEqualToString:ErrCodeGroup.ResendOTP]) return PREF_TAG_RESEND_OTP;
    if([codeGroup isEqualToString:ErrCodeGroup.Logout]) return PREF_TAG_LOGOUT;
    if([codeGroup isEqualToString:ErrCodeGroup.IAPInit]) return PREF_TAG_IAP_INIT;
    if([codeGroup isEqualToString:ErrCodeGroup.FinalizeIAP]) return PREF_TAG_FINALIZE_IAP;
    if([codeGroup isEqualToString:ErrCodeGroup.RequestBoosting]) return PREF_TAG_REQUEST_BOOSTING;
    if([codeGroup isEqualToString:ErrCodeGroup.VerifyBoosting]) return PREF_TAG_VERIFY_BOOSTING;
    return codeGroup;
}

-(void)showErrDialogWithMessage:(NSString *) message andUIViewUIViewController: (UIViewController *)_uiViewController andCallback:(void (^)(UIAlertAction * _Nonnull action))withCallback {
    @try {
        [[SdkHelper sharedInstance] showAlertMessage: _uiViewController andWithTitle: [[SdkLanguage sharedInstance] translate:@"t_alert_001"] andWithMessage:[[SdkLanguage sharedInstance] translate:message] andCallback: withCallback];
    } @catch (NSException *exception) {
        
    }
}
- (NSString *)getContentErrMessageWithCodeGroup:(NSString *)errCodeGroup andErrCode:(int)errCode andRemoteMessage: (NSString *) remoteMessage
{
    NSString *msgCode = [NSString stringWithFormat:@"%@%d", [self getPrefixWithCodeGroup:errCodeGroup], errCode];
    NSString *msgContent = @"";
    if (errCode == ERR_SERVER_INTERNAL) { //500
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx500"], msgCode];
    }
    if (errCode == ERR_RESPONSE_DATA) { //002
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx002"], msgCode];
    }
    if (errCode == ERR_RESPONSE_FAILED) { //003
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx003"], msgCode];
    }
    if (errCode == ERR_CLIENT_NOT_ACTIVE) { //302
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx302"], msgCode];
    }
    if (errCode == ERR_WRONG_SIGNATURE) { //303
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx303"], msgCode];
    }
    if (errCode == ERR_CLIENT_NOT_FOUND) { //304
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx304"], msgCode];
    }
    if (errCode == ERR_BLOCK_DEVICE) { //305
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx305"], msgCode];
    }
    if (errCode == ERR_TOKEN_EXPIRED) { //999
        msgContent = [NSString stringWithFormat:[[SdkLanguage sharedInstance] translate:@"txt_error_COMNx999"], msgCode];
    }
    if (errCode == ERR_CUSTOM_CODE) { //900
        msgContent = [NSString stringWithFormat:@"%@ (%@)", [self getContentMsgByLanguage:remoteMessage], msgCode];
    }
    if (IS_EMPTY_STRING(msgContent)) {
        NSString *keyText = [NSString stringWithFormat:@"txt_error_%@", msgCode];
        SdkLanguage *language = [SdkLanguage sharedInstance];
            
        if ([language hasKey:keyText]) {
            NSString *localizedMessage = [language translate:keyText];
            if (localizedMessage) {
                msgContent = [NSString stringWithFormat:@"%@ (%@)", localizedMessage, msgCode];
            } else {
                msgContent = [NSString stringWithFormat:@"%@ (%@)", remoteMessage, msgCode];
            }
        } else {
            msgContent = [NSString stringWithFormat:@"%@ (%@)", remoteMessage, msgCode];
        }
    }
    return msgContent;
}

-(void)showErrDialogWithErrGroup:(NSString *)errCodeGroup andErrCode:(int)code andRemoteMessage:(NSString *) remoteMessage andCallback:(void (^)(UIAlertAction * _Nonnull))withCallback
{
    NSString *title = [[SdkLanguage sharedInstance] translate:@"t_alert_001"];
    NSString *message = [self getContentErrMessageWithCodeGroup:errCodeGroup andErrCode:code andRemoteMessage:remoteMessage];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:[[SdkLanguage sharedInstance] translate:@"btn_close"]
                                                          style:UIAlertActionStyleDefault
                                                        handler:withCallback];

    [alert addAction:closeAction];
    [rootViewController presentViewController:alert animated:YES completion:nil];
    
    return;
}

- (NSString *)getContentMsgByLanguage:(NSString *)errMsg {
    NSString *languageKey = [[SdkLanguage sharedInstance] getCurentLangCode];
    @try {
        NSData *data = [errMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsonObject isKindOfClass:[NSDictionary class]] && jsonObject[languageKey]) {
            return [NSString stringWithFormat:@"%@", jsonObject[languageKey]];
        }
    } @catch (NSException *exception) {
        // Ignore exception and fall through
    }
    return errMsg;
}
@end
