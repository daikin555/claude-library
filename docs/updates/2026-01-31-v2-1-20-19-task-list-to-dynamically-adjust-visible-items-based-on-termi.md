---
title: "ターミナルの高さに応じて表示項目を動的に調整するタスクリストの改善"
date: 2026-01-27
tags: ['UI改善', 'タスク管理', 'レスポンシブデザイン']
---

## 原文（日本語に翻訳）

ターミナルの高さに基づいて表示項目を動的に調整するようタスクリストを改善

## 原文（英語）

Improved task list to dynamically adjust visible items based on terminal height

## 概要

Claude Code v2.1.20では、タスクリストの表示が大幅に改善され、ターミナルウィンドウの高さに応じて表示するタスク数を動的に調整するようになりました。以前は、タスクリストが固定数の項目を表示していたため、小さいターミナルでは画面を占有しすぎたり、大きいターミナルでは空白が多すぎたりしました。この改善により、利用可能なスペースを最適に活用し、常に適切な量の情報が表示されます。

## 基本的な使い方

タスクリストは自動的にターミナルサイズに適応します：

```bash
# 小さいターミナル（24行）
> 10個のファイルを処理して

Tasks (10):
  [✓] File 1
  [✓] File 2
  [→] File 3
  [ ] File 4
  ... (6 more)  # 残りは省略表示

# 大きいターミナル（50行）
Tasks (10):
  [✓] File 1
  [✓] File 2
  [→] File 3
  [ ] File 4
  [ ] File 5
  [ ] File 6
  [ ] File 7
  [ ] File 8
  [ ] File 9
  [ ] File 10  # すべて表示可能
```

## 実践例

### 小型ラップトップでの作業

限られた画面スペースでの使用：

```bash
# 13インチラップトップ、ターミナル高さ30行

> 20のテストを実行して

# 改善前の問題：
# - 20行全てのタスクが表示
# - 会話履歴が見えなくなる
# - スクロールしないと他の情報にアクセスできない

# 改善後：
Tasks (20):
  [✓] Test auth module
  [✓] Test API endpoints
  [→] Test database layer
  [ ] Test caching
  [ ] Test error handling
  ... (15 more tasks)

View all: /tasks

# 利点：
# - 最重要な情報（進行中・完了・次）が見える
# - 会話の流れが保たれる
# - 詳細は /tasks コマンドで確認可能
```

### 大型モニターでの作業

広いスペースを有効活用：

```bash
# 27インチモニター、ターミナル高さ80行

> 大規模リファクタリングを実行

# 改善後：
Tasks (25):
  [✓] Update imports in auth/
  [✓] Update imports in api/
  [✓] Update imports in models/
  [→] Update imports in views/
  [ ] Update imports in utils/
  [ ] Update imports in tests/
  [ ] Run linter
  [ ] Fix linter warnings
  [ ] Run type checker
  [ ] Fix type errors
  [ ] Run all tests
  [ ] Fix failing tests
  [ ] Update documentation
  [ ] Review changes
  [ ] Create pull request
  ... (10 more)  # 画面に収まる分だけ表示

# すべてのタスクが一目で確認可能
# スクロールバックが不要
```

### ターミナル分割時の自動調整

画面を分割して使用する場合：

```bash
# 左: エディタ（60%）、右: Claude Code（40%）
# ターミナル高さが20行に縮小

> 複数段階のデプロイを実行

# 動的に調整：
Tasks (15):
  [✓] Build frontend
  [→] Build backend
  [ ] Run tests
  [ ] Deploy to staging
  ... (11 more)

# 縮小されたスペースでも
# 最も重要な情報が常に表示される
```

### リアルタイムリサイズ対応

ウィンドウサイズの変更時：

```bash
# 最初：フルスクリーン（60行）
Tasks (30):
  [項目1-15が全て表示]
  ...

# ウィンドウを縮小（30行に）
# → タスクリストが即座に調整
Tasks (30):
  [項目1-8が表示]
  ... (22 more)

# ウィンドウを再拡大（60行に）
# → 再び多くの項目が表示される
Tasks (30):
  [項目1-15が全て表示]
  ...

# 改善により：
# - リサイズに即座に反応
# - 常に最適な表示量
# - 手動調整不要
```

### 長時間実行タスクの追跡

多数のステップを含むプロセス：

```bash
# CI/CDパイプライン実行

> 完全なCI/CDパイプラインを実行

Tasks (50):  # 50ステップ
  [✓] Checkout code
  [✓] Install dependencies
  [✓] Lint code
  [→] Run unit tests (35/100)
  [ ] Run integration tests
  [ ] Build Docker image
  ... (44 more)

Progress: 3/50 (6%)

# ターミナルサイズに応じて：
# - 小: 最も関連性の高い5-7項目
# - 中: 10-15項目
# - 大: 20-25項目
# → 常に進行状況が把握しやすい
```

### 優先度の高いタスクの強調

重要度に基づく表示調整：

```bash
# スペースが限られている場合、
# システムは自動的に優先度を決定：

表示優先度（高→低）：
1. 現在進行中のタスク [→]
2. 直近で完了したタスク [✓]
3. 次に実行されるタスク [ ]
4. エラーが発生したタスク [✗]
5. 残りの未完了タスク [ ]
6. その他の完了済みタスク [✓]

# 改善により：
# - 最も重要な情報が常に見える
# - 手動でスクロールする必要がない
```

## 注意点

- タスクリストのサイズ調整は自動的に行われ、ユーザー操作は不要です
- 最小でも3-5項目は常に表示されます
- 省略された項目数は `... (N more)` の形式で表示されます
- `/tasks` コマンドで完全なタスクリストをいつでも確認できます
- ターミナルのリサイズに即座に反応します
- この改善は特に、大量のタスクを扱うワークフローで効果を発揮します

## 関連情報

- [Task Management](https://code.claude.com/docs/en/advanced/task-management)
- [TodoWrite Tool](https://code.claude.com/docs/en/reference/tools#todowrite)
- [Terminal Configuration](https://code.claude.com/docs/en/setup/terminal-setup)
- [Responsive UI Design](https://code.claude.com/docs/en/reference/ui-design#responsive)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
