---
title: "CJK文字含む複数行プロンプトに余分な空白行が入る問題を修正"
date: 2026-01-31
tags: ['バグ修正', '国際化', 'CJK', '日本語']
---

## 原文（日本語に翻訳）

CJK文字（日本語、中国語、韓国語）を含む複数行プロンプトに余分な空白行が入る問題を修正しました

## 原文（英語）

Fixed extra blank lines in multiline prompts containing CJK characters (Japanese, Chinese, Korean)

## 概要

Claude Code v2.1.0で修正された、日本語など東アジア言語のテキスト処理バグです。以前は、日本語・中国語・韓国語などのCJK文字を含む複数行のプロンプトを入力すると、意図しない空白行が挿入されていました。修正後は、CJK文字が正しく処理され、余分な空白行が挿入されなくなりました。

## 注意点

- Claude Code v2.1.0で実装
- CJK文字の文字幅計算を改善
- 日本語ユーザーの入力体験向上
- 複数行テキストの正確な表示

## 関連情報

- [International support - Claude Code Docs](https://code.claude.com/docs/en/international)
