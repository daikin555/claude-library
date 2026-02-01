---
title: "バックグラウンドタスクの大量出力によるAPIコンテキストオーバーフローを修正"
date: 2026-01-31
tags: ['バグ修正', 'バックグラウンドタスク', 'パフォーマンス']
---

## 原文（日本語に翻訳）

バックグラウンドタスクが大量の出力を生成した場合のAPIコンテキストオーバーフローを、30K文字に切り詰めてファイルパス参照を追加することで修正しました

## 原文（英語）

Fixed API context overflow when background tasks produce large output by truncating to 30K chars with file path reference

## 概要

Claude Code v2.1.0で修正された、バックグラウンドタスクの大量出力処理バグです。以前のバージョンでは、バックグラウンドで実行されたコマンドが大量の出力（ログ、テスト結果など）を生成すると、その全文がAPIリクエストのコンテキストに含まれ、200Kトークンの制限を超えてエラーが発生していました。この修正により、出力は30K文字に自動的に切り詰められ、完全な出力へのファイルパスが提供されるようになりました。

## 修正前の問題

### 症状

```bash
# 大量の出力を生成するテストスイート
claude

> npm test
# Ctrl+B でバックグラウンド化

# テストが1000件のログを出力（500KB）
# バックグラウンドタスク完了

# Claudeに結果を報告
> バックグラウンドタスクの結果を教えて

# エラー: Context length exceeded
# Error: Request would exceed maximum context window (200K tokens)
# 大量のログがコンテキストに含まれ、制限超過
# Claudeが応答できない
```

### 根本原因

```
バックグラウンドタスク:
- コマンド: npm test
- 出力: 500KB（約600Kトークン）

Claude への報告:
- 出力全文をAPIリクエストに含める
- コンテキスト: 通常のメッセージ + 600Kトークン
- 結果: 200K制限を超過 → エラー
```

## 修正後の動作

### 自動切り詰めとファイル参照

```bash
# 大量の出力を生成
claude

> npm test
# Ctrl+B

# テストが500KBの出力を生成

# Claudeに結果を報告
> バックグラウンドタスクの結果を教えて

# 修正後:
# - 最初の30K文字のみClaudeに送信
# - 完全な出力ファイルパスを提供
# - ✓ Claudeが正常に応答

# Claude:
# "テストが完了しました。最初の30,000文字を確認しました。
#  完全な出力は /tmp/claude-task-bash-12345.log で確認できます。
#
#  結果概要:
#  - 合計: 1000テスト
#  - 成功: 995
#  - 失敗: 5
#
#  失敗したテストの詳細は..."
```

## 実践例

### 大規模テストスイートの実行

数百のテストを実行しても、結果を確認できます。

```bash
# 大規模テストスイート
claude

> pytest tests/ -v
# Ctrl+B

# 300個のテストが実行され、詳細なログを出力（300KB）

# テスト完了後
> テスト結果をまとめて

# 修正前: コンテキストオーバーフロー
# 修正後:
# - 最初の30K文字から重要情報を抽出
# - ファイルパス: /tmp/claude-task-bash-67890.log
# ✓ 失敗したテストの要約を生成
```

### ビルドログの分析

大量のビルドログから問題を特定します。

```bash
# 大規模プロジェクトのビルド
claude

> ./gradlew build --info
# Ctrl+B

# ビルドが詳細ログを出力（1MB）

# ビルド完了
> ビルドエラーを分析して

# 修正後:
# - 最初の30K文字でエラーパターンを検出
# - 詳細は /tmp/claude-task-bash-11111.log を参照
# ✓ エラーの原因を特定して修正案を提示
```

### CI/CDログの要約

継続的インテグレーションの長大なログを要約します。

```bash
# GitHub Actions相当のCI実行
claude

> ./ci-pipeline.sh
# Ctrl+B

# CI全ステップのログ（2MB）
# - リント
# - テスト
# - ビルド
# - デプロイ

# CI完了
> CIの結果を教えて

# 修正後:
# - 最初の30K文字から全体像を把握
# - 完全なログ: /tmp/claude-task-bash-22222.log
# ✓ 各ステップの成功/失敗を要約
```

### データベースマイグレーションログ

大量のマイグレーションログを処理します。

```bash
# 数百のマイグレーション実行
claude

> npx prisma migrate deploy --verbose
# Ctrl+B

# 各マイグレーションの詳細ログ（500KB）

# マイグレーション完了
> マイグレーション結果を確認

# 修正後:
# - 最初の30K文字で概要を把握
# - 詳細: /tmp/claude-task-bash-33333.log
# ✓ エラーがあれば特定して報告
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- 切り詰め制限:
  - **30,000文字**（約22,500トークン）
  - 30K文字を超える出力は自動的に切り詰め
  - 切り詰めた旨がClaudeに通知される
- 切り詰めの動作:
  - 出力の最初の30K文字を保持
  - 末尾に以下を追加:
    ```
    ... (output truncated, 470K more chars)
    Full output: /tmp/claude-task-bash-12345.log
    ```
- ファイルパス参照:
  - 完全な出力ファイルのパスが常に提供される
  - ユーザーは外部ツールで全文を確認可能
- 影響を受けるタスク:
  - バックグラウンドBashコマンド
  - バックグラウンドエージェント
  - 長時間実行タスク
- コンテキスト管理:
  - 切り詰めにより、コンテキストウィンドウの空き容量を確保
  - 他のファイルやメッセージのための余裕を作る
- Claudeの分析能力:
  - 最初の30K文字でも、多くの場合十分な情報を提供
  - エラーは通常、ログの最初または最後に出現
  - パターン認識により、重要な情報を抽出
- 完全な出力の確認方法:
  ```bash
  # ファイルを直接確認
  less /tmp/claude-task-bash-12345.log

  # grepで検索
  grep -i error /tmp/claude-task-bash-12345.log

  # エディタで開く
  code /tmp/claude-task-bash-12345.log
  ```
- カスタマイズ:
  - 30K文字の制限は環境変数で変更可能（将来のバージョン）
  - 現在はハードコードされた値
- パフォーマンスへの影響:
  - 切り詰め処理は軽量（ミリ秒単位）
  - APIリクエストサイズが大幅に削減
  - 応答時間が改善
- 関連する改善:
  - index 38: バックグラウンドタスク詳細に出力ファイルパス表示
  - index 31: ファイル読み取りトークン制限の環境変数
- デバッグ:
  - `--debug` フラグで切り詰め処理のログを確認
  - ログに「Truncating background task output to 30K chars」が表示される

## 関連情報

- [Background tasks - Claude Code Docs](https://code.claude.com/docs/en/background-tasks)
- [Context management](https://code.claude.com/docs/en/context-management)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
