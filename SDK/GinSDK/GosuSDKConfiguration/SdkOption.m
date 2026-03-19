//
//  SdkOption.m
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import "SdkOption.h"

@implementation SdkOption

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableIts = NO;
        _enableAppsflyer = NO;
        _enableFirebase = NO;
    }
    return self;
}

#pragma mark - Builder Pattern

+ (instancetype)builder {
    return [[SdkOption alloc] init];
}

+ (instancetype)builderWithDefaultOption {
    SdkOption *options = [[SdkOption alloc] init];
    options.enableIts = YES;
    options.enableAppsflyer = NO;
    options.enableFirebase = YES;
    return options;
}

#pragma mark - ITS Configuration

- (instancetype)enableIts:(BOOL)enable {
    self.enableIts = enable;
    return self;
}

- (BOOL)isItsEnabled {
    return self.enableIts;
}

#pragma mark - AppsFlyer Configuration

- (instancetype)enableAppsflyer:(BOOL)enable {
    self.enableAppsflyer = enable;
    return self;
}

- (BOOL)isAppsflyerEnabled {
    return self.enableAppsflyer;
}

#pragma mark - Firebase Configuration

- (instancetype)enableFirebase:(BOOL)enable {
    self.enableFirebase = enable;
    return self;
}

- (BOOL)isFirebaseEnabled {
    return self.enableFirebase;
}

#pragma mark - Preset Configurations

+ (instancetype)allEnabled {
    SdkOption *options = [[SdkOption alloc] init];
    options.enableIts = YES;
    options.enableAppsflyer = YES;
    options.enableFirebase = YES;
    return options;
}

@end

