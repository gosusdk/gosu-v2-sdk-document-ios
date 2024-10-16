//
//  FloatingButton.h
//  GinSDK
//
//  Created by Nero-Macbook on 2/11/23.
//
#import <UIKit/UIKit.h>

@protocol FloatingButtonDelegate

@end

@interface FloatingButton : UIView
@property (nonatomic, weak) NSObject<FloatingButtonDelegate>* delegate;
- (instancetype)initWithFrame:(CGRect)frame;
@end
