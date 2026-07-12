-- スイーツムツム せかいランキング D1スキーマ＋初期シードデータ
-- 実プレイヤーが増えたらシード行は自然に押し下げられる。
-- 全削除したいとき: DELETE FROM scores WHERE seed = 1;

CREATE TABLE IF NOT EXISTS scores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  score INTEGER NOT NULL,
  seed INTEGER NOT NULL DEFAULT 0,   -- 1 = リリース時に用意したシードスコア
  ip TEXT NOT NULL DEFAULT '',       -- 送信元IPのハッシュ（レート制限用。生IPは保存しない）
  created_at INTEGER NOT NULL        -- エポック秒
);

CREATE INDEX IF NOT EXISTS idx_scores_score ON scores(score DESC);
CREATE INDEX IF NOT EXISTS idx_scores_ip_time ON scores(ip, created_at);

-- 初期シード（コールドスタート対策。倒せるスコア帯に設定）
-- 名前は生成パターン（NAME_WORDS の 形容詞+スイーツ+番号1-99）に合致させること
INSERT INTO scores (name, score, seed, ip, created_at) VALUES
  ('SparklyDonut42',   6210, 1, '', strftime('%s','now')),
  ('ぴんくマカロン7',   5980, 1, '', strftime('%s','now')),
  ('HappyCookie9',     5540, 1, '', strftime('%s','now')),
  ('もちもちプリン3',   5100, 1, '', strftime('%s','now')),
  ('BerryMuffin23',    4620, 1, '', strftime('%s','now')),
  ('きらきらケーキ55',  4180, 1, '', strftime('%s','now')),
  ('FluffyWaffle8',    3750, 1, '', strftime('%s','now')),
  ('いちごタルト21',    3020, 1, '', strftime('%s','now')),
  ('CozyPudding5',     2260, 1, '', strftime('%s','now')),
  ('ぷるぷるゼリー4',   1480, 1, '', strftime('%s','now'));
