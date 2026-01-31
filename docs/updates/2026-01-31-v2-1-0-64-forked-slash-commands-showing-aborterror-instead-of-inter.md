---
title: "フォークされたスラッシュコマンドキャンセル時にAbortErrorではなくInterruptedメッセージを表示するよう修正"
date: 2026-01-31
tags: ['バグ修正', 'スラッシュコマンド', 'エラーメッセージ']
---

## 原文（日本語に翻訳）

フォークされたスラッシュコマンドがキャンセルされた際に、"AbortError"ではなく"Interrupted"メッセージを表示するよう修正しました

## 原文（英語）

Fixed forked slash commands showing "AbortError" instead of "Interrupted" message when cancelled

## 概要

Claude Code v2.1.0で修正された、スラッシュコマンドキャンセル時のエラーメッセージ改善です。以前は、フォークされたスラッシュコマンドをキャンセルすると、技術的な"AbortError"が表示されていました。修正後は、より分かりやすい"Interrupted"（中断されました）メッセージが表示されるようになり、ユーザーフレンドリーになりました。

## 注意点

- Claude Code v2.1.0で実装
- フォークされたコマンド（バックグラウンド実行）が対象
- ユーザーフレンドリーなエラーメッセージ
- 技術的なエラー表示を排除

## 関連情報

- [Slash commands - Claude Code Docs](https://code.claude.com/docs/en/slash-commands)
- [Background tasks](https://code.claude.com/docs/en/background-tasks)
