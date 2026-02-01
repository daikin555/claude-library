---
title: "MCPツール検索の自動モードがデフォルトで有効化"
date: 2026-01-14
tags: ['新機能', 'MCP', 'パフォーマンス', 'コンテキスト管理']
---

## 原文（日本語に翻訳）

すべてのユーザーに対してMCPツール検索の自動モードをデフォルトで有効化しました。MCPツールの説明がコンテキストウィンドウの10%を超える場合、事前にロードするのではなく、MCPSearchツール経由で自動的に遅延して検出されます。これにより、多数のMCPツールを設定しているユーザーのコンテキスト使用量が削減されます。設定で`disallowedTools`に`MCPSearch`を追加することで、この機能を無効化できます。

## 原文（英語）

Enabled MCP tool search auto mode by default for all users. When MCP tool descriptions exceed 10% of the context window, they are automatically deferred and discovered via the MCPSearch tool instead of being loaded upfront. This reduces context usage for users with many MCP tools configured. Users can disable this by adding `MCPSearch` to `disallowedTools` in their settings.

## 概要

MCPツールの説明文がコンテキストウィンドウを圧迫する問題を解決する機能です。多数のMCPツールを設定している場合、すべてのツール説明を事前にロードするとコンテキストが不足する可能性があります。この機能により、ツール説明は必要に応じて動的に検索されるため、コンテキストを効率的に使用できます。

## 基本的な使い方

この機能はデフォルトで有効化されており、特別な設定は不要です。MCPツールの説明がコンテキストウィンドウの10%を超えた場合、自動的に遅延ロードモードに切り替わります。

### 無効化する場合

設定ファイル（`~/.claude/settings.json`）で以下のように設定します。

```json
{
  "disallowedTools": ["MCPSearch"]
}
```

## 実践例

### 多数のMCPツールを使用する場合

例えば、データベース、API、ファイルシステム、Git操作など、10個以上のMCPサーバーを設定している環境では、この機能により以下のメリットがあります。

- **コンテキストの節約**: ツール説明が必要なときだけロードされるため、より多くのコードや会話履歴を保持できます
- **起動の高速化**: すべてのツール説明を事前にロードする必要がないため、セッション開始が速くなります
- **スケーラビリティ**: 多数のMCPツールを追加しても、パフォーマンスへの影響が最小限に抑えられます

### 自動切り替えの動作例

```
# 5個のMCPツール → すべて事前ロード（従来通り）
# 20個のMCPツール → 10%閾値を超える場合、自動的に遅延ロード
```

Claudeは必要なツールを自動的に検索して使用するため、ユーザー側での操作は不要です。

## 注意点

- **10%の閾値**: MCPツール説明の合計がコンテキストウィンドウの10%を超えた場合に自動的に有効化されます
- **透過的な動作**: ユーザーからは従来と同じように見えますが、内部的にはツール検索が動的に行われます
- **無効化の影響**: `MCPSearch`を無効化すると、多数のMCPツールを使用している場合にコンテキスト不足が発生する可能性があります
- **パフォーマンス**: ツール検索には若干のオーバーヘッドがありますが、コンテキスト節約のメリットの方が大きいです

## 関連情報

- [MCP (Model Context Protocol) について](https://modelcontextprotocol.io/)
- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
