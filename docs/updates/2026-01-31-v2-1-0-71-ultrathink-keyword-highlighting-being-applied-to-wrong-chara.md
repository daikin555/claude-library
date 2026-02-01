---
title: "プロンプトが複数行に折り返す際にultrathinkキーワードハイライトが間違った文字に適用される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'UI', 'ハイライト']
---

## 原文（日本語に翻訳）

ユーザープロンプトのテキストが複数行に折り返す際、ultrathinkキーワードハイライトが間違った文字に適用される問題を修正しました

## 原文（英語）

Fixed ultrathink keyword highlighting being applied to wrong characters when user prompt text wraps to multiple lines

## 概要

Claude Code v2.1.0で修正された、シンタックスハイライト表示バグです。以前は、長いプロンプトが画面幅を超えて複数行に折り返す際、`ultrathink`などのキーワードハイライトが間違った位置の文字に適用されていました。修正後は、テキストが折り返してもハイライトが正しい位置に表示されます。

## 注意点

- Claude Code v2.1.0で実装
- 行折り返し時の文字位置計算を修正
- キーワードハイライトの正確性向上
- 長いプロンプトでも正確な表示

## 関連情報

- [Extended thinking - Claude Code Docs](https://code.claude.com/docs/en/extended-thinking)
