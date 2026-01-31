---
title: "読み取り・検索の進捗表示を改善"
date: 2026-01-28
tags: ['改善', 'UI/UX', '進捗表示']
---

## 原文（日本語に翻訳）

読み取り・検索の進捗インジケーターを改善し、進行中は「Reading…」、完了時は「Read」を表示

## 原文（英語）

Improved read/search progress indicators to show "Reading…" while in progress and "Read" when complete

## 概要

ファイルの読み取りやコード検索中の進捗表示が改善され、操作の状態がより明確になりました。以前は、読み取りが進行中か完了したかを判断しにくい場合がありましたが、v2.1.21では進行中は「Reading…」（三点リーダー付き）、完了時は「Read」と明確に表示されるようになりました。これにより、Claudeが現在何をしているのか、いつレスポンスが得られるのかをより正確に把握できます。

## 基本的な使い方

ファイル操作や検索を実行すると、自動的に進捗状態が表示されます。特別な設定は不要です。

```bash
$ claude code
> src/components/Button.tsxを読み込んで
[Reading…]  # 読み込み中
[Read]      # 読み込み完了

> プロジェクト内のすべてのTODOコメントを検索
[Searching…]  # 検索中
[Found 15 matches]  # 検索完了
```

## 実践例

### 大きなファイルの読み込み

大容量のファイルを読み込む際、進捗が視覚的に分かりやすくなります：

```
> package-lock.jsonを読み込んで依存関係を分析
[Reading package-lock.json…]  # 進行中であることが明確
...
[Read package-lock.json]  # 完了したことが明確
```

### 複数ファイルの並行読み込み

複数のファイルを同時に読み込む場合、各ファイルの状態が個別に表示されます：

```
> src/配下の全ファイルを読み込んで
[Reading src/index.ts…]
[Reading src/utils.ts…]
[Reading src/types.ts…]
[Read src/index.ts]
[Read src/utils.ts]
[Read src/types.ts]
```

### コードベース全体の検索

プロジェクト全体を検索する際、進行状況を把握できます：

```
> プロジェクト内で"async function"を使用している箇所を検索
[Searching codebase…]  # 検索実行中
[Searching… 150 files scanned]  # 進捗の詳細（場合により表示）
[Found 23 matches in 12 files]  # 検索完了
```

### インタラクティブな作業フロー

複数の操作を連続して実行する際、各ステップの進捗が追跡できます：

```
> エラーログを読み込んでエラーの原因を特定して
[Reading logs/error.log…]
[Read logs/error.log]
[Analyzing errors…]
[Analysis complete]

> 関連するソースファイルを検索
[Searching for related files…]
[Found 5 related files]
```

## 注意点

- この改善はv2.1.21で適用されました
- CLIとVS Code拡張の両方で動作します
- 三点リーダー（…）は進行中を示します
- 非常に小さなファイルの場合、進捗表示が一瞬で終わることがあります
- 大きなファイルやプロジェクトでは、進捗表示がより長く表示されます
- 進捗表示中でもCtrl+Cで操作をキャンセルできます
- バックグラウンドタスクの場合、進捗は `/task output` コマンドで確認できます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.21](https://github.com/anthropics/claude-code/releases/tag/v2.1.21)
- [UI/UX改善ガイド](https://code.claude.com/docs/ui-improvements)
