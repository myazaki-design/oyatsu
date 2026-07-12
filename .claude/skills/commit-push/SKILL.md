---
name: commit-push
description: このリポジトリの変更をコミットしてGitHubへプッシュする。ユーザーが「コミットプッシュ」「コミットして」と言ったときに使う。ゲーム本体が変更されていればiOS同期を先に実行してから、日本語メッセージでコミットし、origin/mainへプッシュして結果を報告する。
---

# コミット＆プッシュ

スイーツムツムの変更を安全にコミット・プッシュする定型フロー。

## 手順

1. **状態確認**: `git status --short`。変更がなければ「コミットするものがない」と報告して終了。
   `git status -sb` でリモートとの乖離（ahead/behind）も確認し、behindなら先に pull を促す。

2. **iOS同期（重要・忘れ防止）**: ゲーム本体またはアセットに変更がある場合
   （`oyatsu-time.html` / `*.png` / `*.jpg` / `*.mp3` / `*.m4a` / `index.html`）、
   コミット前に同期を実行する:
   - Mac: `bash tools/sync-ios.sh`
   - Windows: `powershell -ExecutionPolicy Bypass -File tools/sync-ios.ps1`
   ※ `app-ios/www` と `public` はgit管理外なのでコミット内容には現れないが、
   ローカルのXcodeビルドを最新に保つために必ず実行する。

3. **ステージ**: `git add -A`（`.gitignore` が `settings.local.json`・`node_modules`・
   生成物を除外済みなので全部addしてよい）。ステージ結果を `git status --short` で確認し、
   意図しないファイル（一時ファイル・巨大ファイル等）が入っていないか目視する。

4. **コミット**: メッセージは日本語で「何を・なぜ」。1行目に要約、必要なら本文に箇条書き。
   末尾にシステム規約どおりの `Co-Authored-By: Claude ...` 行を付ける。

5. **プッシュ**: `git push origin main`。

6. **報告**: コミットハッシュ・メッセージ要約・変更規模（ファイル数/行数）・
   プッシュ結果（`旧..新` の範囲）・iOS同期を実行したかどうかを簡潔に伝える。

## 注意

- コンフリクトやプッシュ拒否（non-fast-forward）が出たら、無理に解決せず状況を報告して指示を仰ぐ
- タグのプッシュはこのスキルでは行わない（バックアップは別途）
