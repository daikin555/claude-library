---
title: "/pluginsのインストール済みタブでプラグインとMCPを統合表示"
date: 2026-01-09
tags: ['改善', 'UI', 'プラグイン', 'MCP', 'スコープ']
---

## 原文（日本語に翻訳）

`/plugins` のインストール済みタブを変更し、プラグインとMCPをスコープベースのグループ分けで統合表示するようにしました。

## 原文（英語）

Changed `/plugins` installed tab to unify plugins and MCPs with scope-based grouping

## 概要

`/plugins` コマンドの「インストール済み」タブが改善され、従来は別々に表示されていたプラグインとMCP（Model Context Protocol）サーバーが、スコープ（グローバル、ユーザー、プロジェクト）ごとにグループ化されて統合表示されるようになりました。これにより、インストールされている拡張機能を一目で把握しやすくなります。

## 基本的な使い方

`/plugins` コマンドを実行すると、改善されたインストール済みタブが表示されます。

### 従来の表示方法

```bash
/plugins

# 修正前: プラグインとMCPが別々のセクションに表示
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Plugins:
#   - @claude/git-helper
#   - @claude/code-review
#
# MCP Servers:
#   - filesystem-mcp
#   - database-connector
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 改善後の表示方法

```bash
/plugins

# 修正後: スコープごとにグループ化された統合表示
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Installed (Grouped by Scope)
#
# 📦 Global:
#   ├─ Plugin: @claude/git-helper
#   └─ MCP: filesystem-mcp
#
# 👤 User:
#   ├─ Plugin: @claude/code-review
#   └─ MCP: database-connector
#
# 📁 Project:
#   └─ MCP: project-specific-api
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 実践例

### グローバルとユーザースコープの確認

```bash
/plugins

# 表示例:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 Global (System-wide):
#   ├─ Plugin: @anthropic/core-utils (v1.2.0)
#   ├─ Plugin: @anthropic/terminal-helpers (v2.0.1)
#   └─ MCP: system-tools-mcp (v1.0.0)
#
# 👤 User (Your account):
#   ├─ Plugin: @user/custom-formatter (v0.5.2)
#   ├─ MCP: personal-api-connector (v1.1.0)
#   └─ MCP: cloud-storage-mcp (v2.3.1)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 一目でどのスコープに何がインストールされているか把握可能
```

### プロジェクト固有の拡張機能

```bash
# プロジェクトディレクトリで
cd ~/my-project
/plugins

# 表示例:
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 Global:
#   └─ Plugin: @anthropic/core-utils (v1.2.0)
#
# 👤 User:
#   └─ MCP: personal-api-connector (v1.1.0)
#
# 📁 Project (my-project):
#   ├─ Plugin: @myproject/custom-linter (v1.0.0)
#   ├─ MCP: internal-api-mcp (v0.9.5)
#   └─ MCP: test-data-generator (v1.2.3)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# プロジェクト専用の拡張機能が明確に識別可能
```

### チーム環境での管理

```bash
# チームメンバーA
/plugins

# 📦 Global (IT部門が管理):
#   ├─ Plugin: @company/security-scanner
#   └─ MCP: corporate-vpn-connector
#
# 👤 User (個人設定):
#   └─ Plugin: @user/productivity-tools
#
# 📁 Project (team-project):
#   ├─ MCP: team-database-connector
#   └─ MCP: shared-api-tools

# チームメンバーB: 同じプロジェクトでも個人設定が異なる
# 👤 User (個人設定):
#   └─ Plugin: @user/code-snippets
#
# スコープ別表示により、共有と個人設定が明確
```

### 拡張機能の競合確認

```bash
/plugins

# 同じ機能が異なるスコープに存在する場合も識別しやすい
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 📦 Global:
#   └─ Plugin: @anthropic/formatter (v1.0.0)
#
# 👤 User:
#   └─ Plugin: @custom/formatter (v2.0.0) ⚠️
#
# Note: User-scoped formatter overrides global version
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# スコープの優先順位が明確に表示される
```

## 注意点

- **スコープの優先順位**: Project > User > Global の順で優先されます
- **統合表示**: プラグインとMCPが混在して表示されますが、種類は明確に識別されます
- **バージョン情報**: 各拡張機能のバージョンも表示されます
- **グループ化のメリット**: 同じスコープの拡張機能をまとめて管理しやすくなります
- **視認性の向上**: 以前よりも多くの情報が整理されて表示されます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [プラグイン開発ガイド](https://code.claude.com/docs/plugins)
- [MCPガイド](https://code.claude.com/docs/mcp)
