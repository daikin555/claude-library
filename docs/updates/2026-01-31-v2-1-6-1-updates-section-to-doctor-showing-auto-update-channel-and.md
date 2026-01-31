---
title: "/doctor コマンドに更新情報セクションを追加"
date: 2026-01-13
tags: ['新機能', 'コマンド', 'アップデート', '診断']
---

## 原文（日本語に翻訳）

`/doctor` コマンドに自動更新チャンネルと利用可能なnpmバージョン（stable/latest）を表示する更新情報セクションを追加

## 原文（英語）

Added Updates section to `/doctor` showing auto-update channel and available npm versions (stable/latest)

## 概要

Claude Code v2.1.6 では、`/doctor` コマンドに更新情報セクションが追加されました。現在の自動更新チャンネル（安定版/最新版）と、利用可能なnpmバージョンが表示されるようになり、システムの更新状態を簡単に確認できます。

## 基本的な使い方

```bash
# 診断コマンドを実行
/doctor
```

実行すると、以下のような情報が表示されます：

- **Auto-update channel**: 現在の更新チャンネル（stable または latest）
- **Available versions**: npmで利用可能なバージョン一覧
- **Current version**: 現在インストールされているバージョン

## 実践例

### 更新チャンネルの確認

現在どの更新チャンネルを使用しているか確認する場合：

1. `/doctor` を実行
2. Updates セクションを確認
3. "stable" または "latest" チャンネルが表示される

### 利用可能なアップデートの確認

新しいバージョンがリリースされているか確認する場合：

1. `/doctor` を実行
2. Available versions で最新の stable と latest バージョンを確認
3. Current version と比較して更新の必要性を判断

### 更新チャンネルの切り替え

安定版から最新版に切り替えたい場合：

1. `/config` を実行して設定画面を開く
2. "release" で検索
3. Release channel 設定を "latest" に変更
4. `/doctor` で変更が反映されたことを確認

## 注意点

- この機能は Claude Code v2.1.6 で導入されました
- "stable" チャンネルは安定性が重視され、"latest" チャンネルは最新機能をいち早く利用できます
- 本番環境では "stable" チャンネルの使用を推奨します
- チャンネルの変更は `/config` コマンドから行えます（v2.1.3以降）

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3) - リリースチャンネル切り替え機能の追加
