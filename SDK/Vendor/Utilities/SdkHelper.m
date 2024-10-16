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
@end
