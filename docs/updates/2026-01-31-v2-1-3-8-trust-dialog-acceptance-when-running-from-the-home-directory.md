---
title: "ホームディレクトリからの起動時の信頼ダイアログ問題を修正"
date: 2026-01-09
tags: ['バグ修正', 'hooks', 'セキュリティ', '信頼設定']
---

## 原文（日本語に翻訳）

ホームディレクトリから実行した際に、信頼ダイアログで承認してもhooksなどの信頼が必要な機能がセッション中に有効にならない問題を修正しました

## 原文（英語）

Fixed trust dialog acceptance when running from the home directory not enabling trust-requiring features like hooks during the session

## 概要

Claude Code v2.1.3では、ホームディレクトリ（`~`）からClaude Codeを起動した際に、信頼ダイアログで「信頼する」を選択しても、hooksなどの信頼が必要な機能が正しく有効化されない問題が修正されました。これにより、どのディレクトリから起動しても、信頼設定が一貫して動作するようになります。

## 基本的な使い方

ホームディレクトリから起動しても、信頼設定が正しく機能します。

```bash
# ホームディレクトリから起動
cd ~
claude

# 信頼ダイアログが表示されたら「信頼する」を選択
# → v2.1.3では、hooksなどの機能が即座に有効化される
```

## 実践例

### 修正前の問題

ホームディレクトリから起動すると、信頼設定が反映されませんでした。

```bash
# 修正前の動作例
# 1. ホームディレクトリから起動
cd ~
claude

# 2. 信頼ダイアログで「信頼する」を選択
# ✅ Trust this directory? → Yes

# 3. hooksを設定しても動作しない（問題！）
# ~/.claude/hooks/ にフックを配置
# → フックが実行されない
# → セッション中は信頼設定が有効化されていない
```

### 修正後の動作

v2.1.3では、ホームディレクトリでも信頼設定が正しく機能します。

```bash
# 修正後の動作例
# 1. ホームディレクトリから起動
cd ~
claude

# 2. 信頼ダイアログで「信頼する」を選択
# ✅ Trust this directory? → Yes

# 3. hooksが即座に有効化される✅
# ~/.claude/hooks/ のフックが実行される
# セッション中も信頼設定が有効
```

### Hooksの設定例

信頼設定が有効になると、hooksが使用できます。

```bash
# ホームディレクトリでhooksを設定
~/.claude/hooks/pre-commit.sh

# v2.1.3では、ホームディレクトリから起動しても
# 信頼承認後にhooksが即座に実行される

# 例：コミット前にlintを実行
# pre-commit hook:
#!/bin/bash
npm run lint
```

### プロジェクト固有の設定との違い

ホームディレクトリとプロジェクトディレクトリでの信頼設定の動作です。

```bash
# ケース1：プロジェクトディレクトリから起動
cd ~/projects/my-app
claude
# → プロジェクト固有の信頼設定
# → ~/projects/my-app/.claude/ の設定が有効

# ケース2：ホームディレクトリから起動
cd ~
claude
# → グローバル信頼設定
# → ~/.claude/ の設定が有効
# → v2.1.3で正しく動作するように修正
```

### セキュリティ関連機能の有効化

信頼が必要なその他の機能も正しく動作します。

```bash
# 信頼が必要な機能の例：
# - Hooks（pre-commit, post-commandなど）
# - カスタムスキル
# - プロジェクト固有のパーミッション設定
# - 環境変数の読み込み

# v2.1.3では、ホームディレクトリから起動しても
# すべての機能が信頼承認後に有効化される
```

## 注意点

- 信頼ダイアログは、新しいディレクトリで初めてClaude Codeを起動したときに表示されます
- ホームディレクトリを信頼する場合、セキュリティへの影響を理解した上で承認してください
- 信頼設定は、セキュリティ上重要な機能のため、慎重に管理することを推奨します
- 信頼を取り消したい場合は、`/config` から設定を変更できます
- 共有マシンでは、ホームディレクトリの信頼設定に特に注意が必要です

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3)
- [Hooksの設定ガイド](https://github.com/anthropics/claude-code)
- [信頼設定とセキュリティ](https://github.com/anthropics/claude-code)
- [パーミッション管理のベストプラクティス](https://github.com/anthropics/claude-code)
