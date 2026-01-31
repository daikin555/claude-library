---
title: "質問への回答時に外部エディタを使用可能に（Ctrl+G）"
date: 2026-01-16
tags: ['新機能', 'UX改善', 'エディタ統合']
---

## 原文（日本語訳）

AskUserQuestion の「Other」入力フィールドで外部エディタのサポート（Ctrl+G）を追加しました。

## 原文（英語）

Added external editor support (Ctrl+G) in AskUserQuestion "Other" input field

## 概要

Claudeが質問してきたときの回答入力時に、外部エディタを使用できるようになりました。複数行の入力や、より複雑な回答を記述する際に、使い慣れたエディタ（VSCode、vim、emacsなど）を使用できます。AskUserQuestionツールの「Other」選択肢（カスタムテキスト入力）で `Ctrl+G` を押すと、設定されているエディタが起動します。

## 基本的な使い方

AskUserQuestionで質問に答える際、「Other」を選択してカスタム入力を行うときに `Ctrl+G` を押します。

1. Claudeが選択肢を提示する質問をする
2. 「Other」を選択（または自動的に表示されるテキスト入力）
3. `Ctrl+G` を押す
4. 外部エディタが起動する
5. エディタで回答を記述し、保存して閉じる
6. 入力内容がClaude Codeに反映される

デフォルトのエディタは環境変数 `EDITOR` または `VISUAL` で設定されているものが使用されます。

## 実践例

### VSCodeで回答を記述

```bash
# VSCodeを外部エディタとして設定
export EDITOR="code --wait"
claude
```

Claudeの質問に対して `Ctrl+G` を押すと、VSCodeが起動して長文を入力できます。

### vimで回答を編集

```bash
# vimをエディタとして使用
export EDITOR="vim"
claude
```

`Ctrl+G` でvimが起動し、使い慣れたキーバインドで回答を作成できます。

### 複数行の構造化データを入力

Claudeが設定情報を尋ねてきたときに、外部エディタでJSON構造を整形して入力できます。

```
Claude> どのような設定が必要ですか？
You> [Other を選択]
You> [Ctrl+G を押す]
[エディタで以下を記述]
{
  "timeout": 30,
  "retries": 3,
  "endpoints": [
    "https://api.example.com/v1",
    "https://backup.example.com/v1"
  ]
}
```

### コードスニペットを貼り付け

既存のコードをベースにした回答を作成する際、エディタで編集・整形してからClaude Codeに渡せます。

## 注意点

- この機能はAskUserQuestionの「Other」入力フィールドでのみ使用可能です
- エディタが設定されていない場合、`Ctrl+G` は機能しません
- エディタは `--wait` フラグをサポートしている必要があります（保存後にClaude Codeに制御が戻るため）
- VSCodeの場合は `code --wait`、Sublime Textの場合は `subl --wait` など
- 一部のターミナル環境では `Ctrl+G` が別の機能にバインドされている場合があります

## 関連情報

- [Interactive Mode公式ドキュメント](https://code.claude.com/docs/en/interactive-mode)
- [エディタ設定の詳細](https://code.claude.com/docs/en/settings)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
