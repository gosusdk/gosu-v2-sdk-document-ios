//
//  SdkOption.h
//  GosuSDK
//
//  Created by ITC on 16/3/26.
//

#import <Foundation/Foundation.h>

/**
 * Configuration options for SDK initialization
 * Allows enabling/disabling specific features: ITS, AppsFlyer, Firebase
 */
@interface SdkOption : NSObject

@property (nonatomic, assign) BOOL enableIts;
@property (nonatomic, assign) BOOL enableAppsflyer;
@property (nonatomic, assign) BOOL enableFirebase;

// Initializers
- (instancetype)init;

// Builder pattern for easy configuration
+ (instancetype)builder;
+ (instancetype)builderWithDefaultOption;

// ITS configuration
- (instancetype)enableIts:(BOOL)enable;
- (BOOL)isItsEnabled;

// AppsFlyer configuration
- (instancetype)enableAppsflyer:(BOOL)enable;
- (BOOL)isAppsflyerEnabled;

// Firebase configuration
- (instancetype)enableFirebase:(BOOL)enable;
- (BOOL)isFirebaseEnabled;

// Preset configurations for common use cases
+ (instancetype)allEnabled;

@end
