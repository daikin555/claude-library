---
title: "大量のツール出力をディスクに永続化して完全アクセス可能に"
date: 2026-01-09
tags: ['改善', 'ツール出力', 'パフォーマンス', 'ファイル管理']
---

## 原文（日本語に翻訳）

大量のツール出力を切り詰める代わりにディスクに永続化するよう変更し、ファイル参照経由で完全な出力へのアクセスを提供します。

## 原文（英語）

Changed large tool outputs to be persisted to disk instead of truncated, providing full output access via file references

## 概要

Claude Codeが使用する各種ツール（Grep、Glob、Read、カスタムツールなど）の出力が大量になる場合、従来は途中で切り詰められていましたが、v2.1.2からはディスクに永続化され、ファイル参照を通じて完全な内容にアクセスできるようになりました。これにより、大規模なコードベースでの検索や分析が正確に行えます。

## 基本的な使い方

この機能は自動的に動作します。ツールが大量の出力を生成すると、自動的にディスクに保存されます。

### 修正前の動作

```bash
# 大規模なコードベースでGrep検索
claude "プロジェクト全体でTODOコメントを探して"

# 修正前:
# Found 500 matches (showing first 100):
# src/app.js:15: // TODO: Refactor this
# src/utils.js:42: // TODO: Add tests
# ...
# [output truncated - 400 matches not shown]

# Claudeは切り詰められた結果のみ分析可能
```

### 修正後の動作

```bash
# 同じ検索
claude "プロジェクト全体でTODOコメントを探して"

# 修正後:
# Found 500 matches - saved to: /tmp/grep-results-abc123.txt
# Preview (first 20 matches):
# src/app.js:15: // TODO: Refactor this
# src/utils.js:42: // TODO: Add tests
# ...
# Full results available at: /tmp/grep-results-abc123.txt

# Claudeは全500件の結果を分析可能
```

## 実践例

### 大規模なコード検索

```bash
# プロジェクト全体でパターン検索
claude "全てのAPIエンドポイント定義を見つけて"

# Grepツールが大量の結果を生成
# 修正前: 最初の100件のみ表示
# 修正後: 全ての結果がファイルに保存される

# Grep results saved to: /tmp/api-endpoints-xyz789.txt (3,245 matches)
# Analyzing all endpoint definitions...

# Claudeの分析:
# "プロジェクト全体で3,245のAPIエンドポイントが見つかりました:
#  - GET: 1,234件
#  - POST: 987件
#  - PUT: 543件
#  - DELETE: 481件
#  重複しているエンドポイントも15件検出しました。"
```

### ファイル一覧の完全処理

```bash
# 大量のファイルをリスト
claude "全てのTypeScriptファイルをリストアップして、
       最も大きいファイル10個を教えて"

# Globツールが数千ファイルを検出
# 修正前: 最初の数百ファイルのみ処理
# 修正後: 全ファイルがディスクに保存される

# File list saved to: /tmp/ts-files-def456.txt (4,521 files)
# Processing complete file list...

# 最大ファイルトップ10:
# 1. src/generated/api-types.ts (2.3MB)
# 2. src/lib/vendor-bundle.ts (1.8MB)
# ...
```

### 大量のファイル内容の分析

```bash
# 複数の設定ファイルを読み込み
claude "全ての.envファイルを読んで、使用されている環境変数をリスト化して"

# Readツールが複数の大きなファイルを読み込む
# 修正前: ファイル内容が切り詰められる
# 修正後: 完全な内容がディスクに保存される

# Read results saved to: /tmp/env-files-ghi789.txt
# Found 15 .env files with total 850 environment variables

# 完全な環境変数の分析と重複チェックが可能
```

### MCPツールの大量出力

```bash
# カスタムMCPツールが大量のデータを返す
claude "データベースから全ての商品情報を取得して分析して"

# MCPツールが100,000レコードを返す
# 修正前: 最初の1,000レコードのみ処理
# 修正後: 全レコードがファイルに保存される

# MCP tool output saved to: /tmp/mcp-products-jkl012.txt (42MB)
# Analyzing 100,000 product records...

# 統計:
# - 総商品数: 100,000
# - カテゴリ数: 250
# - 平均価格: ¥3,245
# - 在庫切れ: 1,234件
```

## 注意点

- **ディスク容量**: 大量の出力はディスク容量を消費します。定期的なクリーンアップを推奨します
- **一時ファイルの管理**: 出力ファイルは一時ディレクトリに保存され、セッション後に自動削除される場合があります
- **パフォーマンス**: 数十MB以上の出力の場合、ディスクI/Oによる遅延が発生する可能性があります
- **メモリ効率**: この変更により、メモリ使用量が大幅に削減されます
- **ファイル参照**: Claudeは自動的にファイル参照を解決し、必要な部分を読み取ります

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
