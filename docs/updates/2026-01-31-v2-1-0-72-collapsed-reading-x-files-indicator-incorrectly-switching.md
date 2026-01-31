---
title: "ストリーム途中でthinkingブロックが表示される際にReading X files...インジケーターが過去形に切り替わる問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'UI', 'インジケーター']
---

## 原文（日本語に翻訳）

ストリーム途中でthinkingブロックが表示される際、折りたたまれた"Reading X files..."インジケーターが誤って過去形に切り替わる問題を修正しました

## 原文（英語）

Fixed collapsed "Reading X files…" indicator incorrectly switching to past tense when thinking blocks appear mid-stream

## 概要

Claude Code v2.1.0で修正された、進行状況表示のタイミングバグです。以前は、ファイル読み込み中にthinkingブロックが表示されると、まだ読み込み中にもかかわらず"Reading X files..."が"Read X files"（過去形）に切り替わっていました。修正後は、実際に完了するまで現在進行形が維持されます。

## 注意点

- Claude Code v2.1.0で実装
- 進行状況インジケーターの状態管理改善
- 時制表示の正確性向上
- ユーザーへの正確な状態通知

## 関連情報

- [UI indicators - Claude Code Docs](https://code.claude.com/docs/en/ui)
