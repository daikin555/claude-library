---
title: "バックグラウンドBashタスク詳細に完全出力ファイルパスを表示"
date: 2026-01-31
tags: ['改善', 'bash', 'バックグラウンドタスク']
---

## 原文（日本語に翻訳）

バックグラウンドBashタスク詳細ダイアログに完全出力へのファイルパスを追加しました

## 原文（英語）

Added filepath to full output in background bash task details dialog

## 概要

Claude Code v2.1.0で導入された、バックグラウンドタスクのデバッグ支援機能です。バックグラウンドで実行中のBashタスクの詳細ダイアログに、タスクの完全な出力が保存されているファイルパスが表示されるようになりました。これにより、ダイアログで切り詰められた出力を外部ツール（`less`、`grep`、エディタなど）で確認でき、長時間実行タスクの詳細なログ分析が容易になります。

## 基本的な使い方

バックグラウンドタスクの詳細ダイアログで、出力ファイルパスを確認します。

```bash
# タスクをバックグラウンド実行
> npm test
# Ctrl+B でバックグラウンド化

# バックグラウンドタスク一覧を表示
Ctrl+B

# タスクを選択してEnter
# 詳細ダイアログが表示される

# [Details] タブに以下が表示:
Task ID: bash-12345
Command: npm test
Started: 2026-01-31 10:30:15
Status: Running
Output file: /tmp/claude-task-bash-12345.log
```

## 実践例

### 長時間実行タスクのログを外部で確認

ダイアログでは一部しか表示されないログを、ファイルから全文確認します。

```bash
# 長時間実行されるビルドタスク
> npm run build
# Ctrl+B

# 別のターミナルを開く
# 詳細ダイアログから出力ファイルパスをコピー
# Output file: /tmp/claude-task-bash-67890.log

# 別のターミナルで確認
tail -f /tmp/claude-task-bash-67890.log

# またはlessで確認
less /tmp/claude-task-bash-67890.log
```

### ログをgrepで検索

エラーや警告を素早く検索します。

```bash
# テストスイート実行中
> npm test
# Ctrl+B

# 詳細ダイアログで出力ファイルパスを確認
# Output file: /tmp/claude-task-bash-11111.log

# 別のターミナルでエラー検索
grep -i error /tmp/claude-task-bash-11111.log

# 警告も検索
grep -E "(error|warning)" /tmp/claude-task-bash-11111.log
```

### エディタで出力を開く

VSCodeや好みのエディタでログを開いて分析します。

```bash
# タスク実行中
> ./run-integration-tests.sh
# Ctrl+B

# ファイルパスを確認
# Output file: /tmp/claude-task-bash-22222.log

# VSCodeで開く
code /tmp/claude-task-bash-22222.log

# またはvimで開く
vim /tmp/claude-task-bash-22222.log
```

### 出力ファイルを保存・共有

タスク完了後、ログファイルを永続的な場所にコピーします。

```bash
# デプロイタスク実行
> ./deploy.sh production
# Ctrl+B

# 完了後、ログファイルパスを確認
# Output file: /tmp/claude-task-bash-33333.log

# ログを保存
cp /tmp/claude-task-bash-33333.log ~/logs/deploy-$(date +%Y%m%d-%H%M%S).log

# またはGitに含めて共有
cp /tmp/claude-task-bash-33333.log ./deploy-logs/production-deploy.log
git add deploy-logs/production-deploy.log
git commit -m "Add deployment log"
```

### リアルタイムで進捗を追跡

`tail -f`でタスクの進捗をリアルタイム監視します。

```bash
# 長時間タスク開始
> python train_model.py
# Ctrl+B

# 別のターミナルでリアルタイム監視
tail -f /tmp/claude-task-bash-44444.log | grep "Epoch"

# 進捗が表示される:
# Epoch 1/100 - Loss: 0.543
# Epoch 2/100 - Loss: 0.521
# Epoch 3/100 - Loss: 0.498
# ...
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- 出力ファイルの場所:
  - デフォルト: `/tmp/claude-task-bash-{task-id}.log`
  - 環境変数 `TMPDIR` で変更可能
  - Windows: `%TEMP%\claude-task-bash-{task-id}.log`
- ファイルの内容:
  - タスクの標準出力（stdout）と標準エラー出力（stderr）が含まれる
  - リアルタイムで書き込まれる（バッファリングなし）
  - タスク完了後も保持される
- ファイルの削除:
  - タスク完了後、一定時間（通常24時間）経過で自動削除
  - 手動削除も可能: `rm /tmp/claude-task-bash-*.log`
  - Claude Code終了時には自動削除されない
- ファイルパスの表示場所:
  - バックグラウンドタスク詳細ダイアログの `[Details]` タブ
  - `Output file:` フィールド
  - パスはコピー可能（選択してCmd+C / Ctrl+C）
- セキュリティ:
  - 出力ファイルは通常のファイルパーミッション（644）で作成
  - 機密情報を含むコマンド出力には注意
  - 他のユーザーから読み取り可能な場合がある
- ダイアログでの出力表示:
  - ダイアログの `[Output]` タブには最新の数千行のみ表示
  - 完全な出力を見るには、ファイルパスから直接アクセス
- 複数タスクの管理:
  - 各タスクに独自の出力ファイル
  - タスクIDがファイル名に含まれる
  - `ls /tmp/claude-task-bash-*.log` で一覧表示
- ログローテーション:
  - 出力ファイルは自動的にローテーションされない
  - 大量のログが生成される場合、手動で管理が必要
- 関連するタスクタイプ:
  - この機能はBashタスクのみ対応
  - エージェントタスクには別の出力ファイルパスが表示される場合がある

## 関連情報

- [Background tasks - Claude Code Docs](https://code.claude.com/docs/en/background-tasks)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
- [Debugging long-running tasks](https://code.claude.com/docs/en/debugging-tasks)
