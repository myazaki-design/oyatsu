# iOSリリース ワークフロー（Apple Developer登録 〜 審査提出）

スイーツムツム v1.0 の初回提出（2026年7月）で確立した手順。次回のアップデート提出や別アプリの新規リリース時はこれに沿って進める。
初回のみ必要な手順には【初回のみ】と付記。アップデート時は Phase 3〜5 だけでよい。

---

## Phase 0: Apple Developer Program 登録【初回のみ】

1. https://developer.apple.com/programs/ から登録（個人・年間 $99/99ドル）
2. 決済完了メールが届いてから有効化まで少し時間がかかることがある
3. **登録済み情報**: Team ID `868GVN9WJJ`（個人 / Masataka Yazaki）。ストアには本名が表示される（確認済みでOK）

> ⚠️ **Apple IDの取り違えに注意**: Macに複数のApple IDが入っていると、Xcodeが旧・無料アカウント
> （Personal Team）を掴むことがある。必ず**Developer Program加入済みのApple ID**でサインインする。

## Phase 1: Xcode プロジェクト設定【初回のみ】

1. Xcode → Settings → **Accounts** → Developer ProgramのApple IDを「Add an Account」で追加
2. ターゲットの **Signing & Capabilities** → Team = 有料チーム（Personal Teamではない方）を選択
3. **Bundle ID はグローバルで一意**。取得できないときは別名にする
   - 例: `com.yazaki.oyatsu` は別アカウントが予約済みで使用不可 → `com.yazaki.sweetstack` に変更
   - 変更箇所: `project.pbxproj` の `PRODUCT_BUNDLE_IDENTIFIER` と `capacitor.config.json` の `appId`
4. **iPhone専用にする**: `TARGETED_DEVICE_FAMILY = 1`
   - 縦画面固定アプリを "1,2"（iPad対応）のままアップロードすると
     **エラー90474**（iPadマルチタスクは4方向対応必須）で弾かれる。iPhone専用なら縦固定OK
5. **Info.plist に追加しておくもの**:
   - `ITSAppUsesNonExemptEncryption` = `false`（暗号化申告。これで提出時の輸出コンプライアンス質問がスキップされる）
   - AdMob利用時: `GADApplicationIdentifier`（アプリID）＋ `SKAdNetworkItems`
6. 実機テスト用のデバイス登録: iPhoneを接続 → エラーが出たら「Register Device」
   - キーチェーンのダイアログにはMacのログインパスワード →「常に許可」

## Phase 2: ストア素材の準備

1. **スクリーンショット**: 6.9インチ（**1320×2868px**）が必須サイズ。ここに入れれば他サイズは自動流用
   - シミュレータで撮影。日本語5枚・英語4枚を作成済み（`../appstore-screenshots/` と `../appstore-screenshots-en/`。**gitリポジトリ外**に保管）
   - 英語版はゲーム側の言語判定がシミュレータに届かないことがあるため、一時的に `const LANG='en'` を強制して撮影 → **撮影後は必ず戻す**（git statusで確認）
2. **プライバシーポリシー**: `privacy.html`（日英併記）を GitHub Pages でホスト
   - URL: `https://myazaki-design.github.io/oyatsu/privacy.html`
   - 連絡先: yazakiiiii@gmail.com（iが5つ・サブアドレス運用）
3. **掲載テキスト**: `docs/appstore-listing.md` にコピペ用の日英一式（名前/サブタイトル/プロモ/説明/キーワード）

## Phase 3: Archive & アップロード

1. `bash tools/sync-ios.sh` でゲーム本体をiOSプロジェクトへ同期
2. AdMob利用時: `ADMOB.useTest = false` になっているか確認（本番提出時）
3. Xcode: 実機 or 「Any iOS Device (arm64)」を選択 → **Product → Archive**
4. Organizer → **Distribute App → App Store Connect → Upload**
5. アップロード後、App Store Connect側の「ビルド処理」完了を待つ（完了メールが届く）

## Phase 4: App Store Connect 入力

### アプリ作成【初回のみ】
- 名前（日本語プライマリ）・Bundle ID・SKU（例 `oyatsu-001`）を入力
- **App名もグローバルで一意**。衝突したら一語足す（例: "Sweet Stack" 使用済み → **"Sweet Stack Tower"** で取得）
- カテゴリ: ゲーム → カジュアル。**キッズカテゴリには入れない**（広告審査が厳格化するため。4+レーティングで全年齢対応にする）
- 年齢レーティング: 全項目「なし」→ **4+**

### App のプライバシー【初回のみ・重要】
AdMob（**非パーソナライズ・子ども向け設定・ATTダイアログなし**）構成での正解:

| データタイプ | 利用目的 | ユーザーにひも付け | トラッキング |
|---|---|---|---|
| デバイスID | サードパーティ広告 | いいえ | **いいえ** |
| 広告データ | サードパーティ広告 | いいえ | **いいえ** |
| 製品の操作 | サードパーティ広告 | いいえ | **いいえ** |
| クラッシュデータ | アプリの機能 | いいえ | **いいえ** |

> ⚠️ トラッキング「はい」にすると ATT ダイアログ（`NSUserTrackingUsageDescription`）が必須になり、
> 実装していないため審査で矛盾を指摘される。`npa=true`＋子ども向け設定なら「いいえ」が正しい。

最後に**「公開」ボタン**を押して確定（これを忘れると申告が反映されない）。

### バージョンページ
1. スクショ（6.9インチ枠）・プロモーションテキスト・説明・キーワード・サポートURLを入力
2. **ビルドを選択**（アップロード済みの処理完了ビルドを紐付け）
3. リリース方法: **「手動でリリース」推奨**（審査通過＝即公開を防ぎ、自分のタイミングで出せる）

### 英語ローカライズ（任意・素材があれば）
1. バージョンページ**右上の言語プルダウン** →「英語（アメリカ）を追加」
2. **先にテキストを入れて「保存」**（ロケール未保存だとメディアマネージャーで
   「新しいロケールを保存してください」エラーになりスクショを上げられない）
3. スクショは「メディアマネージャーですべてのサイズを表示」→ 言語=英語 → **6.9インチ枠**へ
   （バージョンページに最初に出る6.5インチ枠に入れようとするとサイズ不一致になる）
4. App名・サブタイトルの英語版は**「アプリ情報」ページ**の言語プルダウンから（バージョンページではない）
- 未対応言語の国では**プライマリ（日本語）にフォールバック**して表示される。配信自体は全世界

### App Review 情報
- 連絡先メール: yazakiiii@gmail.com（iが4つ）
- サインイン情報: 不要（ログイン機能なし）

## Phase 5: 提出

「審査用に追加」→ 提出。「1項目が提出されました」と出れば完了。
- 審査は最大48時間、結果はメールで通知
- リジェクト時は理由文を確認して個別対応

## Phase 6: 審査通過後にやること

1. 「手動でリリース」の場合: リリースボタンを押して公開
2. **AdMob**: 管理画面でアプリを「アプリストアにリンク」（公開後のストアURLを紐付け）
3. **せかいランキング**: Cloudflare Workerの再デプロイ＋D1シード入れ替え
   ```bash
   cd ranking-api && npx wrangler deploy
   ```
   （名前バリデーション反映。D1操作は CLAUDE.md の「せかいランキングのバックエンド」参照）

---

## つまずきポイント早見表

| 症状 | 原因 | 対処 |
|---|---|---|
| Bundle IDが登録できない | 別アカウントが予約済み（グローバル一意） | 別のIDにする |
| TeamがPersonal Teamしか出ない | 無料Apple IDでサインインしている | Developer Program加入済みIDを追加 |
| アップロード時エラー90474（orientation） | 縦固定＋iPad対応の組み合わせ | `TARGETED_DEVICE_FAMILY = 1` |
| "Device isn't registered" | 実機未登録 | iPhone接続→Register Device |
| App名が「すでに使用されています」 | ストア名もグローバル一意 | 一語足して差別化 |
| 英語スクショが上げられない（ロケール保存エラー） | 英語テキスト未保存 | 先にテキスト入力→保存→スクショ |
| スクショのサイズ不一致 | 6.5インチ枠に6.9インチ画像 | メディアマネージャーで6.9インチ枠へ |
| プライバシーのトラッキング申告で矛盾 | ATT未実装なのに「はい」 | 非パーソナライズ構成なら全部「いいえ」 |
| AdMob「アプリを確認できませんでした」（app-ads.txt） | ストアにデベロッパーサイト未登録 | **任意なので無視可**。下記参照 |

## app-ads.txt について（v1.0時点では未対応・任意）

AdMobの「アプリの確認」で `app-ads.txt` の警告が出るが、**広告配信の必須条件ではない**
（v1.0はこの警告が出たまま広告配信・収益発生を確認済み）。なりすまし防止とプログラマティック
需要の取り込みでわずかに収益が上がる程度なので、規模が小さいうちは対応不要。

対応する場合に必要なもの3点:

1. `myazaki-design.github.io` リポジトリ（GitHub Pagesのユーザーサイト＝ドメインのルート）を作成し、
   `app-ads.txt` を置く。中身はこの1行:
   ```
   google.com, pub-5048076405660377, DIRECT, f08c47fec0942fa0
   ```
   （`pub-5048076405660377` = AdMobパブリッシャーID / `f08c47fec0942fa0` = Google共通の認証ID）
   ※ `/oyatsu/` 配下ではダメ。**ドメインのルート**に置く必要がある
2. **App Store Connectのマーケティングを `https://myazaki-design.github.io/` に設定**
   ← v1.0では **sellerUrl が未設定**だったため、Googleに探す場所が無く検証が失敗していた（これが根本原因）。
   公開中バージョンのメタデータ変更は次バージョン提出時になるので、**v1.1提出のついでにやるのが現実的**
3. AdMobの「アプリの確認」で「アップデートを確認」をクリック
