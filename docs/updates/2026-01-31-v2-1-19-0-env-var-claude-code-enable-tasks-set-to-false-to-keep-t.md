---
title: "CLAUDE_CODE_ENABLE_TASKS環境変数の追加：旧TODOシステムへの一時的復帰"
date: 2026-01-23
tags: ['新機能', '環境変数', 'タスク管理']
---

## 原文（日本語に翻訳）

環境変数 `CLAUDE_CODE_ENABLE_TASKS` を追加しました。`false` に設定することで、一時的に旧システムを維持できます。

## 原文（英語）

Added env var `CLAUDE_CODE_ENABLE_TASKS`, set to `false` to keep the old system temporarily

## 概要

Claude Code v2.1.19で新しい環境変数 `CLAUDE_CODE_ENABLE_TASKS` が追加されました。この環境変数を `false` に設定することで、新しいタスクトラッキングシステムを無効化し、従来のTODOリストシステムに戻すことができます。これは、新システムに慣れていないユーザーや、旧システムの挙動を好むユーザーのための一時的な移行オプションです。

## 基本的な使い方

環境変数を設定してClaude Codeを起動します。

**Bash/Zsh (macOS, Linux, WSL):**

```bash
export CLAUDE_CODE_ENABLE_TASKS=false
claude
```

**PowerShell (Windows):**

```powershell
$env:CLAUDE_CODE_ENABLE_TASKS="false"
claude
```

**恒久的に設定する場合は、シェルの設定ファイルに追加:**

```bash
# ~/.bashrc または ~/.zshrc に追加
export CLAUDE_CODE_ENABLE_TASKS=false
```

## 実践例

### settings.jsonで設定する

プロジェクトごと、またはグローバルに設定する場合は、`settings.json` で環境変数を管理できます。

**ユーザーグローバル設定** (`~/.claude/settings.json`):

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TASKS": "false"
  }
}
```

**プロジェクト固有の設定** (`.claude/settings.json`):

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TASKS": "false"
  }
}
```

### 新旧システムの動作確認

新しいタスクシステムと旧TODOシステムの違いを確認したい場合:

```bash
# 新システムで実行（デフォルト）
claude -p "Fix all lint errors"

# 旧システムで実行
CLAUDE_CODE_ENABLE_TASKS=false claude -p "Fix all lint errors"
```

### CI/CD環境での利用

GitHub ActionsやGitLab CI/CDで旧システムを使用したい場合:

```yaml
# .github/workflows/claude.yml
env:
  CLAUDE_CODE_ENABLE_TASKS: "false"

jobs:
  code-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: claude -p "Review this PR"
```

## 注意点

- **デフォルト値**: この環境変数を設定しない場合、デフォルトで `true`（新しいタスクシステムが有効）になります
- **一時的なオプション**: この環境変数は移行期間のための一時的な措置です。将来のバージョンで削除される可能性があります
- **タスク管理の違い**: 新システムはより詳細なタスク追跡と進捗管理を提供しますが、旧システムはシンプルなTODOリスト形式です
- **チーム環境**: チームで統一したタスク管理システムを使用する場合は、マネージド設定で組織全体に展開できます

## 関連情報

- [Claude Code 公式ドキュメント - Settings](https://code.claude.com/docs/en/settings)
- [Claude Code 公式ドキュメント - Task List](https://code.claude.com/docs/en/interactive-mode#task-list)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
