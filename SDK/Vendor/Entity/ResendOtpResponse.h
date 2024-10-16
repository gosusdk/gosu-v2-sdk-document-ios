//
//  ResendOtpResponse.h
//  GinSDK
//
//  Created by Nero-Macbook on 4/9/22.
//

@interface ResendOtpResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *otpCode;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *phoneNumber;

@end
