---
title: "MCP サーバーの @ メンション機能を削除"
date: 2026-01-13
tags: ['削除', 'MCP', 'コマンド', '仕様変更']
---

## 原文（日本語に翻訳）

MCP サーバーの有効化/無効化のための @ メンション機能を削除 - 代わりに `/mcp enable <name>` を使用

## 原文（英語）

Removed ability to @-mention MCP servers to enable/disable - use `/mcp enable <name>` instead

## 概要

Claude Code v2.1.6 では、MCP サーバーの管理方法が変更されました。以前のバージョンでは、`@mcp-server-name` のようにメンションすることで MCP サーバーを有効化/無効化できましたが、この機能は削除されました。代わりに、より明確な `/mcp enable <name>` および `/mcp disable <name>` コマンドを使用する必要があります。

## 基本的な使い方

MCP サーバーの管理:

**v2.1.6 以降（新しい方法）**
```bash
# 有効化
/mcp enable <server-name>

# 無効化
/mcp disable <server-name>
```

**v2.1.5 以前（削除された方法）**
```bash
# これらは使えなくなりました
@mcp-server-name  # 有効化
@!mcp-server-name  # 無効化
```

## 実践例

### 削除された機能（v2.1.5以前）

@ メンションでの管理:

```bash
# MCP サーバーを有効化
@filesystem

# メッセージに含めることもできた
"Please @filesystem read the config file"
# → filesystem サーバーが自動的に有効化される

# 無効化
@!filesystem
```

この方法の問題点:
- ファイル名との混同（@src/file.ts など）
- 意図しない有効化/無効化
- 不明確なコマンド構文

### 新しい方法（v2.1.6以降）

明確なコマンドを使用:

```bash
# MCP サーバーを有効化
/mcp enable filesystem

# 確認メッセージ
✓ MCP server "filesystem" enabled

# 無効化
/mcp disable filesystem

# 確認メッセージ
✓ MCP server "filesystem" disabled
```

### ファイルシステムサーバーの有効化

ファイル操作機能を有効化:

```bash
# 旧方式（使えない）:
@filesystem

# 新方式:
/mcp enable filesystem

# その後、ファイル操作を依頼
"Please read the contents of src/app.ts"
# filesystem サーバーが使用される
```

### データベースサーバーの管理

データベース MCP サーバーの切り替え:

```bash
# 有効化
/mcp enable database

# データベースクエリを実行
"Query the users table"

# 使用後、無効化（必要に応じて）
/mcp disable database
```

### 複数サーバーの管理

複数の MCP サーバーを使用:

```bash
# 複数サーバーを有効化
/mcp enable filesystem
/mcp enable database
/mcp enable web-search

# 状態確認
/mcp list

# 出力:
Available MCP servers:
  ✓ filesystem (enabled)
  ✓ database (enabled)
  ✓ web-search (enabled)
  ○ analytics (disabled)
```

### ファイル @ メンションとの区別

ファイルとサーバーの混同を回避:

```bash
# v2.1.5 以前の問題:
@filesystem  # サーバー有効化？ファイル添付？混乱
@src/file.ts  # ファイル添付だが、サーバー名と似ている

# v2.1.6:
/mcp enable filesystem  # 明確にサーバー有効化
@src/file.ts  # ファイル添付（変わらず）
```

### エラーメッセージ

旧方式を使用した場合:

```bash
# 旧方式を試みる
@filesystem

# v2.1.6 でのメッセージ:
Note: @-mentioning MCP servers is no longer supported.
Use /mcp enable filesystem instead.

# ファイルとして解釈される（存在しない場合）
Error: File not found: @filesystem
```

### 移行ガイド

旧方式から新方式への移行:

```
旧方式              →  新方式
─────────────────────────────────────
@server-name        →  /mcp enable server-name
@!server-name       →  /mcp disable server-name
@server1 @server2   →  /mcp enable server1
                        /mcp enable server2
```

### MCP サーバー一覧の確認

利用可能なサーバーを確認:

```bash
# サーバー一覧表示
/mcp list

# 出力例:
Available MCP servers:
  ✓ filesystem - File operations
  ✓ database - Database queries
  ○ web-search - Web search (disabled)
  ○ analytics - Analytics tools (disabled)

# 詳細情報
/mcp get filesystem
```

### 自動有効化の設定

特定のサーバーを常に有効化:

```bash
# 設定ファイルで管理
/config
# "mcp" で検索

# autoEnableMCPServers 設定:
autoEnableMCPServers: ["filesystem", "database"]

# これらのサーバーは起動時に自動有効化
# /mcp enable を実行する必要なし
```

### CLAUDE.md での設定

プロジェクトごとの MCP 設定:

```markdown
<!-- CLAUDE.md -->

# Project Configuration

## MCP Servers

Enable the following servers:
- filesystem
- database

<!-- 注: @メンションではなく、説明的に記載 -->
```

起動時に手動で有効化するか、autoEnableMCPServers で自動化:

```bash
# 起動後
/mcp enable filesystem
/mcp enable database
```

## 注意点

- この変更は Claude Code v2.1.6 で導入されました
- `@mcp-server-name` による有効化/無効化は削除されました
- `/mcp enable <name>` および `/mcp disable <name>` を使用してください
- この変更により、ファイルメンションとMCPサーバー管理が明確に区別されます
- 旧方式を使用すると、エラーメッセージが表示されます
- 自動有効化機能は引き続き利用可能です（設定ファイルで管理）
- より明確で予測可能なコマンド構文になりました
- `/mcp` コマンドは `enable`, `disable`, `list`, `get` などをサポートしています

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [MCP (Model Context Protocol)](https://modelcontextprotocol.io/)
- [Claude Code MCP 統合](https://code.claude.com/docs/mcp)
- [Changelog v2.1.6 - @ autocomplete improvement](https://github.com/anthropics/claude-code/releases/tag/v2.1.6) - 関連する改善
