---
title: 'MCPサーバータイムアウト時の子プロセス終了問題を修正してUI凍結を解消'
date: 2026-01-21
tags: ['バグ修正', 'MCP', 'パフォーマンス', '安定性']
---

## 原文（日本語に翻訳）

MCP stdioサーバータイムアウト時に子プロセスが終了されず、UI凍結を引き起こす問題を修正

## 原文（英語）

Fixed MCP stdio server timeout not killing child process, which could cause UI freezes

## 概要

Claude Code v2.1.15では、Model Context Protocol（MCP）のstdioサーバーがタイムアウトした際に子プロセスが適切に終了されず、UI全体が凍結する重大なバグが修正されました。これまで、MCPサーバーが応答しなくなった場合、バックグラウンドで実行される子プロセスが残り続け、システムリソースを消費し続けることでClaude Codeの操作が不可能になる問題がありました。この修正により、タイムアウト発生時に子プロセスが確実に終了され、Claude Codeの安定性と応答性が大幅に向上しました。

## 基本的な使い方

### MCPサーバーの設定

MCPサーバーは`.claude/config.json`または`claude.json`で設定します。

```json
{
  "mcpServers": {
    "my-custom-server": {
      "command": "node",
      "args": ["./mcp-server.js"],
      "timeout": 30000
    }
  }
}
```

### タイムアウト設定の調整

応答が遅いMCPサーバーに対しては、タイムアウト値を調整できます。

```json
{
  "mcpServers": {
    "slow-server": {
      "command": "python",
      "args": ["slow_mcp_server.py"],
      "timeout": 60000,  // 60秒（デフォルトは30秒）
      "env": {
        "DEBUG": "true"
      }
    }
  }
}
```

## 実践例

### カスタムMCPサーバーの安全な使用

外部APIを呼び出すMCPサーバーの設定例：

```json
{
  "mcpServers": {
    "api-integrator": {
      "command": "node",
      "args": ["./servers/api-integrator.js"],
      "timeout": 45000,
      "env": {
        "API_KEY": "${env:MY_API_KEY}",
        "API_ENDPOINT": "https://api.example.com"
      }
    }
  }
}
```

```javascript
// servers/api-integrator.js
// v2.1.15以降、タイムアウト時にプロセスが確実に終了される

import { MCPServer } from '@anthropic/mcp-sdk';

const server = new MCPServer({
  name: 'API Integrator',
  version: '1.0.0'
});

server.tool('fetch-data', async (params) => {
  // 外部API呼び出し
  // タイムアウトした場合、親プロセスが確実に終了処理を行う
  const response = await fetch(process.env.API_ENDPOINT);
  return await response.json();
});

server.start();
```

### 複数のMCPサーバーを使用する場合

複数のMCPサーバーを並行して使用する際の設定：

```json
{
  "mcpServers": {
    "database-tools": {
      "command": "python",
      "args": ["./servers/db_tools.py"],
      "timeout": 30000
    },
    "file-analyzer": {
      "command": "node",
      "args": ["./servers/file-analyzer.js"],
      "timeout": 20000
    },
    "code-formatter": {
      "command": "deno",
      "args": ["run", "--allow-all", "./servers/formatter.ts"],
      "timeout": 15000
    }
  }
}
```

v2.1.15以降では、いずれかのサーバーがタイムアウトしても、他のサーバーやClaude CodeのUIに影響を与えません。

### ネットワーク依存のMCPサーバー

ネットワーク接続に依存するMCPサーバーの場合：

```json
{
  "mcpServers": {
    "github-integration": {
      "command": "npx",
      "args": ["@anthropic/mcp-server-github"],
      "timeout": 60000,  // ネットワーク遅延を考慮
      "env": {
        "GITHUB_TOKEN": "${env:GITHUB_TOKEN}"
      }
    }
  }
}
```

```bash
# Claude Codeを起動
claude

# GitHubツールを使用
# "このリポジトリの最新のプルリクエストを取得してください"

# v2.1.14以前の問題:
# - ネットワークが遅い場合、タイムアウト後もプロセスが残る
# - UIが凍結し、Claude Codeを強制終了する必要がある

# v2.1.15以降:
# - タイムアウト発生時、子プロセスが確実に終了
# - エラーメッセージが表示され、作業を継続できる
# "⚠️ MCP server 'github-integration' timed out and was terminated"
```

### デバッグとトラブルシューティング

MCPサーバーのタイムアウト問題をデバッグする場合：

```json
{
  "mcpServers": {
    "debug-server": {
      "command": "node",
      "args": ["--inspect", "./servers/debug-server.js"],
      "timeout": 30000,
      "env": {
        "LOG_LEVEL": "debug",
        "VERBOSE": "true"
      }
    }
  }
}
```

```bash
# Claude Codeを起動
claude

# ログを確認（別のターミナルで）
tail -f ~/.claude/logs/mcp-servers.log

# v2.1.15では、タイムアウト時のログに詳細情報が記録される:
# [2026-01-21 10:30:45] MCP server 'debug-server' timeout (30000ms)
# [2026-01-21 10:30:45] Sending SIGTERM to process 12345
# [2026-01-21 10:30:46] Process 12345 terminated successfully
```

## 注意点

- **タイムアウト値の設定**: MCPサーバーの応答時間に応じて適切なタイムアウト値を設定してください。デフォルトは30秒ですが、重い処理を行うサーバーでは延長が必要です
- **プロセス終了の猶予期間**: タイムアウト後、まずSIGTERMシグナルが送信され、一定時間後に応答がなければSIGKILLで強制終了されます
- **リソースクリーンアップ**: MCPサーバー側で適切なシグナルハンドリングを実装することで、タイムアウト時にリソースを正常にクリーンアップできます
- **UI応答性**: v2.1.15以降、タイムアウト発生時もUIが凍結せず、エラーメッセージが表示され、他の操作を継続できます
- **複数サーバーの独立性**: 1つのMCPサーバーがタイムアウトしても、他のMCPサーバーやClaude Codeの機能には影響しません
- **ログの確認**: タイムアウトが頻繁に発生する場合は、`~/.claude/logs/`のログファイルを確認して原因を特定してください
- **バックグラウンドプロセス**: 長時間実行されるバックグラウンドタスクを持つMCPサーバーは、タイムアウト値を十分に長く設定するか、非同期パターンを使用してください

## 関連情報

- [MCP（Model Context Protocol）公式ドキュメント](https://modelcontextprotocol.io/)
- [Claude Code MCP統合ガイド](https://code.claude.com/docs/mcp)
- [Changelog v2.1.15](https://github.com/anthropics/claude-code/releases/tag/v2.1.15)
- [MCPサーバー開発ガイド](https://modelcontextprotocol.io/docs/server-development)
- [プロセス管理とシグナルハンドリング](https://code.claude.com/docs/mcp/process-management)
