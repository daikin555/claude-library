---
title: "ログイン時のOAuth URL コピー用ショートカット追加"
date: 2026-01-16
tags: ['新機能', 'UI/UX', '認証', 'キーボードショートカット']
---

## 原文(日本語に翻訳)

ブラウザが自動的に開かない場合にOAuth URLをコピーするためのキーボードショートカット 'c' を追加

## 原文(英語)

Added keyboard shortcut 'c' to copy OAuth URL when browser doesn't open automatically during login

## 概要

Claude Codeへのログイン時、ブラウザが自動的に開かない環境でも、キーボードショートカット 'c' を押すだけでOAuth認証用のURLをクリップボードにコピーできるようになりました。リモートサーバーやヘッドレス環境での認証がより簡単になります。

## 基本的な使い方

Claude Codeを起動し、ログインプロンプトが表示されたら:

```bash
claude
```

ログイン画面で 'c' キーを押すと、OAuth URLがクリップボードにコピーされます。

```
Please login to Claude Code
Press 'c' to copy the OAuth URL
```

コピーしたURLを任意のブラウザに貼り付けて認証を完了させます。

## 実践例

### リモートサーバーでの認証

SSHでリモートサーバーに接続している場合:

1. リモートサーバー上で `claude` を実行
2. ログイン画面が表示されたら 'c' を押す
3. ローカルマシンのブラウザにURLを貼り付けて認証
4. 認証完了後、リモートサーバー上のClaude Codeが使用可能に

### Windows Subsystem for Linux (WSL) での利用

WSL環境ではブラウザの自動起動が失敗することがあります:

1. WSL上で `claude` を起動
2. 'c' キーでURLをコピー
3. Windows側のブラウザに貼り付けて認証

### CI/CD環境での手動認証

一時的にCI環境で手動認証が必要な場合:

```bash
# CI環境でClaude Codeを起動
claude

# 'c' でURLをコピー
# ログからURLを取得して別のブラウザで認証
```

### tmux/screen環境での利用

tmuxやscreenセッション内でブラウザが開けない場合:

1. tmux/screen内で `claude` を実行
2. 'c' キーでOAuth URLをコピー
3. 別のターミナルやデバイスのブラウザで認証

## 注意点

- この機能はログイン画面でのみ有効です
- クリップボードへのアクセス権限が必要な場合があります
- SSH経由の場合、クリップボード共有が設定されている必要があります
- URLは一定時間後に無効になるため、コピー後は速やかに認証を完了してください

## 関連情報

- [Claude Code 認証に関するドキュメント](https://github.com/anthropics/claude-code#authentication)
- [Changelog v2.1.10](https://github.com/anthropics/claude-code/releases/tag/v2.1.10)
