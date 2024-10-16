

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHMAC : NSObject

+ (instancetype) sharedInstance;

- (NSString *) encryptSHA256:(NSString *)rawData key:(NSString *)skey;

- (NSString *) getCurrentTimeStamp;
- (NSString *) getNonceString;
@end

NS_ASSUME_NONNULL_END
