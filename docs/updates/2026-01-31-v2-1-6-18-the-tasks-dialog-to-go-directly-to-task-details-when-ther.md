---
title: "/tasks ダイアログで単一タスク時に詳細画面に直接移動"
date: 2026-01-13
tags: ['改善', 'UI', 'タスク管理', 'ユーザビリティ']
---

## 原文（日本語に翻訳）

バックグラウンドタスクが1つだけ実行中の場合、`/tasks` ダイアログがタスク詳細に直接移動するように改善

## 原文（英語）

Improved the `/tasks` dialog to go directly to task details when there's only one background task running

## 概要

Claude Code v2.1.6 では、タスク管理の UX が改善されました。以前のバージョンでは、バックグラウンドタスクが1つだけ実行中でも、タスク一覧画面を経由する必要がありました。この改善により、単一タスクの場合は詳細画面に直接移動するようになり、より迅速に情報を確認できるようになりました。

## 基本的な使い方

タスクの状態を確認する:

1. `/tasks` コマンドを実行
2. タスクが1つの場合、詳細画面が直接表示される
3. タスクが複数の場合、一覧画面が表示される

## 実践例

### 修正前の動作（v2.1.5以前）

単一タスクでも一覧画面を経由:

```bash
# バックグラウンドで1つのタスクが実行中
# /tasks を実行

╔════════════════════════════════╗
║ Background Tasks (1)           ║
║                                ║
║ ▶ Building project...          ║
║                                ║
║ [View Details] [Close]         ║
╚════════════════════════════════╝

# 詳細を見るには「View Details」を押す必要がある
# → もう1クリック必要

╔════════════════════════════════╗
║ Task: Building project         ║
║                                ║
║ Status: In Progress            ║
║ Progress: 45%                  ║
║ Elapsed: 2m 15s                ║
║                                ║
║ Output:                        ║
║ Compiling src/app.ts...        ║
║ Compiling src/utils.ts...      ║
║                                ║
║ [Back] [Cancel Task]           ║
╚════════════════════════════════╝
```

### 修正後の動作（v2.1.6以降）

v2.1.6 では、単一タスクの場合は直接詳細画面へ:

```bash
# バックグラウンドで1つのタスクが実行中
# /tasks を実行

# 一覧画面をスキップして直接詳細画面へ
╔════════════════════════════════╗
║ Task: Building project         ║
║                                ║
║ Status: In Progress            ║
║ Progress: 45%                  ║
║ Elapsed: 2m 15s                ║
║                                ║
║ Output:                        ║
║ Compiling src/app.ts...        ║
║ Compiling src/utils.ts...      ║
║                                ║
║ [Close] [Cancel Task]          ║
╚════════════════════════════════╝

# 1ステップ減少、より迅速に情報を確認できる
```

### 複数タスクの場合（従来通り）

複数のタスクが実行中の場合は一覧画面を表示:

```bash
# /tasks を実行

╔════════════════════════════════╗
║ Background Tasks (3)           ║
║                                ║
║ ▶ Building project... (45%)    ║
║ ▶ Running tests... (20%)       ║
║ ⏸ Installing packages... (0%)  ║
║                                ║
║ [View Details] [Close]         ║
╚════════════════════════════════╝

# 複数ある場合は一覧で確認する必要があるため
# 従来通りの動作
```

### ビルドタスクの監視

プロジェクトのビルドを監視:

```bash
# ビルドを開始
npm run build

# バックグラウンドタスクとして実行中
# /tasks で即座に詳細を確認

╔════════════════════════════════╗
║ Task: npm run build            ║
║                                ║
║ Status: Running                ║
║ Progress: 67%                  ║
║ Elapsed: 3m 42s                ║
║                                ║
║ Output:                        ║
║ ✓ Compiled 45/67 files         ║
║ ⏳ Optimizing bundle...        ║
║                                ║
║ [Close] [Cancel]               ║
╚════════════════════════════════╝

# v2.1.6 では余計なクリックなしで情報を確認可能
```

### テスト実行の進捗確認

テストスイートの実行状況:

```bash
# テストを実行
npm test

# /tasks で詳細を確認
╔════════════════════════════════╗
║ Task: npm test                 ║
║                                ║
║ Status: Running                ║
║ Progress: 78%                  ║
║ Tests: 156/200 passed          ║
║                                ║
║ Output:                        ║
║ ✓ auth.test.ts                 ║
║ ✓ api.test.ts                  ║
║ ⏳ database.test.ts (running)  ║
║                                ║
║ [Close] [Stop Tests]           ║
╚════════════════════════════════╝
```

### 長時間実行タスクの監視

データ処理など長時間実行するタスク:

```bash
# データ処理を開始
python process_data.py

# 定期的に /tasks で状況確認
╔════════════════════════════════╗
║ Task: process_data.py          ║
║                                ║
║ Status: Running                ║
║ Elapsed: 15m 32s               ║
║ Processed: 45,678/100,000      ║
║                                ║
║ Output:                        ║
║ Processing batch 456...        ║
║ Memory: 2.4 GB                 ║
║ ETA: 18 minutes                ║
║                                ║
║ [Close] [Cancel]               ║
╚════════════════════════════════╝

# 迅速に進捗を確認できる
```

### タスクのキャンセル

実行中のタスクをキャンセル:

```bash
# /tasks で詳細画面を開く
# 「Cancel Task」を選択

╔════════════════════════════════╗
║ Cancel Task?                   ║
║                                ║
║ Are you sure you want to       ║
║ cancel "Building project"?     ║
║                                ║
║ [Yes] [No]                     ║
╚════════════════════════════════╝

# Yes を選択
# → タスクがキャンセルされる

# v2.1.6 では、単一タスクの場合
# より迅速にキャンセル画面に到達できる
```

### タスク完了通知からの遷移

タスク完了通知から詳細確認:

```
# タスクが完了
✓ Task completed: Building project

# /tasks を実行して結果を確認

╔════════════════════════════════╗
║ Task: Building project         ║
║                                ║
║ Status: Completed ✓            ║
║ Duration: 5m 23s               ║
║                                ║
║ Output:                        ║
║ ✓ Build successful             ║
║ ✓ 67 files compiled            ║
║ ✓ Bundle size: 2.3 MB          ║
║                                ║
║ [Close]                        ║
╚════════════════════════════════╝

# 完了したタスクの詳細も直接表示
```

### 実行中タスクのリアルタイム更新

詳細画面ではリアルタイムで情報が更新:

```
# 詳細画面を開いたまま
# 進捗が自動更新される

Time: 0:30
Progress: 10%

↓ (自動更新)

Time: 1:00
Progress: 35%

↓ (自動更新)

Time: 1:30
Progress: 58%

# 画面を開き直す必要なし
```

## 注意点

- この改善は Claude Code v2.1.6 で導入されました
- バックグラウンドタスクが1つだけの場合、タスク一覧をスキップして詳細画面に直接移動します
- 複数のタスクが実行中の場合は、従来通りタスク一覧が表示されます
- タスクが0個の場合は「No background tasks」メッセージが表示されます
- この改善により、単一タスクの監視がより効率的になりました
- タスクの詳細画面から一覧画面に戻ることはできません（単一タスクの場合）
- 詳細画面では、タスクの状態がリアルタイムで更新されます

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code タスク管理](https://code.claude.com/docs/tasks)
