// スイーツムツム せかいランキングAPI（Cloudflare Workers + D1）
// エンドポイント:
//   GET  /top?limit=30      … スコア上位を返す [{n: 名前, s: スコア}]（名前ごとに最高スコア）
//   POST /score {n, s, g}   … スコア送信（g は簡易署名。クライアントの worldSig と同じ計算）
//
// D1 バインディング名: DB（Workerの Settings → Bindings で設定）

// クライアント（oyatsu-time.html の worldSig）と同一の簡易署名。
// 気軽なスコア偽装への抑止であり、厳密な防御ではない
function sig(s) {
  let h = 5381;
  s = s + ':oyatsu-mutsumu-2026';
  for (let i = 0; i < s.length; i++) h = ((h << 5) + h + s.charCodeAt(i)) >>> 0;
  return h.toString(36);
}

// 名前のサニタイズ: 制御文字を除去して trim、最大10文字
function cleanName(v) {
  let out = '';
  const src = String(v || '');
  for (let i = 0; i < src.length; i++) {
    const c = src.charCodeAt(i);
    if (c >= 32 && c !== 127) out += src[i];
  }
  return out.trim().slice(0, 10);
}

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function json(obj, status) {
  return new Response(JSON.stringify(obj), {
    status: status || 200,
    headers: Object.assign({ 'Content-Type': 'application/json; charset=utf-8' }, CORS),
  });
}

// スコアの妥当性上限。ゲームの理論値よりだいぶ上に置いた雑なサニティチェック
const SCORE_MAX = 200000;
// 同一IPからの送信レート制限（60秒間に最大5回）
const RATE_WINDOW_SEC = 60;
const RATE_MAX = 5;

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (request.method === 'OPTIONS') return new Response(null, { headers: CORS });

    try {
      // --- 上位取得 ---
      if (url.pathname === '/top' && request.method === 'GET') {
        let limit = Math.floor(+url.searchParams.get('limit') || 30);
        if (!(limit >= 1)) limit = 30;
        limit = Math.min(limit, 100);
        const rs = await env.DB.prepare(
          'SELECT name AS n, MAX(score) AS s FROM scores GROUP BY name ORDER BY s DESC LIMIT ?1'
        ).bind(limit).all();
        return json(rs.results || []);
      }

      // --- スコア送信 ---
      if (url.pathname === '/score' && request.method === 'POST') {
        let body;
        try { body = await request.json(); } catch (e) { return json({ error: 'bad json' }, 400); }

        const name = cleanName(body.n);
        const score = Math.floor(+body.s || 0);
        const g = String(body.g || '');

        if (!name) return json({ error: 'bad name' }, 400);
        if (!(score > 0) || score > SCORE_MAX) return json({ error: 'bad score' }, 400);
        if (g !== sig(name + ':' + score)) return json({ error: 'bad sig' }, 400);

        // レート制限（IPは保存前にハッシュ化してプライバシー配慮）
        const ipRaw = request.headers.get('CF-Connecting-IP') || '';
        const ip = sig('ip:' + ipRaw);
        const now = Math.floor(Date.now() / 1000);
        const rc = await env.DB.prepare(
          'SELECT COUNT(*) AS c FROM scores WHERE ip = ?1 AND created_at > ?2'
        ).bind(ip, now - RATE_WINDOW_SEC).first();
        if (rc && rc.c >= RATE_MAX) return json({ error: 'rate limited' }, 429);

        await env.DB.prepare(
          'INSERT INTO scores (name, score, seed, ip, created_at) VALUES (?1, ?2, 0, ?3, ?4)'
        ).bind(name, score, ip, now).run();

        return json({ ok: true });
      }

      return json({ error: 'not found' }, 404);
    } catch (e) {
      return json({ error: 'server error' }, 500);
    }
  },
};
