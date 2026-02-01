---
title: "複数タスク完了時の通知表示を3行に制限"
date: 2026-01-13
tags: ['変更', 'UI', 'タスク管理', '通知']
---

## 原文（日本語に翻訳）

複数のバックグラウンドタスクが同時に完了した際、タスク通知の表示を3行に制限し、溢れた分はサマリーで表示するように変更

## 原文（英語）

Changed task notification display to cap at 3 lines with overflow summary when multiple background tasks complete simultaneously

## 概要

Claude Code v2.1.6 では、タスク完了通知の表示方法が改善されました。以前のバージョンでは、複数のタスクが同時に完了すると、全ての通知が表示され、画面が埋め尽くされてしまう問題がありました。この変更により、通知は最大3行までに制限され、それ以上のタスクはサマリー形式で表示されるようになり、画面の視認性が向上しました。

## 基本的な使い方

この変更は自動的に適用され、ユーザー側での設定変更は不要です。

タスク完了通知の動作:
1. タスクが完了すると通知が表示される
2. 3つまでのタスクは個別に表示される
3. 4つ以上のタスクはサマリー形式で表示される

## 実践例

### 変更前の動作（v2.1.5以前）

複数タスクが同時に完了すると画面が埋まる:

```
✓ Task completed: Building project
✓ Task completed: Running tests
✓ Task completed: Linting code
✓ Task completed: Type checking
✓ Task completed: Generating docs
✓ Task completed: Packaging build
✓ Task completed: Uploading artifacts
✓ Task completed: Sending notifications

# 8行の通知が表示され、画面が埋まる
# 作業中の内容が見えなくなる
# スクロールが必要になる
```

### 変更後の動作（v2.1.6以降）

v2.1.6 では、最大3行 + サマリー:

```
✓ Task completed: Building project
✓ Task completed: Running tests
✓ Task completed: Linting code
+ 5 more tasks completed

# 3つの詳細 + サマリー
# 画面がすっきり
# 作業が中断されない
```

### 1-3個のタスク完了（詳細表示）

少数のタスクは全て表示:

```bash
# 1つのタスク完了
✓ Task completed: Building project

# 2つのタスク完了
✓ Task completed: Building project
✓ Task completed: Running tests

# 3つのタスク完了
✓ Task completed: Building project
✓ Task completed: Running tests
✓ Task completed: Linting code

# 全て詳細に表示される
```

### 4個以上のタスク完了（サマリー表示）

多数のタスクはサマリー化:

```bash
# 5つのタスク完了
✓ Task completed: Building project
✓ Task completed: Running tests
✓ Task completed: Linting code
+ 2 more tasks completed

# 詳細を見るには /tasks を実行
```

### CI/CD パイプラインの実行

複数のビルドステップが同時完了:

```bash
# CI/CD パイプラインで10個のタスクが完了

# v2.1.5 以前:
✓ Task completed: Checkout code
✓ Task completed: Install dependencies
✓ Task completed: Build frontend
✓ Task completed: Build backend
✓ Task completed: Run unit tests
✓ Task completed: Run integration tests
✓ Task completed: Lint code
✓ Task completed: Type check
✓ Task completed: Build Docker image
✓ Task completed: Push to registry
# 画面が通知で埋まる

# v2.1.6 以降:
✓ Task completed: Checkout code
✓ Task completed: Install dependencies
✓ Task completed: Build frontend
+ 7 more tasks completed
# すっきり表示
```

### 詳細の確認

サマリー表示から詳細を確認:

```bash
# サマリーが表示された場合
+ 5 more tasks completed

# 詳細を見るには
/tasks

# または
/stats

# 完了したタスクの一覧が表示される
```

### 並列タスクの実行

複数のタスクを並列実行:

```bash
# 並列でタスクを開始
npm run build &
npm run test &
npm run lint &
npm run typecheck &
npm run docs &

# 全て完了
✓ Task completed: build
✓ Task completed: test
✓ Task completed: lint
+ 2 more tasks completed

# v2.1.6: 画面がクリーン
```

### モノレポでの一括ビルド

モノレポで複数パッケージをビルド:

```bash
# 15個のパッケージをビルド
lerna run build

# 全て完了
✓ Task completed: @myapp/core
✓ Task completed: @myapp/utils
✓ Task completed: @myapp/ui
+ 12 more tasks completed

# v2.1.6: 通知が整理される
```

### タスク完了の優先順位

重要なタスクから表示:

```
# 完了順に上位3つを表示
✓ Task completed: Build production (5m 23s)
✓ Task completed: Run tests (3m 45s)
✓ Task completed: Deploy staging (2m 12s)
+ 4 more tasks completed

# 最近完了したタスクが優先的に表示される
```

### 通知の自動消去

通知は数秒後に自動的に消える:

```
# タスク完了直後
✓ Task completed: Building project
✓ Task completed: Running tests
✓ Task completed: Linting code
+ 2 more tasks completed

↓ 5秒後

# 通知が自動的に消える
# 通常の作業画面に戻る
```

### エラーと成功の混在

成功とエラーが混在する場合:

```
# 一部失敗した場合
✓ Task completed: Building project
✗ Task failed: Running tests (exit code 1)
✓ Task completed: Linting code
+ 2 more tasks (1 failed)

# エラーがあることがサマリーでわかる
```

### 通知設定のカスタマイズ

通知の動作を調整:

```bash
/config
# "notification" または "task" で検索

# 設定例:
taskNotificationEnabled: true/false
taskNotificationDuration: 5000  # ミリ秒
taskNotificationMaxLines: 3  # v2.1.6 で固定

# v2.1.6 では最大行数は3で固定
```

## 注意点

- この変更は Claude Code v2.1.6 で導入されました
- タスク完了通知は最大3行までに制限されます
- 4つ以上のタスクが完了した場合、サマリー形式で表示されます
- サマリーには「+ N more tasks completed」の形式で残りのタスク数が表示されます
- 詳細を確認するには `/tasks` コマンドを使用します
- エラーが含まれる場合、サマリーに失敗数が表示されます
- 通知は数秒後に自動的に消えます
- この変更により、多数のタスクを実行しても画面が埋まらなくなりました
- 最大行数(3行)の設定はカスタマイズできません

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Changelog v2.1.6 - /tasks dialog improvement](https://github.com/anthropics/claude-code/releases/tag/v2.1.6) - 関連するタスク管理の改善
- [Claude Code タスク管理](https://code.claude.com/docs/tasks)
