//
//  FloatingButton.m
//  GinSDK
//
//  Created by Nero-Macbook on 2/11/23.
//

#import <Foundation/Foundation.h>
#import "FloatingButton.h"

@implementation FloatingButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // setup button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Floating Button" forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}

-(void)didChangeOrientation
{
    NSLog(@"Did change orientation");
}
- (void)viewDidLayoutSubviews {
    NSLog(@"XOAYYYYYYYYYYYY 1");
}
@end
