# Gamo-SDK-ios

This project is for the development of the GosuSDK on the iOS platform.
---

### 1. Download Libraries and Frameworks
Access the required libraries and frameworks here:  
[Download Link](https://drive.google.com/drive/folders/142ranMQ17b6MhJNGKKQ5le6cSlLJQ8rL?usp=sharing)

### 2. Extract Files
Unzip the downloaded Frameworks and Libraries to the following paths:  
- **Framework**: `./GOSUv2-SDK-ios/SDK/Frameworks/framworks`  
- **Libraries**: `./GOSUv2-SDK-ios/SDK/Frameworks/libs`

### 3. Open GinSDK in Xcode
1. Open `GinSDK.xcodeproj` with Xcode IDE and confirm that all frameworks and libraries are successfully added and referenced.  
2. Verify settings:
   - **Target Destinations**: Ensure destinations for the targets "GosuSDK" and "SDKDataResource" are set for device debugging (preferably on a trusted physical device configured in Xcode).
   - **Signing**: Sign the "SDKDataResource" target with the appropriate development certificate.
3. Save and close `GinSDK.xcodeproj`.

### 4. Build with Bash Script
Run the bash script located at `./SDK/build.sh` to initiate the build.  
- Confirm that the build is successful with output files in the following paths:
  - `./GOSUv2-SDK-ios/SDK/build/derived_data`
  - `./GOSUv2-SDK-ios/SDK/build/GosuSDK`

### 5. Open Demo Project
1. Open `GOSUv2-SDK-ios/Demo/GosuApiv2_Demo.xcodeproj` with Xcode IDE.
2. Confirm that the "GinSDK" project, linked as a reference within this Xcode project, includes all necessary frameworks in `GinSDK/Framework`.  
   - If any frameworks are missing, add references to the frameworks and libraries built in Step 4.

### 6. Build and Run Demo
Select the "GosuApiv2_Demo" target, configure, and select the corresponding certificate.  
Build and run the demo to verify functionality.

---
