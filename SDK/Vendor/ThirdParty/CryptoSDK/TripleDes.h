//
//  TripleDes.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/15/21.
//
#import <UIKit/UIKit.h>

@interface TripleDes : NSObject {
    
}

+ (TripleDes *)sharedInstance;
- (NSString *)encrypt:(NSString *)dataString;
- (NSString *)decrypt:(NSString *)dataString;
@end
