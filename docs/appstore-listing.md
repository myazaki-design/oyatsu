# App Store 掲載情報（コピペ用）

全世界配信・無料（AdMob広告）。日本語＝プライマリ言語、英語＝追加ローカライズ。
App Store Connect の各フィールドにそのまま貼り付ける。文字数上限も併記。

---

## 基本設定

- **プラットフォーム**: iOS
- **バンドルID**: `com.yazaki.sweetstack`
- **SKU**: `oyatsu-001`（任意の管理ID）
- **プライマリカテゴリ**: ゲーム（Games）→ サブカテゴリ **ファミリー（Family）**
- **セカンダリカテゴリ**: カジュアル（Casual）or パズル（Puzzle）※任意
- **年齢レーティング**: **4+**（暴力・不適切表現なし）
- **価格**: 無料（¥0 / Free）
- **プライバシーポリシーURL**: `https://myazaki-design.github.io/oyatsu/privacy.html`
- **サポートURL**: 同上でも可（専用ページがあれば差し替え）

> ⚠️ **「キッズ」カテゴリには入れない**こと。キッズは第三者広告が禁止で、AdMobを積む本アプリは不可。
> 広告OKの **「ファミリー」** サブカテゴリを使う（ファミリー ≠ キッズ）。
> ⚠️ 名前/サブタイトルに「子供向け・幼児」等の強い子ども断定や読点区切りのキーワード羅列は避ける
> （Guideline 2.3.7 のキーワード詰め込み／child-directed×広告のリスク）。年齢系ワードはキーワード欄で狙う。

---

## 日本語（プライマリ）

**App名**（30字以内）
```
スイーツムツム つみあげバランスゲーム
```

**サブタイトル**（30字以内）
```
だれでもかんたん！つみあげバランス
```

**プロモーションテキスト**（170字以内・審査なしで後から変更可）
```
かわいいスイーツをつみあげて、せかいランキングにちょうせん！ほしをとってフィーバータイムをねらおう🍩✨
```

**キーワード**（100字以内・カンマ区切り）
※ App名/サブタイトルの語（つみあげ・バランス等）は自動索引されるのでキーワードでは繰り返さない。
　年齢・家族系の検索はここで狙う。
```
スイーツ,お菓子,タワー,かわいい,暇つぶし,簡単,子供,幼児,小学生,低年齢,パズル,カジュアル,ケーキ,ドーナツ,ファミリー,知育
```

**説明**（4000字以内）
```
かわいいスイーツをつみあげる、かんたん＆ほのぼのタワーゲーム！

おさらを左右にうごかして、おちてくるドーナツ・ケーキ・マカロン・アイスをキャッチ。タイミングよくつんで、どこまで高くできるかな？

■ かんたん操作
スワイプでおさらをうごかすだけ。タップでスピードアップ。小さなお子さまでもすぐ遊べます。

■ フィーバータイム
ときどき出てくる「ほし」をキャッチすると、フィーバー突入！ズレもなおって、いっきに高くつめるチャンス。

■ おじゃまハムスター
かわいいけどイタズラもの。スイーツをとっていくのでよけてね。

■ せかいランキング
世界中のプレイヤーとハイスコアで勝負！ニックネームは安全な候補から選ぶ方式なので、めんどうな入力はいりません。

やさしい絵柄とほんわかBGMで、親子でもゆったり楽しめます。おやすみ前のちょっとした時間にもぴったり。
```

---

## English（追加ローカライズ）

**App Name**（≤30）
```
Sweet Stack
```

**Subtitle**（≤30）
```
Stack cute sweets sky-high!
```

**Promotional Text**（≤170）
```
Stack adorable sweets and climb the world ranking! Grab a Star to trigger Fever Time 🍩✨
```

**Keywords**（≤100, comma separated）
```
sweets,stack,tower,cute,casual,kids,easy,cake,donut,puzzle,dessert,kawaii
```

**Description**（≤4000）
```
Stack up adorable sweets in this easy, feel-good tower game!

Move the plate to catch falling donuts, cakes, macarons and ice cream. Time it right and see how high you can stack!

■ Simple controls
Just swipe to move the plate, tap to drop faster. Easy enough for little kids.

■ Fever Time
Catch the occasional Star to trigger Fever Time — your wobble resets and you can stack fast!

■ Sneaky Hamster
Cute but mischievous — he steals your sweets, so dodge him!

■ World Ranking
Compete with players around the world! Nicknames are picked from a safe preset, so there's no typing needed.

With gentle art and soothing music, it's relaxing to play — alone or with your kids, or as a quick treat before bed.
```

---

## App プライバシー（データ収集の申告）

App Store Connect の「App のプライバシー」で申告する内容の目安:

- **収集する連絡先情報・本名など**: なし
- **ニックネーム＋スコア**: ユーザーコンテンツ等ではなく、匿名の選択式ニックネーム。個人を特定しない
- **識別子・使用状況データ（AdMob経由）**: 「サードパーティ広告」の目的で **デバイスID・使用状況データ** を収集（Googleが処理）。ユーザーにひも付けない設定
- **IPアドレス**: レート制限用にハッシュ化して一時利用。生データは保存しない → 通常「診断」に該当しないが、心配なら記載しない運用でも可

> 具体的なチェック項目は Google の
> [AdMob 用 App プライバシー申告ガイド](https://support.google.com/admob/answer/9989980) を参照して合わせる。

---

## スクリーンショット

`../appstore-screenshots/`（6.9インチ・1320×2868）:
01_title / 02_howto / 03_play / 04_result / 05_ranking
