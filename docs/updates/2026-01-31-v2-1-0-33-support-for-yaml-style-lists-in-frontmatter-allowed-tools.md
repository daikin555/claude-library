---
title: "frontmatterの`allowed-tools`フィールドでYAMLスタイルリストをサポート"
date: 2026-01-31
tags: ['改善', 'スキル', 'YAML']
---

## 原文（日本語に翻訳）

スキル宣言をより読みやすくするため、frontmatterの `allowed-tools` フィールドでYAMLスタイルのリストをサポートしました

## 原文（英語）

Added support for YAML-style lists in frontmatter `allowed-tools` field for cleaner skill declarations

## 概要

Claude Code v2.1.0で導入された、スキル定義の可読性向上機能です。従来はJSON形式の配列で `allowed-tools` を記述する必要がありましたが、YAMLの標準的なリスト記法（`-` で始まる行）を使用できるようになりました。これにより、複数のツールを許可する際の記述が簡潔になり、コメントの追加やメンテナンスが容易になります。

## 基本的な使い方

### 従来の記法（JSON形式）

```yaml
---
name: my-skill
allowed-tools: ["Read", "Write", "Bash"]
---
```

### 新しい記法（YAMLリスト形式）

```yaml
---
name: my-skill
allowed-tools:
  - Read
  - Write
  - Bash
---
```

## 実践例

### 読み取り専用スキルの定義

読み取りツールのみを許可するスキルを見やすく定義します。

```yaml
---
name: code-analyzer
description: コード分析専用スキル
allowed-tools:
  - Read
  - Grep
  - Glob
  - LSP
---

# Code Analyzer Skill
Analyze code without making any modifications...
```

### コメント付きのツールリスト

各ツールの用途をコメントで説明できます。

```yaml
---
name: deployment-skill
description: デプロイ用スキル
allowed-tools:
  - Read      # 設定ファイルの読み取り
  - Bash      # デプロイコマンド実行
  - WebFetch  # APIステータス確認
---

# Deployment Skill
Handle production deployments...
```

### 大量のツールを許可する場合

多数のツールを許可する際も、見やすく整理できます。

```yaml
---
name: full-access-skill
description: フルアクセススキル
allowed-tools:
  # ファイル操作
  - Read
  - Write
  - Edit
  - Glob

  # 検索
  - Grep
  - WebSearch
  - WebFetch

  # 実行
  - Bash
  - Task

  # その他
  - LSP
  - AskUserQuestion
---

# Full Access Skill
Perform any operation needed...
```

### エージェント定義での使用

エージェントのfrontmatterでも同様に使用できます。

```yaml
---
name: terraform-expert
description: Terraform専門家エージェント
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
hooks:
  PreToolUse: |
    echo "Terraform expert running..."
---

# Terraform Expert Agent
Specialized in Terraform operations...
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- サポートされる記法:
  - **YAMLリスト形式**（推奨）:
    ```yaml
    allowed-tools:
      - Read
      - Write
    ```
  - **JSON配列形式**（従来通り）:
    ```yaml
    allowed-tools: ["Read", "Write"]
    ```
  - **インライン配列形式**（YAML標準）:
    ```yaml
    allowed-tools: [Read, Write]
    ```
- すべての形式が引き続きサポートされ、相互運用可能です
- YAMLリスト形式の利点:
  - 各ツールが独立した行になり、視覚的に分かりやすい
  - コメント（`#`）を各行に追加できる
  - Git diffが見やすい（ツール追加時に1行の変更のみ）
  - 長いリストでもスクロールせずに確認しやすい
- インデント:
  - リスト項目（`-`）は `allowed-tools:` より2スペース右にインデント
  - YAMLの標準的なインデントルールに従う
- 空白の扱い:
  - ツール名の前後の空白は自動的にトリミングされる
  - `- Read ` と `- Read` は同じ
- エラーハンドリング:
  - YAML構文エラーがある場合、スキル読み込み時にエラーが表示される
  - エラーメッセージには行番号が含まれる
- 適用範囲:
  - スキル（`.claude/skills/*.md`）
  - エージェント（`.claude/agents/*/AGENT.md`）
  - どちらのfrontmatterでも使用可能
- ベストプラクティス:
  - 3つ以上のツールを許可する場合、YAMLリスト形式を推奨
  - 1-2個のツールのみの場合、インライン形式（`[Read, Write]`）も簡潔
  - コメントが必要な場合、必ずYAMLリスト形式を使用

## 関連情報

- [Creating skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Agent frontmatter](https://code.claude.com/docs/en/agent-frontmatter)
- [YAML Specification](https://yaml.org/spec/1.2.2/)
