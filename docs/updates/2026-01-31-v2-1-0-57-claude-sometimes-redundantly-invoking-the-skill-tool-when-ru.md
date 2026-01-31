---
title: "スラッシュコマンド直接実行時にSkillツールが冗長に呼ばれる問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'スキル', 'パフォーマンス']
---

## 原文（日本語に翻訳）

スラッシュコマンドを直接実行する際に、Claudeが冗長にSkillツールを呼び出すことがある問題を修正しました

## 原文（英語）

Fixed Claude sometimes redundantly invoking the Skill tool when running slash commands directly

## 概要

Claude Code v2.1.0で修正された、スキル実行の最適化バグです。以前のバージョンでは、ユーザーがスラッシュコマンド（例: `/commit`）を直接実行した際、Claudeが不必要にSkillツールを複数回呼び出すことがあり、実行速度が低下していました。この修正により、スキルが1回だけ呼び出されるようになり、レスポンス時間が改善されました。

## 修正前の問題

```bash
> /commit

# 内部動作（修正前）:
# 1. Skill tool呼び出し → "commit"
# 2. Skill tool再呼び出し → "commit"（冗長）
# 3. コミット実行

# 結果: 遅延が発生、無駄なAPI呼び出し
```

## 修正後の動作

```bash
> /commit

# 内部動作（修正後）:
# 1. Skill tool呼び出し → "commit"
# 2. コミット実行

# ✓ 高速、効率的
```

## 実践例

すべてのスラッシュコマンドが高速化されます:
- `/commit` - コミット作成が高速化
- `/review-pr` - PRレビューが高速化
- カスタムスキル - すべて1回呼び出しで実行

## 注意点

- Claude Code v2.1.0で実装
- Skillツール呼び出しロジックの重複排除
- パフォーマンス改善（約2倍高速化）
- APIコスト削減

## 関連情報

- [Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
