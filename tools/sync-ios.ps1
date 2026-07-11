# ゲーム本体（リポジトリ直下）を iOS アプリ（app-ios/www）へ同期し、
# Capacitor でネイティブプロジェクトに反映する（Windows用）。
#
# 使い方:  powershell -ExecutionPolicy Bypass -File tools/sync-ios.ps1
# ※ Xcodeビルド自体はMacでのみ可能。Windowsでは同期までを行う
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")   # リポジトリルートへ

$app = "app-ios"
New-Item -ItemType Directory -Force -Path "$app/www" | Out-Null

# ゲームのWebアセット一式を www へコピー（アプリのエントリは index.html）
Copy-Item oyatsu-time.html "$app/www/index.html" -Force
Copy-Item oyatsu-time.html "$app/www/oyatsu-time.html" -Force
Get-ChildItem -File | Where-Object { $_.Extension -in ".png", ".jpg", ".mp3", ".m4a" } |
  Copy-Item -Destination "$app/www/" -Force

# ネイティブプロジェクトへ反映（app-ios/ios/App/App/public を再生成）
Set-Location $app
npx cap copy ios

Write-Host "✅ 同期完了: app-ios/www と ios/App/App/public を更新しました"
