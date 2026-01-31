---
title: "出力トークン制限で応答が切れた際にエラーではなく自動継続するよう改善"
date: 2026-01-31
tags: ['改善', 'トークン制限', '自動継続']
---

## 原文（日本語に翻訳）

出力トークン制限により応答が途中で切れた際、エラーメッセージを表示する代わりに自動的に継続するよう改善しました

## 原文（英語）

Improved Claude to automatically continue when response is cut off due to output token limit, instead of showing an error message

## 概要

Claude Code v2.1.0で改善された、長文応答の自動継続機能です。以前のバージョンでは、Claudeの応答が出力トークン制限（デフォルト8192トークン）に達すると、エラーメッセージが表示され、ユーザーが手動で「続きを生成」と指示する必要がありました。この改善により、応答が切れた場合でも自動的に継続され、長文のコード生成やドキュメント作成がシームレスに完了するようになりました。

## 改善前の動作

### エラーによる中断

```bash
claude "Generate complete API documentation"

# Claudeが8192トークン分応答
# ...
# ## Endpoint: /api/users
# ### GET /api/users
# Returns a list of...

# 修正前:
Error: Response cut off due to output token limit
Please ask Claude to continue.

# ユーザーが手動で:
> "Continue from where you left off"

# Claudeが継続:
# ... users in the system.
# ### POST /api/users
# ...

# 問題点:
# - 作業が中断される
# - 手動操作が必要
# - 非効率
```

## 改善後の動作

### 自動継続

```bash
claude "Generate complete API documentation"

# Claudeが8192トークン分応答
# ...
# ## Endpoint: /api/users
# ### GET /api/users
# Returns a list of...

# 修正後:
[Automatically continuing...]

# ... users in the system.
# ### POST /api/users
# Creates a new user...
# ...（完了まで自動継続）

# ✓ 中断なし
# ✓ シームレス
# ✓ 完全な出力
```

## 実践例

### 長いコード生成

複数ファイルにわたるコード生成。

```bash
claude "Create a complete Express.js API with authentication"

# 生成内容:
# - server.js (500行)
# - routes/auth.js (300行)
# - routes/users.js (400行)
# - middleware/auth.js (200行)
# - models/User.js (300行)
# - tests/*.js (600行)

# v2.1.0:
# ✓ すべてのファイルを自動的に生成
# ✓ 途中で止まらない
# ✓ 1回のコマンドで完了
```

### 詳細なドキュメント生成

包括的なREADMEやチュートリアル。

```bash
claude "Write comprehensive documentation for this library"

# 生成内容:
# - Introduction (200トークン)
# - Installation (300トークン)
# - Quick Start (500トークン)
# - API Reference (3000トークン)
# - Advanced Usage (2000トークン)
# - Examples (2500トークン)
# - FAQ (1000トークン)
# - Contributing (500トークン)

# 合計: 10,000トークン

# v2.1.0:
# [Automatically continuing...]
# [Automatically continuing...]
# ✓ 完全なドキュメントを一度に生成
```

### 大規模リファクタリング

多数のファイルを変更。

```bash
claude "Refactor entire codebase to TypeScript"

# 変更:
# - 50ファイル以上
# - 各ファイルの型定義追加
# - インポート文の更新
# - 設定ファイルの追加

# v2.1.0:
# ✓ すべての変更を自動的に完了
# ✓ 途中で中断されない
```

### テストケースの生成

包括的なテストスイート。

```bash
claude "Generate complete test suite for API"

# 生成内容:
# - Unit tests (2000トークン)
# - Integration tests (3000トークン)
# - E2E tests (2000トークン)
# - Test utilities (1000トークン)
# - Mock data (1500トークン)

# v2.1.0:
# [Automatically continuing...]
# ✓ すべてのテストを生成完了
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 出力トークン制限:
  - **デフォルト**: 8192トークン
  - **最大**: モデルにより異なる
  - Sonnet 4.5: 8192トークン
  - Opus 4.5: 16384トークン
- 自動継続の動作:
  - 応答が制限に達すると検知
  - 自動的に継続リクエストを送信
  - `[Automatically continuing...]` と表示
  - シームレスに続きを生成
- 継続回数:
  - 理論上は無制限
  - 実用上は2-3回の継続が一般的
  - 10回以上継続する場合は警告
- コスト:
  - 継続ごとに追加のAPIコールが発生
  - トークンカウンターに反映
  - 長文生成はコストが高くなる可能性
- 手動で継続をキャンセル:
  - Ctrl+C でいつでも中断可能
  - 継続中も停止できる
- 非対話モード:
  - `--non-interactive` でも自動継続は動作
  - CI/CDでの長文生成にも対応
- デバッグ:
  - `--debug` フラグで継続のログを確認
  - 各継続のトークン数を表示
- トラブルシューティング:
  - 継続が多すぎる場合:
    - タスクを分割して実行
    - より簡潔な指示を心がける
  - 継続が止まる場合:
    - ネットワーク接続を確認
    - APIレート制限を確認

## 関連情報

- [Token usage - Claude Code Docs](https://code.claude.com/docs/en/tokens)
- [Models - Claude Code Docs](https://code.claude.com/docs/en/models)
- [API limits](https://docs.anthropic.com/claude/reference/errors-and-limits)
