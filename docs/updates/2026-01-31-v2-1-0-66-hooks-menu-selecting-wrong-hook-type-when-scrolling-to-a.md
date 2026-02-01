---
title: "/hooksメニューでスクロール時に間違ったフックタイプが選択される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'hooks', 'UI']
---

## 原文（日本語に翻訳）

`/hooks`メニューで別のオプションにスクロールする際に、間違ったフックタイプが選択される問題を修正しました

## 原文（英語）

Fixed `/hooks` menu selecting wrong hook type when scrolling to a different option

## 概要

Claude Code v2.1.0で修正された、フック設定メニューのUI選択バグです。以前は、`/hooks`メニューで矢印キーやマウスでスクロールして別のフックタイプに移動する際、意図しない別のフックタイプが選択されることがありました。修正後は、スクロール操作が正確に反映され、選択したフックタイプが確実に選ばれます。

## 注意点

- Claude Code v2.1.0で実装
- フック設定UIの選択精度向上
- スクロール時の選択状態管理を改善
- 意図しないフック設定変更を防止

## 関連情報

- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
