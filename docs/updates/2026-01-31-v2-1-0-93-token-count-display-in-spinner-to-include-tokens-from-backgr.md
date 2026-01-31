---
title: "スピナーのトークンカウント表示にバックグラウンドエージェントのトークンを含めるよう改善"
date: 2026-01-31
tags: ['改善', 'トークンカウント', 'スピナー', 'バックグラウンドエージェント']
---

## 原文（日本語に翻訳）

スピナーのトークンカウント表示にバックグラウンドエージェントのトークンを含めるよう改善しました

## 原文（英語）

Improved token count display in spinner to include tokens from background agents

## 概要

Claude Code v2.1.0で改善された、トークン使用量表示機能です。以前のバージョンでは、Taskツールなどで起動したバックグラウンドエージェントが使用したトークンがスピナーのカウント表示に含まれず、実際のトークン使用量と表示が一致しませんでした。この改善により、すべてのエージェント（メインスレッドとバックグラウンド）のトークン使用量が正確に表示され、コスト管理がしやすくなりました。

## 改善前の動作

### 不正確なトークンカウント

```bash
# バックグラウンドエージェントを使用
claude "Analyze entire codebase using background agents"

# 修正前のスピナー表示:
⠋ Processing... [2,500 tokens]
# ↑ メインスレッドのトークンのみ

# 実際の使用量:
# - メインスレッド: 2,500 tokens
# - バックグラウンドエージェント1: 5,000 tokens
# - バックグラウンドエージェント2: 3,000 tokens
# 合計: 10,500 tokens

# 問題点:
# - 表示: 2,500 tokens
# - 実際: 10,500 tokens
# - 4倍以上の差！
```

## 改善後の動作

### 正確なトークンカウント

```bash
# 同じタスク
claude "Analyze entire codebase using background agents"

# 修正後のスピナー表示:
⠋ Processing... [2,500 tokens]
⠙ Processing... [5,800 tokens] (+3,300 from agents)
⠹ Processing... [8,200 tokens] (+5,700 from agents)
⠸ Processing... [10,500 tokens] (+8,000 from agents)

# ✓ すべてのトークンが表示される
# ✓ バックグラウンドエージェントの貢献が分かる
# ✓ 正確なコスト見積もりが可能
```

## 実践例

### コードベース解析タスク

複数のエージェントが並行動作。

```bash
# 大規模解析タスク
claude "Use multiple agents to analyze this project"

# スピナー表示の推移:
⠋ Starting analysis... [500 tokens]

# エージェント1が起動
⠙ Analyzing... [500 tokens]

# エージェント1が作業開始
⠹ Analyzing... [2,000 tokens] (+1,500 from agent-1)

# エージェント2も起動
⠸ Analyzing... [2,500 tokens] (+2,000 from agents)

# 両方のエージェントが作業中
⠼ Analyzing... [6,000 tokens] (+5,500 from agents)

# エージェント1完了、エージェント2継続
⠴ Analyzing... [8,500 tokens] (+8,000 from agents)

# すべて完了
✓ Analysis complete [12,000 tokens total]
  - Main thread: 4,000 tokens
  - Background agents: 8,000 tokens

# ✓ 詳細な内訳が分かる
```

### 並行テスト実行

複数のテストを同時実行。

```bash
# 並行テスト
claude "Run all test suites in parallel"

# リアルタイムトークン表示:
⠋ Starting tests... [200 tokens]
⠙ Running unit tests... [1,000 tokens] (+800 from test-agent-1)
⠹ Running integration tests... [2,500 tokens] (+2,300 from agents)
⠸ Running e2e tests... [5,000 tokens] (+4,800 from agents)
⠼ Collecting results... [7,500 tokens] (+7,300 from agents)

✓ All tests passed [8,000 tokens total]

# ✓ 各エージェントの消費が追跡される
```

### リファクタリングタスク

複数ファイルを並行処理。

```bash
# 大規模リファクタリング
claude "Refactor all components in parallel"

# トークン表示:
⠋ Planning refactoring... [800 tokens]
⠙ Refactoring components... [3,000 tokens] (+2,200 from agents)
⠹ Updating tests... [6,500 tokens] (+5,700 from agents)
⠸ Running tests... [9,000 tokens] (+8,200 from agents)
⠼ Finalizing... [12,000 tokens] (+11,200 from agents)

✓ Refactoring complete [15,000 tokens total]
  - Main coordination: 3,800 tokens
  - 5 parallel agents: 11,200 tokens

# ✓ エージェント数とトークン使用量が明確
```

### コスト管理

トークン上限の監視。

```bash
# トークン上限を設定
claude --max-tokens 50000 "Complex multi-agent task"

# リアルタイム監視:
⠋ Processing... [1,000 tokens] (2% of limit)
⠙ Processing... [5,000 tokens] (10% of limit)
⠹ Processing... [15,000 tokens] (30% of limit) (+13,000 from agents)
⠸ Processing... [30,000 tokens] (60% of limit) (+27,000 from agents)
⠼ Processing... [45,000 tokens] (90% of limit) (+41,000 from agents)

Warning: Approaching token limit (90%)

✓ Task complete [48,000 tokens] (96% of limit)

# ✓ 上限超過を事前に防げる
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 表示される情報:
  - **総トークン数**: メイン + すべてのバックグラウンドエージェント
  - **エージェントのトークン**: `(+X from agents)` 形式で表示
  - **パーセンテージ**: トークン上限に対する割合（設定時）
- トークンカウントの内訳:
  ```bash
  # 表示例:
  [12,500 tokens] (+9,000 from agents)

  内訳:
  - メインスレッド: 3,500 tokens
  - バックグラウンドエージェント: 9,000 tokens
  - 合計: 12,500 tokens
  ```
- リアルタイム更新:
  - バックグラウンドエージェントの進行に応じて自動更新
  - 更新頻度: 1秒ごと
  - スピナーと同期して表示
- バックグラウンドエージェントの種類:
  - Taskツールで起動したエージェント
  - 並行実行される複数のサブエージェント
  - 非同期で動作するすべてのエージェント
- トークン上限の設定:
  ```bash
  # コマンドラインで設定
  claude --max-tokens 100000 "Task"

  # 設定ファイル
  # ~/.claude/settings.json
  {
    "maxTokens": 100000,
    "warnAt": 0.8  # 80%で警告
  }
  ```
- コスト計算:
  ```bash
  # トークン単価（例: Sonnet 4.5）
  # Input: $3 / 1M tokens
  # Output: $15 / 1M tokens

  # 表示例:
  [50,000 tokens]
  Estimated cost: $0.15 (input) + $0.75 (output) = $0.90
  ```
- 詳細ログ:
  ```bash
  claude --debug "Task with agents"

  # デバッグ出力:
  # [DEBUG] Main thread tokens: 2,000
  # [DEBUG] Agent-1 tokens: 3,500
  # [DEBUG] Agent-2 tokens: 4,200
  # [DEBUG] Total: 9,700 tokens
  ```
- エージェント別の内訳:
  ```bash
  # タスク完了後の詳細:
  ✓ Task complete [25,000 tokens total]
    Main thread:        5,000 tokens (20%)
    agent-1 (explore):  8,000 tokens (32%)
    agent-2 (refactor): 7,000 tokens (28%)
    agent-3 (test):     5,000 tokens (20%)
  ```
- トークンの種類:
  - **Input tokens**: リクエストに含まれるトークン
  - **Output tokens**: Claudeの応答トークン
  - 両方が合計に含まれる
- パフォーマンス:
  - トークンカウント表示のオーバーヘッドは最小限
  - エージェント数が多くても影響なし
- 関連する改善:
  - index 92: スピナーフィードバックの改善
  - index 94: 非同期エージェントの増分出力

## 関連情報

- [Token usage - Claude Code Docs](https://code.claude.com/docs/en/tokens)
- [Background agents](https://code.claude.com/docs/en/agents#background)
- [Cost management](https://code.claude.com/docs/en/cost-management)
