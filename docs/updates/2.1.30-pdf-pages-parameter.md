---
title: "PDFの特定ページを読み取る - pagesパラメータの追加"
date: 2026-02-03
tags: [read-tool, pdf, performance]
---

## 原文（日本語）
ReadツールにPDF用の`pages`パラメータを追加し、特定のページ範囲を読み取れるようになりました（例：`pages: "1-5"`）。大きなPDF（10ページ超）は、`@`でメンションされた際にコンテキストに完全に展開される代わりに軽量な参照として返されるようになりました。

## 原文（英語）
Added `pages` parameter to the Read tool for PDFs, allowing specific page ranges to be read (e.g., `pages: "1-5"`). Large PDFs (>10 pages) now return a lightweight reference when `@` mentioned instead of being inlined into context.

## 概要
Claude CodeのReadツールが強化され、PDFファイルの特定ページだけを読み取ることができるようになりました。大きなPDFファイルを扱う際のパフォーマンスが大幅に改善され、必要な部分だけを効率的に読み込めます。

## 基本的な使い方

### 特定のページ範囲を読み取る
```
@path/to/document.pdf pages:1-5
```

このように指定することで、PDFの1ページ目から5ページ目だけを読み込みます。

### 単一ページを読み取る
```
@path/to/report.pdf pages:3
```

1ページだけ読み取りたい場合は、ページ番号を単独で指定します。

## 実践例

### 技術文書の目次と概要を確認
大きな技術仕様書がある場合、最初の数ページだけを読んで概要を把握できます。

```
@specs/api-documentation.pdf pages:1-3
```

「このAPI仕様書の最初の3ページを読んで、主要な機能を説明してください」

### 論文の特定セクションを分析
100ページある論文の中から、関心のある実験結果のセクションだけを読み取ります。

```
@research/ml-paper.pdf pages:45-52
```

「このページ範囲にある実験結果を要約してください」

### 報告書の結論部分をレビュー
長い報告書の最終ページ付近にある結論だけを確認したい場合：

```
@reports/annual-report.pdf pages:95-100
```

### 大規模PDFのパフォーマンス最適化
150ページあるマニュアルの場合、ページ指定なしでメンションすると軽量な参照として扱われます。

```
@manuals/user-guide.pdf
```

このとき、全ページがコンテキストに展開されず、必要に応じてページ範囲を指定して読み込むことができます。

## 注意点

- **10ページを超える大きなPDFは自動的に軽量参照に**: `@`メンションで全体を読み込もうとしても、10ページを超える場合は自動的に軽量な参照として扱われます
- **ページ範囲の形式**: `"1-5"`のようにハイフンで範囲を指定するか、`"3"`のように単一ページを指定します
- **1回のリクエストは最大20ページまで**: パフォーマンスのため、1回のリクエストで読み込めるのは20ページまでです
- **大きなPDFは必ずpagesパラメータを使用**: 10ページを超えるPDFを読み取る際は、必ずpagesパラメータで範囲を指定する必要があります

## 関連情報

- [Claude Code公式ドキュメント - Read Tool](https://docs.anthropic.com/claude/docs/tool-use)
- [PDFファイルの効率的な処理方法](https://www.anthropic.com/claude-code)
