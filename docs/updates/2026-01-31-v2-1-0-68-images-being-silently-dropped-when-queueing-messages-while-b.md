---
title: "タスクバックグラウンド化中にメッセージキュー時に画像が無言で削除される問題を修正"
date: 2026-01-31
tags: ['バグ修正', '画像', 'バックグラウンドタスク']
---

## 原文（日本語に翻訳）

タスクをバックグラウンド化している間にメッセージをキューイングする際、画像が無言で削除される問題を修正しました

## 原文（英語）

Fixed images being silently dropped when queueing messages while backgrounding a task

## 概要

Claude Code v2.1.0で修正された、画像データ損失バグです。以前は、バックグラウンドタスク実行中に新しいメッセージ（画像付き）をキューに追加すると、画像が警告なく削除されていました。修正後は、画像が確実に保持され、タスク完了後に正しく送信されます。

## 注意点

- Claude Code v2.1.0で実装
- バックグラウンドタスクとメッセージキューの同期改善
- 画像データの確実な保持
- データ損失の防止

## 関連情報

- [Background tasks - Claude Code Docs](https://code.claude.com/docs/en/background-tasks)
- [Image support](https://code.claude.com/docs/en/images)
