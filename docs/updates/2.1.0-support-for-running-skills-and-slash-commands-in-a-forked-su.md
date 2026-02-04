---
title: "スキルとスラッシュコマンドのフォーク実行サポートを追加"
date: 2026-01-31
tags: ['新機能', 'スキル', 'サブエージェント']
---

## 原文（日本語に翻訳）

スキルのフロントマターで `context: fork` を使用して、フォークされたサブエージェントコンテキストでスキルとスラッシュコマンドを実行するサポートを追加しました

## 原文（英語）

Added support for running skills and slash commands in a forked sub-agent context using `context: fork` in skill frontmatter

## 概要

Claude Code v2.1.0で導入されたフォークコンテキスト機能です。スキルのYAMLフロントマターに `context: fork` を指定することで、スキルやスラッシュコマンドを独立したサブエージェントコンテキストで実行できます。これにより、メインエージェントの状態を汚染せずに調査や実験的なタスクを安全に実行でき、副作用を防ぎながら新しいロジックをテストできます。

## 基本的な使い方

スキルのYAMLフロントマターに `context: fork` と `agent` フィールドを追加します。これにより、スキルは指定されたエージェントタイプで独立したコンテキストで実行されます。

```markdown
---
name: research-task
description: フォークされたExploreエージェントで調査を実行
context: fork
agent: Explore
---

# Research Task

このスキルはメインセッションとは独立したExploreエージェントで実行されます。
調査結果はメインエージェントのコンテキストに影響を与えません。
```

スキルを実行するには、スラッシュコマンドとして呼び出します。

```bash
# スキルをフォークされたコンテキストで実行
/research-task
```

## 実践例

### コードベース調査の安全な実行

Exploreエージェントをフォークして、メインセッションに影響を与えずにコードベースを調査します。

```markdown
---
name: explore-codebase
description: コードベースの構造を調査
context: fork
agent: Explore
---

# Codebase Exploration

以下のタスクを実行してください：
1. プロジェクトの全体構造を把握
2. 主要なコンポーネントとその依存関係を特定
3. アーキテクチャパターンを分析
```

### 実験的なリファクタリングの計画

Planエージェントをフォークして、実装計画を独立して作成します。

```markdown
---
name: plan-refactor
description: リファクタリング計画を作成
context: fork
agent: Plan
---

# Refactoring Plan

以下の観点でリファクタリング計画を作成：
1. 現在の問題点の特定
2. 改善案の提案
3. 実装ステップの詳細化
```

### データ分析タスクの分離実行

データ分析などの重いタスクをフォークして、メインセッションの応答性を維持します。

```markdown
---
name: analyze-logs
description: ログファイルを分析
context: fork
agent: general-purpose
---

# Log Analysis

大規模なログファイルを分析し、以下を抽出：
1. エラーパターン
2. パフォーマンスボトルネック
3. 異常なアクセスパターン
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- `context: fork` を指定しない場合、スキルはメインエージェントのコンテキストで実行されます
- `agent` フィールドが省略された場合、デフォルトで `general-purpose` エージェントが使用されます
- フォークされたコンテキストは独立しているため、メインセッションの状態や変数にはアクセスできません
- フォークされたエージェントの結果は、スキルの出力として返されます
- 利用可能なエージェントタイプ: `Explore`、`Plan`、`general-purpose`、またはカスタムエージェント（`.claude/agents/`内）
- v2.1.3でスラッシュコマンドとスキルシステムが統合され、後方互換性を保ちながら簡素化されました

## 関連情報

- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Claude Code Skills Compared to Slash Commands](https://egghead.io/claude-skills-compared-to-slash-commands~lhdor)
- [Claude Code Customization Guide](https://alexop.dev/posts/claude-code-customization-guide-claudemd-skills-subagents/)
