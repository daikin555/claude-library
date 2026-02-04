---
title: "MCP `list_changed`通知サポートで再接続なしの動的更新を実現"
date: 2026-01-31
tags: ['新機能', 'MCP', 'プラグイン']
---

## 原文（日本語に翻訳）

MCP `list_changed` 通知のサポートを追加し、MCPサーバーが再接続なしで利用可能なツール、プロンプト、リソースを動的に更新できるようになりました

## 原文（英語）

Added support for MCP `list_changed` notifications, allowing MCP servers to dynamically update their available tools, prompts, and resources without requiring reconnection

## 概要

Claude Code v2.1.0で導入されたMCP（Model Context Protocol）の動的更新機能です。従来はMCPサーバーのツール、プロンプト、リソースを変更した際に接続の再確立が必要でしたが、`list_changed`通知により、実行中のセッションを中断することなく、MCPサーバー側から変更を即座にClaude Codeに伝えられるようになりました。これにより、開発中のMCPサーバーのデバッグや、動的なツールセットの提供が容易になります。

## 基本的な使い方

MCPサーバー側で `list_changed` 通知を送信すると、Claude Codeが自動的に最新のツール、プロンプト、リソースリストを再取得します。

```typescript
// MCPサーバー側の実装例
class MyMCPServer {
  async addNewTool(toolDefinition: Tool) {
    this.tools.push(toolDefinition);

    // list_changed通知を送信
    await this.notify({
      method: "notifications/tools/list_changed"
    });
  }

  async updateResource(resourceId: string, newContent: string) {
    this.resources.set(resourceId, newContent);

    // リソース変更を通知
    await this.notify({
      method: "notifications/resources/list_changed"
    });
  }
}
```

## 実践例

### 開発中のMCPサーバーのホットリロード

MCPサーバーの開発中、ツール定義を変更するたびに自動的にClaude Codeに反映されます。

```typescript
// ファイル監視でツールを自動更新
import { watch } from 'fs';

watch('./tools', async (eventType, filename) => {
  if (eventType === 'change') {
    // ツール定義を再読み込み
    const updatedTools = await loadToolDefinitions();
    this.tools = updatedTools;

    // Claude Codeに変更を通知
    await this.notify({
      method: "notifications/tools/list_changed"
    });

    console.log('Tools updated without reconnection');
  }
});
```

### 動的なデータベーススキーマの反映

データベーススキーマが変更されたとき、MCPサーバーが即座に新しいテーブル情報をClaude Codeに提供します。

```typescript
// データベース監視
db.on('schema_change', async (event) => {
  // 新しいテーブル情報を取得
  const tables = await db.getTables();

  // リソースリストを更新
  this.resources = tables.map(table => ({
    uri: `db://tables/${table.name}`,
    name: table.name,
    description: `Database table: ${table.name}`
  }));

  // list_changed通知
  await this.notify({
    method: "notifications/resources/list_changed"
  });
});
```

### コンテキスト依存のツール提供

現在のプロジェクトやファイルに応じて、利用可能なツールセットを動的に変更します。

```typescript
// プロジェクトタイプに応じたツール提供
class ContextAwareMCPServer {
  async onProjectChange(projectType: string) {
    if (projectType === 'react') {
      this.tools = [...this.baseTools, ...this.reactTools];
    } else if (projectType === 'python') {
      this.tools = [...this.baseTools, ...this.pythonTools];
    }

    // ツールセット変更を通知
    await this.notify({
      method: "notifications/tools/list_changed"
    });

    console.log(`Tools updated for ${projectType} project`);
  }
}
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- MCPサーバー側で `list_changed` 通知を実装する必要があります
- サポートされる通知タイプ:
  - `notifications/tools/list_changed` - ツールリストの変更
  - `notifications/prompts/list_changed` - プロンプトリストの変更
  - `notifications/resources/list_changed` - リソースリストの変更
- 通知を受け取ると、Claude Codeは対応する `list` メソッド（`tools/list`、`prompts/list`、`resources/list`）を自動的に呼び出します
- 頻繁な通知送信はパフォーマンスに影響する可能性があるため、デバウンス処理の実装を推奨します
- MCPサーバーの実装には、公式のMCP SDKまたはFastMCP（Python）の使用を推奨します

## 関連情報

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [MCP Specification - Notifications](https://spec.modelcontextprotocol.io/specification/server/notifications/)
- [Building MCP Servers - Claude Code Docs](https://code.claude.com/docs/en/mcp-servers)
