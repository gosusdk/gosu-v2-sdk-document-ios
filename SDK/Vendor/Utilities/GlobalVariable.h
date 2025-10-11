//
//  GlobalVariable.h
//  GameSDK
//
//  Created by Nero-Macbook on 10/29/21.
//
#if DEBUG
    #define GDLog(...) NSLog(__VA_ARGS__)
#else
    #define GDLog(...)
#endif
#define GALog(...) NSLog(__VA_ARGS__)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE (!IS_IPAD)

#define screenViewHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define screenViewWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)

#define UIColorFromRGB(rgbValue, alph) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:(float)alph]


#define VERSION         @"1.0.3"
#define AESKey          @"NeroPro2021"
#define G_SDK_VERSION_NAME "2.0.0"
//GameInfoConfig
#define IAP_PRODUCT_KEYS @"IAP_ProductID"
#define IDAds_Key @"IDAds_App_Key"
#define IDAds_Sign @"IDAds_App_Signature"
#define G_FB_LOGIN_ERROR_NULL_TOKEN "FB_NULL_TOKEN"
#define G_FB_LOGIN_ERROR_NULL_INFO  "FB_NULL_Info"
#define G_IAP_UI_SHOW "IAP_UI_SHOW"
#define G_IAP_UI_CANCELLED "IAP_UI_CANCELLED"
#define G_IAP_UI_INAPP "IAP_UI_InAppPurchase"
#define G_IAP_UI_W "IAP_UI_W"
#define G_GETPROFILE_SERVER_ERROR "GETPROFILE_SERVER_ERROR"
#define G_LOGIN_BYTOKEN_SV_ERROR "LOGIN_BYTOKEN_SV_ERROR"
#define G_LINKACCOUNT_SV_ERROR "LINKACCOUNT_SV_ERROR"
#define G_IAP_INIT_ERROR "IAP_INIT_ERROR"
#define G_IAP_VERIFY_ERROR "IAP_VERIFY_ERROR"
#define G_IAP_CONNECT_ERROR "IAP_CONNECT_ERROR"
#define G_IAP_INIT_CLIENT_INPUT "G_IAP_INIT_CLIENT_INPUT"
#define G_IAP_UI_SHOW_ERROR "IAP_UI_SHOW_ERROR"




#define G_IAP_APP_ERROR "IAP_APP_ERROR"
#define G_SDKINIT_RESPONSE_DATA_ERROR "SDKINIT_RESPONSE_DATA_ERROR"

