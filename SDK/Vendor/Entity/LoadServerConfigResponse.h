//
//  LoadServerConfigResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/2/21.
//

@interface LoadServerConfigResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) NSInteger *code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *googleID;
@property (nonatomic,strong) NSString *providerID;
@property (nonatomic,strong) NSString *gameID;
@property (nonatomic,strong) NSString *clientID;
@property (nonatomic,strong) NSString *secrectID;
@property (nonatomic,strong) NSString *serviceID;
@property (nonatomic,strong) NSString *serviceKey;
@property (nonatomic,strong) NSArray *productIDs;
@property (nonatomic,strong) NSString *idAdsAppKey;
@property (nonatomic,strong) NSString *idAdsAppSign;
@property (nonatomic,strong) NSString *appsFlyerDevKey;
@property (nonatomic,strong) NSString *appsFlyerAppleAppID;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSString *currencyUnit;
@property (nonatomic, strong) NSString *priceType;
@property (nonatomic, strong) NSString *partnerID;
@property (nonatomic, strong) NSString *environment;
@property (nonatomic, strong) NSString *topupwallet;
@property (nonatomic, strong) NSString *delAccountAllow;
@property (nonatomic, assign) bool isFbAllow;

@end
