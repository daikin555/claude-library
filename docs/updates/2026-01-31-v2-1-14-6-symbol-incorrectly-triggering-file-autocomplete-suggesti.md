---
title: "bashモードでの@記号による誤ったファイル補完の修正"
date: 2026-01-20
tags: ['バグ修正', 'bash', 'オートコンプリート']
---

## 原文（日本語に翻訳）

bashモードで `@` 記号が誤ってファイルのオートコンプリート候補を表示する問題を修正

## 原文（英語）

Fixed `@` symbol incorrectly triggering file autocomplete suggestions in bash mode

## 概要

Claude Codeのbashモードにおいて、`@` 記号を入力した際に意図せずファイルのオートコンプリート候補が表示されてしまうバグを修正しました。この修正により、bashコマンドを入力する際の操作性が向上し、`@` 記号を含むコマンド（例: メールアドレス、Gitのリモートリポジトリなど）をスムーズに入力できるようになりました。

## 基本的な使い方

bashモードで `@` 記号を含む入力を行う際、以前のバージョンでは不要なファイル補完が表示されていましたが、v2.1.14以降では正常に動作します。

```bash
# bashモードで以下のような入力がスムーズに行えます
git config user.email user@example.com
```

## 実践例

### Gitのユーザー設定

以前は `@` を入力した時点でファイル補完が表示されましたが、修正後は問題なく設定できます。

```bash
git config --global user.email developer@company.com
git config --global user.name "Developer Name"
```

### リモートリポジトリの追加

SSH形式のGitリポジトリURLに含まれる `@` 記号でも補完が邪魔しません。

```bash
git remote add origin git@github.com:username/repository.git
git push -u origin main
```

### メールコマンドの使用

メールアドレスを引数に取るコマンドでも快適に入力できます。

```bash
# メール送信コマンドの例
mail -s "Subject" user@example.com < message.txt

# curlでのAPI呼び出し（認証情報を含む）
curl -u admin@site.com:password https://api.example.com/data
```

### bashスクリプト内での変数展開

`@` を含む変数や配列操作も正しく認識されます。

```bash
# 配列の全要素を展開
echo "${array[@]}"

# コマンド置換での使用
users=$(cat /etc/passwd | grep @)
```

## 注意点

- この修正は Claude Code v2.1.14 で適用されました
- bashモード以外（通常の会話モードなど）での `@` メンション機能は引き続き正常に動作します
- ファイルやディレクトリを参照したい場合は、従来通り `@` メンション機能を使用できます
- この修正により、bashコマンドの入力中に不要な補完候補が表示されることが大幅に減少しました

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
- [bashモードの使い方](https://code.claude.com/docs/bash-mode)
- [@メンション機能について](https://code.claude.com/docs/mentions)
