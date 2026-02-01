---
title: "ネストされた .claude/skills ディレクトリからのスキル自動検出機能を追加"
date: 2026-01-13
tags: ['新機能', 'スキル', '自動検出', 'ディレクトリ']
---

## 原文（日本語に翻訳）

サブディレクトリ内のファイルを操作する際に、ネストされた `.claude/skills` ディレクトリからスキルを自動検出する機能を追加

## 原文（英語）

Added automatic discovery of skills from nested `.claude/skills` directories when working with files in subdirectories

## 概要

Claude Code v2.1.6 では、サブディレクトリで作業する際に、そのディレクトリ内の `.claude/skills` ディレクトリからスキルが自動的に検出されるようになりました。これにより、プロジェクトの各サブディレクトリに固有のスキルを配置でき、モノレポ構成やマルチプロジェクト環境での利便性が向上します。

## 基本的な使い方

1. サブディレクトリ内に `.claude/skills` ディレクトリを作成
2. そのディレクトリにスキルファイル（`.md` ファイル）を配置
3. そのサブディレクトリ内のファイルで作業すると、スキルが自動的に利用可能になる

```bash
# プロジェクト構成例
project/
├── .claude/skills/          # ルートのスキル
│   └── root-skill.md
├── frontend/
│   ├── .claude/skills/      # frontend専用のスキル
│   │   └── react-skill.md
│   └── src/
└── backend/
    ├── .claude/skills/      # backend専用のスキル
    │   └── api-skill.md
    └── src/
```

## 実践例

### モノレポでのスキル管理

モノレポ構成で各パッケージに固有のスキルを使いたい場合：

```bash
monorepo/
├── packages/
│   ├── web-app/
│   │   ├── .claude/skills/
│   │   │   ├── react-skill.md      # React関連のスキル
│   │   │   └── tailwind-skill.md   # Tailwind CSS関連のスキル
│   │   └── src/
│   ├── mobile-app/
│   │   ├── .claude/skills/
│   │   │   └── react-native-skill.md  # React Native関連のスキル
│   │   └── src/
│   └── api/
│       ├── .claude/skills/
│       │   ├── fastify-skill.md    # Fastify関連のスキル
│       │   └── prisma-skill.md     # Prisma関連のスキル
│       └── src/
```

`packages/web-app/src` で作業する場合、`packages/web-app/.claude/skills/` のスキルが自動的に利用可能になります。

### マイクロサービスアーキテクチャ

各サービスに特化したスキルを配置：

```bash
services/
├── auth-service/
│   ├── .claude/skills/
│   │   └── auth-patterns.md    # 認証パターンのスキル
│   └── src/
├── payment-service/
│   ├── .claude/skills/
│   │   └── payment-integration.md  # 決済統合のスキル
│   └── src/
└── notification-service/
    ├── .claude/skills/
    │   └── email-templates.md  # メールテンプレートのスキル
    └── src/
```

### ドキュメントプロジェクト

異なるドキュメントタイプに応じたスキル：

```bash
docs/
├── api-docs/
│   ├── .claude/skills/
│   │   └── openapi-skill.md    # OpenAPI仕様のスキル
│   └── specs/
├── user-docs/
│   ├── .claude/skills/
│   │   └── tutorial-skill.md   # チュートリアル作成のスキル
│   └── guides/
└── developer-docs/
    ├── .claude/skills/
    │   └── architecture-skill.md  # アーキテクチャ図のスキル
    └── diagrams/
```

## 注意点

- この機能は Claude Code v2.1.6 で導入されました
- ルートの `.claude/skills` ディレクトリのスキルは常に利用可能です
- サブディレクトリのスキルは、そのディレクトリまたはその子ディレクトリで作業している場合のみ利用可能になります
- 同名のスキルがある場合、より近いディレクトリのスキルが優先されます
- スキルは、作業対象のファイルが存在するディレクトリから上位に向かって検索されます

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code スキル機能ドキュメント](https://github.com/anthropics/claude-code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3) - スラッシュコマンドとスキルの統合
