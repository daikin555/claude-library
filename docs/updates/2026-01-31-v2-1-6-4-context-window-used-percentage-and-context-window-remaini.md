---
title: "ステータスラインにコンテキストウィンドウの使用率表示を追加"
date: 2026-01-13
tags: ['新機能', 'ステータスライン', 'コンテキストウィンドウ', 'UI']
---

## 原文（日本語に翻訳）

ステータスライン入力に `context_window.used_percentage` と `context_window.remaining_percentage` フィールドを追加し、コンテキストウィンドウの表示を容易化

## 原文（英語）

Added `context_window.used_percentage` and `context_window.remaining_percentage` fields to status line input for easier context window display

## 概要

Claude Code v2.1.6 では、ステータスラインのカスタマイズに新しいフィールドが追加されました。`context_window.used_percentage`（使用率）と `context_window.remaining_percentage`（残量率）により、コンテキストウィンドウの利用状況をパーセント表示で確認できるようになりました。これにより、現在の会話がコンテキスト制限にどれだけ近づいているかを視覚的に把握しやすくなります。

## 基本的な使い方

1. `/config` コマンドで設定画面を開く
2. "status" で検索してステータスライン設定を見つける
3. `statusLine.format` 設定を編集
4. `{context_window.used_percentage}` または `{context_window.remaining_percentage}` を追加

```bash
# 設定画面を開く
/config

# statusLine.format に以下のようなフィールドを追加
# 例: "Context: {context_window.used_percentage}% used"
# 例: "Remaining: {context_window.remaining_percentage}%"
```

## 実践例

### 使用率をステータスラインに表示

コンテキストウィンドウの使用率を常時表示する場合:

```
statusLine.format: "Model: {model} | Context: {context_window.used_percentage}% used"
```

これにより、ステータスラインに「Context: 45% used」のように表示されます。

### 残量率で警告を視覚化

残りのコンテキストウィンドウを表示して、会話の継続可能性を確認:

```
statusLine.format: "{model} | Remaining: {context_window.remaining_percentage}%"
```

コンテキストが少なくなってきた場合に、残量をパーセンテージで確認できます。

### 詳細なステータス表示

使用率と残量率を組み合わせて表示:

```
statusLine.format: "Model: {model} | Context: {context_window.used_percentage}%/{context_window.remaining_percentage}% left"
```

現在の使用状況と残量を一目で確認できます。

### プログレスバー風の表示

既存のトークン数表示と組み合わせる:

```
statusLine.format: "{tokens}/{max_tokens} ({context_window.used_percentage}%)"
```

トークン数と使用率の両方を表示することで、より詳細な状況把握が可能になります。

## 注意点

- この機能は Claude Code v2.1.6 で導入されました
- パーセンテージは整数値で表示されます（小数点以下は切り捨て）
- ステータスラインのカスタマイズは `/config` から `statusLine.format` を編集して行います
- 使用率が100%に近づくと、会話の圧縮や新規セッションの開始が必要になる場合があります
- `{context_window.used}` や `{context_window.remaining}` などの既存フィールドと併用可能です

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code ステータスライン設定](https://code.claude.com/docs/configuration#status-line)
