//
//  SdkConfig.h
//  GameSDK
//
//  Created by Nero-Macbook on 3/26/22.
//

@interface SdkConfig : NSObject {
}

//sdk client config data
@property (nonatomic, strong) NSString *idApi;
@property (nonatomic, strong) NSString *payApi;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, strong) NSString *redirectDomainVerify;
@property (nonatomic, strong) NSString *serverState;
@property (nonatomic, strong) NSString *wsUsername;
@property (nonatomic, strong) NSString *wsPassword;
@property (nonatomic, strong) NSString *wsUsernameTest;
@property (nonatomic, strong) NSString *wsPasswordTest;
@property (nonatomic, strong) NSString *passIngame;
@property (nonatomic, strong) NSString *emailIngame;
@property (nonatomic, strong) NSString *ipGame;
@property (nonatomic, strong) NSString *termUrl;
@property (nonatomic, strong) NSString *policyUrl;
@property (nonatomic, strong) NSString *sdkApiType;
@property (nonatomic, strong) NSString *sdkApiName;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *sdkSignature;
@property (nonatomic, strong) NSString *environment;
@property (nonatomic, assign) BOOL      clientIsReady;
@property (nonatomic, assign) BOOL      delAccountIsOpen;
@property (nonatomic, assign) BOOL      showPlaynow;
@property (nonatomic, assign) BOOL      walletAllow;

//sdk server data
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *secrectKey;
@property (nonatomic, strong) NSString *serviceID;
@property (nonatomic, strong) NSString *serviceKey;
@property (nonatomic, strong) NSArray *iapProductID;
// Appsflyer Removed
//@property (nonatomic, strong) NSString *appFlyerKey;
//@property (nonatomic, strong) NSString *appFlyerAppleID;

@property (nonatomic, strong) NSString *idAppKey;
@property (nonatomic, strong) NSString *idAppSign;
@property (nonatomic, strong) NSString *sdkLanguage;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *partnerID;
@property (nonatomic, strong) NSString *network;
@property (nonatomic, assign) BOOL checkAllowSignIn;

//status
@property (nonatomic, assign) BOOL      serverIsReady;
@property (nonatomic, assign) BOOL      isProductReady;
@property (nonatomic, assign) BOOL      isPlayNow;
@property (nonatomic, assign) BOOL userSmsStatus;
@property (nonatomic, assign) BOOL isFbAllow;

//data runtime
@property (nonatomic, strong) NSString *accesstoken;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userStatus;
@property (nonatomic, strong) NSString *firebaseFCMToken;
@property (nonatomic, strong) NSString *deviceToken;
//Airbridge
//remove Airbridge module
//@property (nonatomic, strong) NSString *airbridgeName;
//@property (nonatomic, strong) NSString *airbridgeToken;

//Its
@property (nonatomic, strong) NSString *itsWritekey;
@property (nonatomic, strong) NSString *itsSigningKey;
@property (nonatomic, strong) NSString *itsEnv;

//server config data
+ (SdkConfig *) sharedInstance;
- (SdkConfig *) loadConfig:(void(^)(NSString *))loadCallback;
- (id) apiConnect;
- (void) updateAccessToken:(NSString *)accessToken;
- (void) setUserID:(NSString *)userID;
- (void) setUsername:(NSString *)username;
- (void) setOldAccount:(NSString *)oldAccount;
- (void)updateNetwork:(NSString *)network;
- (void)setFirebaseFCMToken:(NSString *)firebaseFCMToken;
- (NSString *)getOldAccount;
- (void)setLoggedInStatus:(BOOL)isLogged;
- (void)clearConfigFile;
- (void)setIsPlayNow;
- (void)setNotPlayNow;
- (BOOL) isLoggedIn;
- (void)setAppLogInstall;
- (BOOL)appIsInstalled;
- (void)deleteAccountWithCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback;
- (NSString *)getAdId;
- (NSString *) getDefaultLanguage;
- (NSString *)getSDKVersionName;
@end
