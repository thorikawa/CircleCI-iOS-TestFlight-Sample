#!/bin/sh

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_UUID.mobileprovision"
RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
ARCHIVE_PATH="$PWD/build.xcarchive"
APP_DIR="$ARCHIVE_PATH/Products/Applications"
DSYM_DIR="$ARCHIVE_PATH/dSYMs"

echo "********************"
echo "*     Archive      *"
echo "********************"
xcodebuild -scheme "$XCODE_SCHEME" -workspace "$XCODE_WORKSPACE" -archivePath "$ARCHIVE_PATH" clean archive CODE_SIGN_IDENTITY="$DEVELOPER_NAME"

echo "********************"
echo "*     Signing      *"
echo "********************"
xcrun -log -sdk iphoneos PackageApplication "$APP_DIR/$APPNAME.app" -o "$APP_DIR/$APPNAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"

RELEASE_NOTES="Build: $CIRCLE_BUILD_NUM\nUploaded: $RELEASE_DATE"

zip -r -9 "$DSYM_DIR/$APPNAME.app.dSYM.zip" "$DSYM_DIR/$APPNAME.app.dSYM"

echo "********************"
echo "*    Uploading     *"
echo "********************"
curl http://testflightapp.com/api/builds.json \
  -F file="@$APP_DIR/$APPNAME.ipa" \
  -F dsym="@$DSYM_DIR/$APPNAME.app.dSYM.zip" \
  -F api_token="$API_TOKEN" \
  -F team_token="$TEAM_TOKEN" \
  -F distribution_lists="$TESTFLIGHT_DIST_LIST" \
  -F notes="$RELEASE_NOTES" -v
