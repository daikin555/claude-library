---
title: "[VSCode] コンテキストメニューに現在選択中のモデル名を追加"
date: 2026-01-31
tags: ['新機能', 'VSCode', 'モデル', 'UI']
---

## 原文（日本語に翻訳）

[VSCode] コンテキストメニューに現在選択中のモデル名を追加しました

## 原文（英語）

[VSCode] Added currently selected model name to the context menu

## 概要

Claude Code for VSCode v2.1.0で追加された、モデル表示機能です。以前のバージョンでは、現在使用中のClaudeモデル（Sonnet、Opus、Haikuなど）がコンテキストメニューに表示されず、設定画面を開いて確認する必要がありました。この追加により、コンテキストメニューから即座にモデルを確認・切り替えできるようになりました。

## 追加前の動作

```
# VSCodeでコンテキストメニューを開く
右クリック → Claude Code

# 表示項目:
• Ask Claude
• Explain Code
• Fix Issues
• Settings...

# モデル名は表示されない
# 設定画面を開いて確認が必要
```

## 追加後の動作

```
# 同じ操作
右クリック → Claude Code

# 表示項目:
━━━━━━━━━━━━━━━━━━━
Model: Sonnet 4.5  ← 追加！
━━━━━━━━━━━━━━━━━━━
• Ask Claude
• Explain Code
• Fix Issues
• Change Model...
• Settings...

# ✓ モデルが一目で分かる
# ✓ 素早く切り替え可能
```

## 実践例

### モデルの確認

```
# 現在のモデルを確認
右クリック → Claude Code
→ Model: Opus 4.5

# 別のファイルで確認
右クリック → Claude Code
→ Model: Haiku 3.5

# ✓ ファイルごとのモデル設定が分かる
```

### モデル切り替え

```
# コストの高いタスク
右クリック → Claude Code
→ Model: Opus 4.5
→ Change Model... → Sonnet 4.5

# 簡単なタスク
右クリック → Claude Code
→ Model: Sonnet 4.5
→ Change Model... → Haiku 3.5

# ✓ 素早い切り替え
```

## 注意点

- VSCode extension v2.1.0で追加
- 表示される情報:
  - モデル名: Sonnet 4.5, Opus 4.5, Haiku 3.5
  - モデルアイコン
  - Change Model... メニュー
- クリックで切り替え:
  - Model名をクリック → モデル選択ダイアログ
  - Change Model... → 同じダイアログ
- 設定の保存:
  - ワークスペース単位
  - グローバル設定も可能

## 関連情報

- [VSCode extension - Claude Code](https://marketplace.visualstudio.com/items?itemName=Anthropic.claude-code)
- [Model selection](https://code.claude.com/docs/en/models)
