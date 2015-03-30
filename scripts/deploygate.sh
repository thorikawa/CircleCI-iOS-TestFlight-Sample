#!/bin/sh

#PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_UUID.mobileprovision"
RELEASE_DATE=$(date '+%Y-%m-%d %H:%M:%S')
ARCHIVE_PATH="$PWD/build.xcarchive"
APP_DIR="$ARCHIVE_PATH/Products/Applications"
DSYM_DIR="$ARCHIVE_PATH/dSYMs"

echo "********************"
echo "*     Archive      *"
echo "********************"
xcodebuild -scheme "$XCODE_SCHEME" -workspace "$XCODE_WORKSPACE" -archivePath "$ARCHIVE_PATH" clean archive -configuration Release

echo "********************"
echo "*     Signing      *"
echo "********************"
xcrun -sdk iphoneos PackageApplication -v  "$APP_DIR/$APPNAME.app" -o "$APP_DIR/$APPNAME.ipa"

#RELEASE_NOTES="Build: ${CIRCLE_BUILD_NUM} Uploaded: $RELEASE_DATE"
RELEASE_NOTES="$RELEASE_DATE"
curl -F file="@$APP_DIR/$APPNAME.ipa"  -F "token=${DEPLOYGATE_API_TOKEN}" -F message="$RELEASE_NOTES" https://deploygate.com/api/users/${DEPLOYGATE_USER_NAME}/apps



#zip -r -9 "$DSYM_DIR/$APPNAME.app.dSYM.zip" "$DSYM_DIR/$APPNAME.app.dSYM"

# echo "********************"
# echo "*    Uploading     *"
# echo "********************"
# curl http://testflightapp.com/api/builds.json \
#   
#   -F dsym="@$DSYM_DIR/$APPNAME.app.dSYM.zip" \
#   -F api_token="$API_TOKEN" \
#   -F team_token="$TEAM_TOKEN" \
#   -F distribution_lists="$TESTFLIGHT_DIST_LIST" \
#   -F notes="$RELEASE_NOTES" -v

