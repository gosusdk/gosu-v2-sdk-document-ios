//
//  TripleDes.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/15/21.
//
#import "TripleDes.h"
#import <CommonCrypto/CommonCryptor.h>

#define key @"ZhrMFHLdSysIO2lsCsYAleLAZGMUTC3R"
#define iv @"4YzbPdL11aa="
#define kSecrectKeyLength 24

static TripleDes *sharedInstance;
@implementation TripleDes
#pragma mark Singleton Methods
+ (TripleDes *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

/*
 .Net/android dùng key 32 bytes
 thì trên objective c là 32 bytes + 8 bytes = 40 bytes
 8 bytes cộng thêm trên objective c là 8 bytes đầu tiên của key
 */
- (NSString *)tripleDesEncryptData:(NSString *)dataValue andKey:(NSString *)key40Byte IV:(NSString *)IV{
    // first of all we need to prepare key
    if([key40Byte length] != 40)
        return @"Require 24 byte key, call function generate24ByteKeySameAsAndroidDotNet with a 16Byte key same as used in Android and .NET"; //temporary error message


    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key40Byte options:NSUTF8StringEncoding];

    // our key is ready, let's prepare other buffers and moved bytes length
    NSData *data = [dataValue dataUsingEncoding:NSUTF8StringEncoding];
    size_t resultBufferSize = [data length] + kCCBlockSize3DES;
    unsigned char resultBuffer[resultBufferSize];
    size_t moved = 0;

    // DES-CBC requires an explicit Initialization Vector (IV)
    // IV - second half of md5 key
    NSMutableData *ivData = [[NSMutableData alloc] initWithBase64EncodedString:IV options:NSUTF8StringEncoding];
    NSMutableData *iivData = [NSMutableData dataWithData:ivData];

    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                            kCCOptionPKCS7Padding , [keyData bytes],
                                            kCCKeySize3DES, [iivData bytes],
                                            [data bytes], [data length],
                                            resultBuffer, resultBufferSize, &moved);

    if (cryptorStatus == kCCSuccess) {
        return [[NSData dataWithBytes:resultBuffer length:moved] base64EncodedStringWithOptions:0];
    } else {
        return nil;
    }
}

- (NSString *)tripleDesDecryptData:(NSString *)encryptValue andKey:(NSString *)key40Byte IV:(NSString *)IV{
   // first of all we need to prepare key
   if([key40Byte length] != 40)
       return @"Require 24 byte key, call function generate24ByteKeySameAsAndroidDotNet with a 16Byte key same as used in Android and .NET"; //temporary error message


   NSData *keyData = [[NSData alloc] initWithBase64EncodedString:key40Byte options:NSUTF8StringEncoding];

   // our key is ready, let's prepare other buffers and moved bytes length
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:encryptValue options:NSUTF8StringEncoding];
   size_t resultBufferSize = [encryptData length] + kCCBlockSize3DES;
   unsigned char resultBuffer[resultBufferSize];
   size_t moved = 0;

   // DES-CBC requires an explicit Initialization Vector (IV)
   // IV - second half of md5 key
   NSMutableData *ivData = [[NSMutableData alloc] initWithBase64EncodedString:IV options:NSUTF8StringEncoding];
   NSMutableData *iivData = [NSMutableData dataWithData:ivData];

   CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                           kCCOptionPKCS7Padding , [keyData bytes],
                                           kCCKeySize3DES, [iivData bytes],
                                           [encryptData bytes], [encryptData length],
                                           resultBuffer, resultBufferSize, &moved);

   if (cryptorStatus == kCCSuccess) {
       return [[NSString alloc] initWithData:[NSData dataWithBytes:resultBuffer length:moved] encoding:NSUTF8StringEncoding];
   } else {
       return nil;
   }
}

-(NSString *)generate40ByteKeySameAsAndroidDotNet:(NSString *)keyData{
    NSString *new40ByteKey = keyData;
    new40ByteKey = [new40ByteKey stringByAppendingString:[keyData substringWithRange:NSMakeRange(0, 8)]];

    return new40ByteKey;
}

- (NSString*)encryptKeyLenghtAuto:(NSString*)plainText{
    uint8_t keyByte[[key length]];
    NSMutableData *keyData = [[NSMutableData alloc] init];
    int i;
    for (i=0; i < [key length] / 2; i++) {
        NSString *tempNumber = [key substringWithRange: NSMakeRange(i * 2, 2)];
        NSScanner *scanner=[NSScanner scannerWithString:tempNumber];
        unsigned int temp;
        [scanner scanHexInt:&temp];
        Byte B = (Byte)(0xFF & temp);
        keyByte[i] = B;
    }

    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

//    const void *vkey = (const void *) keyByte;
    NSData *ivData = [[NSData alloc] initWithBase64EncodedString:iv options:1];
    const void *vinitVec = (const void *) [[self hexadecimalString:ivData] UTF8String];
    ccStatus = CCCrypt(kCCEncrypt,
                   kCCAlgorithm3DES,
                       kCCModeCBC,
                       keyData.bytes,
                   kCCKeySize3DES,
                   vinitVec,
                   vplainText,
                   plainTextBufferSize,
                   (void *)bufferPtr,
                   bufferPtrSize,
                   &movedBytes);

    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSLog(@"myData = %@", myData);
    NSString *result = [myData base64EncodedStringWithOptions:1];

    NSLog(@"result=%@",result);

    return result;
}

- (NSString *)encrypt:(NSString *)dataString
{
    return [self tripleDesEncryptData:dataString andKey:[self generate40ByteKeySameAsAndroidDotNet:key] IV:iv];
}

- (NSString *)decrypt:(NSString *)dataString
{
    return [self tripleDesDecryptData:dataString andKey:[self generate40ByteKeySameAsAndroidDotNet:key] IV:iv];
}

- (NSString *)hexadecimalString:(NSData *)data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */

    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];

    if (!dataBuffer)
        return [NSString string];

    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];

    return [NSString stringWithString:hexString];
}

- (NSString*)base64Encode:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    return base64String;
}
@end
