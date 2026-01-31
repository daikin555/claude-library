---
title: "起動時にLSPツールが「サーバーが利用できません」を返す競合状態を修正"
date: 2026-01-31
tags: ['バグ修正', 'LSP', '競合状態']
---

## 原文（日本語に翻訳）

起動時にLSPツールが"no server available"（サーバーが利用できません）を返す競合状態を修正しました

## 原文（英語）

Fixed race condition where LSP tool could return "no server available" during startup

## 概要

Claude Code v2.1.0で修正された、Language Server Protocol（LSP）の初期化タイミングバグです。以前は、Claude Code起動直後にLSP機能を使用しようとすると、LSPサーバーの初期化が完了していないために"no server available"エラーが発生することがありました。修正後は、LSPサーバーの起動完了を適切に待機してから処理を開始します。

## 注意点

- Claude Code v2.1.0で実装
- LSP起動時の同期処理改善
- 起動直後のLSP機能利用の信頼性向上
- 競合状態の解消

## 関連情報

- [LSP integration - Claude Code Docs](https://code.claude.com/docs/en/lsp)
