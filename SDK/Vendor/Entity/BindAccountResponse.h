//
//  BindAccountResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/8/21.
//

@interface BindAccountResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic,strong) NSString *transactionID;

@end
