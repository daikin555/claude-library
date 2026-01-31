---
title: "HTTP/SSE transport使用時の過剰なMCP接続リクエストの修正"
date: 2026-01-17
tags: ['バグ修正', 'MCP', 'パフォーマンス', 'HTTP', 'SSE']
---

## 原文（日本語に翻訳）

HTTP/SSE transport使用時の過剰なMCP接続リクエストを修正

## 原文（英語）

Fixed excessive MCP connection requests for HTTP/SSE transports

## 概要

Claude Code v2.1.11では、MCP（Model Context Protocol）のHTTP/SSE transportを使用する際に発生していた過剰な接続リクエストの問題が修正されました。この修正により、リモートMCPサーバーとの通信効率が向上し、不要なネットワークトラフィックが削減されます。

## MCPのTransportについて

MCPは2つのtransport方式をサポートしています。

### Stdio Transport
- ローカルプロセス間の通信に使用
- 標準入出力ストリームを利用
- ネットワークオーバーヘッドなしで最適なパフォーマンスを実現
- ローカルファイルシステムサーバーなどで使用

### Streamable HTTP Transport（HTTP/SSE）
- リモートサーバーとの通信に使用
- HTTP POSTでクライアントからサーバーへメッセージ送信
- Server-Sent Events（SSE）によるストリーミング機能をサポート
- 標準的なHTTP認証方式（Bearer token、APIキー、カスタムヘッダー）に対応
- リモートのSentryサーバーなどで使用

## この修正の重要性

HTTP/SSE transportを使用するリモートMCPサーバーとの接続時、以前のバージョンでは必要以上に多くの接続リクエストが発生していました。この問題は以下のような影響をもたらしていました。

1. **ネットワーク負荷の増加** - 不要な接続リクエストによるトラフィック増加
2. **パフォーマンスの低下** - 過剰なリクエストによる応答時間の遅延
3. **サーバー負荷** - リモートMCPサーバーへの不要な負荷
4. **リソースの浪費** - クライアント・サーバー双方でのリソース消費

v2.1.11では、この問題が修正され、適切な接続管理が行われるようになりました。

## 基本的な使い方

この修正は自動的に適用されるため、特別な設定変更は不要です。HTTP/SSE transportを使用するMCPサーバーを設定している場合、v2.1.11にアップデート後、自動的に効率的な接続管理が適用されます。

### MCP設定例（~/.claude/mcp_config.json）

```json
{
  "mcpServers": {
    "remote-server": {
      "url": "https://example.com/mcp",
      "transport": "http",
      "headers": {
        "Authorization": "Bearer YOUR_TOKEN"
      }
    }
  }
}
```

## 実践例

### リモートMCPサーバーの設定

#### Sentryサーバーとの接続

Sentryなどのリモートサービスは、HTTP/SSE transportを使用してMCP接続を提供します。

```json
{
  "mcpServers": {
    "sentry": {
      "url": "https://sentry.io/api/mcp",
      "transport": "http",
      "headers": {
        "Authorization": "Bearer YOUR_SENTRY_TOKEN"
      }
    }
  }
}
```

v2.1.11では、このような設定でSentryサーバーに接続する際、不要な接続リクエストが発生しなくなり、スムーズに動作します。

#### 複数のリモートサーバーとの接続

複数のリモートMCPサーバーを使用する場合、それぞれに対して効率的な接続管理が適用されます。

```json
{
  "mcpServers": {
    "service-a": {
      "url": "https://service-a.com/mcp",
      "transport": "http"
    },
    "service-b": {
      "url": "https://service-b.com/mcp",
      "transport": "http"
    }
  }
}
```

### パフォーマンス改善の確認

修正後、以下のような改善が期待できます。

1. **接続確立時間の短縮** - 初回接続時の応答が高速化
2. **ネットワークトラフィックの削減** - 監視ツールで確認可能
3. **エラーレートの低下** - 過剰なリクエストによるタイムアウトが減少
4. **安定性の向上** - 長時間の使用でも安定した接続を維持

## 注意点

### バージョンアップの推奨

HTTP/SSE transportを使用している場合は、v2.1.11以降へのアップデートを推奨します。特に以下のような症状が出ている場合は、早めのアップデートをお勧めします。

- リモートMCPサーバーへの接続が遅い
- 接続時にタイムアウトエラーが頻発する
- ネットワークトラフィックが異常に多い

### Stdio Transportには影響なし

この修正は、HTTP/SSE transport専用の修正です。ローカルのStdio transportを使用している場合は、この問題の影響を受けていません。

### 既存の設定はそのまま使用可能

MCP設定ファイル（~/.claude/mcp_config.json）を変更する必要はありません。既存の設定で、修正の恩恵を受けることができます。

## 関連情報

### 公式ドキュメント

- [Model Context Protocol 公式サイト](https://modelcontextprotocol.io/)
- [MCP Architecture - Transport Layer](https://modelcontextprotocol.io/docs/learn/architecture)
- [Claude Code 公式ドキュメント](https://github.com/anthropics/claude-code)

### リリースノート

- [Changelog v2.1.11](https://github.com/anthropics/claude-code/releases/tag/v2.1.11)

### 関連記事

- [MCPとは何か - 公式概要](https://modelcontextprotocol.io/)
- [MCP Server実装例](https://github.com/modelcontextprotocol/servers)
