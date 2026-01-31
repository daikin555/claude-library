---
title: "タブ補完で入力フィールドが更新されない問題を修正"
date: 2026-01-29
tags: ['バグ修正', 'UI', 'タブ補完', 'インタラクティブ']
---

## 原文（日本語に翻訳）

サジェスチョンを受け入れたときに、タブ補完が入力フィールドを更新しない問題を修正

## 原文（英語）

Fixed tab completion not updating the input field when accepting a suggestion

## 概要

Claude Codeのインタラクティブモードでタブ補完を使用した際、Tabキーでサジェスチョンを受け入れても入力フィールドに反映されない問題が修正されました。これにより、ファイルパスやコマンドの入力がよりスムーズになり、ユーザー体験が向上します。特に長いファイルパスや複雑なコマンドを入力する際に、効率的に作業できるようになりました。

## 基本的な使い方

タブ補完は、ファイルパスやコマンドの一部を入力してTabキーを押すことで、候補を表示・選択できる機能です。

### ファイルパス補完

```bash
claude

> このファイルを読んでください: src/co[TAB]
# 自動的に補完される
> このファイルを読んでください: src/components/
```

### コマンド補完

```bash
> /com[TAB]
# /commit に補完される
```

## 実践例

### 深い階層のファイルパス入力

修正前は、Tabキーを押してもテキストが更新されませんでした。

```bash
# v2.1.22以前の問題
> src/co[TAB]
# 候補: components/ config/ core/
# [Tab]を押しても入力フィールドが更新されない

# v2.1.23以降
> src/co[TAB]
# 候補: components/ config/ core/
> src/components/  ← 正しく更新される
```

### 複数階層の連続補完

```bash
# 長いパスを効率的に入力
> src/[TAB]
> src/components/[TAB]
> src/components/auth/[TAB]
> src/components/auth/LoginForm.tsx  ← すべて正しく反映
```

### スラッシュコマンドの補完

Claude Codeの組み込みコマンドの入力：

```bash
> /[TAB]
# 候補: /help, /clear, /commit, /review-pr など

> /com[TAB]
> /commit  ← 補完される

> /review-pr [TAB]
# PR番号の候補が表示される（設定している場合）
```

### 設定ファイルパスの補完

```bash
> ~/.claude/[TAB]
> ~/.claude/settings.json  ← 設定ファイルパスを簡単に入力
```

### プロジェクト内のファイル検索

```bash
> このファイルを最適化してください: test/[TAB]
# 候補: test/unit/ test/integration/ test/e2e/

> このファイルを最適化してください: test/unit/[TAB]
# 候補: auth.test.ts api.test.ts utils.test.ts
```

## 注意点

- タブ補完は、現在の作業ディレクトリを基準に候補を表示します
- 候補が1つしかない場合は、Tabキー1回で自動的に補完されます
- 候補が複数ある場合は、Tabキーを2回押すことで候補一覧が表示されます
- ファイル名やディレクトリ名に空白が含まれる場合、自動的に引用符で囲まれます
- 隠しファイル（`.`で始まるファイル）も補完候補に含まれます
- 大文字小文字の区別は、使用しているOSのファイルシステムに依存します（Windowsは区別なし、Linux/macOSは区別あり）
- 非常に多くのファイルがあるディレクトリでは、候補の表示に時間がかかる場合があります
- ネットワークドライブやリモートファイルシステムでは、補完が遅くなることがあります

## 関連情報

- [シェルのタブ補完について](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
- [効率的なコマンドライン操作のヒント](https://github.com/jlevy/the-art-of-command-line)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- Claude Codeのキーボードショートカットについては、`/help`コマンドを参照してください
