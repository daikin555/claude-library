---
title: "シェル補完キャッシュファイルの切り捨て問題を修正"
date: 2026-01-28
tags: ['バグ修正', 'シェル', 'CLI']
---

## 原文（日本語に翻訳）

終了時にシェル補完キャッシュファイルが切り捨てられる問題を修正

## 原文（英語）

Fixed shell completion cache files being truncated on exit

## 概要

Claude CodeのCLI終了時に、シェル補完のキャッシュファイルが誤って切り捨てられる（空になる）バグが修正されました。この問題により、タブ補完の候補が消失し、毎回再生成が必要になっていました。v2.1.21では、キャッシュファイルが正しく保持されるようになり、次回起動時も高速な補完が利用できます。

## 基本的な使い方

この修正は自動的に適用されるため、特別な設定は不要です。Claude Codeを通常通り使用するだけで、シェル補完が正常に動作します。

```bash
# bashの場合
claude code <Tab>  # 補完候補が表示される

# zshの場合
claude code <Tab>  # 補完候補が表示される
```

## 実践例

### タブ補完の動作確認

Claude Codeのコマンドでタブキーを押すと、利用可能なオプションやサブコマンドが表示されます：

```bash
$ claude code --<Tab>
--help              # ヘルプを表示
--version           # バージョン情報を表示
--model             # 使用するモデルを指定
--allowedTools      # 許可するツールを指定
```

v2.1.21以降は、Claude Code終了後もこのキャッシュが保持され、次回起動時も即座に補完候補が表示されます。

### 複数セッションでの利用

複数のターミナルウィンドウでClaude Codeを使用している場合でも、キャッシュファイルが正しく管理されます：

```bash
# ターミナル1
$ claude code --model sonnet
# 作業後に終了

# ターミナル2（別のウィンドウ）
$ claude code --<Tab>  # キャッシュが保持されているため高速に補完
```

### 補完キャッシュの恩恵

頻繁に使用するコマンドやオプションの補完が高速化されます：

```bash
# ファイルパスの補完
$ claude code ~/projects/<Tab>

# モデル名の補完
$ claude code --model <Tab>
sonnet    haiku    opus
```

## 注意点

- この修正はv2.1.21で適用されました
- bash、zsh、fishなど主要なシェルで動作します
- キャッシュファイルは通常 `~/.claude/` ディレクトリに保存されます
- 初回起動時はキャッシュ生成のため若干時間がかかる場合があります
- キャッシュが破損した場合は、`~/.claude/completion-cache` を削除すると再生成されます
- この問題により以前のバージョンで補完が機能しなくなっていた場合、v2.1.21にアップデート後は正常に動作します

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.21](https://github.com/anthropics/claude-code/releases/tag/v2.1.21)
- [シェル補完の設定ガイド](https://code.claude.com/docs/)
