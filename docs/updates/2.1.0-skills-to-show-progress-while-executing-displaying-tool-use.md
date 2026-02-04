---
title: "スキル実行中の進捗表示を改善 - ツール使用をリアルタイム表示"
date: 2026-01-31
tags: ['改善', 'スキル', 'UI', '進捗表示']
---

## 原文（日本語に翻訳）

スキル実行中の進捗表示を改善し、ツール使用がリアルタイムで表示されるようになりました

## 原文（英語）

Improved skills to show progress while executing, displaying tool uses as they happen

## 概要

Claude Code v2.1.0で改善された、スキル実行時の進捗表示機能です。以前のバージョンでは、スキルを実行すると完了するまで何が起きているか分からず、長時間のタスクで不安を感じることがありました。この改善により、スキルが実行中に使用するツール（ファイル読み込み、コマンド実行、Web検索など）がリアルタイムで表示され、現在の進行状況を把握できるようになりました。

## 改善前の動作

### ブラックボックス状態

```bash
# スキルを実行
claude

> /commit

# 修正前:
[Running commit skill...]
# 何が起きているか不明
# 長時間待機
# ...
✓ Done

# 問題点:
# - 進捗が見えない
# - 何をしているか不明
# - フリーズとの区別がつかない
```

## 改善後の動作

### リアルタイム進捗表示

```bash
# スキルを実行
claude

> /commit

# 修正後:
[Running commit skill...]
→ Running: git status
→ Running: git diff
→ Running: git log --oneline -5
→ Analyzing changes...
→ Drafting commit message...
→ Running: git add src/
→ Running: git commit -m "..."
✓ Done

# ✓ すべてのステップが見える
# ✓ 現在の作業が明確
# ✓ 安心して待てる
```

## 実践例

### コミットスキル

各git操作がリアルタイムで表示される。

```bash
> /commit

# 表示される進捗:
→ Running: git status
→ Running: git diff --staged
→ Running: git diff
→ Reading: package.json
→ Running: git log --oneline -10
→ Drafting commit message...
→ Running: git add src/components/Button.tsx
→ Running: git commit -m "feat: add Button component..."
✓ Committed successfully

# ✓ 各ステップが見える
# ✓ どのファイルを処理中か分かる
```

### コードレビュースキル

ファイル読み込みと解析の進捗。

```bash
> /code-review

# 表示される進捗:
→ Running: git diff main...HEAD
→ Reading: src/auth.ts (128 lines)
→ Reading: src/middleware.ts (64 lines)
→ Reading: tests/auth.test.ts (95 lines)
→ Analyzing code quality...
→ Checking for security issues...
→ Checking test coverage...
→ Generating report...
✓ Review complete

# ✓ どのファイルを読んでいるか分かる
# ✓ 解析ステップが見える
```

### 長時間タスク

複雑なタスクでも進捗が明確。

```bash
> /refactor-codebase

# 表示される進捗:
→ Running: find . -name "*.ts"
→ Reading: src/components/Header.tsx
→ Reading: src/components/Footer.tsx
→ Reading: src/components/Sidebar.tsx
→ Analyzing component structure...
→ Planning refactoring strategy...
→ Running: git checkout -b refactor/components
→ Editing: src/components/Header.tsx
→ Editing: src/components/Footer.tsx
→ Running: npm test
→ Running: git add .
→ Running: git commit -m "..."
✓ Refactoring complete

# ✓ 20分のタスクでも進捗が見える
# ✓ 各ステップで何が起きているか分かる
```

### Web検索を含むスキル

外部APIアクセスの進捗。

```bash
> /research-topic "Claude Code best practices"

# 表示される進捗:
→ Searching web: "Claude Code best practices"
→ Fetching: https://code.claude.com/docs/...
→ Fetching: https://github.com/anthropics/...
→ Reading: README.md
→ Analyzing sources...
→ Synthesizing information...
→ Writing: research-report.md
✓ Research complete

# ✓ Web検索の進行が見える
# ✓ どのURLを取得中か分かる
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 表示される情報:
  - **ツール名**: Running, Reading, Editing, Writing, Searching など
  - **対象**: ファイル名、コマンド、URL など
  - **進捗**: 現在のステップ
  - **結果**: 完了時のサマリー
- 表示のタイミング:
  - ツール実行の直前にリアルタイム表示
  - 長時間のツール実行中も表示を維持
  - 完了後に結果を表示
- パフォーマンス:
  - 進捗表示のオーバーヘッドは最小限
  - スキルの実行速度に影響なし
- 非表示にする:
  - 現時点では進捗表示を無効化できない
  - すべてのスキルで自動的に有効
- カスタムスキルでの利用:
  - 自作スキルでも自動的に進捗が表示される
  - スキル側で特別な実装は不要
- デバッグモード:
  ```bash
  claude --debug
  # さらに詳細な進捗情報を表示
  # - ツール呼び出しのパラメータ
  # - 中間結果
  # - エラー詳細
  ```
- 長時間タスクの中断:
  - Ctrl+C でいつでもスキルを中断可能
  - 進捗を見ながら安全に停止
- UI表示:
  - ターミナル幅に合わせて自動調整
  - 長いパスやコマンドは省略表示
  - 色分けで読みやすく表示
- 関連する改善:
  - index 92: スピナーフィードバックの改善
  - index 93: トークンカウント表示の改善

## 関連情報

- [Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Custom skills](https://code.claude.com/docs/en/custom-skills)
- [Progress indicators](https://code.claude.com/docs/en/ui#progress)
