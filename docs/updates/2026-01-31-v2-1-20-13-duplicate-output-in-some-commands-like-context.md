---
title: "`/context`などのコマンドで出力が重複する問題を修正"
date: 2026-01-27
tags: ['バグ修正', 'コマンド', '出力表示']
---

## 原文（日本語に翻訳）

`/context`などの一部のコマンドで出力が重複する問題を修正

## 原文（英語）

Fixed duplicate output in some commands like `/context`

## 概要

Claude Code v2.1.20では、`/context`コマンドをはじめとする一部のスラッシュコマンドで、出力が重複して表示される問題が修正されました。以前は、同じ情報が2回表示されることがあり、出力が冗長で読みにくくなっていました。この修正により、すべてのコマンド出力がクリーンで一度だけ表示されるようになります。

## 基本的な使い方

コマンドを実行すると、出力が一度だけ表示されます：

```bash
# コンテキスト情報を確認
> /context

# 修正前の出力：
# Current context: 45,234 tokens (22% of limit)
# Current context: 45,234 tokens (22% of limit)  ← 重複

# 修正後の出力：
# Current context: 45,234 tokens (22% of limit)  ← 1回のみ
```

## 実践例

### コンテキストサイズの確認

セッション中のトークン使用量をチェック：

```bash
> /context

# 修正前：
Files in context:
  - src/app.js (1,234 tokens)
  - src/utils.js (567 tokens)
  - README.md (890 tokens)
Total: 2,691 tokens (1.3% of context window)

Files in context:
  - src/app.js (1,234 tokens)
  - src/utils.js (567 tokens)
  - README.md (890 tokens)
Total: 2,691 tokens (1.3% of context window)
# ↑ 同じ内容が2回表示される

# 修正後：
Files in context:
  - src/app.js (1,234 tokens)
  - src/utils.js (567 tokens)
  - README.md (890 tokens)
Total: 2,691 tokens (1.3% of context window)
# ↑ スッキリ1回のみ
```

### 設定情報の表示

現在の設定を確認する際：

```bash
> /config

# 修正前は設定項目が2回ずつ表示：
Model: claude-opus-4.5
Model: claude-opus-4.5  ← 重複

Temperature: 0.7
Temperature: 0.7  ← 重複

# 修正後は各項目が1回のみ：
Model: claude-opus-4.5
Temperature: 0.7
Max tokens: 4096
...
```

### ヘルプコマンドの使用

コマンドのヘルプを参照：

```bash
> /help context

# 修正前：
# /context - Show current context usage
# Usage: /context
#
# /context - Show current context usage  ← 重複
# Usage: /context  ← 重複

# 修正後：
# /context - Show current context usage
# Usage: /context
# ← クリーンな表示
```

### スキルリストの表示

利用可能なスキルを確認：

```bash
> /skills

# 修正前の問題：
Available skills:
  - /commit - Create a git commit
  - /review-pr - Review a pull request
  - /debug - Debug code

Available skills:  ← 重複開始
  - /commit - Create a git commit
  - /review-pr - Review a pull request
  - /debug - Debug code

# リストが長い場合、非常に読みにくい

# 修正後：
Available skills:
  - /commit - Create a git commit
  - /review-pr - Review a pull request
  - /debug - Debug code
# 1回のみ、スクロールしやすい
```

### マーケットプレイス情報の表示

カスタムソースのリスト表示：

```bash
> /marketplace list

# 修正前：
Installed sources:
  - https://github.com/example/tools
  - https://github.com/company/internal-skills

Installed sources:  ← 重複
  - https://github.com/example/tools
  - https://github.com/company/internal-skills

# 修正後：
Installed sources:
  - https://github.com/example/tools
  - https://github.com/company/internal-skills
# スッキリ
```

### ログ出力でのデバッグ

開発者がコマンド出力をログに保存する場合：

```bash
# 出力をファイルにリダイレクト
> /context > context-log.txt

# 修正前の問題：
# - ログファイルに重複データが記録される
# - ファイルサイズが2倍に
# - 解析スクリプトが誤動作の可能性

# 修正後：
# - クリーンなログファイル
# - 適切なファイルサイズ
# - 解析が正確に動作
```

## 注意点

- この修正は、影響を受けていた複数のスラッシュコマンドに適用されます
- 主に `/context`、`/config`、`/help` などの情報表示コマンドが対象でした
- 出力内容自体は変更されておらず、重複のみが削除されました
- コマンドの実行速度にも若干の改善が見られる場合があります
- ログファイルやスクリプトが重複出力に依存していた場合は、調整が必要な場合があります

## 関連情報

- [Slash Commands Reference](https://code.claude.com/docs/en/reference/slash-commands)
- [Context Management](https://code.claude.com/docs/en/advanced/context-management)
- [Configuration](https://code.claude.com/docs/en/reference/configuration)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
