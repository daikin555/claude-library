---
title: "スキルとスラッシュコマンドのfrontmatterでhooksをサポート"
date: 2026-01-31
tags: ['新機能', 'hooks', 'スキル']
---

## 原文（日本語に翻訳）

スキルとスラッシュコマンドのfrontmatterにhooksサポートを追加しました

## 原文（英語）

Added hooks support for skill and slash command frontmatter

## 概要

Claude Code v2.1.0で導入された、スキル固有のフック機能です。従来のエージェントフックに加えて、各スキルやスラッシュコマンドが独自のPreToolUse、PostToolUse、Stopフックをfrontmatterで定義できるようになりました。これにより、スキル実行時の自動ログ記録、環境検証、後処理などを各スキルごとにカスタマイズでき、スキルの動作をきめ細かく制御できます。

## 基本的な使い方

スキル定義ファイル（`.claude/skills/<skill-name>.md`）のfrontmatterにフックを定義します。

```markdown
---
name: my-skill
description: カスタムスキル
hooks:
  PreToolUse: |
    #!/bin/bash
    echo "Skill: $SKILL_NAME, Tool: $TOOL_NAME"
  PostToolUse: |
    #!/bin/bash
    echo "Tool completed: $TOOL_NAME"
  Stop: |
    #!/bin/bash
    echo "Skill execution finished"
---

# スキルのプロンプト内容
このスキルは...
```

## 実践例

### コミット用スキルの自動検証

コミットスキルで、コミット前に自動的にリンターとテストを実行します。

```markdown
---
name: safe-commit
description: 検証付きコミット
hooks:
  PreToolUse: |
    #!/bin/bash
    # git commit 実行前のみチェック
    if [ "$TOOL_NAME" = "Bash" ] && echo "$TOOL_INPUT" | grep -q "git commit"; then
      echo "Running pre-commit checks..."

      # リンター実行
      npm run lint
      if [ $? -ne 0 ]; then
        echo "❌ Lint failed. Commit aborted."
        exit 1
      fi

      # テスト実行
      npm test
      if [ $? -ne 0 ]; then
        echo "❌ Tests failed. Commit aborted."
        exit 1
      fi

      echo "✅ Pre-commit checks passed"
    fi
  PostToolUse: |
    #!/bin/bash
    # コミット成功時の通知
    if [ "$TOOL_NAME" = "Bash" ] && echo "$TOOL_INPUT" | grep -q "git commit" && [ "$TOOL_SUCCESS" = "true" ]; then
      osascript -e 'display notification "Commit successful" with title "Claude Code"'
    fi
---

# Safe commit skill
Create commits with automatic validation...
```

### デプロイスキルの実行ログ

デプロイスキルで、すべての操作を詳細にログ記録します。

```markdown
---
name: deploy-prod
description: 本番環境デプロイ
hooks:
  PreToolUse: |
    #!/bin/bash
    # デプロイログの初期化（初回のみ）
    log_file=~/.claude/logs/deploy-$(date +%Y%m%d-%H%M%S).log
    if [ ! -f /tmp/deploy-log-initialized ]; then
      echo "=== Deploy started at $(date) ===" > "$log_file"
      echo "$log_file" > /tmp/current-deploy-log
      touch /tmp/deploy-log-initialized
    fi

    # すべてのツール使用をログ
    current_log=$(cat /tmp/current-deploy-log)
    echo "[$(date +%H:%M:%S)] Using tool: $TOOL_NAME" >> "$current_log"
  PostToolUse: |
    #!/bin/bash
    current_log=$(cat /tmp/current-deploy-log)
    if [ "$TOOL_SUCCESS" = "true" ]; then
      echo "[$(date +%H:%M:%S)] ✓ $TOOL_NAME completed" >> "$current_log"
    else
      echo "[$(date +%H:%M:%S)] ✗ $TOOL_NAME failed" >> "$current_log"
    fi
  Stop: |
    #!/bin/bash
    # デプロイ完了時の処理
    current_log=$(cat /tmp/current-deploy-log)
    echo "=== Deploy finished at $(date) ===" >> "$current_log"
    echo "Deploy log saved to: $current_log"

    # クリーンアップ
    rm -f /tmp/current-deploy-log /tmp/deploy-log-initialized
---

# Production deployment skill
Handle production deployments with full logging...
```

### データベース操作スキルのバックアップ

データベース変更前に自動バックアップを作成します。

```markdown
---
name: db-migration
description: データベースマイグレーション
hooks:
  PreToolUse: |
    #!/bin/bash
    # Bashツールでマイグレーション実行前にバックアップ
    if [ "$TOOL_NAME" = "Bash" ] && echo "$TOOL_INPUT" | grep -q "migrate"; then
      echo "Creating database backup before migration..."

      backup_file="db-backup-$(date +%Y%m%d-%H%M%S).sql"
      pg_dump mydb > "$backup_file"

      if [ $? -eq 0 ]; then
        echo "✅ Backup saved: $backup_file"
        echo "$backup_file" > /tmp/latest-db-backup
      else
        echo "❌ Backup failed. Migration aborted."
        exit 1
      fi
    fi
  Stop: |
    #!/bin/bash
    # マイグレーション完了後のクリーンアップ
    if [ -f /tmp/latest-db-backup ]; then
      backup=$(cat /tmp/latest-db-backup)
      echo "Migration completed. Backup available at: $backup"
      rm -f /tmp/latest-db-backup
    fi
---

# Database migration skill
Safely perform database migrations with automatic backups...
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- スキルフックの適用範囲:
  - スキルが実行されている間のみ有効
  - スキル終了時（Claudeがプロンプトを処理し終えた時）に自動的に登録解除
  - 複数のスキルを同時に実行する場合、各スキルのフックは独立して動作
- サポートされるフックタイプ:
  - `PreToolUse`: ツール実行直前に実行
  - `PostToolUse`: ツール実行直後に実行
  - `Stop`: スキル終了時に実行
- 利用可能な環境変数:
  - `$SKILL_NAME`: 実行中のスキル名
  - `$TOOL_NAME`: 使用されるツール名
  - `$TOOL_INPUT`: ツールへの入力（一部のツールのみ）
  - `$TOOL_SUCCESS`: ツールの成功/失敗（PostToolUseのみ）
- フック実行の順序:
  1. グローバルPreToolUse
  2. スキルPreToolUse
  3. ツール実行
  4. スキルPostToolUse
  5. グローバルPostToolUse
- エラーハンドリング:
  - PreToolUseで `exit 1` を実行すると、ツール実行がキャンセルされる
  - PostToolUseやStopでのエラーは警告として記録されるが、実行は継続
- パフォーマンスへの影響:
  - フックは各ツール呼び出しごとに実行される（頻繁に実行される可能性）
  - 重い処理はバックグラウンドで実行することを推奨
- スキルとエージェントの違い:
  - スキル: ユーザーが明示的に呼び出す（`/skill-name`）
  - エージェント: Claudeが自動的に呼び出す（`Task` ツール経由）
  - どちらも同じフック機構を使用可能

## 関連情報

- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Creating skills](https://code.claude.com/docs/en/skills)
- [Skill lifecycle and frontmatter](https://code.claude.com/docs/en/skill-lifecycle)
