---
title: "画像参照リンクの下線スタイルを削除"
date: 2026-01-31
tags: ['削除', 'UI', 'Markdown', '画像']
---

## 原文（日本語に翻訳）

画像参照リンクから下線スタイルを削除しました

## 原文（英語）

Removed underline styling from image reference links

## 概要

Claude Code v2.1.0で削除された、画像参照リンクの下線スタイルです。以前のバージョンでは、Markdown形式の画像参照（`![alt](url)`）が通常のリンクと同様に下線付きで表示され、視覚的に混乱を招く問題がありました。この削除により、画像リンクは下線なしで表示され、テキストリンクと明確に区別できるようになりました。

## 削除前の動作

```markdown
# ドキュメント内の画像
See the architecture diagram: ![Architecture](./arch.png)

# 削除前の表示:
See the architecture diagram: Architecture
                               ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲ ̲
                               （下線付き）

# 問題点:
# - テキストリンクと区別しにくい
# - クリック可能と誤解しやすい
# - 視覚的に煩雑
```

## 削除後の動作

```markdown
# 同じドキュメント
See the architecture diagram: ![Architecture](./arch.png)

# 削除後の表示:
See the architecture diagram: 🖼️ Architecture
                               （下線なし）

# ✓ 画像リンクと明確
# ✓ すっきりした表示
# ✓ テキストリンクと区別しやすい
```

## 実践例

### ドキュメント with 画像

```markdown
# README.md

## Architecture

The system consists of three layers:

1. Frontend - ![UI Screenshot](./images/ui.png)
2. Backend - ![API Diagram](./images/api.png)
3. Database - ![Schema](./images/schema.png)

See [documentation](./docs) for details.

# 削除後の表示:
# 画像: 下線なし、アイコン付き
# リンク: 下線あり

# ✓ 一目で区別できる
```

### 混在するリンク

```markdown
For the [API guide](./api.md), refer to the
![API flow diagram](./flow.png) which shows the
complete [authentication process](./auth.md).

# 表示:
# [API guide] - 下線あり（リンク）
# ![API flow diagram] - 下線なし（画像）
# [authentication process] - 下線あり（リンク）

# ✓ 種類が明確
```

## 注意点

- Claude Code v2.1.0で削除
- 削除対象:
  - 画像参照: `![alt](url)`
  - インライン画像: `![](url)`
- 影響なし:
  - テキストリンク: `[text](url)` - 下線あり
  - 直リンク: `<url>` - 下線あり
- 画像表示の改善:
  - アイコン: 🖼️ で画像と表示
  - ツールチップ: alt テキストを表示
  - プレビュー: カーソルで画像プレビュー（対応ターミナル）

## 関連情報

- [Markdown rendering - Claude Code Docs](https://code.claude.com/docs/en/markdown)
- [UI styling](https://code.claude.com/docs/en/ui#styling)
