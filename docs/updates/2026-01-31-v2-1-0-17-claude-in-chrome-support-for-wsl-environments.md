---
title: "WSL環境でのClaude in Chromeサポートを修正"
date: 2026-01-31
tags: ['バグ修正', 'Windows', 'WSL', 'Chrome']
---

## 原文（日本語に翻訳）

WSL環境でのClaude in Chromeサポートを修正しました

## 原文（英語）

Fixed Claude in Chrome support for WSL environments

## 概要

Claude Code v2.1.0で修正された、WSL（Windows Subsystem for Linux）環境での「Claude in Chrome」機能のサポートです。以前のバージョンでは、WSL環境でClaude Codeを実行している場合、「Claude in Chrome」機能が "Native Host not supported on this platform" エラーで失敗していました。この修正により、Windows上のWSL環境でClaude Codeを使用しながら、Chromeブラウザとの統合機能を利用できるようになりました。

## 修正前の問題

### エラーの発生

```bash
# WSL環境でClaude Codeを実行
claude

# Claude in Chrome機能を使おうとすると...
Error: Claude in Chrome Native Host not supported on this platform
```

WSL環境は技術的にはLinuxですが、Windows上で実行されているため、ネイティブホスト通信のセットアップで問題が発生していました。

### ドキュメントの矛盾

- **公式ドキュメント**: WSLではClaude in Chromeが使用できないと記載
- **Changelog v2.1.0**: WSL環境のサポートを修正したと記載

この矛盾により、Windowsユーザーに混乱が生じていました。

## 修正後の動作

### WSLでの使用

```bash
# WSL環境（Ubuntu、Debianなど）でClaude Codeを起動
claude

# /teleportコマンドでセッションをChromeに転送
> /teleport

# または、会話中に「このセッションをChromeに転送して」と依頼
> このセッションをClaude.ai/codeに転送してください

# ✓ WSL環境でもChromeブラウザとの統合が正常に動作
```

## 実践例

### WSL開発環境からブラウザへの切り替え

```bash
# WSLのターミナルでコーディング中
cd /mnt/c/Users/username/project
claude

# 複雑なビジュアル確認が必要になった
> このUIコンポーネントをブラウザで確認したいので、
> セッションをChromeに転送してください

# /teleportコマンドで転送
# ✓ Chrome上のclaude.ai/codeでセッション継続
```

### リモートサーバー（WSL）とローカルブラウザの連携

```bash
# WSL2で開発サーバーを起動
npm run dev

# セッションをChromeに転送してブラウザでデバッグ
> /teleport

# Chromeで継続しながら、WSLのサーバーはバックグラウンドで実行
```

### ドキュメント作成での活用

```bash
# WSLでMarkdownドキュメントを編集
> READMEを更新して

# プレビューのためにChromeに転送
> Chromeでプレビューしながら編集したいので転送して

# ✓ Chrome上でリッチなマークダウンプレビューを確認
```

## WSLとネイティブWindows版の比較

### WSL版の利点

- Linuxツールチェーンの完全なサポート
- シェルスクリプトやUNIXコマンドの互換性
- Dockerなどの開発ツールとの統合

### ネイティブWindows版の利点

- セットアップが簡単（WSL不要）
- PowerShellとの直接統合
- Git for Windowsとの連携

### 推奨環境

- **WSL推奨**: Linux開発環境が必要な場合、Dockerを使用する場合
- **ネイティブ版推奨**: Windowsツールとの統合が主な場合、シンプルなセットアップが必要な場合

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- **現在のWSLサポート状況**:
  - WSL 1とWSL 2の両方でClaude in Chromeが動作します
  - Windows 10 1809以降またはWindows Server 2019以降が必要
- **ネイティブWindows版の利用**:
  - Claude Code v2.x以降、ネイティブWindows版が利用可能（WSL不要）
  - Git Bash経由での実行を推奨
  - WSLは代替手段として位置付けられています
- **セットアップ手順**:
  - WSL環境にClaude Codeをインストール: `npm install -g @anthropic-ai/claude-code`
  - Chromeに拡張機能をインストール（必要に応じて）
  - `/teleport`コマンドでブラウザに転送
- **既知の制限**:
  - ファイルパスの扱いに注意（Windowsパス vs Linuxパス）
  - `/mnt/c/`経由でWindowsファイルシステムにアクセス可能

## 関連情報

- [Set up Claude Code - Official Docs](https://code.claude.com/docs/en/setup)
- [Comprehensive Guide to Setting Up Claude Code on Windows Using WSL](https://medium.com/ai-insights-cobet/comprehensive-guide-to-setting-up-claude-code-on-windows-using-wsl-d3a3f3b5a128)
- [Claude Code Windows Native Installation](https://smartscope.blog/en/generative-ai/claude/claude-code-windows-native-installation/)
- [GitHub Issue: WSL Documentation Contradiction](https://github.com/anthropics/claude-code/issues/18061)
