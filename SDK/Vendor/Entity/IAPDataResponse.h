//
//  IAPDataResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/9/21.
//


@interface IAPDataResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *refreshToken;
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,strong) id transactionData;

@end
