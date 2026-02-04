---
title: "スキルでのagentフィールドサポートを追加"
date: 2026-01-31
tags: ['新機能', 'スキル', 'サブエージェント']
---

## 原文（日本語に翻訳）

スキルの実行に使用するエージェントタイプを指定するための `agent` フィールドのサポートを追加しました

## 原文（英語）

Added support for `agent` field in skills to specify agent type for execution

## 概要

Claude Code v2.1.0で導入された、スキル実行時のエージェントタイプ指定機能です。スキルのYAMLフロントマターに `agent` フィールドを追加することで、そのスキルをどのサブエージェント設定で実行するかを制御できます。ビルトインエージェント（Explore、Plan、general-purpose）またはカスタムサブエージェント（`.claude/agents/`内）を指定可能で、省略時は `general-purpose` が使用されます。

## 基本的な使い方

スキルのYAMLフロントマターに `agent` フィールドを追加して、実行するエージェントタイプを指定します。

```markdown
---
name: my-exploration-skill
description: コードベースを探索するスキル
agent: Explore
---

# My Exploration Skill

このスキルはExploreエージェントで実行されます。
コードベースの調査に最適化された動作をします。
```

利用可能なビルトインエージェント：
- `Explore` - コードベースの探索と調査に特化
- `Plan` - 実装計画の作成に特化
- `general-purpose` - 汎用タスク（デフォルト）

## 実践例

### Exploreエージェントでのコードベース調査

Exploreエージェントを使用してコードベースの構造を効率的に調査します。

```markdown
---
name: find-api-endpoints
description: APIエンドポイントを検索
agent: Explore
---

# Find API Endpoints

プロジェクト内のすべてのAPIエンドポイントを検索し、
以下の情報を抽出してください：
- エンドポイントのパス
- HTTPメソッド
- リクエスト/レスポンス形式
- 認証要件
```

### Planエージェントでの実装計画作成

Planエージェントを使用して、新機能の実装計画を構造的に作成します。

```markdown
---
name: plan-new-feature
description: 新機能の実装計画を作成
agent: Plan
---

# Plan New Feature

以下の手順で新機能の実装計画を作成：
1. 既存のコードベースパターンを分析
2. アーキテクチャへの適合方法を検討
3. 必要な変更ファイルをリストアップ
4. 実装ステップの詳細化
5. テスト戦略の提案
```

### カスタムエージェントの使用

`.claude/agents/` に配置したカスタムエージェントを指定します。

```markdown
---
name: security-audit
description: セキュリティ監査を実行
agent: security-scanner
---

# Security Audit

カスタムのsecurity-scannerエージェントを使用して、
以下のセキュリティチェックを実行：
- 脆弱な依存関係の検出
- ハードコードされたシークレットの検索
- 安全でないコードパターンの特定
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- `agent` フィールドが省略された場合、`general-purpose` エージェントが使用されます
- ビルトインエージェント: `Explore`、`Plan`、`general-purpose`
- カスタムエージェントは `.claude/agents/` ディレクトリに配置する必要があります
- Agent Skills オープンスタンダードに準拠しており、複数のAIツール間で互換性があります
- Claude Codeはこの標準を拡張し、呼び出し制御、サブエージェント実行、動的コンテキスト注入などの追加機能を提供します
- `context: fork` と組み合わせることで、独立したコンテキストで特定のエージェントを実行できます

## 関連情報

- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Claude Agent Skills: A First Principles Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)
- [How to Use Claude Code: Skills Guide](https://www.producttalk.org/how-to-use-claude-code-features/)
