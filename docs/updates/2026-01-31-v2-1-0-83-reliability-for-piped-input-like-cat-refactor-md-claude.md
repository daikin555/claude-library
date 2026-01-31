---
title: "パイプ入力（cat file.md | claude）の信頼性を改善"
date: 2026-01-31
tags: ['改善', 'パイプ入力', '標準入力']
---

## 原文（日本語に翻訳）

`cat refactor.md | claude` のようなパイプ入力の信頼性を改善しました

## 原文（英語）

Improved reliability for piped input like `cat refactor.md | claude`

## 概要

Claude Code v2.1.0で改善された、標準入力（stdin）からのパイプ入力処理です。以前のバージョンでは、ファイルやコマンド出力をパイプでClaude Codeに渡す際、入力が切り詰められたり、エンコーディングエラーが発生したり、処理が途中で停止するなどの問題がありました。この改善により、大規模なファイルや特殊な文字を含むデータでも確実に処理できるようになりました。

## 改善前の問題

### 大きなファイルの切り詰め

```bash
# 大きなファイルをパイプ
cat large-file.md | claude "Summarize"

# 修正前:
# - 最初の数KB のみ読み込まれる
# - 残りのデータが無視される
# - エラーメッセージなし
```

### エンコーディングエラー

```bash
# 日本語を含むファイル
cat japanese.txt | claude "Translate to English"

# 修正前:
# - 文字化け
# - エンコーディングエラー
# - 処理失敗
```

### 処理の中断

```bash
# 長い出力をパイプ
git diff | claude "Review changes"

# 修正前:
# - 処理が途中で停止
# - "Broken pipe" エラー
```

## 改善後の動作

### 大規模データの確実な処理

```bash
# 10MBのファイル
cat large-log.txt | claude "Find errors"

# 修正後:
# ✓ 全データを読み込み
# ✓ メモリ効率的に処理
# ✓ 確実に完了
```

### 正確なエンコーディング処理

```bash
# マルチバイト文字
cat multilingual.txt | claude "Analyze"

# 修正後:
# ✓ UTF-8を正しく処理
# ✓ 文字化けなし
# ✓ すべての言語に対応
```

## 実践例

### ログファイルの解析

大規模なログファイルを効率的に解析。

```bash
# アクセスログを解析
cat access.log | claude "Find suspicious activity"

# 100MB のログファイル
# v2.1.0: 確実に全行を処理
# エラーや異常なパターンを検出
```

### Git diff のレビュー

変更内容をパイプで渡してレビュー。

```bash
# すべての変更をレビュー
git diff HEAD~10 | claude "Review all changes"

# 数千行のdiff
# v2.1.0: 全変更を確実にレビュー
```

### データ変換パイプライン

複数のコマンドをつなげた処理。

```bash
# データ処理パイプライン
cat data.json | \
  jq '.items[]' | \
  claude "Analyze and transform" | \
  jq -r '.results[]' > output.json

# v2.1.0: パイプライン全体が安定動作
```

### スクリプト出力の処理

スクリプトの出力を直接処理。

```bash
# テスト結果を解析
npm test 2>&1 | claude "Summarize test failures"

# 大量のテスト出力
# v2.1.0: すべての出力を確実に受け取る
```

### 複数ファイルの一括処理

```bash
# 複数ファイルを結合して処理
cat src/**/*.ts | claude "Find code smells"

# 数百ファイルの連結
# v2.1.0: すべてのコードを解析
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 改善された動作:
  - **バッファリング**: 大規模データを効率的に処理
  - **エンコーディング**: UTF-8を正しく認識
  - **エラーハンドリング**: パイプエラーを適切に処理
  - **メモリ管理**: 大きな入力でもメモリ効率的
- パイプ入力の基本:
  ```bash
  # ファイルから
  cat file.txt | claude "Process"

  # コマンド出力から
  command | claude "Analyze"

  # 複数行入力
  echo -e "Line 1\nLine 2" | claude "Process"

  # ヒアドキュメント
  claude "Process" << EOF
  Multi-line
  input
  EOF
  ```
- サイズ制限:
  - 最大入力サイズ: 制限なし（メモリが許す限り）
  - 実用的な上限: ~100MB
  - それ以上: ファイルパスを直接指定推奨
- エンコーディング:
  - UTF-8を推奨
  - その他のエンコーディングは自動検出を試行
  - `iconv`で事前変換も可能:
    ```bash
    iconv -f SHIFT_JIS -t UTF-8 file.txt | claude "Process"
    ```
- 対話モードとの違い:
  - パイプ入力: 非対話モードで実行
  - 標準入力から読み込み後、即座に処理
  - 出力は標準出力に出力
- デバッグ:
  - `--debug` フラグで入力バイト数を確認
  - パイプの途中で `tee` を使用:
    ```bash
    cat file.txt | tee /tmp/debug.txt | claude "Process"
    ```
- トラブルシューティング:
  - 入力が切り詰められる: v2.1.0にアップグレード
  - 文字化け: エンコーディングを確認
  - Broken pipe: パイプ先のコマンドを確認

## 関連情報

- [Command-line usage - Claude Code Docs](https://code.claude.com/docs/en/cli)
- [Non-interactive mode](https://code.claude.com/docs/en/non-interactive)
