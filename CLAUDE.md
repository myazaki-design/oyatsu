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

## ランキング

- **じぶんのきろく（ローカルTOP10）**: 全環境で有効。`userData`（best/ranking/nm/howtoSeen）に保持。GMO上は `game_save`、単体は localStorage（`oyatsu_best`/`oyatsu_ranking`/`oyatsu_name`/`oyatsu_howto_seen`）
- **せかいランキング（全世界）**: **iOSアプリ限定**（`isIosApp()` = Capacitor判定）。GMOでは非表示（ポータル側ランキングが役割）、Web単体も非表示。開発確認は `?debug=1` で実API接続、`WORLD_API_BASE` 空ならモック表示
- タイトルの「ランキング」ボタン → ダイアログ内タブ（じぶん/せかい）。せかいは iOS/debug 時のみタブ表示
- リザルトで自動スコア送信（iOS時のみ）。初回は「なまえ」入力ダイアログ → `userData.nm` に保存

## せかいランキングのバックエンド（Cloudflare Workers + D1）

- コードと手順は `ranking-api/`（`worker.js` / `schema.sql` / `README.md`）
- 本番URL: `https://oyatsu-ranking.yazakiiii.workers.dev`（`oyatsu-time.html` の `WORLD_API_BASE` に設定済み）
- API: `GET /top?limit=30`（名前ごと最高スコア降順）、`POST /score {n,s,g}`（`g` は簡易署名。クライアント `worldSig` と worker `sig` が同一実装で、秘密文字列 `:oyatsu-mutsumu-2026` を共有。**両方同時に変えること**）
- 対策: スコア上限20万・IPハッシュで60秒5回のレート制限・CORS。厳密な防御ではない（賞品を付けるなら要強化）
- 運用（D1コンソールでSQL実行）: シード削除 `DELETE FROM scores WHERE seed=1;` / 全送信削除 `DELETE FROM scores WHERE seed=0;` / 不正値削除 `DELETE FROM scores WHERE score>20000;`
- リリース時のシード10件（コールドスタート対策）は `schema.sql` に含む。倒せるスコア帯（最高6210）に設定

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
ranking-api/       せかいランキングのバックエンド（Cloudflare Workers+D1・デプロイ手順つき）
```

クローン直後のiOS開発は `cd app-ios && npm install` が必要。PSD等のデザイン元データはgit外（別途バックアップ）。
