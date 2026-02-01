---
title: "大きな画像ペースト時に「画像が大きすぎます」エラーが発生する問題を修正"
date: 2026-01-31
tags: ['バグ修正', '画像', 'エラー処理']
---

## 原文（日本語に翻訳）

大きなペースト画像が"Image was too large"エラーで失敗する問題を修正しました

## 原文（英語）

Fixed large pasted images failing with "Image was too large" error

## 概要

Claude Code v2.1.0で修正された、画像サイズ処理バグです。以前は、許容範囲内のサイズの画像をペーストしても、誤って"Image was too large"（画像が大きすぎます）エラーが発生することがありました。修正後は、画像サイズの判定が正確になり、適切なサイズの画像は正常に処理されます。

## 注意点

- Claude Code v2.1.0で実装
- 画像サイズ判定ロジックの修正
- 実際のAPI制限に合わせた正確な検証
- より大きな画像のサポート

## 関連情報

- [Image support - Claude Code Docs](https://code.claude.com/docs/en/images)
- [API limits](https://docs.anthropic.com/claude/reference/errors-and-limits)
