---
title: "MCP Tool Searchの自動有効化しきい値をカスタマイズ可能に"
date: 2026-01-16
tags: ['新機能', 'MCP', '設定']
---

## 原文（日本語訳）

MCP tool search の自動有効化しきい値を設定するための `auto:N` 構文を追加しました。N はコンテキストウィンドウのパーセンテージ（0-100）を表します。

## 原文（英語）

Added `auto:N` syntax for configuring the MCP tool search auto-enable threshold, where N is the context window percentage (0-100)

## 概要

多数のMCPサーバーを設定している場合、すべてのツール定義を事前にコンテキストに読み込むとコンテキストウィンドウを圧迫します。v2.1.9では、MCP Tool Searchが自動的に有効化される条件をカスタマイズできるようになりました。デフォルトでは、MCPツールの説明がコンテキストウィンドウの10%を超えると自動的にTool Searchが有効化されますが、この閾値を `auto:N` 構文で調整できます。

## 基本的な使い方

環境変数 `ENABLE_TOOL_SEARCH` を使用して、Tool Searchの動作を制御します。

```bash
# デフォルト（10%で自動有効化）
claude

# 5%の閾値で自動有効化
ENABLE_TOOL_SEARCH=auto:5 claude

# 常に有効化
ENABLE_TOOL_SEARCH=true claude

# 完全に無効化（すべてのMCPツールを事前読み込み）
ENABLE_TOOL_SEARCH=false claude
```

また、設定ファイル（`~/.claude/settings.json` または `.claude/settings.json`）の `env` フィールドでも設定可能です。

```json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "auto:5"
  }
}
```

## 実践例

### 大規模プロジェクトでの最適化

多数のMCPサーバーを使用しているプロジェクトでは、より低い閾値を設定することでコンテキストを節約できます。

```bash
# 3%の閾値で早期に有効化
ENABLE_TOOL_SEARCH=auto:3 claude
```

### Tool Searchを完全に無効化

Tool Searchをサポートしないモデル（Haikuなど）を使用する場合、または全ツールを常時読み込みたい場合は無効化します。

```bash
ENABLE_TOOL_SEARCH=false claude
```

### permissions設定でMCPSearchを無効化

Tool Search機能自体を無効にしたい場合は、permissions設定でMCPSearchツールを拒否できます。

```json
{
  "permissions": {
    "deny": ["MCPSearch"]
  }
}
```

## 注意点

- Tool Searchは Sonnet 4以降、Opus 4以降でのみ対応しています（`tool_reference` ブロックをサポートするモデルが必要）
- Haikuモデルはtool searchに対応していません
- デフォルトの `auto` モードでは、MCPツールの説明が10%未満の場合はTool Searchは有効化されません
- Tool Searchが有効な場合、MCPサーバーのserver instructionsフィールドがより重要になります（Claudeがいつツールを検索すべきかを理解するため）

## 関連情報

- [MCP Tool Search公式ドキュメント](https://code.claude.com/docs/en/mcp#scale-with-mcp-tool-search)
- [MCP統合ガイド](https://code.claude.com/docs/en/mcp)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
