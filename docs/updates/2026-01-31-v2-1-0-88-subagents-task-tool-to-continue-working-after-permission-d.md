---
title: "パーミッション拒否後もサブエージェントが代替アプローチを試行できるよう改善"
date: 2026-01-31
tags: ['改善', 'サブエージェント', 'パーミッション', 'Task']
---

## 原文（日本語に翻訳）

サブエージェント（Taskツール）がパーミッション拒否後も作業を継続し、代替アプローチを試行できるよう改善しました

## 原文（英語）

Improved subagents (Task tool) to continue working after permission denial, allowing them to try alternative approaches

## 概要

Claude Code v2.1.0で改善された、サブエージェントの柔軟な実行機能です。以前のバージョンでは、Taskツールで起動したサブエージェントがパーミッションを要求し、ユーザーが拒否すると、サブエージェントはエラーで停止していました。この改善により、パーミッション拒否後もサブエージェントが別の方法を試行できるようになり、より柔軟なタスク実行が可能になりました。

## 改善前の動作

### パーミッション拒否で停止

```bash
# サブエージェントを起動
claude

> Use Task tool to analyze codebase

# サブエージェントが危険なコマンドを実行しようとする
Subagent: Execute `rm -rf node_modules`?
[Deny]

# 修正前:
Error: Permission denied
Subagent terminated
Task failed

# タスク全体が失敗
```

## 改善後の動作

### 代替アプローチを試行

```bash
# サブエージェントを起動
claude

> Use Task tool to analyze codebase

# サブエージェントが危険なコマンドを実行しようとする
Subagent: Execute `rm -rf node_modules`?
[Deny]

# 修正後:
Subagent: Permission denied for rm command
Subagent: Trying alternative approach...
Subagent: Using safer method: analyzing package.json instead

# ✓ タスク継続
# ✓ 代替方法で完了
```

## 実践例

### コードベース解析

危険な操作を避けながら解析。

```bash
# タスク: コードベース全体を解析
claude "Analyze entire project"

# サブエージェント起動
# 1. すべてのファイルを読み込もうとする
Subagent: Read 10,000 files?
[Deny]  # ファイル数が多すぎる

# 修正後: 代替アプローチ
Subagent: Switching to sampling approach
Subagent: Analyzing 100 representative files
✓ Analysis complete

# ✓ より安全な方法で完了
```

### データベース操作

本番DBへの直接操作を回避。

```bash
# タスク: データベーススキーマを確認
claude "Check database schema"

# サブエージェント
Subagent: Connect to production database?
[Deny]  # 本番環境は危険

# 修正後:
Subagent: Checking local schema files instead
Subagent: Reading migrations/*.sql
✓ Schema documented

# ✓ 本番に触れずに完了
```

### ファイル削除タスク

安全な代替手段を提案。

```bash
# タスク: 不要なファイルをクリーンアップ
claude "Clean up temp files"

# サブエージェント
Subagent: Execute `find / -name "*.tmp" -delete`?
[Deny]  # ルートディレクトリは危険

# 修正後:
Subagent: Limiting scope to current project
Subagent: `find . -name "*.tmp" -delete`
[Approve]
✓ Cleanup complete

# ✓ より安全なスコープで実行
```

### ネットワーク操作

外部接続を避ける。

```bash
# タスク: APIエンドポイントをテスト
claude "Test API endpoints"

# サブエージェント
Subagent: Send requests to production API?
[Deny]  # 本番APIは避けたい

# 修正後:
Subagent: Using mock server instead
Subagent: Testing with local data
✓ Tests passed

# ✓ 本番に影響なし
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 代替アプローチの例:
  - **ファイル操作**: 大量読み込み → サンプリング
  - **コマンド実行**: 危険なコマンド → 安全な代替コマンド
  - **ネットワーク**: 本番環境 → ローカル/モック
  - **データベース**: 直接接続 → スキーマファイル読み込み
- サブエージェントの判断:
  - パーミッション拒否を検知
  - タスクの目的を再評価
  - 代替手段を探索
  - より安全な方法を提案
- ユーザーの制御:
  - 代替アプローチも承認が必要
  - いつでもタスクを中断可能
  - Ctrl+Cでサブエージェント停止
- 失敗するケース:
  - 代替手段が見つからない場合
  - すべての方法が拒否された場合
  - タスクが本質的に危険な場合
- デバッグ:
  - `--debug` フラグで代替アプローチの詳細を確認
  - サブエージェントの思考プロセスを表示
- セキュリティ:
  - 代替アプローチも同じパーミッションルールに従う
  - 拒否された操作を迂回することはない
  - より安全な方法のみ提案

## 関連情報

- [Task tool - Claude Code Docs](https://code.claude.com/docs/en/tools#task)
- [Permissions](https://code.claude.com/docs/en/permissions)
- [Subagents](https://code.claude.com/docs/en/agents)
