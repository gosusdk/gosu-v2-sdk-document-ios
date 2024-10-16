//
//  AES256Crypt.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/15/21.
//

#import "AES256Crypt.h"
#import <CommonCrypto/CommonCryptor.h>

#define key @"wFl9SEa9ZOSEaVUNpns4eEmmZtMFzFAa"
#define iv @"RC0AmIcwHXN="

static AES256Crypt *sharedInstance;
@implementation AES256Crypt
#pragma mark Singleton Methods
+ (AES256Crypt *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (NSData *)dataForHex:(NSString *)hex
{
    NSString *hexNoSpaces = [[[hex stringByReplacingOccurrencesOfString:@" " withString:@""]
            stringByReplacingOccurrencesOfString:@"<" withString:@""]
            stringByReplacingOccurrencesOfString:@">" withString:@""];

    NSMutableData *data = [[NSMutableData alloc] init];
    unsigned char whole_byte = 0;
    char byte_chars[3] = {'\0','\0','\0'};
    for (NSUInteger i = 0; i < [hexNoSpaces length] / 2; i++) {
        byte_chars[0] = (unsigned char) [hexNoSpaces characterAtIndex:(NSUInteger) (i * 2)];
        byte_chars[1] = (unsigned char) [hexNoSpaces characterAtIndex:(NSUInteger) (i * 2 + 1)];
        whole_byte = (unsigned char)strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}
- (NSData *) cryptOperation:(CCOperation)operation andDataString:(NSData *)dataString
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keys[kCCKeySizeAES256 + 1];
    [key getCString:keys maxLength:sizeof(keys) encoding:NSUTF8StringEncoding];
    // Perform PKCS7Padding on the key.
    unsigned long bytes_to_pad = sizeof(keys) - [key length];
    if (bytes_to_pad > 0)
    {
        char byte = bytes_to_pad;
        for (unsigned long i = sizeof(keys) - bytes_to_pad; i < sizeof(keys); i++)
            keys[i] = byte;
    }
    NSUInteger dataLength = [dataString length];
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus status = CCCrypt(operation, kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keys, kCCKeySizeAES256,
                                     [iv UTF8String],
                                     [dataString bytes], dataLength, /* input */
                                     buffer, bufferSize, /* output */
                                     &numBytesDecrypted);
    if (status == kCCSuccess)
    {
        //the returned NSData takes ownership of buffer and will free it on dealloc
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)encrypt:(NSData *)dataString
{
    return [self cryptOperation:kCCEncrypt andDataString:dataString];
}

- (NSData *)decrypt:(NSData *)dataString
{
    return [self cryptOperation:kCCDecrypt andDataString:dataString];
}

- (NSString *)encryptWithBase64:(NSString *)dataString
{
    NSData *dataNSDATA = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataEncrypt = [self encrypt:dataNSDATA];
    return [dataEncrypt base64EncodedStringWithOptions:1];
}

- (NSString *)decryptWithBase64:(NSString *)dataEncryptBase64
{
    NSData *dataDecryptBase64 = [[NSData alloc] initWithBase64EncodedString:dataEncryptBase64 options:1];
    NSData *dataDecrypt = [self decrypt:dataDecryptBase64];
    return [[NSString alloc] initWithData:dataDecrypt encoding:NSUTF8StringEncoding];
}
@end
