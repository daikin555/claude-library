---
title: "デバッグログにツールコールの失敗と拒否を記録する機能の追加"
date: 2026-01-30
tags: ['新機能', 'デバッグ', 'ログ']
---

## 原文（日本語に翻訳）

デバッグログにツールコールの失敗と拒否を追加

## 原文（英語）

Added tool call failures and denials to debug logs

## 概要

Claude Codeの問題をトラブルシューティングする際に、ツールコールが失敗したり、権限設定により拒否された場合の詳細情報がデバッグログに記録されるようになりました。これにより、権限設定の問題や予期しないエラーの原因を特定しやすくなります。

## 基本的な使い方

デバッグモードを有効化するには、`--debug`フラグを使用してClaude Codeを起動します。

```bash
claude --debug
```

特定のカテゴリのみをログに出力する場合は、カテゴリを指定できます。

```bash
# API とフックのログのみを表示
claude --debug "api,hooks"

# statsig と file 以外のすべてを表示
claude --debug "!statsig,!file"
```

## 実践例

### 権限エラーのデバッグ

権限設定により特定のツールが拒否される場合、デバッグログで詳細を確認できます。

```bash
claude --debug
```

これにより、以下のような情報がログに記録されます：
- どのツールコールが拒否されたか
- 拒否の理由（権限ルールに該当、ユーザーによる手動拒否など）
- 適用された権限ルール

### ツール実行失敗の原因特定

Bashコマンドやファイル操作が失敗する際に、その原因を特定します。

```bash
claude --debug "api,tools"
```

デバッグログには以下が含まれます：
- ツールコールのパラメータ
- 実行結果とエラーメッセージ
- スタックトレース（該当する場合）

### MCP サーバーの問題診断

MCP サーバーとの通信問題をデバッグする場合：

```bash
claude --debug "mcp,api"
```

これにより、MCPサーバーへのリクエストとレスポンス、接続エラーなどが確認できます。

### 開発中のプラグインやエージェントのデバッグ

カスタムプラグインやエージェントを開発している場合：

```bash
claude --debug --plugin-dir ./my-plugins
```

プラグインの読み込み状況やエラーがログに表示されます。

## 注意点

- デバッグモードは多量のログを出力するため、通常の使用時は無効にすることを推奨します
- カテゴリフィルタリングを使用することで、必要な情報のみを絞り込めます
- センシティブな情報（APIキー、パスワードなど）がログに含まれる可能性があるため、ログの共有時は注意してください
- `/doctor`コマンドでも基本的な診断情報を確認できます

## 関連情報

- [Troubleshooting - Claude Code Docs](https://code.claude.com/docs/en/troubleshooting)
- [CLI reference - Claude Code Docs](https://code.claude.com/docs/en/cli-reference)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
