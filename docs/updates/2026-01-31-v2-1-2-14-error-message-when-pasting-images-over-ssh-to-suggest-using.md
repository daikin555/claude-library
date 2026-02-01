---
title: "SSH接続時の画像ペーストエラーメッセージを改善"
date: 2026-01-09
tags: ['改善', 'SSH', 'エラーメッセージ', 'UX']
---

## 原文（日本語に翻訳）

SSH接続時に画像をペーストしようとした際のエラーメッセージを改善し、役に立たないクリップボードショートカットのヒントの代わりに `scp` の使用を提案するようにしました。

## 原文（英語）

Improved error message when pasting images over SSH to suggest using `scp` instead of the unhelpful clipboard shortcut hint

## 概要

SSH経由でリモートサーバー上のClaude Codeを使用する際、画像をクリップボードから直接ペーストすることはできませんが、以前のエラーメッセージは実用的な解決策を提示していませんでした。v2.1.2では、`scp` や他の実用的なファイル転送方法を提案する、より役立つエラーメッセージに改善されました。

## 基本的な使い方

SSH接続時に画像をペーストしようとすると、改善されたエラーメッセージが表示されます。

### 修正前のエラーメッセージ

```bash
# SSH接続でClaude Codeを使用
ssh user@remote-server
claude

# 画像をペーストしようとする（Cmd+V / Ctrl+V）
# → "Cannot paste image from clipboard. Try using a keyboard shortcut."
#    （役に立たない情報）
```

### 修正後のエラーメッセージ

```bash
# SSH接続でClaude Codeを使用
ssh user@remote-server
claude

# 画像をペーストしようとする
# → "Cannot paste image over SSH. Transfer the file using:
#     scp local-image.png user@remote-server:/path/to/image.png
#    Then reference it in your message."
#    （実用的な解決策）
```

## 実践例

### scpを使用した画像転送

```bash
# ローカルマシンから別のターミナルで実行
scp ~/screenshots/error.png user@remote-server:/tmp/error.png

# SSH接続先のClaude Codeで
claude "この画像 /tmp/error.png のエラーを解決して"
```

### rsyncを使用した複数画像の転送

```bash
# 複数の画像を一度に転送
rsync -avz ~/design-mockups/ user@remote-server:~/mockups/

# リモートで参照
claude "~/mockups/ 内のデザインをレビューして"
```

### ドラッグ&ドロップを使用（一部のターミナル）

```bash
# iTerm2などの高機能ターミナルでは、
# SSH接続中でもファイルをドラッグ&ドロップすると
# 自動的にscpで転送される

# ターミナルにファイルをドロップ
# → 自動的にscpコマンドが実行される
# → リモートにファイルが転送される
```

### 画像のbase64エンコード（小さい画像の場合）

```bash
# ローカルで画像をbase64エンコード
base64 image.png | pbcopy  # macOS
base64 image.png | xclip   # Linux

# SSH接続先で
echo "<base64-string>" | base64 -d > /tmp/image.png

# Claude Codeで使用
claude "この画像 /tmp/image.png を分析して"
```

## 注意点

- **SSH制限**: SSH接続では、クリップボード経由での画像転送は技術的に不可能です
- **scp推奨**: 最も信頼性が高い方法はscpまたはrsyncです
- **パスの指定**: 転送後は絶対パスまたは相対パスで画像を参照してください
- **権限**: リモートサーバーでの書き込み権限を確認してください
- **代替手段**: VS Code Remote SSHなどのツールでは、統合されたファイル転送機能が利用できる場合があります

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [scp コマンドガイド](https://man.openbsd.org/scp)
- [rsync ドキュメント](https://rsync.samba.org/)
