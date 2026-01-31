---
title: "VSCode: 長時間セッション後のOAuthトークン有効期限による401エラーを修正"
date: 2025-01-27
tags: [bugfix, vscode, authentication, oauth]
---

## 原文（日本語訳）

VSCode: 長時間セッション後にOAuthトークンの有効期限が切れることで401エラーが発生する問題を修正

## 原文（英語）

VSCode: Fixed OAuth token expiration causing 401 errors after extended sessions

## 概要

VSCode拡張機能で長時間Claude Codeを使用していると、OAuthトークンの有効期限が切れて401エラーが発生する問題が修正されました。トークンの自動更新が正しく機能するようになり、セッションの中断なく長時間の作業が可能になります。

## 基本的な使い方

修正後は、自動的にトークンが更新されます。特別な操作は不要です。

```bash
# VSCode拡張機能でClaude Codeを起動
# 長時間使用してもトークンが自動更新される
```

## 実践例

### 長時間の開発セッション

一日中VSCodeでClaude Codeを使用する場合でも、エラーが発生しません。

```bash
# 朝からセッションを開始
# 午前中に機能Aを開発
> "Implement feature A"

# 昼休憩後もセッション継続
# 午後に機能Bを開発
> "Implement feature B"

# トークンが自動更新されるため、401エラーは発生しない
```

### マルチタスクワークフロー

他の作業をしながらVSCodeを開いたままにしていても問題ありません。

```bash
# VSCodeでClaude Codeセッションを開始
> "Refactor the authentication module"

# 数時間後に戻ってきて作業を再開
> "Add tests for the refactored code"

# セッションが継続しており、再ログイン不要
```

### リモート開発環境での使用

SSH接続やWSL環境で長時間作業する場合も安定します。

```bash
# Remote-SSHでリモートサーバーに接続
# Claude Codeで開発作業
> "Deploy the application to staging"

# 数時間後、別の作業を実行
> "Check logs and fix any deployment issues"

# トークンが適切に管理されるため、認証エラーなし
```

### ペアプログラミングセッション

Live Shareなどで長時間のペアプログラミングをする場合。

```bash
# 午前中からペアプログラミング開始
# Claude Codeでコード生成
> "Generate unit tests for the new API endpoints"

# 午後も継続して作業
> "Refactor based on review comments"

# トークン更新が自動的に行われる
```

## 注意点

- OAuth認証を使用している場合にのみ適用されます
- APIキー認証では関係ありません
- ネットワークが切断されている場合、トークン更新に失敗する可能性があります
- キーチェーンへのアクセスが必要な場合があります（macOS）

## トラブルシューティング

### それでも401エラーが発生する場合

```bash
# Claude Codeを再起動
# Cmd+Shift+P (Mac) / Ctrl+Shift+P (Windows)
> "Claude Code: Restart"

# または、OAuthを再認証
> "Claude Code: Sign Out"
> "Claude Code: Sign In"
```

### macOSでキーチェーンロックの問題

```bash
# ターミナルでキーチェーンをアンロック
security unlock-keychain

# その後、VSCodeを再起動
```

## 関連情報

- [VSCode拡張機能ガイド](https://code.claude.com/docs/en/vscode)
- [OAuth認証について](https://code.claude.com/docs/en/authentication#oauth)
- [トラブルシューティング](https://code.claude.com/docs/en/troubleshooting)
- [認証の管理](https://code.claude.com/docs/en/authentication)
