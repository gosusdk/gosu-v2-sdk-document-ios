//
//  AppsflyerException.m
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import "AppsflyerException.h"

@implementation AppsflyerException

+ (instancetype)exceptionWithMessage:(NSString *)message code:(NSInteger)code {
    return [[self alloc] initWithMessage:message code:code];
}

- (instancetype)initWithMessage:(NSString *)message code:(NSInteger)code {
    self = [super initWithName:@"AppsflyerException" reason:message userInfo:@{@"code": @(code)}];
    if (self) {
        _message = message;
        _code = code;
    }
    return self;
}

@end
