
#import "MyHMAC.h"

@implementation MyHMAC

+ (instancetype)sharedInstance
{
    static MyHMAC *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyHMAC alloc] init];
    });
    
    return instance;
}

- (NSString *)encryptSHA256:(NSString *)rawdata key:(nonnull NSString *)skey
{
    const char *cKey = [skey cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [rawdata cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData2 = [rawdata cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData2, strlen(cData2), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *base64 = [hash base64EncodedStringWithOptions:kNilOptions];
    //NSLog(@"base64=%@", base64);
    return base64;
}

- (NSString *)getCurrentTimeStamp
{
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); // returned as a double
    long digits = (long)time; // this is the first 10 digits
    int decimalDigits = (int)(fmod(time, 1) * 1000); // this will get the 3 missing digits
    NSString *timestampString = [NSString stringWithFormat:@"%ld%d", digits ,decimalDigits];
    return timestampString;
}

- (NSString *)getNonceString
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:20];
    for (int i=0; i<20; i++) {
         [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

@end
