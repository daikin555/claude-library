---
title: "実行中にサブエージェントからのトークンを正しく累積するようスピナートークンカウンターを修正"
date: 2026-01-31
tags: ['バグ修正', 'トークンカウンター', 'エージェント']
---

## 原文（日本語に翻訳）

実行中にサブエージェントからのトークンを正しく累積するよう、スピナートークンカウンターを修正しました

## 原文（英語）

Fixed spinner token counter to properly accumulate tokens from subagents during execution

## 概要

Claude Code v2.1.0で修正された、トークンカウント表示バグです。以前は、Taskツールでサブエージェントを実行している際、スピナーに表示されるトークンカウンターがサブエージェントの使用トークンを含めずに表示していました。修正後は、親エージェントとサブエージェントのトークンが正しく合算されて表示されます。

## 注意点

- Claude Code v2.1.0で実装
- 階層的なエージェント実行時の正確なトークン集計
- リアルタイムでのトークン使用量表示
- コスト管理の精度向上

## 関連情報

- [Agents - Claude Code Docs](https://code.claude.com/docs/en/agents)
- [Token usage](https://code.claude.com/docs/en/tokens)
