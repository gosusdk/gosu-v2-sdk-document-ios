xcodebuild build \
  -scheme GosuSDK \
  -configuration Debug \
  -derivedDataPath build/derived_data \
  -arch arm64 \
  -sdk iphoneos \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

mkdir -p build/GosuSDK/iphoneos
mkdir -p build/GosuSDK/simulators
mkdir -p build/GosuSDK/arm64_simulators
mkdir build/GosuSDK/xcframework

cp -r build/derived_data/Build/Products/Debug-iphoneos/*.a build/GosuSDK/iphoneos
cp -r build/derived_data/Build/Products/Debug-iphoneos/GSinSDK_include build/GosuSDK/iphoneos

xcodebuild build \
  -scheme GosuSDK \
  -configuration Debug \
  -derivedDataPath build/derived_data \
  -arch x86_64 \
  -arch arm64 \
  -sdk iphonesimulator \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

cp -r build/derived_data/Build/Products/Debug-iphonesimulator/*.a build/GosuSDK/simulators
cp -r build/derived_data/Build/Products/Debug-iphonesimulator/GSinSDK_include build/GosuSDK/simulators
rm -rf build/derived_data/Build/Products/Debug-iphonesimulator

# Clean xcframework directory before creating new one
rm -rf build/GosuSDK/xcframework/GosuSDK.xcframework

# Build SDKDataResource.bundle for device iphone
xcodebuild build \
  -scheme SDKDataResource \
  -configuration Debug \
  -derivedDataPath build/derived_data \
  -sdk iphoneos \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

cp -r build/derived_data/Build/Products/Debug-iphoneos/SDKDataResource.bundle build/GosuSDK/iphoneos/SDKDataResource.bundle

# Build SDKDataResource.bundle for device simulator
xcodebuild build \
  -scheme SDKDataResource \
  -configuration Debug \
  -derivedDataPath build/derived_data \
  -sdk iphonesimulator \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

cp -r build/derived_data/Build/Products/Debug-iphonesimulator/SDKDataResource.bundle build/GosuSDK/simulators/SDKDataResource.bundle

# Remove CFBundleExecutable key from SDKDataResource.bundle Info.plist to fix App Store validation
echo "Fixing SDKDataResource.bundle Info.plist..."
if [ -f "build/GosuSDK/iphoneos/SDKDataResource.bundle/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c "Delete :CFBundleExecutable" "build/GosuSDK/iphoneos/SDKDataResource.bundle/Info.plist" 2>/dev/null || echo "CFBundleExecutable key not found or already removed"
    echo "CFBundleExecutable key removed from SDKDataResource.bundle/Info.plist"
fi

xcodebuild -create-xcframework \
  -library build/GosuSDK/simulators/libGosuSDK.a \
  -headers build/GosuSDK/simulators/GSinSDK_include/GosuSDK \
	-library build/GosuSDK/iphoneos/libGosuSDK.a \
	-headers build/GosuSDK/iphoneos/GSinSDK_include/GosuSDK \
  -output build/GosuSDK/xcframework/GosuSDK.xcframework

cp -r build/GosuSDK/iphoneos/SDKDataResource.bundle build/GosuSDK/xcframework/.
cp -r build/GosuSDK/iphoneos/GSinSDK_include/Frameworks build/GosuSDK/xcframework/.

# Also fix the bundle in xcframework directory
echo "Fixing SDKDataResource.bundle in xcframework..."
if [ -f "build/GosuSDK/xcframework/SDKDataResource.bundle/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c "Delete :CFBundleExecutable" "build/GosuSDK/xcframework/SDKDataResource.bundle/Info.plist" 2>/dev/null || echo "CFBundleExecutable key not found or already removed"
    echo "CFBundleExecutable key removed from xcframework/SDKDataResource.bundle/Info.plist"
fi
