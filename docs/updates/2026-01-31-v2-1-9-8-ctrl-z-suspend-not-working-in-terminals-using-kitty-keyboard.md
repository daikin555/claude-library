---
title: "Kittyキーボードプロトコル対応ターミナルでのCtrl+Z問題を修正"
date: 2026-01-16
tags: ['バグ修正', 'ターミナル', '互換性']
---

## 原文（日本語訳）

Kittyキーボードプロトコルを使用するターミナル（Ghostty、iTerm2、kitty、WezTerm）でCtrl+Zサスペンドが動作しない問題を修正しました。

## 原文（英語）

Fixed Ctrl+Z suspend not working in terminals using Kitty keyboard protocol (Ghostty, iTerm2, kitty, WezTerm)

## 概要

最新の高機能ターミナル（Ghostty、iTerm2、kitty、WezTermなど）で採用されているKittyキーボードプロトコルを使用している環境で、`Ctrl+Z` によるプロセスのサスペンド（一時停止）が機能しない問題が修正されました。従来、これらのターミナルでClaude Codeを実行中に `Ctrl+Z` を押しても反応せず、バックグラウンドに送ることができませんでした。v2.1.9では、Kittyキーボードプロトコルの拡張キー入力を正しく処理するようになり、標準的なUnixのジョブコントロールが期待通りに動作します。

## 問題の詳細

### Kittyキーボードプロトコルとは

Kittyキーボードプロトコルは、従来のターミナルキーボード入力の制限を克服するために開発された新しいプロトコルです。以下のような利点があります：

- すべてのキー組み合わせを区別可能（Ctrl+I と Tab、Ctrl+M と Enter など）
- 修飾キー（Shift、Ctrl、Alt）の正確な検出
- より豊富なキーイベント情報

このプロトコルは以下のターミナルで採用されています：
- **Ghostty** - 最新の高速ターミナルエミュレータ
- **iTerm2** - macOS向けの人気ターミナル
- **kitty** - GPU加速ターミナル
- **WezTerm** - クロスプラットフォームターミナル

### 発生していた症状

- `Ctrl+Z` を押しても Claude Code が一時停止しない
- ジョブコントロールコマンド（`fg`、`bg`）が使用できない
- `Ctrl+Z` が完全に無視されるか、異なる動作をする
- 標準的なUNIXワークフローが使えない

## 修正内容

v2.1.9での改善：

- Kittyキーボードプロトコルの拡張エスケープシーケンスを正しく解析
- `Ctrl+Z` を含む制御文字の適切な処理
- ターミナルの機能検出とプロトコル自動適応
- レガシーターミナルとの互換性維持

## 影響を受けていたユースケース

### マルチタスキング環境

複数のタスクを並行して実行する開発者向けワークフロー。

```bash
# Claude Codeで作業中
claude

# 一時的に別の作業が必要になった場合
# Ctrl+Z でバックグラウンドに送る
^Z
[1]  + suspended  claude

# 別の作業を実行
git status
vim config.json

# Claude Codeに戻る
fg
```

### 長時間実行タスクの一時停止

長時間のコード生成やリファクタリング中に、一時的に別の確認作業が必要な場合。

```bash
# 大規模なリファクタリング中
> Refactor the entire authentication system

# 急ぎの確認が必要になった
# Ctrl+Z で一時停止
^Z

# 確認作業
git log --oneline -10
git diff main

# 作業を再開
fg
```

### ターミナルマルチプレクサとの併用

tmux や screen と組み合わせて使用する場合。

```bash
# tmuxセッション内でClaude Codeを使用
claude

# Ctrl+Z で一時停止してtmuxのウィンドウ操作
^Z
# tmuxのコマンドを実行後
fg
```

## 対応ターミナル

この修正により、以下のターミナルで正常に動作するようになりました：

| ターミナル | OS | 特徴 |
|-----------|-----|------|
| **Ghostty** | macOS, Linux | 最新の高速ターミナル |
| **iTerm2** | macOS | 豊富な機能を持つターミナル |
| **kitty** | macOS, Linux | GPU加速、高度なカスタマイズ |
| **WezTerm** | macOS, Linux, Windows | クロスプラットフォーム、Lua設定 |

## 注意点

- この修正は、Kittyキーボードプロトコルをサポートするターミナルで自動的に適用されます
- レガシーターミナル（標準のTerminal.app、古いxtermなど）でも引き続き `Ctrl+Z` は動作します
- 一部のターミナルでは、Kittyプロトコルを手動で有効化する必要がある場合があります
- `Ctrl+Z` でバックグラウンドに送った後は、`fg` コマンドで戻ります
- Claude Codeの状態は保持されますが、実行中の処理は一時停止します

## 関連情報

- [ターミナル設定ガイド](https://code.claude.com/docs/en/terminal-config)
- [Kittyキーボードプロトコル仕様](https://sw.kovidgoyal.net/kitty/keyboard-protocol/)
- [トラブルシューティング](https://code.claude.com/docs/en/troubleshooting)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
