#!/usr/bin/env bash
set -euo pipefail

APP_ID="${APP_ID:-com.boss.coolapp}"
APP_NAME="${APP_NAME:-MyCoolApp}"

WORKDIR="${GITHUB_WORKSPACE:-$(pwd)}"
BUILD_DIR="$WORKDIR/app"

echo "==> Using APP_ID=$APP_ID  APP_NAME=$APP_NAME"
rm -rf "$BUILD_DIR"

# 1️⃣ Create fresh Cordova app
npx cordova telemetry off || true
npx cordova create "$BUILD_DIR" "$APP_ID" "$APP_NAME"

cd "$BUILD_DIR"
npx cordova platform add android

# 2️⃣ Copy frontend/backend files into www/
mkdir -p www
cp -r "$WORKDIR/frontend/"* www/ 2>/dev/null || true
cp -r "$WORKDIR/backend/"*  www/ 2>/dev/null || true

# 3️⃣ Force correct config.xml content src
sed -i 's|<content src=".*" />|<content src="index.html" />|' config.xml

# 4️⃣ Build APK (debug + release)
npx cordova build android --debug

echo "==> Build finished. APKs are in:"
find platforms/android/app/build/outputs/apk/ -type f -name "*.apk"
