//
//  AES256Crypt.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/15/21.
//
#import <UIKit/UIKit.h>

@interface AES256Crypt : NSObject {
    
}

+ (AES256Crypt *)sharedInstance;
- (NSData *)encrypt:(NSData *)dataString;
- (NSData *)decrypt:(NSData *)dataString;
- (NSData *)dataForHex:(NSString *)hex;
- (NSString *)encryptWithBase64:(NSString *)dataString;
- (NSString *)decryptWithBase64:(NSString *)dataEncryptBase64;
@end
