---
title: "ツール出力のファイルパスがクリック可能に"
date: 2026-01-09
tags: ['新機能', 'terminal', 'UI改善', 'OSC8']
---

## 原文（日本語に翻訳）

OSC 8をサポートするターミナル（iTermなど）で、ツール出力に含まれるファイルパスをクリック可能なハイパーリンクとして表示する機能を追加しました。

## 原文（英語）

Added clickable hyperlinks for file paths in tool output in terminals that support OSC 8 (like iTerm)

## 概要

Claude Codeが実行したツール（Grep、Glob、Bashコマンドなど）の出力に含まれるファイルパスが、OSC 8エスケープシーケンスをサポートするターミナルで自動的にクリック可能なハイパーリンクとして表示されるようになりました。これにより、結果のファイルをワンクリックで開くことができ、作業効率が大幅に向上します。

## 基本的な使い方

特別な設定は不要です。OSC 8対応ターミナルでClaude Codeを使用するだけで、自動的にファイルパスがハイパーリンク化されます。

**対応ターミナルの例:**
- iTerm2 (macOS)
- WezTerm
- kitty
- Windows Terminal
- GNOME Terminal（最新版）

**使用イメージ:**
1. Claudeにファイル検索やコード検索を依頼
2. 結果に表示されるファイルパスがアンダーライン付きで表示される
3. パスをクリックすると、デフォルトエディタで該当ファイルが開く

## 実践例

### コード検索結果から直接ファイルを開く

```bash
# Claudeに質問:
"認証関連のコードを探してください"

# Grepツールの出力例:
src/auth/login.ts:15
src/auth/middleware.ts:42
src/utils/tokenHelper.ts:8

# → 各ファイルパスがクリック可能
# クリックするとエディタで該当ファイルが開く
```

### エラー箇所への即座のジャンプ

```bash
# Claudeに依頼:
"このエラーを修正してください"

# Bashツールの出力（テスト実行結果）:
Error: Type mismatch
  at src/components/UserCard.tsx:23:5

# → ファイルパスをクリックして即座にエラー箇所にジャンプ
```

### ビルドエラーの迅速な修正

```bash
# ビルドコマンドの出力:
ERROR in src/pages/Dashboard.tsx:45:10
TS2345: Argument of type 'string' is not assignable...

# → パスをクリックして該当行を直接開く
```

### ファイル一覧からの効率的なナビゲーション

```bash
# Claudeに質問:
"このプロジェクトのReactコンポーネントを一覧表示して"

# Globツールの出力:
src/components/Header.tsx
src/components/Footer.tsx
src/components/Sidebar.tsx
src/components/Button.tsx

# → 各コンポーネントをクリックして順番にレビュー
```

## 注意点

- **ターミナルの対応状況を確認**: OSC 8に対応していないターミナルでは、通常のテキストとして表示されます
- **エディタの設定**: ファイルを開く際のデフォルトエディタは、ターミナルまたはOSの設定に依存します
- **リモート環境**: SSH接続時は、ローカルとリモートのパスマッピングが正しく設定されている必要があります
- **大量の出力**: 非常に多くのファイルパスが表示される場合、ターミナルのパフォーマンスに影響する可能性があります

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [OSC 8仕様](https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda)
