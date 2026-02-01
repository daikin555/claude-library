---
title: "/config コマンドに検索機能を追加"
date: 2026-01-13
tags: ['新機能', 'コマンド', '設定', '検索']
---

## 原文（日本語に翻訳）

`/config` コマンドに設定を素早くフィルタリングするための検索機能を追加

## 原文（英語）

Added search functionality to `/config` command for quickly filtering settings

## 概要

Claude Code v2.1.6 では、`/config` コマンドに検索機能が追加されました。これにより、多数の設定項目の中から必要な設定を素早く見つけることができます。設定の確認や変更がより効率的になります。

## 基本的な使い方

1. `/config` コマンドを実行して設定画面を開く
2. 検索フィールドにキーワードを入力
3. 入力したキーワードに一致する設定項目のみが表示される
4. 目的の設定を見つけて変更する

```bash
# 設定画面を開く
/config

# 画面内で検索キーワードを入力（例: "model", "theme", "timeout" など）
```

## 実践例

### モデル関連の設定を検索

モデルに関する設定を素早く見つけたい場合：

1. `/config` を実行
2. "model" と入力
3. `defaultModel`、`modelPreferences` などモデル関連の設定のみが表示される

### テーマ設定を検索

UIテーマを変更したい場合：

1. `/config` を実行
2. "theme" と入力
3. テーマ関連の設定が絞り込まれる

### タイムアウト設定の確認

コマンドのタイムアウト設定を確認・変更したい場合：

1. `/config` を実行
2. "timeout" と入力
3. 各種タイムアウト関連の設定が表示される

## 注意点

- この機能は Claude Code v2.1.6 で導入されました
- 検索は設定項目の名前と説明に対して行われます
- 部分一致で検索されるため、一部のキーワードでも関連設定を見つけられます
- 大文字小文字は区別されません

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code リリースノート](https://github.com/anthropics/claude-code/releases)
