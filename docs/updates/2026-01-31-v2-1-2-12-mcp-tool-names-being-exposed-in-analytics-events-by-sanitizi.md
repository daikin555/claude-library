---
title: "MCPツール名の分析イベント流出を修正（プライバシー保護）"
date: 2026-01-09
tags: ['バグ修正', 'MCP', 'プライバシー', 'セキュリティ', '分析']
---

## 原文（日本語に翻訳）

ユーザー固有のサーバー設定をサニタイズすることで、MCPツール名が分析イベントに露出していた問題を修正しました。

## 原文（英語）

Fixed MCP tool names being exposed in analytics events by sanitizing user-specific server configurations

## 概要

Claude CodeのModel Context Protocol（MCP）サーバー使用時、ユーザーが設定したカスタムMCPツールの名前が分析イベントに含まれ、プライバシー情報が漏洩する可能性がありました。この問題が修正され、ユーザー固有の設定情報は適切にサニタイズ（無害化）されてから分析データに送信されるようになりました。

## 基本的な使い方

この修正は自動的に適用されます。MCPサーバーを使用する際、プライバシーが自動的に保護されます。

### 修正前の問題

```json
// MCPサーバー設定例
{
  "mcpServers": {
    "company-internal-api": {
      "command": "node",
      "args": ["./internal-mcp-server.js"]
    },
    "customer-database-tool": {
      "command": "python",
      "args": ["customer_db_mcp.py"]
    }
  }
}

// 修正前: 分析イベントに送信されるデータ
{
  "event": "mcp_tool_used",
  "tool_name": "company-internal-api"  // ← 内部情報が露出
}
```

### 修正後の動作

```json
// 修正後: 分析イベントに送信されるデータ
{
  "event": "mcp_tool_used",
  "tool_name": "<sanitized>"  // または匿名化されたID
}
```

## 実践例

### 企業内部ツールの使用

```bash
# 企業の機密MCPサーバーを設定
# ~/.config/claude-code/mcp-servers.json
{
  "secret-project-x-api": {
    "command": "node",
    "args": ["./secret-api.js"]
  }
}

# Claude Codeで使用
claude "プロジェクトXのデータを取得して"

# 修正前: "secret-project-x-api" が分析データに送信される
# 修正後: ツール名は匿名化され、プロジェクト情報は保護される
```

### 顧客管理システムとの統合

```bash
# MCPサーバー設定
{
  "acme-corp-crm": {
    "command": "python",
    "args": ["acme_crm_connector.py"]
  }
}

# 使用時
claude "顧客データを分析して"

# 修正前: "acme-corp-crm" という顧客名が露出
# 修正後: 顧客名は保護される
```

### プライベートAPIの使用

```bash
# 個人のプライベートAPIをMCPサーバーとして設定
{
  "my-personal-finance-api": {
    "command": "node",
    "args": ["./finance-tracker.js"]
  },
  "my-health-data-api": {
    "command": "python",
    "args": ["health_data.py"]
  }
}

# 使用時
claude "今月の支出を分析して"

# 修正前: 個人的なツール名が分析データに含まれる
# 修正後: プライバシーが保護される
```

### 複数のMCPサーバーを使用する環境

```bash
# 開発環境でのMCP設定
{
  "internal-jenkins": {},
  "company-jira": {},
  "team-slack-bot": {},
  "proprietary-build-system": {}
}

# 修正前の問題:
# - 全てのツール名が分析データに送信される
# - 社内システムの構成が外部に露出する

# 修正後:
# - ツール名は匿名化される
# - 使用統計のみが送信される（どのツールかは特定できない）
```

## 注意点

- **自動保護**: v2.1.2以降、MCPツール名は自動的に匿名化されます
- **プライバシー優先**: ユーザー固有の設定情報は分析データに含まれません
- **統計の維持**: 匿名化されたデータは、製品改善のための統計には引き続き使用されます
- **完全なプライバシー**: より厳格なプライバシーが必要な場合は、分析機能自体を無効化できます
- **MCPサーバーの動作**: この変更はMCPサーバーの機能には影響しません

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [MCP (Model Context Protocol) ガイド](https://code.claude.com/docs/mcp)
- [プライバシーポリシー](https://www.anthropic.com/privacy)
