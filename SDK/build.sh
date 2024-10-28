xcodebuild build \
  -scheme GosuSDK \
  -derivedDataPath build/derived_data \
  -arch arm64 \
  -sdk iphoneos \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES
  
xcodebuild build \
  -scheme SDKDataResource \
  -derivedDataPath build/derived_data \
  -sdk iphoneos \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES
mkdir build/GosuSDK 
mkdir build/GosuSDK/xcframework
cp -r build/derived_data/Build/Products/Debug-iphoneos/SDKDataResource.bundle build/GosuSDK/SDKDataResource.bundle
cp -r build/derived_data/Build/Products/Debug-iphoneos/*.a build/GosuSDK
cp -r build/derived_data/Build/Products/Debug-iphoneos/GSinSDK_include build/GosuSDK

xcodebuild -create-xcframework \
	-library build/GosuSDK/libGosuSDK.a \
	-headers build/GosuSDK/GSinSDK_include/GosuSDK \
  -output build/GosuSDK/GosuSDK.xcframework
cp -r build/GosuSDK/GosuSDK.xcframework build/GosuSDK/xcframework/.
cp -r build/GosuSDK/SDKDataResource.bundle build/GosuSDK/xcframework/.
cp -r build/GosuSDK/GSinSDK_include/Frameworks build/GosuSDK/xcframework/.



