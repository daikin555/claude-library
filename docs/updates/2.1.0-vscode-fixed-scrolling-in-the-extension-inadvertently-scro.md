---
title: "[VSCode] 拡張機能内のスクロールが親iframeも誤ってスクロールするバグを修正"
date: 2026-01-31
tags: ['バグ修正', 'VSCode', 'スクロール', 'UI']
---

## 原文（日本語に翻訳）

[VSCode] 拡張機能内でスクロールすると親iframeも誤ってスクロールしてしまうバグを修正しました

## 原文（英語）

[VSCode] Fixed scrolling in the extension inadvertently scrolling the parent iframe

## 概要

Claude Code for VSCode v2.1.0で修正された、スクロール動作のバグです。以前のバージョンでは、Claude Code拡張機能のパネル内でスクロールすると、親のVSCodeウィンドウまで一緒にスクロールしてしまう問題がありました。この修正により、拡張機能内のスクロールが独立して動作し、VSCodeのエディタ表示が維持されるようになりました。

## 修正前の動作

```
# Claude Codeパネルで長文応答を読む
Claude: [Long response...]

# スクロールダウン
↓↓↓

# 修正前:
# - Claude Codeパネルがスクロール
# - 同時にVSCodeのエディタもスクロール
# - エディタの表示位置がずれる
# - 元の位置に戻すのが面倒

# 問題点:
# - コードを見ながら応答を読めない
# - 作業が中断される
```

## 修正後の動作

```
# 同じ操作
Claude: [Long response...]

# スクロールダウン
↓↓↓

# 修正後:
# ✓ Claude Codeパネルのみスクロール
# ✓ エディタは動かない
# ✓ コードの表示位置を維持
```

## 実践例

### コードレビュー中

```
# エディタでコードを表示
src/auth.ts:45

# Claude Codeで説明を読む
Claude: This authentication flow...
[Long explanation...]

# スクロールして全文を読む
# ✓ エディタの表示は auth.ts:45 のまま
# ✓ コードを見ながら説明を読める
```

### 長い応答の確認

```
# Claudeが長文応答
Claude: Here's a detailed explanation...
[200 lines of text]

# 最後まで読む
# ✓ エディタはそのまま
# ✓ 作業を継続できる
```

## 注意点

- VSCode extension v2.1.0で修正
- 修正内容:
  - スクロールイベントの伝播を停止
  - 拡張機能パネル内でスクロールを完結
- 影響範囲:
  - Claude Codeパネルのスクロール
  - サイドバー表示時も適用
- iframe隔離:
  - 拡張機能はiframe内で実行
  - スクロールイベントが親に伝播しないよう修正

## 関連情報

- [VSCode extension](https://marketplace.visualstudio.com/items?itemName=Anthropic.claude-code)
- [UI behavior](https://code.claude.com/docs/en/vscode#ui)
