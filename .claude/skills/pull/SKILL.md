---
name: pull
description: 作業開始時にGitHubから最新を取り込む。ユーザーが「git pull」「プルして」「最新にして」と言ったときに使う。取り込んだコミットを要約し、ゲーム本体が更新されていればiOS同期まで自動で行う（別PCとの2台開発の同期漏れ防止）。
---

# プル＆同期（作業開始ルーチン）

別PCとの2台開発で、作業開始時にリポジトリとiOSアプリを最新化する定型フロー。

## 手順

1. **ローカルの未コミット確認**: `git status --short`。未コミットの変更がある場合は
   内容を報告し、pullを続けてよいか判断（コンフリクトしそうなら先にコミットや退避を提案）。

2. **プル**: 現在のHEADを控えてから `git pull origin main`。
   - `Already up to date.` なら「最新です」と報告して終了（同期不要）
   - コンフリクトが出たら、自動で解決せず状況を報告して指示を仰ぐ

3. **取り込み内容の要約**: `git log --oneline 旧HEAD..HEAD` と
   `git diff --stat 旧HEAD..HEAD | tail -3` で、何が入ってきたかを日本語で簡潔に報告。
   CLAUDE.md が更新されていたら仕様変更の可能性が高いので内容を確認する。

4. **iOS同期（重要）**: プルで `oyatsu-time.html` またはアセット
   （`*.png` / `*.jpg` / `*.mp3` / `*.m4a` / `index.html`）が変更されていたら同期を実行:
   - Mac: `bash tools/sync-ios.sh`
   - Windows: `powershell -ExecutionPolicy Bypass -File tools/sync-ios.ps1`
   ※ これを忘れるとXcodeビルドに古いゲームが入る事故になる（過去に発生）。

5. **報告**: 取り込んだコミット数と要点・iOS同期を実行したか・
   次の作業に影響しそうな変更（新機能・仕様変更・新ファイル）を伝える。
