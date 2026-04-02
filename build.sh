#!/bin/sh
set -e

# tenta reaproveitar caches do Vercel
FLUTTER_DIR=".vercel/cache/flutter"
PUB_CACHE_DIR=".vercel/cache/.pub-cache"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_DIR"
fi

PATH="$PATH:$(pwd)/$FLUTTER_DIR/bin"
PUB_CACHE="$(pwd)/$PUB_CACHE_DIR"
export PATH PUB_CACHE

flutter --version
flutter clean
flutter pub get
flutter build web --release
