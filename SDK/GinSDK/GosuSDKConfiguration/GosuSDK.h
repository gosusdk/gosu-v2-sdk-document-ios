//
//  GosuSDK.h
//  GosuSDK
//
//  Created by Nero-Macbook on 2/15/23.
//

#import <UIKit/UIKit.h>
#import "LibSDKFramework.h"

@interface GosuSDK : LibSDKFramework

+ (GosuSDK *) sharedInstance;
- (void) initSDK;
@end
