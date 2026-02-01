---
title: "npmインストール非推奨の通知機能を追加"
date: 2026-01-21
tags: ['新機能', 'インストール', 'npm']
---

## 原文（日本語に翻訳）

npmインストール方式の非推奨通知を追加 - `claude install`を実行するか、https://docs.anthropic.com/en/docs/claude-code/getting-started で他のオプションを確認してください

## 原文（英語）

Added deprecation notification for npm installations - run `claude install` or see https://docs.anthropic.com/en/docs/claude-code/getting-started for more options

## 概要

Claude Code v2.1.15では、npmを使用したインストール方法が非推奨となることをユーザーに通知する機能が追加されました。従来の`npm install -g @anthropic-ai/claude-code`によるインストール方法から、より安定した新しいインストール方法への移行を促すための変更です。この通知により、ユーザーは`claude install`コマンドまたは公式ドキュメントで推奨されている最新のインストール方法を確認できるようになります。

## 基本的な使い方

### 非推奨通知の確認

npmでClaude Codeをインストールまたは更新しようとすると、非推奨通知が表示されます。

```bash
# 従来の方法（非推奨）
npm install -g @anthropic-ai/claude-code

# 通知メッセージが表示される:
# "npm installations are deprecated. Run 'claude install' or see
# https://docs.anthropic.com/en/docs/claude-code/getting-started for more options"
```

### 推奨される新しいインストール方法

既にClaude Codeをインストール済みの場合は、`claude install`コマンドを実行してください。

```bash
# 推奨される方法
claude install
```

## 実践例

### npmからの移行手順

既存のnpmインストールから新しい方法へ移行する場合：

```bash
# 1. 現在のバージョンを確認
claude --version

# 2. npmでインストールされたバージョンをアンインストール（任意）
npm uninstall -g @anthropic-ai/claude-code

# 3. 推奨される方法で再インストール
claude install

# 4. インストールが完了したことを確認
claude --version
```

### 初回インストール時の対応

Claude Codeを初めてインストールする場合は、公式ドキュメントに記載されている最新の推奨インストール方法を使用してください。

```bash
# 公式ドキュメントで推奨されているインストーラーを使用
# Windows: MSIインストーラー
# macOS: Homebrewまたは直接ダウンロード
# Linux: パッケージマネージャーまたはバイナリダウンロード

# 例: macOSの場合（Homebrew）
brew install claude-code

# 例: Linuxの場合（直接ダウンロード）
curl -fsSL https://code.anthropic.com/install.sh | sh
```

### CI/CD環境での対応

継続的インテグレーション環境で使用している場合は、インストールスクリプトを更新してください。

```yaml
# GitHub Actions の例（更新前 - 非推奨）
- name: Install Claude Code
  run: npm install -g @anthropic-ai/claude-code

# GitHub Actions の例（更新後 - 推奨）
- name: Install Claude Code
  run: |
    curl -fsSL https://code.anthropic.com/install.sh | sh
    claude --version
```

## 注意点

- **npm方式は将来的に廃止される予定**: この通知は、npmベースのインストール方法が将来のバージョンで完全に廃止されることを示しています
- **既存の環境への影響**: v2.1.15時点では、npmでインストールされたClaude Codeは引き続き動作しますが、早めの移行が推奨されます
- **自動更新の変更**: 新しいインストール方法では、より効率的な自動更新メカニズムが提供される可能性があります
- **互換性**: 新しいインストール方法でも、既存のプロジェクト設定やカスタマイズは維持されます
- **ドキュメントの確認**: 使用しているOSやプラットフォームに応じた最適なインストール方法は、公式ドキュメントで確認してください

## 関連情報

- [Claude Code Getting Started（公式ドキュメント）](https://docs.anthropic.com/en/docs/claude-code/getting-started)
- [Changelog v2.1.15](https://github.com/anthropics/claude-code/releases/tag/v2.1.15)
- [インストールガイド](https://code.anthropic.com/docs/installation)
- [アップグレードガイド](https://code.anthropic.com/docs/upgrade)
