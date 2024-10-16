//
//  requestLoginResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/3/21.
//

@interface RequestLoginResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *refreshToken;
@property (nonatomic,strong) NSString *transactionID;

@end
