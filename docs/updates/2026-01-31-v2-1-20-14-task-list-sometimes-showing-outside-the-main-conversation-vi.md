---
title: "タスクリストがメイン会話ビューの外に表示される問題を修正"
date: 2026-01-27
tags: ['バグ修正', 'UI', 'タスク管理']
---

## 原文（日本語に翻訳）

タスクリストがメイン会話ビューの外側に表示されることがある問題を修正

## 原文（英語）

Fixed task list sometimes showing outside the main conversation view

## 概要

Claude Code v2.1.20では、タスクリスト（TodoList）がメインの会話エリアから外れて表示される視覚的なバグが修正されました。以前は、特定の条件下でタスクリストが画面の見えない領域にレンダリングされたり、会話の流れから切り離されて表示されることがありました。この修正により、タスクリストは常に適切な位置に表示され、会話の一部として自然に統合されます。

## 基本的な使い方

タスクリストは自動的に正しい位置に表示されます：

```bash
# エージェントがタスクを作成
> この3つのファイルを順番に確認して修正して：
  1. src/app.js
  2. src/utils.js
  3. src/config.js

# エージェントがタスクリストを作成
[ ] src/app.js を確認
[ ] src/utils.js を確認
[ ] src/config.js を確認

# 修正前の問題：
# - タスクリストが会話エリアの外に表示される
# - スクロールしても見えない
# - タスクの進捗が追跡できない

# 修正後：
# - タスクリストが会話内に正しく表示される
# - 進捗が視覚的に確認可能
```

## 実践例

### 複数ステップのタスク実行

長期的なタスクを段階的に進める場合：

```bash
> このプロジェクトをデプロイ可能な状態にして

# エージェントが作成するタスクリスト：
Tasks:
  [✓] Run linter and fix issues
  [✓] Run all tests
  [ ] Build production bundle
  [ ] Update documentation
  [ ] Create deployment package

# 修正により：
# - リストが会話の中に表示される
# - 完了したタスクにチェックマークが付く
# - 進捗が一目で分かる
```

### 小さなターミナルウィンドウでの使用

画面スペースが限られている環境：

```bash
# 狭いターミナル（80x24など）での作業
> 5つのファイルを順番にリファクタリングして

# タスクリスト表示
Tasks (5):
  [✓] Refactor auth.js
  [✓] Refactor api.js
  [→] Refactor utils.js  # 現在進行中
  [ ] Refactor config.js
  [ ] Refactor index.js

# 修正前の問題：
# - リストが画面外にはみ出す
# - スクロールバーの位置が不自然
# - タスクの一部が見切れる

# 修正後：
# - ウィンドウサイズに応じて適切に表示
# - すべてのタスクが可視範囲内
# - スムーズにスクロール可能
```

### 並行タスクの管理

複数の独立したタスクを同時進行：

```bash
> この3つのバグを並行して修正して

# タスクリストが会話内に表示：
Parallel tasks:
  [✓] Fix authentication timeout (completed 14:32)
  [→] Fix database connection leak (in progress...)
  [ ] Fix memory leak in image processing

# エージェントの作業状況がリアルタイムで更新
# 修正により、常に見やすい位置に表示される
```

### 長い会話セッション中のタスク追跡

多くのやり取りがある中でタスクを管理：

```bash
# 100以上のメッセージがある長いセッション
> [多くの会話...]

# 途中でタスクリストを確認
> /tasks

Current tasks:
  [✓] Setup development environment
  [✓] Install dependencies
  [→] Configure database
  [ ] Run migrations
  [ ] Seed test data

# 修正前：
# - /tasks コマンドでリストが画面外に表示
# - 会話履歴をスクロールしないと見えない

# 修正後：
# - コマンド実行位置に正しく表示
# - 他の出力と同じように統合
```

### ネストされたタスクの表示

サブタスクを含む複雑な構造：

```bash
> フロントエンドとバックエンドの両方をアップデートして

Main tasks:
  [✓] Frontend updates
      [✓] Update React components
      [✓] Update styles
  [→] Backend updates
      [✓] Update API endpoints
      [ ] Update database schema
      [ ] Write migration scripts
  [ ] Integration testing

# 修正により：
# - ネストされたタスクも正しくインデント
# - 階層構造が視覚的に明確
# - すべて会話エリア内に収まる
```

## 注意点

- この修正は、タスクリストのレンダリング位置に影響します
- タスクリストは会話の流れに沿って表示されます
- 非常に長いタスクリストは自動的にページング or スクロール可能な形式で表示されます
- ターミナルのサイズ変更時も、リストは適切に再配置されます
- この問題は特に小さい画面やリサイズされたウィンドウで顕著でした

## 関連情報

- [Task Management](https://code.claude.com/docs/en/advanced/task-management)
- [TodoWrite Tool](https://code.claude.com/docs/en/reference/tools#todowrite)
- [Interactive Mode - UI Layout](https://code.claude.com/docs/en/interactive-mode#ui-layout)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
