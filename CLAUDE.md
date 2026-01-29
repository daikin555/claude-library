# CLAUDE.md - プロジェクト指示

## プロジェクト概要
Claude Codeのchangelogを監視し、新機能の活用ガイドを自動生成するシステム。

## ガイド記事生成ルール

### 言語
- すべて日本語で記述すること

### ファイル命名規則
- `docs/updates/YYYY-MM-DD-feature-name.md` 形式
- feature-nameは英語のkebab-case

### Frontmatter形式
```yaml
---
title: "記事タイトル（日本語）"
date: YYYY-MM-DD
tags: [tag1, tag2]
---
```

### 記事構成
1. **概要** - 機能の説明（2-3文）
2. **使い方** - 具体的な手順やコマンド例
3. **活用シーン** - どのような場面で役立つか
4. **コード例** - 実践的なコードサンプル
5. **注意点・Tips** - 知っておくべきこと

### 調査指示
- Web検索で公式ドキュメントと関連記事を調査すること
- 公式のAnthropic/Claude Codeドキュメントを優先参照すること

### コミットルール
- 記事生成後は `git add` → `git commit` すること
- コミットメッセージは `docs: add guide for <feature-name>` 形式
