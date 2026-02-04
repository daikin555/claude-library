---
title: "エージェントのfrontmatterでhooksをサポート - ライフサイクル制御が可能に"
date: 2026-01-31
tags: ['新機能', 'hooks', 'エージェント']
---

## 原文（日本語に翻訳）

エージェントのfrontmatterにhooksサポートを追加し、エージェントのライフサイクルにスコープされたPreToolUse、PostToolUse、Stopフックを定義できるようになりました

## 原文（英語）

Added hooks support to agent frontmatter, allowing agents to define PreToolUse, PostToolUse, and Stop hooks scoped to the agent's lifecycle

## 概要

Claude Code v2.1.0で導入された、エージェント固有のフック機能です。従来のグローバルフックに加えて、各エージェントが独自のPreToolUse、PostToolUse、Stopフックをfrontmatterで定義できるようになりました。これらのフックはエージェントが実行されている間のみ有効で、エージェント終了時に自動的にクリーンアップされます。これにより、エージェント専用のロギング、検証、リソース管理などをカプセル化できます。

## 基本的な使い方

エージェント定義ファイル（`.claude/agents/<agent-name>/AGENT.md`）のfrontmatterにフックを定義します。

```markdown
---
name: my-custom-agent
description: カスタムエージェント
hooks:
  PreToolUse: |
    #!/bin/bash
    echo "Tool: $TOOL_NAME" >> /tmp/agent-tools.log
  PostToolUse: |
    #!/bin/bash
    echo "Completed: $TOOL_NAME" >> /tmp/agent-tools.log
  Stop: |
    #!/bin/bash
    echo "Agent finished" >> /tmp/agent-tools.log
---

# エージェントのプロンプト内容
このエージェントは...
```

## 実践例

### エージェント専用のツール使用ログ

特定のエージェントがどのツールを使用したかを記録します。

```markdown
---
name: code-reviewer
description: コードレビューエージェント
hooks:
  PreToolUse: |
    #!/bin/bash
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] code-reviewer: Using $TOOL_NAME" >> ~/.claude/logs/code-reviewer.log
  PostToolUse: |
    #!/bin/bash
    if [ "$TOOL_SUCCESS" = "true" ]; then
      status="✓"
    else
      status="✗"
    fi
    echo "  $status $TOOL_NAME completed" >> ~/.claude/logs/code-reviewer.log
  Stop: |
    #!/bin/bash
    echo "Review session completed at $(date)" >> ~/.claude/logs/code-reviewer.log
    echo "---" >> ~/.claude/logs/code-reviewer.log
---

# Code review agent
Perform thorough code reviews...
```

### エージェント実行時のリソース監視

エージェントが使用するリソースを監視し、制限を超えた場合に警告します。

```markdown
---
name: heavy-task-agent
description: 重い処理を行うエージェント
hooks:
  PreToolUse: |
    #!/bin/bash
    # ツール実行前のメモリ使用量を記録
    free -m | grep Mem | awk '{print $3}' > /tmp/agent-mem-before.txt
  PostToolUse: |
    #!/bin/bash
    # ツール実行後のメモリ使用量をチェック
    mem_before=$(cat /tmp/agent-mem-before.txt)
    mem_after=$(free -m | grep Mem | awk '{print $3}')
    mem_diff=$((mem_after - mem_before))

    if [ $mem_diff -gt 1000 ]; then
      echo "⚠️ Warning: $TOOL_NAME used ${mem_diff}MB of memory" >&2
    fi
  Stop: |
    #!/bin/bash
    # クリーンアップ
    rm -f /tmp/agent-mem-*.txt
---

# Heavy task agent
Handle resource-intensive operations...
```

### エージェント固有の環境変数設定

エージェントが動作する間だけ有効な環境変数を設定します。

```markdown
---
name: terraform-agent
description: Terraform操作エージェント
hooks:
  PreToolUse: |
    #!/bin/bash
    # Terraform専用の環境変数を設定
    export TF_LOG=DEBUG
    export TF_LOG_PATH=~/.claude/logs/terraform-debug.log

    # 初回ツール使用時のみ実行
    if [ ! -f /tmp/tf-agent-initialized ]; then
      echo "Initializing Terraform agent environment"
      terraform version >> ~/.claude/logs/terraform-agent.log
      touch /tmp/tf-agent-initialized
    fi
  Stop: |
    #!/bin/bash
    # クリーンアップ
    rm -f /tmp/tf-agent-initialized
    echo "Terraform agent stopped at $(date)" >> ~/.claude/logs/terraform-agent.log
---

# Terraform operations agent
Specialized in Terraform workflows...
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- フックのスコープ:
  - エージェントが起動されてから終了するまでの間のみ有効
  - エージェント終了時に自動的に登録解除される
  - 同じエージェントの複数インスタンスが実行される場合、各インスタンスで独立してフックが動作
- サポートされるフックタイプ:
  - `PreToolUse`: ツール実行直前に実行
  - `PostToolUse`: ツール実行直後に実行
  - `Stop`: エージェント終了時に実行
- 環境変数:
  - `$TOOL_NAME`: 使用されるツール名
  - `$TOOL_SUCCESS`: ツールの成功/失敗（PostToolUseのみ）
  - `$AGENT_NAME`: 現在のエージェント名
- フックの実行:
  - Bashスクリプトとして実行される
  - 標準出力はログに記録される
  - エラー（終了コード非0）は警告としてログに記録されるが、エージェント実行は継続
- グローバルフックとの関係:
  - エージェント固有のフックはグローバルフックに追加される形で実行
  - 実行順序: グローバルPreToolUse → エージェントPreToolUse → ツール実行 → エージェントPostToolUse → グローバルPostToolUse
- 注意事項:
  - フック内で長時間実行される処理は避ける（エージェントの応答性に影響）
  - フックは各ツール呼び出しごとに実行される（頻繁に実行される可能性）
  - 一時ファイルは必ずStopフックでクリーンアップする

## 関連情報

- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Creating custom agents](https://code.claude.com/docs/en/custom-agents)
- [Agent lifecycle](https://code.claude.com/docs/en/agent-lifecycle)
