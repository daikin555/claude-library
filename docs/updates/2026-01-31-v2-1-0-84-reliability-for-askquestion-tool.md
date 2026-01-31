---
title: "AskQuestionツールの信頼性を改善"
date: 2026-01-31
tags: ['改善', 'AskQuestion', 'ツール', '対話']
---

## 原文（日本語に翻訳）

AskQuestionツールの信頼性を改善しました

## 原文（英語）

Improved reliability for AskQuestion tool

## 概要

Claude Code v2.1.0で改善された、AskQuestionツールの安定性向上です。以前のバージョンでは、Claudeがユーザーに質問を投げかける際、質問が表示されなかったり、回答が正しく処理されなかったり、UIがフリーズするなどの問題が発生することがありました。この改善により、Claudeとユーザーの対話がスムーズになり、より複雑なタスクを安全に実行できるようになりました。

## 改善前の問題

### 質問が表示されない

```bash
# Claudeが質問しようとする
claude "Deploy to production"

# 修正前:
# - 質問が表示されずにスタック
# - タイムアウト
# - 処理が中断
```

### 回答が処理されない

```bash
# 質問に回答
> Which environment? [staging/production]
> production

# 修正前:
# - 回答が無視される
# - Claudeが再度同じ質問をする
# - 無限ループ
```

### UIのフリーズ

```bash
# 複数の質問
claude "Complex task with multiple decisions"

# 修正前:
# - 1つ目の質問後にフリーズ
# - Ctrl+Cも効かない
# - 強制終了が必要
```

## 改善後の動作

### 確実な質問表示

```bash
# デプロイタスク
claude "Deploy application"

# Claude: Which environment should I deploy to?
#   1. staging (Recommended)
#   2. production
#
# Your choice: _

# ✓ 質問が確実に表示される
# ✓ 選択肢が明確
```

### 正確な回答処理

```bash
# 回答を入力
Your choice: 1

# Claude: Deploying to staging...
# ✓ Done

# ✓ 回答が確実に処理される
# ✓ 次のステップに進む
```

## 実践例

### デプロイ確認

本番環境へのデプロイ前に確認。

```bash
claude "Deploy to production"

# Claude: This will deploy to PRODUCTION. Are you sure?
#   1. Yes, proceed (BE CAREFUL)
#   2. No, cancel
#
# Your choice: 2

# Claude: Deployment cancelled.

# ✓ 安全な確認プロセス
```

### 設定選択

複数の設定オプションから選択。

```bash
claude "Set up database"

# Claude: Which database should I use?
#   1. PostgreSQL (Recommended for production)
#   2. MySQL (Good for compatibility)
#   3. SQLite (For development only)
#
# Your choice: 1

# Claude: Configuring PostgreSQL...

# ✓ スムーズな設定フロー
```

### 段階的な意思決定

複数ステップのタスクで各段階で確認。

```bash
claude "Refactor authentication system"

# Step 1:
# Claude: Which auth method?
#   1. JWT
#   2. Session-based
# Your choice: 1

# Step 2:
# Claude: Where to store tokens?
#   1. LocalStorage
#   2. Cookie (Recommended)
# Your choice: 2

# Step 3:
# Claude: Enable refresh tokens?
#   1. Yes (Recommended)
#   2. No
# Your choice: 1

# ✓ 各質問が確実に処理される
# ✓ スムーズなワークフロー
```

### エラーリカバリー

無効な回答に対する適切な処理。

```bash
claude "Choose deployment target"

# Claude: Which environment?
#   1. dev
#   2. staging
#   3. production
# Your choice: 5

# Claude: Invalid choice. Please select 1-3.
# Your choice: 2

# Claude: Deploying to staging...

# ✓ エラーハンドリングが改善
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 改善された動作:
  - **質問の確実な表示**: UIレンダリングの最適化
  - **回答の正確な処理**: 入力パーサーの改善
  - **エラーハンドリング**: 無効な入力への対応
  - **タイムアウト処理**: 適切なタイムアウト設定
  - **マルチステップ**: 複数質問の安定動作
- AskQuestionツールの使用場面:
  - 重要な操作の確認（デプロイ、削除など）
  - 設定オプションの選択
  - パラメータの入力
  - ファイル選択
  - 実行方法の決定
- 質問の種類:
  - **単一選択**: ラジオボタン形式
  - **複数選択**: チェックボックス形式
  - **テキスト入力**: フリーテキスト
  - **確認**: Yes/No
- キーボード操作:
  - **↑/↓**: 選択肢の移動
  - **Space**: 選択（複数選択時）
  - **Enter**: 確定
  - **Esc**: キャンセル（可能な場合）
- 非対話モード:
  - `--yes` フラグですべての質問に "Yes" を自動回答
  - CI/CDで有用
  - 注意: 危険な操作も自動承認される
  ```bash
  claude --yes "Deploy to production"
  # すべての確認をスキップ
  ```
- デバッグ:
  - `--debug` フラグで質問と回答のログを確認
- トラブルシューティング:
  - 質問が表示されない: ターミナルの対話モード対応を確認
  - 回答が無視される: 有効な選択肢を入力しているか確認
  - フリーズ: Ctrl+Cでキャンセル、v2.1.0にアップグレード

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Tools - AskUserQuestion](https://code.claude.com/docs/en/tools#askuserquestion)
