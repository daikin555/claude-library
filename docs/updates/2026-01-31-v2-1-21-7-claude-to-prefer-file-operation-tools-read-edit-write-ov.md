---
title: "Claudeがファイル操作ツールを優先的に使用するように改善"
date: 2026-01-28
tags: ['改善', 'ツール選択', 'ベストプラクティス']
---

## 原文（日本語に翻訳）

Claudeがbash相当のコマンド（cat、sed、awk）よりもファイル操作ツール（Read、Edit、Write）を優先的に使用するように改善

## 原文（英語）

Improved Claude to prefer file operation tools (Read, Edit, Write) over bash equivalents (cat, sed, awk)

## 概要

Claude Codeの動作が改善され、ファイルの読み込み、編集、書き込みを行う際に、bashコマンド（cat、sed、awkなど）ではなく、専用のファイル操作ツール（Read、Edit、Write）を優先的に使用するようになりました。これにより、より安全で信頼性の高いファイル操作が可能になり、エラー処理や状態管理が改善されます。また、クロスプラットフォーム互換性も向上し、Windows環境でも一貫した動作が保証されます。

## 基本的な使い方

この改善は自動的に適用されるため、ユーザー側で特別な設定は不要です。Claudeが自動的に適切なツールを選択します。

```bash
$ claude code
> src/config.jsonを読み込んで
# v2.1.21以降: Readツールを使用
# v2.1.20以前: cat コマンドを使用する場合があった

> ファイルの一部を編集して
# v2.1.21以降: Editツールを使用
# v2.1.20以前: sed コマンドを使用する場合があった
```

## 実践例

### ファイルの読み込み

ファイル内容を確認する際、Readツールが使用されます：

```
> package.jsonの内容を確認して

# v2.1.21以降の動作:
[Using Read tool]
[Reading package.json…]
[Read complete]

# v2.1.20以前の動作（場合により）:
[Using Bash: cat package.json]
```

**メリット:**
- Readツールは行番号を自動的に付与
- 長いファイルの場合、適切に分割して読み込み
- エラー時のメッセージがより明確

### ファイルの編集

コードの一部を変更する際、Editツールが使用されます：

```
> src/utils.tsの関数名をupdateUserからupdateUserProfileに変更して

# v2.1.21以降の動作:
[Using Edit tool]
[Editing src/utils.ts…]
[Edit complete: 3 occurrences replaced]

# v2.1.20以前の動作（場合により）:
[Using Bash: sed -i 's/updateUser/updateUserProfile/g' src/utils.ts]
```

**メリット:**
- 変更前後の差分が明確
- 置換対象が一意かどうかを自動確認
- ロールバックが容易

### ファイルの作成

新しいファイルを作成する際、Writeツールが使用されます：

```
> 新しいコンポーネントファイルを作成して

# v2.1.21以降の動作:
[Using Write tool]
[Writing src/components/NewComponent.tsx…]
[File created successfully]

# v2.1.20以前の動作（場合により）:
[Using Bash: cat > src/components/NewComponent.tsx <<EOF]
```

**メリット:**
- ファイルの上書き防止機能
- 構文チェックの統合
- より安全なパス処理

### クロスプラットフォーム互換性

Windows環境でもLinux/macOSと同じ動作が保証されます：

```
# Windows環境
> C:\Projects\myapp\src\index.tsを編集

# Editツールを使用するため、Windows特有のパス処理が不要
# sedコマンド（Windows標準では利用不可）を使わない
```

## 注意点

- この改善はv2.1.21で適用されました
- bashコマンドが完全に使用されなくなったわけではありません（git操作、npm実行など、適切な場面では引き続き使用されます）
- ファイル操作ツールは、bashコマンドよりも多くのコンテキスト情報を提供します
- Editツールは既存ファイルに対してのみ使用可能です（新規ファイルにはWriteツールを使用）
- この変更により、ファイル操作のログがより読みやすくなります
- Windows環境では特に恩恵が大きく、sedやawkのインストールが不要になります

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.21](https://github.com/anthropics/claude-code/releases/tag/v2.1.21)
- [ファイル操作ツールガイド](https://code.claude.com/docs/tools/file-operations)
- [ツール選択のベストプラクティス](https://code.claude.com/docs/best-practices/tool-selection)
