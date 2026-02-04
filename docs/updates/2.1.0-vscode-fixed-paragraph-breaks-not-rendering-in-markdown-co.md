---
title: "[VSCode] Markdownコンテンツで段落区切りが表示されないバグを修正"
date: 2026-01-31
tags: ['バグ修正', 'VSCode', 'Markdown', 'レンダリング']
---

## 原文（日本語に翻訳）

[VSCode] Markdownコンテンツで段落区切りが正しく表示されないバグを修正しました

## 原文（英語）

[VSCode] Fixed paragraph breaks not rendering in markdown content

## 概要

Claude Code for VSCode v2.1.0で修正された、Markdownレンダリングのバグです。以前のバージョンでは、Claudeの応答内で段落区切り（空行）が無視され、すべてのテキストが1つの段落として表示される問題がありました。この修正により、Markdown形式の応答が正しくフォーマットされ、読みやすく表示されるようになりました。

## 修正前の動作

```markdown
Claude's response:

# Title
This is the first paragraph with some explanation about the topic.
This should be a separate paragraph but it appears merged.
Another paragraph that should be separated.

# 表示（修正前）:
# Title
This is the first paragraph with some explanation about the topic. This should be a separate paragraph but it appears merged. Another paragraph that should be separated.

# 問題点:
# - 段落が区切られない
# - 読みにくい
# - Markdown仕様に反する
```

## 修正後の動作

```markdown
# 同じ応答
# Title
This is the first paragraph with some explanation about the topic.

This should be a separate paragraph but it appears merged.

Another paragraph that should be separated.

# 表示（修正後）:
# Title

This is the first paragraph with some explanation about the topic.

This should be a separate paragraph but it appears merged.

Another paragraph that should be separated.

# ✓ 段落が正しく区切られる
# ✓ 読みやすい
# ✓ 適切なスペーシング
```

## 実践例

### コード説明

```markdown
# Claude's explanation:

This function validates user input.

It performs the following checks:
1. Email format
2. Password strength
3. Required fields

If validation fails, it returns an error.

# 修正後:
# 段落ごとに区切られて読みやすい
```

### 長文ドキュメント

```markdown
# API Documentation

## Overview
This API provides access to user data.

## Authentication
Use Bearer tokens for authentication.

## Endpoints
Available endpoints are listed below.

# ✓ セクションごとに適切なスペース
```

## 注意点

- VSCode extension v2.1.0で修正
- 修正内容:
  - 空行（`\n\n`）を段落区切りとして認識
  - 適切なマージンを適用
- 影響範囲:
  - Claudeの応答
  - スキルの出力
  - プラン表示
- Markdown仕様準拠:
  - CommonMark仕様に従う
  - 連続する空行は1つの段落区切りとして扱う

## 関連情報

- [VSCode extension](https://marketplace.visualstudio.com/items?itemName=Anthropic.claude-code)
- [Markdown rendering](https://code.claude.com/docs/en/markdown)
