//
//  GAppsflyerListener.h
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import <Foundation/Foundation.h>

@class AppsflyerException;

@protocol GAppsflyerListener <NSObject>

@optional
- (void)onInitializeSuccess;
- (void)onInitializeError:(AppsflyerException *)error;
- (void)onConversionDataSuccess:(NSDictionary *)conversionData;
- (void)onConversionDataFail:(NSString *)error;

@end
