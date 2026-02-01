---
title: "`Task(AgentName)` 構文で特定エージェントを無効化可能に"
date: 2026-01-31
tags: ['新機能', 'パーミッション', 'エージェント']
---

## 原文（日本語に翻訳）

settings.jsonのパーミッション設定または`--disallowedTools` CLIフラグで、`Task(AgentName)` 構文を使用して特定のエージェントを無効化するサポートを追加しました

## 原文（英語）

Added support for disabling specific agents using `Task(AgentName)` syntax in settings.json permissions or the `--disallowedTools` CLI flag

## 概要

Claude Code v2.1.0で導入された、きめ細かなエージェント制御機能です。`Task(AgentName)` 構文を使うことで、特定の専門エージェント（例: `Bash`, `Explore`, `Plan`など）を選択的に無効化できます。これにより、セキュリティポリシーの遵守、リソース制限、または特定の作業フローに応じて、Claudeが使用できるエージェントを制限できます。settings.jsonでの永続的な設定と、CLIフラグでのセッション単位の制御の両方に対応しています。

## 基本的な使い方

### settings.jsonでの設定

```json
{
  "permissions": {
    "disallowedTools": [
      "Task(Bash)",
      "Task(Explore)"
    ]
  }
}
```

### CLIフラグでの設定

```bash
# Bashエージェントを無効化してClaude Codeを起動
claude --disallowedTools "Task(Bash)"

# 複数のエージェントを無効化
claude --disallowedTools "Task(Bash),Task(Plan),Task(Explore)"
```

## 実践例

### セキュリティ重視の環境でBashエージェントを無効化

本番環境や共有開発環境で、シェルコマンド実行を禁止します。

```json
// ~/.claude/settings.json
{
  "permissions": {
    "disallowedTools": [
      "Task(Bash)"
    ]
  }
}
```

```bash
# Claude Codeを起動
claude

# Bashコマンド実行を試みると...
> ファイル一覧を表示して

# Claudeは ls コマンドの代わりにGlobツールを使用
# （Bashツールは無効化されているため）
```

### 初心者向けに複雑なエージェントを制限

学習目的で、高度なエージェント機能を無効化して基本機能のみ使用させます。

```json
{
  "permissions": {
    "disallowedTools": [
      "Task(Plan)",
      "Task(Explore)",
      "Task(feature-dev:*)"
    ]
  }
}
```

```bash
# 初心者モードで起動
claude --disallowedTools "Task(Plan),Task(Explore)"

# Claudeは基本的なツール（Read、Write、Edit）のみ使用
# 複雑なプラン作成やコードベース探索は行わない
```

### プロジェクト別のエージェント制限

特定のプロジェクトでのみ、特定のエージェントを無効化します。

```json
// プロジェクトの .claude/settings.json
{
  "permissions": {
    "disallowedTools": [
      "Task(terraform-aws-expert)",
      "Task(deployment-engineer)"
    ]
  }
}
```

```bash
cd ~/projects/frontend-only-project
claude

# このプロジェクトではTerraformやデプロイ関連のエージェントは使用されない
# フロントエンド開発に集中できる
```

### CI/CD環境での自動化制限

CI/CD パイプラインで、インタラクティブなエージェントを無効化します。

```bash
# GitHub Actions workflow
- name: Run Claude Code analysis
  run: |
    claude --disallowedTools "Task(Plan),Task(AskUserQuestion)" \
      --prompt "コードレビューを実施"
    # プラン作成や質問機能を無効化し、自動実行可能にする
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- 対象となるエージェント:
  - 組み込みエージェント: `Bash`, `Explore`, `Plan`, `general-purpose` など
  - カスタムエージェント: `feature-dev:code-architect`, `terraform-aws-expert` など
  - ワイルドカード対応: `Task(feature-dev:*)` で feature-dev 配下のすべてのエージェントを無効化
- 構文:
  - `Task(AgentName)` - 特定のエージェントを無効化
  - `Task(Namespace:*)` - 名前空間配下のすべてのエージェントを無効化
  - カンマ区切りで複数指定: `Task(Bash),Task(Plan)`
- 優先順位:
  1. CLIフラグ `--disallowedTools`（セッション単位）
  2. プロジェクトの `.claude/settings.json`
  3. グローバルの `~/.claude/settings.json`
- 無効化されたエージェントを使用しようとすると:
  - Claude は別の方法を自動的に試みる
  - または、「このエージェントは無効化されています」というメッセージを表示
- `Task` ツール自体を無効化すると、すべてのエージェントが使用不可になります
- 他のツール（`Read`, `Write`, `Bash`など）の無効化には、従来の `disallowedTools` 構文を使用します:
  ```json
  {
    "permissions": {
      "disallowedTools": ["Bash", "Task(Explore)"]
    }
  }
  ```

## 関連情報

- [Permissions - Claude Code Docs](https://code.claude.com/docs/en/permissions)
- [Agent system - Claude Code Docs](https://code.claude.com/docs/en/agents)
- [Settings configuration](https://code.claude.com/docs/en/settings)
