//
//  ErrManager.h
//  GosuSDK
//
//  Created by ITC on 5/6/26.
//

#import <Foundation/Foundation.h>
#import "ErrCodeGroup.h"
#import "ErrConstant.h"
#import <UIKit/UIKit.h>


@interface ErrManager : NSObject

+ (ErrManager *)sharedInstance;

- (void)showErrDialogWithUIViewController: (UIViewController *)_uiViewController andMessage: (NSString *) message andCallback:(void (^)(UIAlertAction * _Nonnull action))withCallback;
//
- (void)showErrDialogWithErrGroup:(NSString *)errCodeGroup andErrCode:(int)errCode andRemoteMessage: (NSString *) remoteMessage andCallback:(void (^)(UIAlertAction * _Nonnull action))withCallback;
//
- (NSString *)getContentErrMessageWithCodeGroup:(NSString *)errCodeGroup andErrCode:(int)errCode andRemoteMessage: (NSString *) remoteMessage;

@end
