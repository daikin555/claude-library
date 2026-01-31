---
title: "フィードバックパネルで 'n' を入力すると閉じてしまう問題を修正"
date: 2026-01-13
tags: ['バグ修正', 'UI', 'フィードバック', 'キーボード入力']
---

## 原文（日本語に翻訳）

説明フィールドで 'n' を入力すると予期せずフィードバックパネルが閉じてしまう問題を修正

## 原文（英語）

Fixed the feedback panel closing unexpectedly when typing 'n' in the description field

## 概要

Claude Code v2.1.6 では、フィードバックパネルの重要な使い勝手の問題が修正されました。以前のバージョンでは、フィードバックの説明を入力中に文字 'n' を入力すると、それが "No"（キャンセル）のショートカットキーとして誤って解釈され、パネルが予期せず閉じてしまう問題がありました。この修正により、説明文を安心して入力できるようになりました。

## 基本的な使い方

フィードバックパネルの正常な使用方法:

1. フィードバックを送信したい場面で専用のコマンドを実行
2. フィードバックの種類を選択（問題報告、機能要望など）
3. 説明フィールドに自由に文章を入力
4. 完了したら送信

v2.1.6 以降、説明フィールドでは全ての文字を自由に入力できます。

## 実践例

### 修正前の問題（v2.1.5以前）

フィードバック入力中に以下の問題が発生していました:

```
Feedback Description:
I found a bug in the configuratio[n]  ← ここで 'n' を入力
# パネルが突然閉じる
# 入力内容が失われる
```

特に以下の単語を含む場合に頻繁に発生:
- configuration
- function
- implementation
- documentation
- installation

など、'n' を含む一般的な英単語が使えませんでした。

### 修正後の動作（v2.1.6以降）

v2.1.6 では、'n' を含む文章を自由に入力可能:

```
Feedback Description:
I found a bug in the configuration.
The function implementation needs improvement.
Documentation should include installation steps.

# 'n' を何度入力しても問題なく、全ての内容が保持される
```

### フィードバックの送信例

バグ報告の場合:

```
Feedback Type: Bug Report

Description:
When running the installation command, the
configuration file is not created automatically.
This happens on Windows 11.

Steps to reproduce:
1. Run npm install -g claude-code
2. Launch claude
3. Notice no configuration file

# 'n' を含む詳細な説明を問題なく入力可能
```

### 機能要望の送信

新機能のリクエスト:

```
Feedback Type: Feature Request

Description:
It would be great to have an option to
enable syntax highlighting in the terminal
for JSON and XML content.

# 'n' を含む単語（option, JSON, content など）が正常に入力できる
```

### 日本語入力でのフィードバック

日本語でもフィードバック可能:

```
フィードバックの種類: バグ報告

説明:
設定ファイルの読み込み時にエラーが発生します。
特に日本語のファイル名を使用している場合に
問題が起きます。

# 'n' キーの誤認識が修正されたため、スムーズに入力できる
```

### キーボードショートカットの正しい使い方

フィードバックパネルでのキーボード操作:

- **説明フィールド入力中**: 全ての文字が入力として扱われる
- **確認ダイアログ**: `y` (Yes) / `n` (No) のショートカットが有効
- **フィールド間移動**: `Tab` キーで移動
- **送信**: `Ctrl+Enter` または送信ボタン
- **キャンセル**: `Esc` キーまたはキャンセルボタン

### 入力途中での保存

長いフィードバックを書く場合:

```
# v2.1.6 では 'n' を入力してもパネルが閉じないため
# 安心して長文を入力できる

Description:
This is a comprehensive feedback about the
implementation of the new configuration system.

(中略、数百文字の詳細な説明)

The solution should consider both performance
and maintainability.

# 入力内容が保持され、安心して送信できる
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- 説明フィールドでは、全ての文字が通常の入力として扱われるようになりました
- キーボードショートカット（y/n）は、確認ダイアログなど適切な場面でのみ機能します
- フィードバックパネルの外（メインUI）では、従来通りのショートカットキーが機能します
- `Esc` キーを使用すれば、いつでもフィードバックパネルを安全に閉じることができます
- 入力中のフィードバック内容は、パネルを閉じると失われるため、送信前に内容を確認してください

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code フィードバック送信](https://code.claude.com/docs/feedback)
