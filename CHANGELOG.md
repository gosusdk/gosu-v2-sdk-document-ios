# iOS GosuSDK Changelog

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
