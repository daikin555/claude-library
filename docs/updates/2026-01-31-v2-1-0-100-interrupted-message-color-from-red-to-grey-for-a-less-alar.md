---
title: "「中断」メッセージの色を赤からグレーに変更 - 警告感を軽減"
date: 2026-01-31
tags: ['変更', 'UI', '色', 'UX']
---

## 原文（日本語に翻訳）

「Interrupted（中断）」メッセージの色を赤からグレーに変更し、警告感を軽減しました

## 原文（英語）

Changed "Interrupted" message color from red to grey for a less alarming appearance

## 概要

Claude Code v2.1.0で変更された、タスク中断メッセージの表示色です。以前のバージョンでは、ユーザーがCtrl+Cでタスクを中断すると、赤色で「Interrupted」メッセージが表示され、エラーと誤解されやすい問題がありました。この変更により、メッセージ色がグレーになり、意図的な中断であることが明確になり、不要な警告感がなくなりました。

## 変更前の動作

### 赤色の警告的表示

```bash
# タスクを実行中
claude "Analyze large codebase"

# Ctrl+C で中断
^C

# 変更前:
❌ Interrupted  # 赤色で表示

# 問題点:
# - エラーと誤解しやすい
# - 警告的に見える
# - 意図的な操作なのに不安感
```

## 変更後の動作

### グレーの中立的表示

```bash
# 同じ操作
claude "Analyze large codebase"

# Ctrl+C で中断
^C

# 変更後:
⏸  Interrupted  # グレー色で表示

# ✓ 中立的な印象
# ✓ エラーではないと明確
# ✓ 意図的な中断と分かる
```

## 実践例

### 長時間タスクの中断

意図的にタスクを停止。

```bash
# 時間がかかるタスク
claude "Generate documentation for entire project"

# 5分後、他の作業が必要になった
^C

# 変更後の表示:
⏸  Interrupted  # グレー（落ち着いた表示）

# 以前の進捗は保存されている
# 必要に応じて後で再開可能

# ✓ エラーではなく意図的な中断と分かる
```

### エラーとの区別

エラーと中断が明確に区別される。

```bash
# タスク1: エラーが発生
claude "Invalid command"

❌ Error: Command not found  # 赤色（エラー）

# タスク2: ユーザーが中断
claude "Long running task"
^C

⏸  Interrupted  # グレー（中断）

# ✓ 色で状況が明確に区別できる
```

### 複数タスクの中断

複数のタスクを順次中断。

```bash
# バックグラウンドエージェント起動
claude "Run multiple analysis tasks"

# 各タスクを確認しながら中断
Task 1 running...
^C
⏸  Interrupted (Task 1)  # グレー

Task 2 running...
^C
⏸  Interrupted (Task 2)  # グレー

# ✓ 落ち着いて操作できる
# ✓ パニックにならない
```

### デバッグ中の中断

デバッグ時に頻繁に中断。

```bash
# デバッグ実行
claude "Debug authentication flow"

# 問題箇所で中断
^C
⏸  Interrupted at line 45  # グレー

# コードを修正
# 再実行
claude "Debug authentication flow"

^C
⏸  Interrupted at line 52  # グレー

# ✓ 中断が日常的な操作として自然
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で変更
- 色の変更:
  - **変更前**: 赤色（`#FF0000`系）
  - **変更後**: グレー（`#808080`系）
  - エラーは引き続き赤色を使用
- アイコンの変更:
  - **変更前**: ❌（クロスマーク）
  - **変更後**: ⏸（一時停止マーク）
  - より中断を表すアイコン
- メッセージの種類と色:
  ```bash
  # エラー（赤色）
  ❌ Error: File not found

  # 警告（黄色）
  ⚠️  Warning: Deprecated feature

  # 中断（グレー）
  ⏸  Interrupted

  # 成功（緑色）
  ✓ Task completed

  # 情報（青色）
  ℹ️  Processing...
  ```
- 中断の種類:
  - **Ctrl+C**: ユーザーによる手動中断（グレー）
  - **タイムアウト**: 自動中断（黄色の警告）
  - **エラー**: 異常終了（赤色のエラー）
- ターミナル互換性:
  - ほとんどのターミナルで色が正しく表示
  - 色対応していない環境では記号のみ表示
- カスタマイズ:
  ```bash
  # ~/.claude/settings.json
  {
    "ui": {
      "colors": {
        "interrupted": "grey",  # デフォルト
        "error": "red",
        "warning": "yellow",
        "success": "green"
      }
    }
  }
  ```
- 色覚対応:
  - 色だけでなくアイコンでも区別可能
  - 色覚異常のユーザーにも分かりやすい
- ログファイル:
  ```bash
  # ログでは色なしのテキスト
  cat ~/.claude/logs/session.log
  # [12:34:56] Interrupted
  # [12:35:10] Error: ...
  ```
- 非対話モード:
  ```bash
  # CI/CDでは色なし
  claude --non-interactive "Task"
  # Interrupted（色なし）
  ```
- 関連する色の統一:
  - 中断（Interrupted）: グレー
  - キャンセル（Cancelled）: グレー
  - スキップ（Skipped）: グレー
  - すべて意図的な操作は中立的な色
- デバッグモード:
  ```bash
  claude --debug

  # 詳細情報も表示:
  ⏸  Interrupted (signal: SIGINT, time: 12:34:56)
  ```
- 以前のバージョンとの違い:
  - v2.0.x: 赤色の ❌ Interrupted
  - v2.1.0: グレーの ⏸  Interrupted
- UX向上の理由:
  - ユーザーテストで赤色が不安を引き起こすと判明
  - 中断は正常な操作であることを強調
  - エラーとの混同を防止

## 関連情報

- [UI colors - Claude Code Docs](https://code.claude.com/docs/en/ui#colors)
- [Task interruption](https://code.claude.com/docs/en/tasks#interruption)
- [Accessibility](https://code.claude.com/docs/en/accessibility)
