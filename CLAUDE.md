# スイーツムツム 開発ガイド（Claude用）

お菓子を積み上げるHTML5ゲーム。Web（GMOかんたんゲームボックス）とiOSアプリ（Capacitor）に同一ソースからリリースする。

## 鉄則

1. **ゲームの変更はリポジトリ直下の `oyatsu-time.html` だけに行う**（Web/GMO/iOS共通の唯一のソース）
2. `app-ios/www/` と `app-ios/ios/App/App/public/` は**生成物。直接編集禁止**（同期で上書きされる）
3. iOSアプリへの反映: Mac `bash tools/sync-ios.sh` / Windows `powershell tools/sync-ios.ps1`
4. ゲーム本体を変更したら sync を忘れずに実行してからコミットに含める運用（コミット前チェック）
5. **マルチPC開発**: 作業開始時に必ず `git pull`、区切りでコミット＆プッシュ。未プッシュのまま別PCで作業しない

## ローカル確認

```bash
python3 -m http.server 8090        # Windows: python -m http.server 8090
# → http://localhost:8090/oyatsu-time.html
```
- ポート**8081は使わない**（Claudeデスクトップのプレビュー機能と衝突）
- `?debug=1` でデバッグUI（コライダー表示・崩壊ログ等）
- `?lang=en` / `?lang=ja` で言語切替（指定はlocalStorageに保存される）

## コードの約束事

- **文言の直書き禁止**: ユーザー向けテキストは `I18N` 辞書（ja/en）にキーを追加し `t('key')` で参照。プレースホルダは `t('key', {n: 3})` 形式
- **音源は44.1kHz統一**（48kHzはiOS画面録画で倍速になるバグの原因）。新規追加はAAC(.m4a)推奨。追加時は `applySfxVolume()` と `stopAllAudioForBackground()` の対象リストにも登録
- **物理は固定タイムステップ**（揺れ・崩壊とも1/120s。フレームレート依存を入れない）。フレーム移動量には `fs`（dt×60）を掛ける
- 座標系: `screenY = worldY - cameraY`。`UNIT = min(W/420, H/700)` が画面スケール基準
- セーフエリア: `--sat/--sab` CSS変数経由。`PLATE_Y = H - safeBottom`
- 環境判定: GMO埋め込みは `gbEmbedded()`（iframe判定）。iframe時は額縁なし全面表示（`html.embedded`）

## リリース

- **GMO**: リポジトリ直下のWebファイル一式が成果物。スコア送信・セーブ・リワード広告は gamebox API（`gbOn()`/`gbAdOn()` でガード済み。単体動作時はlocalStorageフォールバック）
- **iOS**: sync実行 → `app-ios/ios/App/App.xcodeproj` をXcodeで開いてArchive（**Macのみ**。Windowsではゲーム開発のみ可能）
- コンティニュー画面はGMO上（広告あり）でのみ表示される仕様

## コミット規約

- メッセージは日本語で「何を・なぜ」。末尾に `Co-Authored-By: Claude ...` を付与
- プッシュはユーザーの指示があったときに行う
- 節目のバックアップは日付タグ（例: `backup-20260711`）＋`git archive`のzip

## ディレクトリ

```
oyatsu-time.html   ゲーム本体（唯一のソース）
index.html         リダイレクト（Web用エントリ）
*.png *.jpg *.mp3 *.m4a  アセット
tools/sync-ios.*   iOS同期スクリプト（.sh=Mac / .ps1=Windows）
app-ios/           Capacitor iOSプロジェクト（node_modules/wwwはgit外）
```

クローン直後のiOS開発は `cd app-ios && npm install` が必要。PSD等のデザイン元データはgit外（別途バックアップ）。
