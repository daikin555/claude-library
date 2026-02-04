---
title: "/contextでスキルトークン推定値がfrontmatter表示を正確に反映するよう修正"
date: 2026-01-31
tags: ['バグ修正', 'スキル', 'コンテキスト']
---

## 原文（日本語に翻訳）

`/context`でスキルのトークン推定値が、frontmatterのみのロード状態を正確に反映するよう修正しました

## 原文（英語）

Fixed skill token estimates in `/context` to accurately reflect frontmatter-only loading

## 概要

Claude Code v2.1.0で修正された、コンテキスト表示のスキルトークン推定バグです。以前は、スキルの本文がロードされていなくてもフルサイズのトークン数が表示されていました。修正後は、frontmatterのみロード時は正確な小さいトークン数が表示され、コンテキスト管理が正確になりました。Ctrl+O → Contextタブでスキルトークン数を確認すると、ロード状態に応じた正確な値が表示されます。

## 注意点

- Claude Code v2.1.0で実装
- スキルはfrontmatterのみロード時と全体ロード時で異なるトークン数
- 正確なトークン推定により、コンテキストウィンドウ管理が改善

## 関連情報

- [Context management - Claude Code Docs](https://code.claude.com/docs/en/context-management)
- [Skills](https://code.claude.com/docs/en/skills)
