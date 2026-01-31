---
title: "サブエージェントが親のモデルを継承しない問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'エージェント', 'モデル']
---

## 原文（日本語に翻訳）

サブエージェントが親のモデルをデフォルトで継承しないことがある問題を修正しました

## 原文（英語）

Fixed subagents sometimes not inheriting the parent's model by default

## 概要

Claude Code v2.1.0で修正された、エージェント階層でのモデル継承バグです。以前は、親エージェントでOpusを使用していても、サブエージェント（Taskツールで起動）がSonnetで実行されることがありました。修正後は、サブエージェントが明示的にモデルを指定しない限り、親のモデル設定を自動的に継承します。claude --model opusでTaskツールを使うと、サブエージェントもOpusを使用します。

## 注意点

- Claude Code v2.1.0で実装
- モデル継承順序: サブエージェント明示指定 > 親モデル > デフォルト
- コスト管理: 親でhaikuを使用すれば、サブエージェントもhaikuで動作

## 関連情報

- [Agents - Claude Code Docs](https://code.claude.com/docs/en/agents)
- [Model selection](https://code.claude.com/docs/en/models)
