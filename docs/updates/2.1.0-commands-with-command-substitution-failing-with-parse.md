---
title: "`$()`コマンド置換を含むコマンドのパースエラーを修正"
date: 2026-01-31
tags: ['バグ修正', 'bash', 'コマンド置換']
---

## 原文（日本語に翻訳）

`$()`コマンド置換を含むコマンドがパースエラーで失敗する問題を修正しました

## 原文（英語）

Fixed commands with `$()` command substitution failing with parse errors

## 概要

Claude Code v2.1.0で修正された、Bashコマンド解析バグです。以前のバージョンでは、`$(command)` 形式のコマンド置換を含むBashコマンドを実行しようとすると、パーミッションチェック時のパース処理でエラーが発生し、コマンドが実行できませんでした。この修正により、コマンド置換を含む複雑なBashコマンドも正しく解析・実行されるようになりました。

## 修正前の問題

### 症状

```bash
claude

# コマンド置換を使用
> git commit -m "$(cat commit-message.txt)" を実行

# 修正前: パースエラー
Error: Failed to parse command
Parse error at position 18: unexpected token '('

# コマンドが実行されない
```

### よくある失敗パターン

```bash
# 日付をファイル名に含める
> touch backup-$(date +%Y%m%d).tar.gz
# エラー: Parse error

# 動的なディレクトリパス
> cd $(git rev-parse --show-toplevel)
# エラー: Parse error

# 環境変数の動的取得
> echo "User: $(whoami), Home: $(echo $HOME)"
# エラー: Parse error
```

## 修正後の動作

### コマンド置換の正常動作

```bash
claude

# 日付を含むファイル名
> touch backup-$(date +%Y%m%d).tar.gz

# 修正後: ✓ 正常実行
# backup-20260131.tar.gz が作成される

# Gitルートに移動
> cd $(git rev-parse --show-toplevel)

# ✓ 正常実行
# カレントディレクトリが変更される

# 複数のコマンド置換
> echo "User: $(whoami), Date: $(date +%F)"

# ✓ 正常実行
# "User: alice, Date: 2026-01-31" が表示される
```

## 実践例

### 動的なファイル名生成

タイムスタンプや変数を使ったファイル名を生成します。

```bash
# ログファイルにタイムスタンプ
> cat error.log > logs/error-$(date +%Y%m%d-%H%M%S).log

# 修正前: エラー
# 修正後: ✓ logs/error-20260131-103045.log が作成される

# Gitブランチ名を含むファイル
> echo "Build info" > build-$(git branch --show-current).txt

# ✓ build-feature-auth.txt が作成される
```

### ネストしたコマンド置換

複数レベルのコマンド置換を使用します。

```bash
# 最新のGitタグを使用
> echo "Version: $(git describe --tags $(git rev-list --tags --max-count=1))"

# 修正後: ✓ 正常実行
# "Version: v2.1.0" が表示される

# ファイル数をカウント
> echo "Files: $(ls $(pwd) | wc -l)"

# ✓ "Files: 42" が表示される
```

### コミットメッセージの動的生成

外部ファイルやコマンドからコミットメッセージを生成します。

```bash
# ファイルからメッセージを読み取り
> git commit -m "$(cat .commit-message-template.txt)"

# 修正後: ✓ 正常実行
# テンプレートの内容でコミット

# 動的にメッセージ生成
> git commit -m "Auto-commit at $(date) by $(whoami)"

# ✓ "Auto-commit at Fri Jan 31 10:30:45 JST 2026 by alice" でコミット
```

### 環境依存のパス解決

環境変数やコマンドを使ってパスを解決します。

```bash
# Nodeのバージョンを含むパス
> mkdir -p builds/node-$(node --version)

# ✓ builds/node-v18.16.0 が作成される

# プロジェクトルートからの相対パス
> cp config.json $(git rev-parse --show-toplevel)/config.backup.json

# ✓ Gitルートにバックアップコピー
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- コマンド置換（Command Substitution）:
  - `$(command)` 形式: モダンな構文（推奨）
  - `` `command` `` 形式: レガシー構文（古い形式）
  - コマンドの出力を文字列として埋め込む
- 両方の構文をサポート:
  - `$(command)`: ✅ サポート（修正済み）
  - `` `command` ``: ✅ サポート（元々動作）
- ネストのサポート:
  - `$(cmd1 $(cmd2))`: ✅ サポート
  - 複数レベルのネストも可能
- パーミッションチェック:
  - コマンド置換を含む場合でも、適切にパーミッションチェックが実行される
  - 内部コマンドと外部コマンドの両方をチェック
- エスケープ処理:
  - 引用符内のコマンド置換も正しく処理
  - 例: `echo "Result: $(command)"`
- 修正の詳細:
  - Bashコマンドパーサーの改善
  - `$(...)`ブロックを正しく認識
  - ネストしたブロックも再帰的にパース
- パフォーマンス:
  - コマンド置換は実行時に評価される
  - 複雑なコマンド置換は実行時間が長くなる可能性
- セキュリティ:
  - コマンド置換の結果がそのまま使用される
  - 信頼できないソースからの入力には注意
  - シェルインジェクションのリスク
- デバッグ:
  - `--debug` フラグでコマンドパースのログを確認
  - ログに「Parsed command substitution: $(...)」が表示される
- 関連する修正:
  - index 52: バックスラッシュ継続を含むマルチラインコマンド
  - index 53: Bashコマンドプレフィックス抽出の改善
- トラブルシューティング:
  - コマンド置換が動作しない場合:
    1. 引用符のエスケープを確認
    2. ネストレベルを減らす
    3. 一時変数に分割
    ```bash
    # 複雑な例を分割
    temp=$(command1)
    result=$(command2 $temp)
    ```

## 関連情報

- [Bash tool - Claude Code Docs](https://code.claude.com/docs/en/bash-tool)
- [Command substitution - Bash manual](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html)
- [Shell parameter expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
