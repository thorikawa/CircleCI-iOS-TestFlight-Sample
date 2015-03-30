#!/bin/bash

RELEASE_DATE=$(date '+%Y-%m-%d %H:%M:%S')
ARCHIVE_PATH="$PWD/build.xcarchive"
APP_DIR="$ARCHIVE_PATH/Products/Applications"

echo "********************"
echo "*     Archive      *"
echo "********************"
xcodebuild -scheme "$XCODE_SCHEME" -workspace "$XCODE_WORKSPACE" -archivePath "$ARCHIVE_PATH" clean archive -configuration Release

echo "********************"
echo "*     Signing      *"
echo "********************"
xcrun -sdk iphoneos PackageApplication -v  "$APP_DIR/$APPNAME.app" -o "$APP_DIR/$APPNAME.ipa"

# deploy
RELEASE_NOTES="Build: ${CIRCLE_BUILD_NUM}, Uploaded: $RELEASE_DATE"
curl -F file="@$APP_DIR/$APPNAME.ipa"  -F "token=${DEPLOYGATE_API_TOKEN}" -F message="$RELEASE_NOTES" "https://deploygate.com/api/users/${DEPLOYGATE_USER_NAME}/apps"

