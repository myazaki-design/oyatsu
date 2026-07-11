# スイーツムツム 🍩

お菓子を積み上げるHTML5ゲーム。Web（GMOかんたんゲームボックス）と iOSアプリ（Capacitor）の両方にこのリポジトリからリリースする。

## 構成

```
oyatsu-time.html   ← ゲーム本体（唯一のソース。Web/GMO/iOS共通）
index.html         ← oyatsu-time.html へのリダイレクト（Web用）
*.png *.jpg        ← 画像アセット
*.mp3 *.m4a        ← 音声アセット（すべて44.1kHz統一。倍速録画バグ対策）
tools/sync-ios.sh  ← ゲーム本体を iOS アプリへ同期するスクリプト
app-ios/           ← Capacitor iOSプロジェクト
├── ios/App/App.xcodeproj  ← Xcodeで開くのはこれ
├── www/                   ← 生成物（git管理外。sync-ios.sh が作る）
└── node_modules/          ← git管理外（無ければ app-ios で npm install）
```

## 開発の鉄則

**ゲームの変更はかならずリポジトリ直下の `oyatsu-time.html` に対して行う。**
`app-ios/www/` を直接編集しない（同期で上書きされる）。

## リリース手順

### Web / GMO
リポジトリ直下の `oyatsu-time.html`＋画像・音声一式がそのまま成果物。

### iOS
```bash
bash tools/sync-ios.sh                 # ゲーム本体 → app-ios/www → ネイティブへ反映
open app-ios/ios/App/App.xcodeproj     # Xcodeで開く
```
Xcodeで実機ビルド or Product → Archive → App Store Connectへアップロード。

クローン直後は先に `cd app-ios && npm install` が必要。

## ローカル起動

```bash
python3 -m http.server 8090
# → http://localhost:8090/oyatsu-time.html （?debug=1 でデバッグUI表示）
# ※ 8081 は Claude デスクトップアプリのプレビュー機能が使うため避ける
```
