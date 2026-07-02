//
//  RequestLogoutResponse.h
//  GosuSDK
//
//  Created by ITC on 8/6/26.
//

@interface RequestLogoutResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;

@end
