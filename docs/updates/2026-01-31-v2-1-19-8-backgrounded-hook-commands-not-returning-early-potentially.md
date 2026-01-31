---
title: "バックグラウンド実行されたフックコマンドが即座に戻らない問題の修正"
date: 2026-01-23
tags: ['バグ修正', 'hooks', 'バックグラウンド処理']
---

## 原文（日本語に翻訳）

意図的にバックグラウンド実行されたフックコマンドが早期に戻らず、セッションが不要にプロセスを待機する可能性がある問題を修正しました。

## 原文（英語）

Fixed backgrounded hook commands not returning early, potentially causing the session to wait on a process that was intentionally backgrounded

## 概要

Claude Code v2.1.19で修正されたフックシステムの問題です。バックグラウンドで実行するように設計されたフックコマンド（`&` を使用）が即座に制御を返さず、セッションがそのプロセスの完了を待ってしまう問題が解決されました。これにより、長時間実行されるバックグラウンドタスク（ログ監視、サーバー起動など）を含むフックが正しく動作するようになりました。

## 基本的な使い方

フックでバックグラウンドプロセスを起動する場合、コマンドの末尾に `&` を付けます。

**修正前の問題:**

```yaml
# .claude/hooks/on-session-start.sh
#!/bin/bash

# 開発サーバーをバックグラウンドで起動
npm run dev > /tmp/dev-server.log 2>&1 &

# 修正前: ここでセッションが待機してしまう
# → npm run dev が終了するまで Claude Code が応答しない
```

**修正後の動作:**

```yaml
# .claude/hooks/on-session-start.sh
#!/bin/bash

# 開発サーバーをバックグラウンドで起動
npm run dev > /tmp/dev-server.log 2>&1 &

# 修正後: すぐに制御が戻る
# → セッションが即座に開始され、サーバーはバックグラウンドで動作
```

## 実践例

### 開発サーバーの自動起動

セッション開始時に開発サーバーをバックグラウンドで起動:

```bash
#!/bin/bash
# .claude/hooks/on-session-start.sh

# フロントエンド開発サーバー
cd /path/to/frontend
npm run dev > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!

# バックエンド開発サーバー
cd /path/to/backend
python manage.py runserver > /tmp/backend.log 2>&1 &
BACKEND_PID=$!

# PIDをファイルに保存（後でクリーンアップ用）
echo $FRONTEND_PID > /tmp/frontend.pid
echo $BACKEND_PID > /tmp/backend.pid

echo "開発環境を起動しました"
```

修正後は、これらのサーバーがバックグラウンドで起動し、すぐにClaude Codeセッションが使用可能になります。

### ログ監視の開始

特定のログファイルを監視してエラーを検出:

```bash
#!/bin/bash
# .claude/hooks/on-session-start.sh

# エラーログ監視をバックグラウンドで開始
tail -f /var/log/app.log | grep -i error > /tmp/errors.log 2>&1 &
LOG_MONITOR_PID=$!

echo $LOG_MONITOR_PID > /tmp/log-monitor.pid
echo "ログ監視を開始しました"
```

### データベースのウォームアップ

セッション開始時にデータベースキャッシュをウォームアップ:

```bash
#!/bin/bash
# .claude/hooks/on-session-start.sh

# 時間のかかるウォームアップクエリをバックグラウンドで実行
(
  sleep 2
  psql -d mydb -c "SELECT * FROM large_table LIMIT 1000;" > /dev/null 2>&1
  echo "キャッシュウォームアップ完了" > /tmp/warmup.log
) &

echo "データベースウォームアップを開始しました"
```

### テストウォッチャーの起動

ファイル変更を監視して自動テストを実行:

```bash
#!/bin/bash
# .claude/hooks/on-session-start.sh

# Jestをウォッチモードで起動
cd /path/to/project
npm run test:watch > /tmp/test-watch.log 2>&1 &
TEST_WATCHER_PID=$!

echo $TEST_WATCHER_PID > /tmp/test-watcher.pid
echo "テストウォッチャーを起動しました"
```

### セッション終了時のクリーンアップ

バックグラウンドプロセスを適切に終了:

```bash
#!/bin/bash
# .claude/hooks/on-session-end.sh

# 起動したプロセスを終了
if [ -f /tmp/frontend.pid ]; then
  kill $(cat /tmp/frontend.pid) 2>/dev/null
  rm /tmp/frontend.pid
fi

if [ -f /tmp/backend.pid ]; then
  kill $(cat /tmp/backend.pid) 2>/dev/null
  rm /tmp/backend.pid
fi

if [ -f /tmp/test-watcher.pid ]; then
  kill $(cat /tmp/test-watcher.pid) 2>/dev/null
  rm /tmp/test-watcher.pid
fi

echo "バックグラウンドプロセスを終了しました"
```

## 注意点

- **`&` の使用**: バックグラウンド実行には必ず `&` をコマンドの末尾に付けてください
- **出力のリダイレクト**: バックグラウンドプロセスの出力は適切にリダイレクトしないと、ターミナル出力が乱れる可能性があります
- **PIDの管理**: クリーンアップが必要な場合は、プロセスIDを保存しておいてください
- **エラーハンドリング**: バックグラウンドプロセスのエラーは直接見えないため、ログファイルで確認できるようにしてください
- **リソース管理**: 終了しないバックグラウンドプロセスはリソースを消費し続けるため、`on-session-end` フックで適切にクリーンアップしてください
- **タイムアウト**: 非常に長時間実行されるプロセスの場合、システムリソースの監視が重要です

## 関連情報

- [Claude Code 公式ドキュメント - Hooks](https://code.claude.com/docs/en/hooks)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
- [Bash バックグラウンドジョブ](https://www.gnu.org/software/bash/manual/html_node/Job-Control.html)
