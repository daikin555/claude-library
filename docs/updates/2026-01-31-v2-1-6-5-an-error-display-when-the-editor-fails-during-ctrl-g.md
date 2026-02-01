---
title: "Ctrl+G でエディタが失敗した時のエラー表示を追加"
date: 2026-01-13
tags: ['新機能', 'エディタ', 'エラー処理', 'UI']
---

## 原文（日本語に翻訳）

Ctrl+G でエディタが失敗した時のエラー表示を追加

## 原文（英語）

Added an error display when the editor fails during Ctrl+G

## 概要

Claude Code v2.1.6 では、Ctrl+G（外部エディタ起動）が失敗した際に、エラーメッセージが表示されるようになりました。従来はエディタ起動の失敗が無言で終了していましたが、今回のアップデートにより、失敗の原因を把握しやすくなり、トラブルシューティングが容易になります。

## 基本的な使い方

1. Claude Code の入力欄で `Ctrl+G` を押す
2. 外部エディタが起動する
3. エディタで長文を編集
4. 保存して終了すると、内容が Claude Code に反映される

エディタ起動に失敗した場合:
- エラーメッセージが画面に表示される
- 失敗の原因（エディタが見つからない、権限エラーなど）が示される

## 実践例

### 正常な外部エディタ起動

長い質問やコードを編集したい場合:

1. `Ctrl+G` を押す
2. 設定されたエディタ（vim, nano, VSCode など）が起動
3. 複数行のテキストを編集
4. エディタを保存して終了
5. Claude Code に編集内容が挿入される

### エディタが設定されていない場合のエラー

エディタが正しく設定されていない場合、以下のようなエラーが表示されます:

```
Error: Editor not found
Please set EDITOR or VISUAL environment variable
```

対処法:
```bash
# bashの場合
export EDITOR=vim

# または
export VISUAL=code
```

### エディタ実行権限エラー

指定されたエディタに実行権限がない場合:

```
Error: Permission denied: /path/to/editor
```

対処法:
```bash
# エディタに実行権限を付与
chmod +x /path/to/editor

# または、環境変数を正しいパスに設定
export EDITOR=/usr/bin/vim
```

### エディタクラッシュ時のエラー

エディタが異常終了した場合:

```
Error: Editor exited with code 1
Changes may not have been saved
```

このエラーが表示された場合、編集内容が失われている可能性があるため、再度編集を試みます。

### 設定を確認する

どのエディタが使用されるか確認:

```bash
# 現在のエディタ設定を確認
echo $EDITOR
echo $VISUAL

# Claude Codeの設定を確認
/config
# "editor" で検索
```

## 注意点

- この機能は Claude Code v2.1.6 で導入されました
- Ctrl+G はシステムの `EDITOR` または `VISUAL` 環境変数で指定されたエディタを起動します
- エディタが見つからない場合やクラッシュした場合、明確なエラーメッセージが表示されるようになりました
- Windows では `Ctrl+G` の動作が異なる場合があります
- エディタの起動に失敗した場合、入力内容は失われません（元の入力欄に残ります）
- GUIエディタ（VSCode, Sublime など）を使用する場合、`--wait` フラグが必要な場合があります

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code エディタ設定](https://code.claude.com/docs/configuration#editor)
