---
title: "/contextコマンドのカラー出力が表示されない問題を修正"
date: 2025-01-27
tags: [bugfix, command, ui]
---

## 原文（日本語訳）

`/context` コマンドがカラー出力を表示しない問題を修正

## 原文（英語）

Fixed /context command not displaying colored output

## 概要

`/context` コマンドの出力が、意図したカラー表示にならず見づらかった問題が修正されました。これにより、コンテキスト使用状況がより視覚的にわかりやすく表示されるようになります。

## 基本的な使い方

通常通り `/context` コマンドを実行すると、カラー出力が表示されます。

```bash
# Claude Code内で
/context
```

## 実践例

### コンテキスト使用状況の確認

セッション中に、現在どれだけのコンテキストを使用しているか確認できます。

```bash
# Claude Code内で
/context

# カラー表示で以下のような情報が表示される:
# - トークン使用量（色分けされた進捗バー）
# - 残りコンテキスト
# - 各ツールやファイルの使用量
```

### コンパクト化のタイミングを判断

コンテキストが一杯になる前に、`/compact` を実行するタイミングを視覚的に判断できます。

```bash
# 使用状況を確認
/context

# 警告色（例: 赤や黄色）で表示された場合はコンパクト化を検討
/compact
```

### verboseモードでの詳細確認

より詳細なコンテキスト情報を色付きで確認できます。

```bash
# 設定でverboseモードを有効化
/config
# verboseをオンにする

# 詳細なカラー出力で表示
/context
```

### デバッグ時の視認性向上

問題が発生した際、どのツールやファイルがコンテキストを圧迫しているかを色分けで素早く特定できます。

```bash
# コンテキスト使用状況を確認
/context

# 各項目が色分けされて表示:
# - Skills: 緑
# - Files: 青
# - Tools: 黄
# - MCP: 紫
# など
```

## 注意点

- ターミナルがANSIカラーコードをサポートしている必要があります
- 一部の古いターミナルでは色が正しく表示されない場合があります
- モノクロモードのターミナルでは従来通り白黒表示になります

## 関連情報

- [コンテキスト管理ガイド](https://code.claude.com/docs/en/context-management)
- [/contextコマンドリファレンス](https://code.claude.com/docs/en/commands#context)
- [コンパクト化について](https://code.claude.com/docs/en/compaction)
