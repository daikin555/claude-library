---
title: "最初の応答トークン待機時のスピナーフィードバックを改善"
date: 2026-01-31
tags: ['改善', 'UI', 'スピナー', 'フィードバック']
---

## 原文（日本語に翻訳）

最初の応答トークン待機時のスピナーフィードバックを改善しました

## 原文（英語）

Improved spinner feedback when waiting for the first response token

## 概要

Claude Code v2.1.0で改善された、応答待機時のスピナー表示機能です。以前のバージョンでは、リクエストを送信してからClaudeの最初の応答が返ってくるまで、何も表示されず不安を感じることがありました。この改善により、待機中に分かりやすいスピナーとステータスメッセージが表示され、現在の処理状況を把握できるようになりました。

## 改善前の動作

### 無応答状態

```bash
claude "Analyze this large codebase"

# 修正前:
# ... 無反応 ...
# 5秒経過
# ... まだ無反応 ...
# 10秒経過
# ... フリーズ？ ...

# 問題点:
# - 処理中か不明
# - フリーズとの区別がつかない
# - 不安感
```

## 改善後の動作

### 明確なフィードバック

```bash
claude "Analyze this large codebase"

# 修正後:
⠋ Waiting for Claude's response...
# 3秒経過
⠙ Waiting for Claude's response...
# 5秒経過
⠹ Waiting for Claude's response...
# 8秒経過
⠸ Processing your request...

# Claude's response:
I'll analyze the codebase...

# ✓ 処理中であることが明確
# ✓ 進行状況が見える
# ✓ 安心して待てる
```

## 実践例

### 大規模コードベース解析

長時間かかる処理。

```bash
claude "Analyze entire project structure"

# スピナー表示:
⠋ Waiting for Claude's response...
⠙ Waiting for Claude's response...
⠹ Waiting for Claude's response...
⠸ Waiting for Claude's response...
⠼ Processing (5s)...
⠴ Processing (10s)...
⠦ Processing (15s)...
⠧ Analyzing codebase...

# ✓ 時間経過が分かる
# ✓ 処理が進行中であることが明確
```

### 複雑な質問

思考時間が長いリクエスト。

```bash
claude "Design a distributed architecture for high-traffic system"

# スピナー表示:
⠋ Waiting for Claude's response...
⠙ Thinking...
⠹ Thinking...
⠸ Thinking...
⠼ Analyzing requirements...
⠴ Designing architecture...
⠦ Preparing response...

# Claude's detailed response...

# ✓ 各段階が見える
```

### Web検索を含むリクエスト

外部APIアクセスが必要な場合。

```bash
claude "Search for latest React best practices"

# スピナー表示:
⠋ Waiting for Claude's response...
⠙ Preparing web search...
⠹ Searching...
⠸ Processing results...
⠼ Analyzing sources...

# Claude's response with sources...

# ✓ 各ステップが明確
```

### ネットワーク遅延時

接続が遅い環境。

```bash
# 遅いネットワーク
claude "Generate documentation"

# スピナー表示:
⠋ Waiting for Claude's response...
⠙ Waiting for Claude's response...
⠹ Waiting for Claude's response...
# ... 20秒経過 ...
⠸ Waiting for Claude's response... (20s)
⠼ Waiting for Claude's response... (25s)
⠴ Connection slow, still waiting... (30s)

# Claude's response arrives...

# ✓ ネットワーク遅延が明確
# ✓ タイムアウトまでの時間が分かる
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- スピナーの種類:
  - **アニメーション**: 回転するスピナー（⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏）
  - **ステータステキスト**: 現在の処理内容
  - **経過時間**: 5秒以降に秒数を表示
- 表示されるメッセージ:
  - `Waiting for Claude's response...` - 初期待機
  - `Processing your request...` - リクエスト処理中
  - `Thinking...` - Claude思考中
  - `Analyzing...` - 解析中
  - `Connection slow...` - ネットワーク遅延検知
- 経過時間の表示:
  - 0-5秒: メッセージのみ
  - 5秒以降: 秒数を括弧内に表示（例: `(10s)`）
  - 30秒以降: 遅延警告メッセージ
  - 60秒でタイムアウト（設定可能）
- タイムアウト設定:
  ```bash
  # デフォルト: 60秒
  claude --timeout 120 "Long running task"

  # 無制限
  claude --timeout 0 "Very long task"
  ```
- キャンセル:
  - Ctrl+C でいつでも中断可能
  - スピナー表示中も反応する
- デバッグモード:
  ```bash
  claude --debug "Your request"

  # 詳細な待機情報を表示:
  # [DEBUG] Request sent at 12:34:56
  # [DEBUG] Waiting for response (2s)
  # [DEBUG] Waiting for response (5s)
  # [DEBUG] First token received at 12:35:03 (7s)
  ```
- 非対話モード:
  ```bash
  claude --non-interactive "Task"
  # スピナーは表示されず、ログのみ出力
  ```
- パフォーマンス:
  - スピナー表示のオーバーヘッドは最小限
  - CPUリソースをほとんど使用しない
- ターミナル互換性:
  - ほとんどのターミナルでスピナーアニメーション対応
  - 非対応の場合はシンプルなドットアニメーション（...）に自動切り替え
- CI/CD環境:
  - CIでは自動的にスピナーを無効化
  - 代わりにログメッセージを出力
- カスタマイズ:
  ```bash
  # ~/.claude/settings.json
  {
    "spinner": {
      "style": "dots",  # dots, line, star など
      "showElapsedTime": true,
      "slowConnectionThreshold": 30  # 秒
    }
  }
  ```
- 関連する改善:
  - index 89: スキル実行中の進捗表示
  - index 93: トークンカウント表示の改善

## 関連情報

- [UI feedback - Claude Code Docs](https://code.claude.com/docs/en/ui#feedback)
- [Spinner customization](https://code.claude.com/docs/en/settings#spinner)
- [Timeout configuration](https://code.claude.com/docs/en/settings#timeout)
