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
INSERT INTO scores (name, score, seed, ip, created_at) VALUES
  ('Emma',           6210, 1, '', strftime('%s','now')),
  ('ぴょんきち',      5980, 1, '', strftime('%s','now')),
  ('Liam',           5540, 1, '', strftime('%s','now')),
  ('はむたろう',      5100, 1, '', strftime('%s','now')),
  ('Sophie',         4620, 1, '', strftime('%s','now')),
  ('ケーキだいすき',  4180, 1, '', strftime('%s','now')),
  ('Lucas',          3750, 1, '', strftime('%s','now')),
  ('あんこ',          3020, 1, '', strftime('%s','now')),
  ('Olivia',         2260, 1, '', strftime('%s','now')),
  ('ぷりん',          1480, 1, '', strftime('%s','now'));
