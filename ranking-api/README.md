# せかいランキングAPI（Cloudflare Workers + D1）

スイーツムツムの世界ランキング用バックエンド。無料枠で運用できる。

- `worker.js` … API本体（GET /top, POST /score）
- `schema.sql` … DBスキーマ＋リリース用シードスコア10件
- `wrangler.toml` … CLIデプロイ用設定（ダッシュボード手順なら不要）

## セットアップ手順A: ダッシュボードだけで完結（おすすめ・ツール不要）

1. **Cloudflareアカウント作成**（無料）: https://dash.cloudflare.com/sign-up
2. **D1データベース作成**:
   - ダッシュボード左メニュー「Storage & Databases」→「D1 SQL Database」→「Create Database」
   - 名前: `oyatsu-ranking` → Create
   - 作成後、「Console」タブを開き、`schema.sql` の中身を全部貼り付けて実行
     （テーブル作成＋シードスコア10件が入る）
3. **Worker作成**:
   - 左メニュー「Workers & Pages」→「Create」→「Create Worker」
   - 名前: `oyatsu-ranking`（URLの一部になる）→ Deploy
   - 「Edit code」で `worker.js` の中身を全部貼り付けて Deploy
4. **WorkerにD1をつなぐ**:
   - Workerの「Settings」→「Bindings」→「Add」→「D1 database」
   - Variable name: `DB` / D1 database: `oyatsu-ranking` → Save（再デプロイされる）
5. **動作確認**（ブラウザでOK）:
   - `https://oyatsu-ranking.<あなたのサブドメイン>.workers.dev/top` を開く
   - シードの10件がJSONで返ってくれば成功
6. **ゲームに接続**:
   - `oyatsu-time.html` の `WORLD_API_BASE = ''` に上記URL（`/top` を除いたベース部分）を設定
   - 例: `const WORLD_API_BASE = 'https://oyatsu-ranking.xxxx.workers.dev';`

## セットアップ手順B: wrangler CLI（Node.js がある環境向け）

```bash
cd ranking-api
npx wrangler login
npx wrangler d1 create oyatsu-ranking        # 出力された database_id を wrangler.toml に書く
npx wrangler d1 execute oyatsu-ranking --remote --file=schema.sql
npx wrangler deploy
```

## APIの仕様

### GET /top?limit=30
スコア上位を返す（名前ごとに最高スコア、降順、limit最大100）。
```json
[{ "n": "Emma", "s": 6210 }, ...]
```

### POST /score
```json
{ "n": "なまえ", "s": 5332, "g": "簡易署名" }
```
- `g` はクライアント（`worldSig`）と同じ djb2 ハッシュ。一致しないと 400
- スコア上限 200000（サニティチェック）、名前は制御文字除去・最大10文字
- 同一IP 60秒に5回までのレート制限（429）。IPはハッシュ化して保存

## 運用メモ

- **シードスコアの削除**（実プレイヤーが増えたら）: D1のConsoleで
  `DELETE FROM scores WHERE seed = 1;`
- **不正っぽいスコアの削除**: `DELETE FROM scores WHERE score > 20000;` など
- 署名は簡易的なもの（ソースを読めば偽装可能）。ランキングに賞品を付ける場合は本格的な対策が必要
