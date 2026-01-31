---
title: "スライスされた文字列が大きな親文字列を保持するgit diffパース時のメモリリークを修正"
date: 2026-01-31
tags: ['バグ修正', 'パフォーマンス', 'メモリリーク', 'git']
---

## 原文（日本語に翻訳）

スライスされた文字列が大きな親文字列を保持してしまう、git diffパース時のメモリリークを修正しました

## 原文（英語）

Fixed memory leak in git diff parsing where sliced strings retained large parent strings

## 概要

Claude Code v2.1.0で修正された、メモリ管理バグです。以前は、`git diff`の出力をパースする際、JavaScriptの文字列スライス操作により、小さな文字列断片が元の巨大な文字列全体への参照を保持し続け、メモリリークが発生していました。修正後は、文字列が適切にコピーされ、不要なメモリが解放されます。

## 注意点

- Claude Code v2.1.0で実装
- 大規模なgit diffでのメモリ使用量削減
- 長時間セッションでの安定性向上
- パフォーマンス改善

## 関連情報

- [Git integration - Claude Code Docs](https://code.claude.com/docs/en/git)
