---
title: "コマンド検索で完全一致と前方一致を優先するよう修正"
date: 2026-01-31
tags: ['バグ修正', 'UX', 'コマンド検索']
---

## 原文（日本語に翻訳）

コマンド名の完全一致と前方一致を、説明文のファジーマッチよりも優先するようコマンド検索を修正しました

## 原文（英語）

Fixed command search to prioritize exact and prefix matches on command names over fuzzy matches in descriptions

## 概要

Claude Code v2.1.0で修正された、コマンド検索の優先度改善です。以前のバージョンでは、コマンド名の完全一致や前方一致よりも、説明文のファジーマッチが優先される場合があり、目的のコマンドを見つけにくい問題がありました。この修正により、コマンド名の直接的なマッチが最優先され、より直感的で効率的なコマンド検索が可能になりました。

## 基本的な使い方

スラッシュコマンド検索やCLIヘルプ検索で、より正確な結果が得られます。

```bash
# コマンド検索
> /commit

# 修正後の優先順位:
# 1. /commit（完全一致）
# 2. /commit-changes, /commit-all（前方一致）
# 3. 説明文に"commit"を含むコマンド（ファジーマッチ）
```

## 実践例

### スキルの検索

```bash
# "review" スキルを検索
> /review

# 修正前: 説明に"review"を含む無関係なスキルが上位に
# 修正後: /review コマンド自体が最上位に表示
```

### プラグインコマンドの検索

```bash
# "build" コマンドを検索
> build

# 検索結果の表示順:
# 1. build（完全一致）
# 2. build-docker, build-prod（前方一致）
# 3. rebuild, pre-build（説明文マッチ）
```

### CLIヘルプでの検索

```bash
claude --help | grep test

# 改善後:
# - "test" が最初に表示
# - "test-run", "test-debug" が次に表示
# - 説明に "testing" を含むコマンドは最後
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- コマンド検索の優先順位: 1) 完全一致 2) 前方一致 3) ファジーマッチ
- 大量のスキルやプラグインがある環境で特に効果的です
- インクリメンタル検索（リアルタイムフィルタリング）にも適用されます
- カスタムスキルやプラグインコマンドにも同じルールが適用されます

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Extend Claude with skills](https://code.claude.com/docs/en/skills)
