---
title: "引数付きコマンド入力時の引数ヒントちらつきを修正"
date: 2026-01-31
tags: ['バグ修正', 'UX', 'スラッシュコマンド']
---

## 原文（日本語に翻訳）

引数を持つコマンドを入力する際の、スラッシュコマンド引数ヒントのちらつきと不整合な表示を修正しました

## 原文（英語）

Fixed slash command argument hint flickering and inconsistent display when typing commands with arguments

## 概要

Claude Code v2.1.0で修正された、スラッシュコマンドUIの視覚バグです。以前のバージョンでは、引数を受け取るスラッシュコマンド（例: `/commit -m "message"`）を入力している際、引数のヒント表示が点滅したり、不整合な状態で表示されたりしていました。この修正により、引数ヒントが安定して表示されるようになり、コマンド入力体験が改善されました。

## 修正前の問題

```bash
# 引数を持つコマンドを入力
> /comm

# 引数ヒントが表示される（点滅）
/commit [--amend] [--message <msg>]
# ↑ ちらつく

# 文字を追加するたびに点滅
> /commi
# ヒント消える → 表示される → 消える → 表示される

# 不整合な表示
> /commit -
# ヒント: [--message <msg>]  # 既に入力した --amend が表示される
# 混乱を招く
```

## 修正後の動作

```bash
# 引数を持つコマンドを入力
> /comm

# 引数ヒントが安定表示
/commit [--amend] [--message <msg>]
# ✓ ちらつかない

# 文字を追加
> /commi
# ヒントが常に表示される（安定）

# 整合性のある表示
> /commit -
# ヒント: [--amend] [--message <msg>]
# ✓ 正しい引数が表示される
```

## 実践例

```bash
# コミットメッセージ付きコミット
> /commit --message "Fix bug"
# 修正後: 引数ヒントが安定表示、入力しやすい

# PRレビュー（PR番号指定）
> /review-pr 123
# ヒント: [PR number]
# ✓ 安定表示

# デプロイコマンド（環境指定）
> /deploy production
# ヒント: [environment]
# ✓ ちらつかない
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- 引数ヒント表示のタイミング改善
- UI再描画ロジックの最適化
- 引数の状態追跡の改善

## 関連情報

- [Slash commands - Claude Code Docs](https://code.claude.com/docs/en/slash-commands)
