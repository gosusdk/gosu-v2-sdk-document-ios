//
//  UserProfileResponse.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/3/21.
//
@interface UserProfileResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *userStatus;
@property (nonatomic,strong) NSString *userSmsStatus;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *transactionID;

@end
