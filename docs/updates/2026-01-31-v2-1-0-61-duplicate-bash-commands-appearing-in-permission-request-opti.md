---
title: "パーミッション要求オプションに重複Bashコマンドが表示される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'パーミッション', 'UI', 'Bash']
---

## 原文（日本語に翻訳）

パーミッション要求のオプションラベルに重複したBashコマンドが表示される問題を修正しました

## 原文（英語）

Fixed duplicate Bash commands appearing in permission request option labels

## 概要

Claude Code v2.1.0で修正された、パーミッションダイアログ表示バグです。以前は、Bashコマンドの承認を求める際、同じコマンドが複数回表示されていました。修正後は、コマンドが1回のみ表示され、選択肢が明確になりました。パーミッション要求ダイアログで、コマンドが重複せず1回のみ表示されます。

## 注意点

- Claude Code v2.1.0で実装
- パーミッションダイアログのUI改善
- 選択肢の可読性向上
- 混乱を招く重複表示を排除

## 関連情報

- [Permissions - Claude Code Docs](https://code.claude.com/docs/en/permissions)
