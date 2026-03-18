//
//  SdkHelper.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/1/21.
//

#import <UIKit/UIKit.h>

@interface SdkHelper : NSObject {
    
}
+ (SdkHelper *) sharedInstance;

- (void) showAlertMessage:(NSString *)withTitle
           andWithMessage:(NSString *)withMessage
              andCallback:(void (^)(UIAlertAction * _Nonnull action))withCallback;
- (void) showAlertMessage: (UIViewController *_Nonnull)_UIViewController
             andWithTitle:(NSString *_Nonnull)withTitle
           andWithMessage:(NSString *_Nonnull)withMessage
              andCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action))withCallback;
- (void) showConfirmMessage: (UIViewController *_Nullable)_UIViewController
               andWithTitle:(NSString *_Nonnull)withTitle
             andWithMessage:(NSString *_Nonnull)withMessage
              andOkCallback:(void (^_Nonnull)(UIAlertAction * _Nonnull action)) okCallback
          andCancelCallback:(void (^_Nullable)(UIAlertAction * _Nonnull action)) cancelCallback;
- (void) runInMainThread:(void(^)(void)) loading;
-(UIViewController *)getKeyWindow;
- (UIViewController *)topViewController:(UIViewController *)rootViewController;

// Security methods for encrypted keys
+ (NSString *)getAppsflyerDevKey;
@end
