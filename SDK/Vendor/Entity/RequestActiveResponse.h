//
//  RequestActiveResponse.h
//  GinSDK
//
//  Created by Nero-Macbook on 5/30/22.
//

@interface RequestActiveResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) NSString *code;
@property (nonatomic,strong) NSString *contentFlag;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *transactionID;
@property (nonatomic,strong) NSString *errMessage;

@end
