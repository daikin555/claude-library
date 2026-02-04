---
title: "claude.ai サブスクライバー向け `/teleport` と `/remote-env` コマンドを追加"
date: 2026-01-31
tags: ['新機能', 'コマンド', 'リモート環境']
---

## 原文（日本語に翻訳）

claude.ai サブスクライバー向けに `/teleport` と `/remote-env` スラッシュコマンドを追加し、リモートセッションの再開と設定を可能にしました

## 原文（英語）

Added `/teleport` and `/remote-env` slash commands for claude.ai subscribers, allowing them to resume and configure remote sessions

## 概要

Claude Code v2.1.0で導入された、claude.aiの有料サブスクライバー専用のリモートセッション機能です。`/teleport`コマンドはローカルのClaude CodeセッションをClaude.aiのウェブインターフェースに転送して継続でき、`/remote-env`コマンドはリモート環境の設定を管理します。これにより、ターミナルとブラウザ間でシームレスに作業を切り替えられ、外出先でもモバイルデバイスからセッションにアクセス可能になります。

## 基本的な使い方

### /teleport コマンド

ローカルセッションをclaude.aiに転送します。

```bash
# Claude Code対話モードで実行
> /teleport

# セッションがclaude.aiに転送され、URLが表示される
# Session teleported to: https://claude.ai/chat/abc123...
# ブラウザで開くと、同じコンテキストで作業を継続できる
```

### /remote-env コマンド

リモート環境の設定を確認・変更します。

```bash
# 現在のリモート環境設定を表示
> /remote-env

# リモート環境の設定（例: 使用するマシン、作業ディレクトリ）
> /remote-env --config ~/my-remote-config.json
```

## 実践例

### ローカルからモバイルへの作業移行

ローカルで開始したコーディングセッションを、外出先でモバイルから継続します。

```bash
# ローカルのターミナルで作業開始
cd ~/project
claude

> このファイルのバグを修正して
# コード修正中...

# 外出する必要が生じた
> /teleport
# Session teleported to: https://claude.ai/chat/xyz789

# スマートフォンでURLを開く
# → 同じコンテキストで作業を継続
# → コード修正を完了してコミット
```

### チームレビューのための共有

ローカルセッションをチームメンバーと共有してレビューを依頼します。

```bash
# ローカルで実装作業
> この機能の実装を手伝って
# 実装完了

# レビュー依頼のためにセッションを転送
> /teleport
# Session URL: https://claude.ai/chat/review123

# URLをチームメンバーに共有
# → ブラウザで開いて、実装の経緯とコンテキストを確認
# → コメントやフィードバックを追加
```

### リモート開発環境での作業

クラウド開発環境やリモートサーバー上での作業をclaude.aiで管理します。

```bash
# SSHでリモートサーバーに接続
ssh dev-server

# Claude Codeを起動
claude

# リモート環境設定を確認
> /remote-env
# Current environment: dev-server
# Working directory: /home/user/projects

# 作業をブラウザに転送
> /teleport
# → ブラウザでリモート環境にアクセス
# → GUIツールや可視化機能を活用
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **claude.aiの有料サブスクライバー限定機能**です（Pro、Team、Enterpriseプラン）
- `/teleport`の制限事項:
  - セッションの転送は一方向のみ（ローカル→claude.ai）
  - 転送後もローカルセッションは継続可能
  - 転送されたセッションはclaude.aiのセッション数制限にカウントされます
- セキュリティに関する注意:
  - 転送されたセッションには作業ディレクトリのコンテキストが含まれます
  - 機密情報を含むプロジェクトでの使用には注意が必要
  - 共有URLは適切に管理してください
- `/remote-env`の機能詳細:
  - リモート環境の設定（ワーキングディレクトリ、環境変数など）
  - 複数のリモート環境の切り替え
  - 環境設定のエクスポート/インポート
- ネットワーク接続が必要です
- 認証トークンの有効期限に注意してください

## 関連情報

- [Remote sessions - Claude Code Docs](https://code.claude.com/docs/en/remote-sessions)
- [Claude.ai Subscription Plans](https://claude.ai/upgrade)
- [Using Claude Code with remote environments](https://code.claude.com/docs/en/remote-development)
