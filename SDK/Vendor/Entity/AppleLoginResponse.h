//
//  AppleLoginResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/8/21.
//

@interface AppleLoginResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *errorTitle;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *refreshToken;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *identityToken;

@end
