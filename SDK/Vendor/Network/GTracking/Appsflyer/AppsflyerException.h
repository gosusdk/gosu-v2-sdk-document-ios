//
//  AppsflyerException.h
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import <Foundation/Foundation.h>

@interface AppsflyerException : NSException

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger code;

+ (instancetype)exceptionWithMessage:(NSString *)message code:(NSInteger)code;
- (instancetype)initWithMessage:(NSString *)message code:(NSInteger)code;

@end
