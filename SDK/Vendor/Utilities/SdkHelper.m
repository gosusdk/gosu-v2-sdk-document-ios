//
//  SdkHelper.m
//  GameSDK
//
//  Created by Nero-Macbook on 11/1/21.
//

#import <Foundation/Foundation.h>
#import "SdkHelper.h"

static SdkHelper *sharedInstance;
@implementation SdkHelper

#pragma mark Singleton Methods
+ (SdkHelper *)sharedInstance
{
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}


- (void) showAlertMessage:(NSString *)withTitle
           andWithMessage:(NSString *)withMessage
              andCallback:(void (^)(UIAlertAction * _Nonnull action))withCallback
{
    UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:withTitle message:withMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *_alertAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:withCallback];
    [_alertController addAction:_alertAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:_alertController animated:YES completion:nil];
    return;
}

- (void) showAlertMessage: (UIViewController *)_UIViewController
             andWithTitle:(NSString *)withTitle
           andWithMessage:(NSString *)withMessage
              andCallback:(void (^)(UIAlertAction * _Nonnull action))withCallback
{
    [self runInMainThread:^{
        UIViewController *rootVC = [self topViewController:_UIViewController];
        UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:withTitle message:withMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *_alertAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:withCallback];
        [_alertController addAction:_alertAction];
        [rootVC presentViewController:_alertController animated:YES completion:nil];
    }];
    return;
}


- (void) showConfirmMessage: (UIViewController *)_UIViewController
             andWithTitle:(NSString *)withTitle
           andWithMessage:(NSString *)withMessage
              andOkCallback:(void (^)(UIAlertAction * _Nonnull action)) okCallback
          andCancelCallback:(void (^)(UIAlertAction * _Nonnull action)) cancelCallback
{
    UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:withTitle message:withMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *_alertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:cancelCallback];
    UIAlertAction *_okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:okCallback];
    [_alertController addAction:_alertAction];
    [_alertController addAction:_okAction];
        [_UIViewController presentViewController:_alertController animated:YES completion:nil];
    return;
}

- (void) runInMainThread:(void(^)(void)) loading
{
    dispatch_block_t block = ^{
        loading();
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

-(UIViewController *)getKeyWindow
{
    UIViewController *keyWindowUIViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    if(!keyWindowUIViewController)
    {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
          if (window.isKeyWindow) {
              keyWindowUIViewController = [window rootViewController];
              break;
          }
        }
    }
    if(!keyWindowUIViewController) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                keyWindowUIViewController = [windowScene.windows.firstObject rootViewController];
                break;
            }
        }
    }
    return keyWindowUIViewController;
}


- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

#pragma mark - Security Methods

+ (NSString *)xorDecryptString:(NSString *)encryptedString withKey:(NSString *)key {
    @try {
        NSData *encryptedData = [encryptedString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!encryptedData || !keyData || keyData.length == 0) {
            return @"";
        }
        
        NSMutableData *decryptedData = [NSMutableData dataWithLength:encryptedData.length];
        const unsigned char *encryptedBytes = (const unsigned char *)encryptedData.bytes;
        const unsigned char *keyBytes = (const unsigned char *)keyData.bytes;
        unsigned char *decryptedBytes = (unsigned char *)decryptedData.mutableBytes;
        
        for (NSUInteger i = 0; i < encryptedData.length; i++) {
            decryptedBytes[i] = encryptedBytes[i] ^ keyBytes[i % keyData.length];
        }
        
        return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding] ?: @"";
        
    } @catch (NSException *exception) {
        NSLog(@"XOR decryption error: %@", exception.reason);
        return @"";
    }
}

+ (NSString *)getAppsflyerDevKey {
    @try {
        NSLog(@"SdkHelper -> getAppsflyerDevKey");
        // Encrypted AppsFlyer key (XOR encrypted with "GamoSDK-GosuCorp-ITC")
        // Same encrypted data as in native-lib.cpp
        const unsigned char encryptedBytes[] = {
            0x0C, 0x26, 0x07, 0x37, 0x67, 0x33, 0x08, 0x55,
            0x03, 0x1D, 0x06, 0x10, 0x2A, 0x25, 0x45, 0x1D,
            0x7F, 0x04, 0x3E, 0x2D, 0x71, 0x03
        };
        
        // Decryption key (obfuscated in multiple parts - same as Android)
        NSString *keyPart1 = @"GamoSDK";
        NSString *keyPart2 = @"-GosuCorp";
        NSString *keyPart3 = @"-ITC";
        NSString *decryptionKey = [NSString stringWithFormat:@"%@%@%@", keyPart1, keyPart2, keyPart3];
        
        // XOR decrypt directly with bytes
        NSData *keyData = [decryptionKey dataUsingEncoding:NSUTF8StringEncoding];
        const unsigned char *keyBytes = (const unsigned char *)keyData.bytes;
        NSUInteger keyLength = keyData.length;
        NSUInteger encryptedLength = sizeof(encryptedBytes);
        
        // Decrypt byte by byte using XOR
        NSMutableData *decryptedData = [NSMutableData dataWithLength:encryptedLength];
        unsigned char *decryptedBytes = (unsigned char *)decryptedData.mutableBytes;
        
        for (NSUInteger i = 0; i < encryptedLength; i++) {
            decryptedBytes[i] = encryptedBytes[i] ^ keyBytes[i % keyLength];
        }
        
        // Convert to string
        NSString *decryptedKey = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
        
        if (decryptedKey && decryptedKey.length > 0) {
            return decryptedKey;
        } else {
            NSLog(@"AppsFlyer key decryption failed: invalid result");
            return @"";
        }
        
    } @catch (NSException *exception) {
        NSLog(@"AppsFlyer key decryption failed: %@", exception.reason);
        // Return empty string on any error to prevent crashes
        return @"";
    }
}
@end
