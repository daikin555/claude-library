---
title: "lsやcatなどのBash読み取りコマンドが折りたたみグループでカウントされずRead 0 filesと表示される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'Bash', 'UI', 'カウンター']
---

## 原文（日本語に翻訳）

`ls`や`cat`などのBash読み取りコマンドが、折りたたまれた読み取り/検索グループでカウントされず、グループに誤って"Read 0 files"と表示される問題を修正しました

## 原文（英語）

Fixed Bash read commands (like `ls` and `cat`) not being counted in collapsed read/search groups, causing groups to incorrectly show "Read 0 files"

## 概要

Claude Code v2.1.0で修正された、ファイルカウンター表示バグです。以前は、Bashツールで`ls`や`cat`コマンドを使用してファイルを読み取った場合、折りたたまれた表示で正しくカウントされず、"Read 0 files"と表示されていました。修正後は、Bashコマンド経由の読み取りも正確にカウントされます。

## 注意点

- Claude Code v2.1.0で実装
- Bash読み取りコマンドの検出ロジック改善
- 正確なファイルカウント表示
- すべての読み取り方法を統一的にカウント

## 関連情報

- [Bash tool - Claude Code Docs](https://code.claude.com/docs/en/bash)
