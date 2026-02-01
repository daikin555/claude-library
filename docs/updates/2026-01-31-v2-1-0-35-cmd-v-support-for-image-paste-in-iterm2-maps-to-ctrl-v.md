---
title: "iTerm2でCmd+Vによる画像貼り付けをサポート（Ctrl+Vにマップ）"
date: 2026-01-31
tags: ['改善', 'UX', 'macOS']
---

## 原文（日本語に翻訳）

iTerm2でCmd+Vによる画像貼り付けサポートを追加しました（Ctrl+Vにマッピング）

## 原文（英語）

Added Cmd+V support for image paste in iTerm2 (maps to Ctrl+V)

## 概要

Claude Code v2.1.0で導入された、macOSのiTerm2ユーザー向けのUX改善です。従来はiTerm2でクリップボードの画像を貼り付けるには `Ctrl+V` を使う必要がありましたが、macOSの標準的なショートカット `Cmd+V` でも画像を貼り付けられるようになりました。これにより、他のmacOSアプリと同じ操作感で画像をClaudeに送信でき、スクリーンショットやデザインモックの共有がスムーズになります。

## 基本的な使い方

iTerm2でClaude Codeを実行中に、画像をクリップボードにコピーして `Cmd+V` で貼り付けます。

```bash
# iTerm2でClaude Code起動
claude

# スクリーンショットを撮る（Cmd+Shift+4）
# または画像をコピー（Cmd+C）

# Claude Codeに貼り付け
> この画像のUIを実装して <Cmd+V>

# 画像が送信され、Claudeが分析
```

## 実践例

### スクリーンショットのバグ報告

スクリーンショットを撮って即座にClaudeに共有します。

```bash
# iTerm2でClaude Code実行中
claude

# バグのあるUIのスクリーンショット撮影
# Cmd+Shift+4 でスクリーンショット

# すぐに貼り付け（macOS標準の操作）
> このUIのバグを修正して <Cmd+V>

# Claudeが画像を分析し、問題を特定して修正コードを提案
```

### デザインモックからのコード生成

Figmaやデザインツールからデザインをコピーして実装を依頼します。

```bash
# Figmaでデザインをコピー（Cmd+C）

# iTerm2に切り替え
> このデザインをReactで実装 <Cmd+V>

# デザイン画像が送信される
# Claudeがコンポーネントコードを生成
```

### エラー画面の診断

ブラウザのエラー画面をスクリーンショットして分析を依頼します。

```bash
# ブラウザのエラー画面をスクリーンショット
# Cmd+Shift+3 (全画面) または Cmd+Shift+4 (範囲選択)

# Claude Codeに貼り付け
> このエラーの原因を特定して <Cmd+V>

# エラースタックトレースをOCRで読み取り
# Claudeが問題を診断して解決策を提案
```

### ワイヤーフレームからのプロトタイプ

手書きのワイヤーフレームをスマホで撮影してコード化します。

```bash
# スマホで手書きワイヤーフレームを撮影
# AirDropでMacに転送 → 自動的にクリップボードにコピー

# iTerm2で
> この手書きスケッチをHTML/CSSで実装 <Cmd+V>

# Claudeがワイヤーフレームを解釈してコード生成
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **iTerm2専用の機能**:
  - macOSのiTerm2でのみ動作
  - 他のターミナル（Terminal.app、Alacritty、Kittyなど）では `Ctrl+V` を使用
  - VSCode統合ターミナルでは別の貼り付け方法を使用
- 動作の仕組み:
  - iTerm2が `Cmd+V` を検出すると、内部的に `Ctrl+V` として処理
  - Claude Codeは `Ctrl+V` として画像貼り付けを受け取る
  - ユーザーはmacOSの標準ショートカットを使える
- 対応画像形式:
  - PNG
  - JPEG/JPG
  - WebP
  - GIF（アニメーション非対応、最初のフレームのみ）
- クリップボード以外の方法:
  - 画像ファイルのドラッグ&ドロップ（iTerm2で対応）
  - 画像ファイルパスの指定（Read toolで読み取り）
- 従来の `Ctrl+V` も引き続き動作:
  - `Cmd+V` と `Ctrl+V` の両方が使用可能
  - どちらも同じ動作
- iTerm2の設定:
  - iTerm2のキーバインド設定と競合しないように設計
  - カスタムキーバインドがある場合、動作が異なる可能性
- 画像サイズ制限:
  - 非常に大きな画像（10MB超）はアップロード前に圧縮される
  - 推奨サイズ: 5MB以下
- プライバシー:
  - 貼り付けた画像はClaudeのAPIに送信される
  - 機密情報を含む画像の共有には注意
- トラブルシューティング:
  - `Cmd+V` が動作しない場合:
    1. iTerm2のバージョンを確認（最新版を推奨）
    2. `Ctrl+V` で動作するか確認
    3. クリップボードに画像があるか確認（`pbpaste` コマンド）
    4. iTerm2のキーバインド設定を確認

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Image input support](https://code.claude.com/docs/en/image-input)
- [iTerm2 Documentation](https://iterm2.com/documentation.html)
