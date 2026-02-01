---
title: "バックグラウンドタスク機能を無効化する環境変数の追加"
date: 2026-01-11
tags: ['新機能', '環境変数', 'バックグラウンドタスク']
---

## 原文（日本語に翻訳）

すべてのバックグラウンドタスク機能（自動バックグラウンド化とCtrl+Bショートカットを含む）を無効化する `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` 環境変数を追加しました。

## 原文（英語）

Added `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` environment variable to disable all background task functionality including auto-backgrounding and the Ctrl+B shortcut

## 概要

Claude Code v2.1.4では、バックグラウンドタスク機能を完全に無効化できる環境変数 `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` が追加されました。この環境変数を `1` に設定することで、長時間実行されるコマンドをバックグラウンドで実行する機能を全て無効化できます。バックグラウンドタスクを使用したくない場合や、タスクの実行をより厳密に管理したい場合に有用です。

## 基本的な使い方

環境変数を設定してClaude Codeを起動します。

```bash
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
claude
```

または、一時的に無効化する場合：

```bash
CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1 claude
```

Windowsの場合：

```powershell
$env:CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
claude
```

この設定により、以下の機能が無効化されます：

- `run_in_background` パラメータ（BashおよびSubagentツール）
- 自動バックグラウンド化
- Ctrl+B ショートカット

## 実践例

### CI/CD環境での使用

継続的インテグレーション環境では、タスクの実行を順次処理したい場合があります。

```bash
# GitHub Actions ワークフロー例
env:
  CLAUDE_CODE_DISABLE_BACKGROUND_TASKS: 1
steps:
  - name: Run Claude Code
    run: claude -p "Run all tests and fix any issues"
```

この設定により、すべてのコマンドが順番に実行され、出力が即座に表示されます。

### デバッグ時の使用

デバッグ時には、タスクの実行順序を明確にしたい場合があります。

```bash
# バックグラウンドタスクを無効化してデバッグモードで起動
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
claude --debug "api,hooks"
```

すべてのコマンドが前面で実行されるため、出力を確認しながらデバッグできます。

### スクリプトでの使用

自動化スクリプトでClaude Codeを使用する場合、バックグラウンドタスクを無効化することで、実行フローを制御できます。

```bash
#!/bin/bash
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1

# テストの実行
claude -p "Run unit tests"

# テスト結果に基づいて次のステップを実行
if [ $? -eq 0 ]; then
  claude -p "Deploy to staging"
fi
```

### チーム設定での永続化

プロジェクト全体でバックグラウンドタスクを無効化する場合は、`.bashrc` や `.zshrc` に追加します。

```bash
# ~/.bashrc または ~/.zshrc
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
```

## 注意点

- この環境変数を設定すると、Ctrl+B ショートカットが完全に無効化されます（Tmuxユーザーの場合でも）
- 長時間実行されるコマンド（ビルド、テスト実行など）は、すべて完了まで待機する必要があります
- バックグラウンドタスクを使用しているスクリプトやワークフローがある場合、動作が変わる可能性があります
- デフォルトではバックグラウンドタスク機能は有効です。無効化する必要がある場合のみ、この環境変数を設定してください

## 関連情報

- [Environment Variables - Claude Code 公式ドキュメント](https://code.claude.com/docs/en/settings#environment-variables)
- [Background Bash Commands - Interactive Mode](https://code.claude.com/docs/en/interactive-mode#background-bash-commands)
- [Changelog v2.1.4](https://github.com/anthropics/claude-code/releases/tag/v2.1.4)
