# iOS GosuSDK Changelog

## [1.2.0] - 2026-03-20

### 🚀 New Features

#### AppsFlyer Integration Module
- **AppsFlyer SDK Integration**: Added comprehensive AppsFlyer tracking module for enhanced attribution and analytics

#### SDK Configuration Enhancements
- **SDKOptions Configuration**: New `SdkOption` class for flexible SDK initialization and configuration management
- **Enhanced SDK Initialization**: Improved SDK startup process with configurable options

#### Tracking & Analytics Improvements
- **GTrackingManager Logout Event**: Added missing logout event tracking in GTrackingManager
- **Server ID Tracking**: Enhanced IdAppTracking module for better server-side tracking correlation

### 🛠️ Code Quality & Maintenance

#### Deprecated Code Cleanup
- **Removed @Deprecated Functions**: Cleaned up deprecated methods in GTrackingManager.h/.m
- **Code Standardization**: Improved code consistency across tracking modules

#### Bug Fixes
- **Fixed Duplicate OpenGameLog**: Resolved issue with duplicate OpenGameLog API calls
- **Tracking Event Consistency**: Fixed missing logout event calls in tracking workflow
- **Configuration Stability**: Enhanced SDK configuration loading and validation

### 📋 Migration Notes

#### New Configuration Options
1. **SDKOptions Setup**: Configure SDK options during initialization:
   ```objectivec
   SdkOption *options = [[SdkOption alloc] init];
      //
    SdkOption *option = [SdkOption alloc];
    option.enableIts = YES;
    option.enableFirebase = YES;
    option.enableAppsflyer =YES;
    
    [[GosuSDK sharedInstance] initSdkWithOption:option andInitStatus:^(NSString *initStatus) {
          NSLog(@"initStatus = %@", initStatus);
          if ([initStatus isEqual:@"success"]) {
              NSLog(@"GosuSDK init success");
          } else {
              NSLog(@"GosuSDK init faild");
          }
      }];
   ```

#### Required Updates
1. **Remove Deprecated Calls**: Update any usage of deprecated GTrackingManager methods
2. **AppsFlyer Framework**: Ensure AppsFlyer framework is properly linked in your project
3. **Configuration Migration**: Update SDK initialization to use new SdkOption configuration

### 🔧 Technical Improvements

#### Architecture Enhancements
- **Modular AppsFlyer Integration**: Clean separation of AppsFlyer functionality into dedicated modules
- **Improved Error Handling**: Enhanced exception handling for AppsFlyer operations
- **Configuration Management**: Centralized SDK configuration through SdkOption class

#### Performance Optimizations
- **Reduced Code Duplication**: Eliminated duplicate OpenGameLog calls
- **Streamlined Initialization**: More efficient SDK startup process
- **Better Memory Management**: Improved resource handling in tracking modules

### ⚠️ Breaking Changes

#### Removed APIs
- **Deprecated GTrackingManager Methods**: Several deprecated tracking methods have been removed
- **Legacy Configuration**: Some obsolete configuration options are no longer supported

#### Framework Requirements
- **iOS Version**: Continues to support iOS 13.0+
- **AppsFlyer Framework**: AppsFlyer SDK now included and required for full functionality
- **Xcode Version**: Xcode 14.0+ recommended for full compatibility

---
**Note**: This release enhances the GosuSDK with AppsFlyer integration for improved attribution tracking while maintaining backward compatibility for core features. The cleanup of deprecated functions and improved configuration management provides better stability and maintainability.

For technical support and integration guidance, please contact our development team.

## [1.1.0] - 2025-10-31

### 🚀 New Features

#### ITS Tracking Module Integration
- **ITS Analytics Framework**: Integrated comprehensive ITS tracking module for enhanced analytics and user behavior tracking
- **Performance Metrics**: Real-time performance tracking and user journey analytics

### 📦 Removed Dependencies

#### Legacy Tracking Modules
- **AppsFlyer SDK**: Completely removed AppsFlyer tracking framework and all related dependencies
- **Airbridge SDK**: Removed Airbridge tracking framework and all integration components
- **Legacy Analytics**: Removed outdated analytics modules and deprecated tracking methods

#### Deprecated Components
- **Old Tracking APIs**: Removed deprecated tracking method signatures and legacy interfaces
- **Legacy Configuration**: Removed obsolete configuration options and unused parameters



### 🛠️ Technical Changes

#### Core Architecture Improvements
- **ITS SDK Integration**: Seamless integration of ITS SDK 1.1.2 for advanced analytics and tracking

### 📋 Migration Notes

#### Required Updates
1. **ITS Configuration**: Add ITS configuration keys to your Info.plist
   ```xml
   <key>ItsSigningKey</key>
   <string>your_its_signing_key</string>
   <key>ItsWriteKey</key>
   <string>your_its_write_key</string>
   ```

2. **Framework Cleanup**: Remove AppsFlyer and Airbridge frameworks from your project build settings
3. **Tracking Migration**: Update tracking calls to use new methods:
   ```objectivec
   [[GosuSDK GTracking] purchase:orderId 
                    andProductId:productId 
                       andAmount:amount 
                     andCurrency:currency 
                     andUsername:username 
                        andIsIAP:YES];
   ```

#### Optional Improvements
- **Enhanced Analytics**: Leverage new ITS analytics capabilities for better user insights
- **Performance Monitoring**: Utilize built-in performance metrics and monitoring
- **Privacy Controls**: Implement granular privacy controls and user consent management

### ⚠️ Breaking Changes

#### Removed APIs
- **AppsFlyer Methods**: All AppsFlyer-specific tracking methods and configurations removed
- **Airbridge Methods**: All Airbridge-specific tracking methods and configurations removed
- **Legacy Tracking**: Deprecated tracking method signatures and legacy APIs removed

#### Framework Requirements
- **Minimum iOS Version**: iOS 13.0+ (unchanged for backward compatibility)
- **Xcode Version**: Xcode 14.0+ recommended for full compatibility with latest features
- **ITS Framework**: ITS SDK 1.1.2 framework now required for analytics functionality

---
**Note**: This release represents a significant modernization of the GosuSDK with focus on performance, privacy compliance, and maintainability. The removal of legacy tracking modules (AppsFlyer, Airbridge) in favor of the unified ITS system provides better analytics capabilities while reducing SDK complexity and size.

For technical support and migration assistance, please contact our development team or refer to the updated documentation.
