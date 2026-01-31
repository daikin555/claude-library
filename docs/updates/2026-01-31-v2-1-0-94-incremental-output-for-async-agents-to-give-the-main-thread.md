---
title: "非同期エージェントの増分出力を改善 - メインスレッドに制御と可視性を提供"
date: 2026-01-31
tags: ['改善', '非同期エージェント', '増分出力', 'UI']
---

## 原文（日本語に翻訳）

非同期エージェントの増分出力を改善し、メインスレッドにより多くの制御と可視性を提供するようにしました

## 原文（英語）

Improved incremental output for async agents to give the main thread more control and visibility

## 概要

Claude Code v2.1.0で改善された、非同期エージェントの出力表示機能です。以前のバージョンでは、バックグラウンドで動作するエージェント（Taskツール）の出力が完了するまで見えず、進捗が不明でした。この改善により、エージェントの出力がリアルタイムで増分的に表示され、メインスレッドから進行状況を監視したり、必要に応じて介入したりできるようになりました。

## 改善前の動作

### 出力が見えない

```bash
# バックグラウンドエージェントを起動
claude

# Taskツールを使用
> Use Task tool to analyze codebase

# 修正前:
[Agent running in background...]
# ... 5分待機 ...
# ... 何が起きているか不明 ...
# ... 10分待機 ...

# 完了後に一括出力:
Agent output:
Analysis complete. Found 50 files...
[大量の出力]

# 問題点:
# - 途中経過が見えない
# - 問題発生時に気づけない
# - 途中で方向修正できない
```

## 改善後の動作

### リアルタイム増分出力

```bash
# 同じタスク
claude

> Use Task tool to analyze codebase

# 修正後:
[Agent: Starting analysis...]

# リアルタイム出力:
Agent: Reading src/
Agent: Found 10 TypeScript files
Agent: Analyzing components/Header.tsx
Agent: Analyzing components/Footer.tsx
Agent: Analyzing utils/helpers.ts
Agent: Found potential issue in helpers.ts:45
Agent: Checking tests/
Agent: 80% test coverage

# ユーザー介入が可能:
> Ctrl+C (必要に応じて中断)
> または続行を監視

Agent: Analysis complete. Summary:
- 50 files analyzed
- 3 issues found
- 80% test coverage

# ✓ 進行状況がリアルタイムで見える
# ✓ 問題を早期発見
# ✓ 必要に応じて介入可能
```

## 実践例

### 大規模コードベース解析

進捗を監視しながら実行。

```bash
# 数千ファイルの解析
claude "Analyze entire monorepo"

# 増分出力:
[Agent: Starting monorepo analysis...]
Agent: Scanning packages/
Agent: Found 15 packages
Agent: Analyzing package-1/ (1/15)
  → 25 files, 5,000 lines
Agent: Analyzing package-2/ (2/15)
  → 30 files, 8,000 lines
Agent: Found circular dependency in package-3
  → Warning: import cycle detected

# ユーザーが問題に気づく
> Ctrl+C

# 途中で停止して問題を修正
# 修正後に再実行

# ✓ 早期に問題発見
# ✓ 時間を節約
```

### 長時間タスク

進行状況を確認しながら作業。

```bash
# 1時間かかるリファクタリング
claude "Refactor all legacy code"

# リアルタイム出力:
[Agent: Planning refactoring...]
Agent: Identified 200 files to refactor
Agent: Priority 1: Authentication module
Agent: Refactoring auth/login.ts
  → Converting class to hooks
Agent: Running tests for auth module
  ✓ All tests passed
Agent: Priority 2: API clients
Agent: Refactoring api/users.ts
Agent: Refactoring api/posts.ts
Agent: Running integration tests
  ✗ 2 tests failed

# ユーザーが確認
> Let me check those failing tests first

# タスクを一時停止して調査
# 問題を修正後に再開

# ✓ 段階的に進行
# ✓ 問題を即座に対処
```

### 並行エージェント

複数エージェントの出力を統合表示。

```bash
# 3つのエージェントを並行実行
claude "Run tests, build, and deploy in parallel"

# 増分出力（統合表示）:
[Agent-1: Running tests...]
[Agent-2: Building project...]
[Agent-3: Preparing deployment...]

Agent-1: Unit tests: 50/100 passed
Agent-2: Bundling components...
Agent-3: Uploading assets to S3...

Agent-1: Unit tests: 100/100 passed ✓
Agent-2: Build complete (2.5 MB)
Agent-3: Assets uploaded ✓

Agent-1: Integration tests: 20/30 passed
Agent-2: Generating source maps...
Agent-3: Deploying to staging...

# ユーザーが全体の進捗を監視
# 問題があれば即座に気づく

Agent-1: All tests passed ✓
Agent-2: Build artifacts ready ✓
Agent-3: Deployment complete ✓

# ✓ 複数エージェントの状況を同時監視
```

### デバッグ情報の表示

エラー発生時の詳細。

```bash
# エージェントがエラーに遭遇
claude "Complex task with potential issues"

# 増分出力:
[Agent: Processing data...]
Agent: Reading config.json
Agent: Validating schema
Agent: Error: Invalid field 'apiKey'
  → Expected: string
  → Got: undefined

# デバッグ情報が即座に表示
Agent: Stack trace:
  at validateConfig (config.ts:45)
  at main (index.ts:12)

# ユーザーがエラーを確認
> Ah, I see the issue. Let me fix config.json

# 即座に修正して再実行

# ✓ エラーを即座に発見
# ✓ デバッグ情報が詳細
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 増分出力の仕組み:
  - エージェントの出力をバッファリング
  - 行単位で即座にメインスレッドに送信
  - ユーザーに表示
- 表示方式:
  - **リアルタイムストリーミング**: 出力が生成されるとすぐに表示
  - **プレフィックス付き**: `Agent:` や `[Agent-1:]` で識別
  - **色分け**: 異なるエージェントを色で区別
- メインスレッドの制御:
  - **監視**: 進行状況をリアルタイムで確認
  - **介入**: Ctrl+Cでエージェントを停止
  - **ログ記録**: すべての出力を自動保存
- 複数エージェントの管理:
  ```bash
  # 出力例:
  [Agent-1: Testing...]
  [Agent-2: Building...]
  [Agent-1: Tests passed]
  [Agent-3: Deploying...]
  [Agent-2: Build complete]
  [Agent-3: Deploy complete]
  ```
- 出力のバッファリング:
  - 行単位でバッファリング
  - 完全な行のみ表示（部分的な行は次の更新まで待機）
  - 最大遅延: 100ms
- パフォーマンス:
  - 出力量が多い場合でも UI がブロックされない
  - 大量の出力は自動的にスロットリング
- ログファイル:
  ```bash
  # エージェント出力は自動保存
  ~/.claude/logs/agent-YYYYMMDD-HHMMSS.log

  # 後で確認可能
  cat ~/.claude/logs/agent-20260131-143000.log
  ```
- 出力のフィルタリング:
  ```bash
  # デバッグ出力のみ表示
  claude --log-level debug "Task"

  # エラーのみ表示
  claude --log-level error "Task"
  ```
- 非対話モード:
  ```bash
  # CI/CDでの使用
  claude --non-interactive "Task"
  # 増分出力は標準出力に送信
  # パイプやリダイレクトが可能
  ```
- エージェント出力の制御:
  ```bash
  # 設定ファイル
  # ~/.claude/settings.json
  {
    "agentOutput": {
      "incremental": true,  # 増分出力を有効化
      "showTimestamps": true,  # タイムスタンプを表示
      "colorize": true  # 色分けを有効化
    }
  }
  ```
- デバッグ:
  ```bash
  claude --debug "Task with agents"

  # 詳細な出力:
  # [12:34:56] [Agent-1] Starting...
  # [12:34:57] [Agent-1] Processing file 1/10
  # [12:34:58] [Agent-1] Processing file 2/10
  ```
- 関連する改善:
  - index 89: スキル実行中の進捗表示
  - index 93: バックグラウンドエージェントのトークンカウント

## 関連情報

- [Async agents - Claude Code Docs](https://code.claude.com/docs/en/agents#async)
- [Task tool](https://code.claude.com/docs/en/tools#task)
- [Output streaming](https://code.claude.com/docs/en/output-streaming)
