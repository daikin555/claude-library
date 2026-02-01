---
title: "CLAUDE.mdのバイナリファイル誤読み込み問題を修正"
date: 2026-01-09
tags: ['バグ修正', 'CLAUDE.md', '@include', 'メモリ管理']
---

## 原文（日本語に翻訳）

CLAUDE.mdファイルで `@include` ディレクティブを使用した際に、バイナリファイル（画像、PDFなど）が誤ってメモリに読み込まれていた問題を修正しました。

## 原文（英語）

Fixed binary files (images, PDFs, etc.) being accidentally included in memory when using `@include` directives in CLAUDE.md files

## 概要

CLAUDE.mdファイルで `@include` ディレクティブを使用してディレクトリやファイルパターンを指定した際、意図せずバイナリファイル（画像、PDF、動画など）がメモリに読み込まれてしまい、メモリ使用量の増加やパフォーマンス低下を引き起こす問題が修正されました。これにより、テキストファイルのみが適切に処理されるようになります。

## 基本的な使い方

この修正は自動的に適用されます。CLAUDE.mdファイルで `@include` を使用する際、バイナリファイルは自動的に除外されます。

### CLAUDE.mdの例

```markdown
# CLAUDE.md

プロジェクトの指示をここに記述

@include src/**/*

# v2.1.2以降:
# - src/**/*.js, *.ts などのテキストファイルのみが読み込まれる
# - src/**/*.png, *.pdf などのバイナリファイルは除外される
```

## 実践例

### ドキュメントディレクトリの読み込み

```markdown
# CLAUDE.md

@include docs/**/*

# 修正前:
# - docs/**/*.md (テキスト) ✓
# - docs/**/*.png (画像) ✗ メモリに読み込まれてしまう
# - docs/**/*.pdf (PDF) ✗ メモリに読み込まれてしまう

# 修正後:
# - docs/**/*.md (テキスト) ✓
# - docs/**/*.png (画像) 自動的に除外
# - docs/**/*.pdf (PDF) 自動的に除外
```

### プロジェクト全体の読み込み

```markdown
# CLAUDE.md

@include **/*

# 修正前:
# 画像、PDF、バイナリファイル全てがメモリに読み込まれ、
# 大量のメモリを消費してパフォーマンスが低下

# 修正後:
# ソースコードやドキュメントなどのテキストファイルのみが読み込まれ、
# メモリ使用量が適切に管理される
```

### アセットを含むディレクトリの処理

```markdown
# CLAUDE.md

# 公開ディレクトリを含める
@include public/**/*

# 修正前の問題:
# public/
#   images/
#     logo.png (5MB) → メモリに読み込まれる
#     banner.jpg (3MB) → メモリに読み込まれる
#   videos/
#     intro.mp4 (50MB) → メモリに読み込まれる
# → 合計58MB以上の不要なメモリ消費

# 修正後:
# public/
#   index.html → 読み込まれる
#   styles.css → 読み込まれる
#   images/, videos/ → バイナリファイルは除外される
# → 必要なファイルのみが読み込まれる
```

### 混在したプロジェクトでの使用

```markdown
# CLAUDE.md

# デザインファイルとコードが混在するプロジェクト
@include design-system/**/*

# design-system/
#   components/
#     Button.tsx → 読み込まれる
#     Button.stories.tsx → 読み込まれる
#     button-mockup.sketch → 除外される
#     button-icon.svg → 除外される (SVGもバイナリとして扱われる)
#   docs/
#     README.md → 読み込まれる
#     screenshot.png → 除外される
```

## 注意点

- **自動除外**: バイナリファイルは自動的に除外されるため、特別な設定は不要です
- **テキストファイルのみ**: `@include` は基本的にソースコード、ドキュメント、設定ファイルなどのテキストファイル用です
- **メモリ効率**: この修正により、大規模プロジェクトでもメモリ使用量が大幅に削減されます
- **SVGファイル**: SVGはテキスト形式ですが、一部のケースではバイナリとして扱われる場合があります
- **明示的な指定**: 特定のファイルを読み込みたい場合は、ファイル名を明示的に指定してください

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [CLAUDE.md ガイド](https://code.claude.com/docs/claude-md)
