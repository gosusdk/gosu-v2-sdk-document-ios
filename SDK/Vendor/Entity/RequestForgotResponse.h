//
//  RequestForgotResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/4/21.
//

@interface RequestForgotResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSString *transactionID;
@property (nonatomic,assign) BOOL isRichText;

@end
