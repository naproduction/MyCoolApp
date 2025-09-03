#!/usr/bin/env bash
set -euo pipefail

# You can override these from the workflow env or before running:
APP_ID="${APP_ID:-com.example.mycoolapp}"
APP_NAME="${APP_NAME:-MyCoolApp}"

WORKDIR="$(pwd)"
BUILD_DIR="$WORKDIR/app"

echo "==> Using APP_ID=$APP_ID  APP_NAME=$APP_NAME"
rm -rf "$BUILD_DIR"

# Create fresh Cordova app each build
npx cordova telemetry off || true
npx cordova create "$BUILD_DIR" "$APP_ID" "$APP_NAME"

cd "$BUILD_DIR"
npx cordova platform add android

# Copy your code into the app's web assets
rm -rf www/*
mkdir -p www
cp -r "$WORKDIR/../frontend/"* www/ 2>/dev/null || true
cp -r "$WORKDIR/../backend/"*  www/ 2>/dev/null || true

# Build DEBUG (easier to install). Change to --release if you want unsigned release.
npx cordova build android

echo "==> APKs at: app/platforms/android/app/build/outputs/apk/"
