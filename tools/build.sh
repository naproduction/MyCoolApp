#!/usr/bin/env bash
set -euo pipefail

# build.sh - Cordova create + build script (GitHub Actions friendly)
APP_ID="${APP_ID:-com.boss.coolapp}"
APP_NAME="${APP_NAME:-MyCoolApp}"

# If running in GitHub Actions, GITHUB_WORKSPACE is set; otherwise fallback to cwd
WORKROOT="${GITHUB_WORKSPACE:-$(pwd)}"
BUILD_DIR="$WORKROOT/app"

echo "==> build.sh running in: $WORKROOT"
echo "==> APP_ID=$APP_ID APP_NAME=$APP_NAME"

# clean
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# create app
npx cordova telemetry off || true
npx cordova create "$BUILD_DIR" "$APP_ID" "$APP_NAME"

# inject our config.xml (replace placeholders)
TEMPLATE="$WORKROOT/tools/config-template.xml"
if [ -f "$TEMPLATE" ]; then
  sed "s|__APP_ID__|$APP_ID|g; s|__APP_NAME__|$APP_NAME|g" "$TEMPLATE" > "$BUILD_DIR/config.xml"
fi

cd "$BUILD_DIR"

# add android platform
npx cordova platform add android

# copy web assets
rm -rf www/*
mkdir -p www
cp -r "$WORKROOT/frontend/"* www/ 2>/dev/null || true
cp -r "$WORKROOT/backend/"*  www/ 2>/dev/null || true

# copy resources for icons/splash to a res folder inside project
mkdir -p res
cp -r "$WORKROOT/resources/icon.png" res/icon.png 2>/dev/null || true
cp -r "$WORKROOT/resources/splash.png" res/splash.png 2>/dev/null || true

# ensure config.xml content src is correct (local file)
sed -i 's|<content src=".*" />|<content src="index.html" />|' config.xml || true

# build debug apk
npx cordova build android --debug

# print results
echo "==> Build finished. APKs:"
find platforms/android/app/build/outputs/apk/ -type f -name "*.apk" || true
