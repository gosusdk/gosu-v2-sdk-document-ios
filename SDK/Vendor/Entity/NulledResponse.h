//
//  NulledResponse.h
//  GinSDK
//
//  Created by Nero-Macbook on 5/27/22.
//

@interface NulledResponse : NSObject

@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString *message;

@end
