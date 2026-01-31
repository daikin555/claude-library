---
title: "Escキャンセル時にキューされたプロンプトの画像が[object Object]と表示される問題を修正"
date: 2026-01-31
tags: ['バグ修正', '画像', 'UI']
---

## 原文（日本語に翻訳）

Escキーを押してキャンセルする際に、キューされたプロンプト内の画像が"[object Object]"と表示される問題を修正しました

## 原文（英語）

Fixed images in queued prompts showing as "[object Object]" when pressing Esc to cancel

## 概要

Claude Code v2.1.0で修正された、画像表示のバグです。以前は、画像を含むプロンプトがキューに入っている状態でEscキーを押してキャンセルすると、画像が技術的なエラー表記"[object Object]"として表示されていました。修正後は、画像が正しくプレビュー表示またはファイル名として表示されます。

## 注意点

- Claude Code v2.1.0で実装
- 画像オブジェクトの文字列変換を修正
- キャンセル時のUI表示改善
- ユーザーフレンドリーな画像表示

## 関連情報

- [Image support - Claude Code Docs](https://code.claude.com/docs/en/images)
