//
//  SdkConfig.m
//  GinSDK
//
//  Created by Nero-Macbook on 3/26/22.
//
#import <Foundation/Foundation.h>
#import "SdkConfig.h"
#import "TripleDes.h"
#import "ServerFactory.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "GlobalVariable.h"
#import "SdkHelper.h"

static SdkConfig *sharedInstance;
@implementation SdkConfig

#pragma mark Singleton Methods
+ (SdkConfig *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil){
            sharedInstance = [[super alloc] init];
            sharedInstance.clientIsReady = NO;
            sharedInstance.serverIsReady = NO;
        }
    }
    return sharedInstance;
}

- (SdkConfig *) loadConfig:(void(^)(NSString *))loadCallback
{
//    NSString *dataResult = @"failed";
    if(!_clientIsReady)
    {
        //load client config
        [self loadClientConfig];
    }
    [self loadServerConfig:loadCallback];
    [self loadConfigFile];
    return self;
}

- (NSString *)getLocale
{
    NSString *currentLanguage = [[NSLocale preferredLanguages] firstObject];
    NSLog(@"locale = %@", currentLanguage);
    if (currentLanguage && [currentLanguage length] > 0) {
        return currentLanguage;
    }
    return @"en";
}

- (NSString *) formatLanguage:(NSString *)lang
{
    NSString *tmp = [self extractLanguages:lang];
    if (tmp) {
        lang = tmp;
    }
    NSDictionary *langDic = @{
        @"vi": @"vi",
        @"vi-us": @"vi",
        @"vn": @"vi",
        @"en": @"en",
        @"en-us": @"en",
        @"th": @"thb",
        @"thb": @"thb",
        @"khmer": @"khmer",
        @"km": @"khmer",
        @"tw": @"tw",
        @"zh-hant": @"tw",
        @"zh-tw": @"tw"
    };
    NSString *langDefault = @"vi";
    NSString *langLowercase = lang ? [lang lowercaseString]: @"";
    if (langLowercase && [langDic objectForKey:langLowercase] && [[langDic objectForKey:langLowercase] length] > 1) {
        langDefault = [langDic objectForKey:langLowercase];
    }
    return langDefault;
}

- (NSString *) extractLanguages:(NSString *)inputStrings {
    NSString *pattern = @"^([^\\-]+)";
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        NSLog(@"Error creating regex: %@", error);
        return inputStrings;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:inputStrings options:0 range:NSMakeRange(0, [inputStrings length])];
    if (match) {
        NSRange matchRange = [match rangeAtIndex:1];
        NSString *language = [inputStrings substringWithRange:matchRange];
        return language;
    }
    
    return inputStrings;
}

- (NSString *) getDefaultLanguage
{
    return [self formatLanguage:[self getLocale]];
}

- (void)loadClientConfig
{
    self->_sdkLanguage = [self getDefaultLanguage];
    
    NSBundle *GameSDKResource = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SDKDataResource" withExtension:@"bundle"]];
    NSString *gameConfigFile = [[GameSDKResource bundlePath] stringByAppendingPathComponent:@"SDKDataConfiguration"];
    NSString *dataConfig = [NSString stringWithContentsOfFile:gameConfigFile encoding:NSUTF8StringEncoding error:nil];
    NSString *sdkBundlePlist = [GameSDKResource pathForResource:@"Info" ofType:@"plist"];
    _sdkVersion = @"";
    if(sdkBundlePlist) {
        NSDictionary *bundleData = [NSDictionary dictionaryWithContentsOfFile:sdkBundlePlist];
        if(bundleData) {
            _sdkVersion = [bundleData objectForKey:@"CFBundleShortVersionString"];
        }
    }
    _clientIsReady = NO;
//    _airbridgeName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AirbAppName"];
//    _airbridgeToken = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AirbAppToken"];
    [self loadItsConfig];
    
    [self loadLocalAppsflyerConfig];
    
    NSString *GameClientID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GameClientID"];
    NSString *GameSdkSignature = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GameSdkSignature"];
    if(GameClientID && [GameClientID length] > 0 )
    {
        _clientID = GameClientID;
    }
    if(GameSdkSignature && [GameSdkSignature length] > 0 )
    {
        _sdkSignature = GameSdkSignature;
    } else if(!_sdkSignature || [_sdkSignature length] <1 ) {
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        _sdkSignature = bundleID;
    }
}

- (void)loadServerConfig:(void(^)(NSString *))loadCallback
{
    if(_serverIsReady) {
        if(loadCallback){
            loadCallback(@"success");
        }
        
    } else {
        id<ServerConnectionDelegate> connect = [self apiConnect];
        [connect loadServerConfig:self andCallback:^(LoadServerConfigResponse *response) {
            
            if([response.status isEqualToString:@"success"]) {
                self->_checkAllowSignIn = YES;
                self->_gameId = response.gameID;
                self->_clientID = response.clientID;
                self->_secrectKey = response.secrectID;
                self->_serviceID = response.clientID;
                self->_serviceKey = response.secrectID;
                self->_idAppKey = response.idAdsAppKey;
                self->_idAppSign = response.idAdsAppSign;
                //Appflyer Removed
//                self->_appFlyerKey = response.appsFlyerDevKey;
//                self->_appFlyerAppleID = response.appsFlyerAppleAppID;
                self->_iapProductID = response.productIDs;
                self->_priceType = response.priceType;
                self->_currency = response.currencyUnit;
                self->_partnerID = response.partnerID;
                self->_delAccountIsOpen = [response.delAccountAllow isEqual:@"allow"] ? YES : NO;
                self->_environment = response.environment;
                self->_showPlaynow = ![self->_environment isEqual:@"censorship"];
                self->_walletAllow = ![self->_environment isEqual:@"submit"];
                self->_isFbAllow = response.isFbAllow;
                if(response.currencyUnit && [response.currencyUnit length]>0)
                {
                    self->_currency = [response.currencyUnit uppercaseString];
                }
                if(response.language && [response.language length]>1)
                {
                    self->_sdkLanguage = [self formatLanguage:response.language];
                }
                if([self->_iapProductID count] > 0)
                {
                    self->_isProductReady = YES;
                }
                NSLog(@"self->_productIDList = %@", self->_iapProductID);
                self->_serverIsReady = YES;
            }
            if(loadCallback) {
                if(self->_serverIsReady)
                {
                    loadCallback(@"success");
                } else {
                    loadCallback(@"failed");
                }
            }
        }];
    }
     
}

- (void)loadConfigFile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _accesstoken   = [defaults objectForKey:@"accessToken"];
    _deviceToken   = [defaults objectForKey:@"devicetoken"];
    _username      = [defaults objectForKey:@"username"];
    _network       = [defaults objectForKey:@"signInNetwork"];
    _userSmsStatus     = [defaults boolForKey:@"userSmsStatus"];
    _userID        = [defaults objectForKey:@"userID"];
    _isPlayNow        = [defaults boolForKey:@"isPlayNow"];
    
    _firebaseFCMToken        = [defaults objectForKey:@"firebaseFCMToken"];
    
    
    if(!_accesstoken || [_accesstoken isKindOfClass:[NSNull class]])
        _accesstoken = @"";
    if(!_deviceToken || [_deviceToken isKindOfClass:[NSNull class]])
        _deviceToken = @"";
    if(!_username || [_username isKindOfClass:[NSNull class]])
        _username = @"";
    if(!_userID || [_userID isKindOfClass:[NSNull class]])
        _userID = @"";
}

- (void)loadItsConfig
{
    //NSLog(@"loadItsConfig");
    if(_itsWritekey == NULL) {
        _itsWritekey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ItsWriteKey"];
        _itsSigningKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ItsSigningKey"];
        _itsEnv = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ItsMode"];
        
    }
}

- (void)loadLocalAppsflyerConfig
{
    NSLog(@"SdkConfig -> loadLocalAppsflyerConfig");
    if(_appsflyerKey == NULL) {
        _appsflyerKey = [SdkHelper getAppsflyerDevKey];
        _appsflyerAppleID =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppsflyerAppleID"];
    }
}

- (void) setUsername:(NSString *)username
{
    _username = username;
    [self setDefaultDataWithKey:@"username" andValue:username];
}
- (void) setUserID:(NSString *)userID
{
    _userID = userID;
    [self setDefaultDataWithKey:@"userID" andValue:userID];
}

- (void) updateAccessToken:(NSString *)accessToken
{
    _accesstoken = accessToken;
    [self setDefaultDataWithKey:@"accessToken" andValue:accessToken];
}
- (void) setOldAccount:(NSString *)oldAccount
{
    [self setDefaultDataWithKey:@"oldAccount" andValue:oldAccount];
}

- (NSString *)getOldAccount
{
    return [self getDefaultDataWithKey:@"oldAccount"];
}

- (void)updateNetwork:(NSString *)network
{
    _network = network;
    [self setDefaultDataWithKey:@"signInNetwork" andValue:network];
}

- (void)setIsPlayNow
{
    _isPlayNow = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_isPlayNow forKey:@"isPlayNow"];
    [defaults synchronize];
}

- (void)setNotPlayNow
{
    _isPlayNow = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_isPlayNow forKey:@"isPlayNow"];
    [defaults synchronize];
}

- (void)clearConfigFile
{
    _accesstoken = @"";
    _username = @"";
    _userID = @"";
    _network = @"";
    _userSmsStatus = NO;
    _isPlayNow = NO;
    //
    [self setUserID:_userID];
    [self updateNetwork:_userID];
    [self resetDefaultData];
    [self setLoggedInStatus:NO];
}

- (void)setFirebaseFCMToken:(NSString *)firebaseFCMToken
{
    _firebaseFCMToken = firebaseFCMToken;
    [self setDefaultDataWithKey:@"firebaseFCMToken" andValue:firebaseFCMToken];
}

- (void)setLoggedInStatus:(BOOL)isLogged
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isLogged forKey:@"isLogged"];
    [defaults synchronize];
}

- (void)setAppLogInstall
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isInstalled"];
    [defaults synchronize];
}

- (BOOL)appIsInstalled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool isInstalled = [defaults boolForKey:@"isInstalled"];
    return isInstalled;
}

- (BOOL) isLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isLogged"];
}
- (void) resetDefaultData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_accesstoken forKey:@"accesstoken"];
    [defaults setObject:_userID forKey:@"userID"];
    [defaults setObject:_username forKey:@"username"];
    [defaults setObject:_firebaseFCMToken forKey:@"firebaseFCMToken"];
    [defaults setBool:_userSmsStatus forKey:@"userSmsStatus"];
    [defaults setBool:_isPlayNow forKey:@"isPlayNow"];
    [defaults synchronize];
}
- (NSString *) getDefaultDataWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dataValue = [defaults objectForKey:key];
    if(!dataValue || [dataValue isKindOfClass:[NSNull class]])
        dataValue = @"";
    return dataValue;
}
- (void) setDefaultDataWithKey:(NSString *)key andValue:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
- (void)deleteAccountWithCallback:(void (^)(NSDictionary<NSString *, id> *))deleteCallback
{
    id<ServerConnectionDelegate> connect = [self apiConnect];
    UserRequireData *_userData = [[UserRequireData alloc] init];
    _userData.username = [self username];
    [connect deleteAccount:_userData andCallback:deleteCallback];
}
- (id<ServerConnectionDelegate>) apiConnect
{
    return [[ServerFactory sharedInstance] connection];
}

- (NSString *)getAdId {
    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
    BOOL isTrackingEnabled = NO;
    // Kiểm tra trạng thái tracking trên iOS 14 trở lên
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
         isTrackingEnabled = (status == ATTrackingManagerAuthorizationStatusAuthorized);
    }
    // Kiểm tra trạng thái tracking trên các phiên bản iOS khác
    else {
        ASIdentifierManager *identifierManager = [ASIdentifierManager sharedManager];
        isTrackingEnabled = [identifierManager isAdvertisingTrackingEnabled];
    }
    if(isTrackingEnabled == YES) {
        return [manager.advertisingIdentifier UUIDString];
    }
    return @"";
}

- (NSString *)getSDKVersionName {
    return @G_SDK_VERSION_NAME;
}

-(void) setFeatureWithOption:(SdkOption *) option {
    self->_enableIts = option.enableIts;
    self->_enableFirebase = option.enableFirebase;
    self->_enableAppsflyer = option.enableAppsflyer;
}
- (BOOL) isEnableIts {
    return _enableIts;
}
- (BOOL) isEnableAppsflyer {
    return _enableAppsflyer;
}
- (BOOL) isEnableFirebase {
    return _enableFirebase;
}

@end

