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

### ファイル分割ルール
- **changelogの1項目ごとに1ファイルを作成する**
- 例：以下のchangelogがある場合、3つのファイルを作成する
  - Added tool call failures and denials to debug logs → 1ファイル
  - Fixed context management validation error → 1ファイル
  - Added --from-pr flag → 1ファイル

### 記事構成
1. **原文（日本語に翻訳）** - changelogの該当項目を日本語に翻訳
2. **原文（英語）** - changelogの該当項目を英語で記載
3. **概要** - 機能の説明（2-3文）
4. **基本的な使い方** - シンプルな例
5. **実践例** - 具体的なユースケース別のコード例
   - ユースケースごとにH3見出し（###）で区切る
6. **注意点** - 知っておくべきこと
7. **関連情報** - 公式ドキュメントや関連記事へのリンク

### 調査指示
- Web検索で公式ドキュメントと関連記事を調査すること
- 公式のAnthropic/Claude Codeドキュメントを優先参照すること

### コミットルール
- 記事生成後は `git add` → `git commit` すること
- コミットメッセージは `docs: add guide for <feature-name>` 形式
