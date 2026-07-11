#!/bin/bash
# ゲーム本体（リポジトリ直下）を iOS アプリ（app-ios/www）へ同期し、
# Capacitor でネイティブプロジェクトに反映する。
#
# 使い方:  bash tools/sync-ios.sh
# その後:  app-ios/ios/App/App.xcodeproj を Xcode で開いてビルド/Archive
set -euo pipefail
cd "$(dirname "$0")/.."   # リポジトリルートへ

APP=app-ios
mkdir -p "$APP/www"

# ゲームのWebアセット一式を www へコピー（アプリのエントリは index.html）
cp oyatsu-time.html "$APP/www/index.html"
cp oyatsu-time.html "$APP/www/oyatsu-time.html"
cp -f *.png *.jpg *.mp3 *.m4a "$APP/www/" 2>/dev/null || true

# ネイティブプロジェクトへ反映（app-ios/ios/App/App/public を再生成）
cd "$APP"
npx cap copy ios

echo "✅ 同期完了: app-ios/www と ios/App/App/public を更新しました"
