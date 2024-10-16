//
//  UserRequireData.h
//  GameSDK
//
//  Created by Nero-Macbook on 3/21/22.
//
#import <Foundation/Foundation.h>
@interface UserRequireData : NSObject

+ (UserRequireData *) sharedInstance;
+ (UserRequireData *)sharedInstance:(BOOL)newObject;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *rePassword;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *OTPNetwork;
@property (nonatomic,strong) NSString *OTPCode;
@property (nonatomic,strong) NSString *transactionID;
@property (nonatomic,strong) NSString *actionType;
//1 = register
//2 = forgot password
//3 = link account

//IAP
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,strong) NSString *OrderToken;
@property (nonatomic,strong) NSString *ServiceEmail;
@property (nonatomic,strong) NSString *ExtraInfo;
@property (nonatomic,assign) int ResultCode;
@property (nonatomic,strong) NSString *ErrorMessage;
@property (nonatomic,strong) NSString *AccessToken;
@property (nonatomic, assign) bool isNotEmpty;

typedef void(^userRequireCallback)(id);
@property (nonatomic,copy) userRequireCallback callback;

- (void)clear;
- (int) getActionTypeNumber;
@end
