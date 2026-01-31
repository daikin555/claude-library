---
title: "PreToolUseフックで追加コンテキストをモデルに渡せるように"
date: 2026-01-16
tags: ['新機能', 'hooks', '拡張性']
---

## 原文（日本語訳）

`PreToolUse` フックが `additionalContext` をモデルに返せるようサポートを追加しました。

## 原文（英語）

Added support for `PreToolUse` hooks to return `additionalContext` to the model

## 概要

PreToolUseフックから、ツール実行前にClaudeのコンテキストに追加情報を注入できるようになりました。これにより、ツール呼び出しの直前に動的な情報（最新のプロジェクト状態、環境変数、外部APIからのデータなど）をClaudeに提供できます。従来のフックは「許可/拒否」の判断しかできませんでしたが、`additionalContext` を返すことで、Claudeの判断材料を増やし、より適切な実行を促すことができます。

## 基本的な使い方

PreToolUseフックのスクリプトから、JSON形式で `additionalContext` を返します。

```json
{
  "additionalContext": "実行前にClaudeに伝えたい追加情報"
}
```

または、従来通りstdoutにテキストを出力することもできます（exit 0の場合）。

## 実践例

### 環境情報をツール実行前に注入

Bashコマンド実行前に、現在のGitブランチや環境変数などの情報をClaudeに提供します。

`.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'cat <<EOF\n{\n  \"additionalContext\": \"Current branch: $(git branch --show-current)\\nNode version: $(node --version)\\nENV: ${NODE_ENV:-development}\"\n}\nEOF'"
          }
        ]
      }
    ]
  }
}
```

### データベースの状態を確認して情報提供

データベース操作前に、現在の接続数や負荷状況をClaudeに伝えます。

```bash
#!/bin/bash
# check-db-status.sh

# データベースの状態を取得
ACTIVE_CONNECTIONS=$(psql -t -c "SELECT count(*) FROM pg_stat_activity;")

cat <<EOF
{
  "additionalContext": "Database status: ${ACTIVE_CONNECTIONS} active connections. Consider load before running heavy queries."
}
EOF
```

`.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/check-db-status.sh"
          }
        ]
      }
    ]
  }
}
```

### ファイル編集前にレビューガイドラインを表示

特定のファイルを編集する際に、そのファイル固有のガイドラインをClaudeに提示します。

```bash
#!/bin/bash
# file-edit-context.sh

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# 特定ファイルの場合、ガイドラインを注入
if [[ "$FILE_PATH" == *"config.json"* ]]; then
  cat <<EOF
{
  "additionalContext": "Reminder: config.json requires manual validation after changes. Always backup before editing."
}
EOF
else
  echo '{"additionalContext": ""}'
fi
```

### API制限をチェックして警告

外部API呼び出し前に、現在のレート制限状況を確認してClaudeに通知します。

```bash
#!/bin/bash
# check-api-limits.sh

# APIレート制限を確認（例）
REMAINING=$(curl -s https://api.example.com/rate_limit | jq -r '.remaining')

cat <<EOF
{
  "additionalContext": "API Rate Limit: ${REMAINING} requests remaining this hour. Be conservative with API calls."
}
EOF
```

## 注意点

- `additionalContext` はJSON構造で返す必要があります
- exit 0 で終了した場合のみ、コンテキストが注入されます
- exit 2 で終了した場合、ツール実行はブロックされます（従来通り）
- 大量のコンテキストを注入すると、Claudeのコンテキストウィンドウを圧迫する可能性があります
- フックの実行には10分のタイムアウトがあります（`timeout` フィールドでカスタマイズ可能）
- `UserPromptSubmit` フックでも同様に `additionalContext` を使用できます

## 関連情報

- [Hooks Guide公式ドキュメント](https://code.claude.com/docs/en/hooks-guide)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [JSON出力フォーマット](https://code.claude.com/docs/en/hooks#json-output)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
