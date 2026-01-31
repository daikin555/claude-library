---
title: "[VSCode] claudeProcessWrapper設定のパス渡しを修正"
date: 2026-01-14
tags: ['バグ修正', 'VSCode', '設定']
---

## 原文（日本語に翻訳）

[VSCode] `claudeProcessWrapper`設定が、Claudeバイナリパスではなくラッパーパスを渡していた問題を修正しました。

## 原文（英語）

[VSCode] Fixed `claudeProcessWrapper` setting passing the wrapper path instead of the Claude binary path

## 概要

VS Code拡張機能で、`claudeProcessWrapper`設定を使用してClaudeプロセスをラップする際、本来渡すべきClaudeバイナリのパスではなく、ラッパースクリプト自体のパスが渡されていた問題が修正されました。この問題により、カスタムラッパースクリプトが正しく機能しませんでした。

## 問題の詳細

### claudeProcessWrapperとは

VS Code拡張では、Claudeプロセスを起動する前にカスタムスクリプトを実行できる機能があります。これは、環境変数の設定、ログ記録、リソース制限の適用などに使用されます。

### 修正前の動作（バグ）

```json
// VS Code settings.json
{
  "claude.claudeProcessWrapper": "/path/to/wrapper.sh"
}
```

ラッパースクリプト（wrapper.sh）の期待される呼び出し：
```bash
# 期待: wrapper.sh <claude-binary-path> [args]
/path/to/wrapper.sh /usr/local/bin/claude --model sonnet
```

実際の呼び出し（バグ）：
```bash
# 実際: wrapper.sh自体のパスが渡される
/path/to/wrapper.sh /path/to/wrapper.sh --model sonnet
# ↑ Claudeバイナリパスではなくラッパーパス
```

結果：
```
❌ Error: Invalid arguments
❌ Claude fails to start
```

### 修正後の動作

```bash
# 正しい呼び出し
/path/to/wrapper.sh /usr/local/bin/claude --model sonnet
# ↑ Claudeバイナリの正しいパス
```

ラッパースクリプトは期待通りClaudeを起動できます。

## 実践例

### ロギングラッパー

Claudeの実行をログに記録するラッパー：

```bash
#!/bin/bash
# logging-wrapper.sh

CLAUDE_BIN=$1
shift

echo "[$(date)] Starting Claude: $CLAUDE_BIN $@" >> /var/log/claude.log
exec "$CLAUDE_BIN" "$@"
```

**修正前:**
```
$ code .
❌ Claude fails to start
Log: Starting Claude: /path/to/logging-wrapper.sh --model sonnet
```

**修正後（v2.1.7）:**
```
$ code .
✓ Claude starts successfully
Log: Starting Claude: /usr/local/bin/claude --model sonnet
```

### 環境変数設定ラッパー

プロジェクトごとに異なる環境変数を設定：

```bash
#!/bin/bash
# env-wrapper.sh

CLAUDE_BIN=$1
shift

# プロジェクト固有の環境変数を設定
export PROJECT_NAME="my-project"
export API_KEY=$(cat ~/.secrets/api-key)
export DEBUG=true

exec "$CLAUDE_BIN" "$@"
```

**修正前:** 環境変数が設定されず、Claudeが正しく起動しない
**修正後:** 環境変数が正しく設定され、Claudeが起動

### リソース制限ラッパー

Claudeプロセスのリソース使用を制限：

```bash
#!/bin/bash
# resource-limit-wrapper.sh

CLAUDE_BIN=$1
shift

# メモリとCPU使用量を制限
ulimit -v 4194304  # 4GB memory
nice -n 10 exec "$CLAUDE_BIN" "$@"
```

**修正前:** リソース制限が適用されない
**修正後:** リソース制限が正しく適用される

## 設定方法

### VS Code設定ファイル

`.vscode/settings.json`または`~/.config/Code/User/settings.json`に追加：

```json
{
  "claude.claudeProcessWrapper": "/path/to/your/wrapper.sh"
}
```

### ラッパースクリプトの要件

1. **実行可能であること**:
   ```bash
   chmod +x /path/to/wrapper.sh
   ```

2. **第1引数がClaudeバイナリパス**:
   ```bash
   CLAUDE_BIN=$1
   shift  # 残りの引数を取得
   ```

3. **Claudeを`exec`で起動**:
   ```bash
   exec "$CLAUDE_BIN" "$@"
   ```

## 技術的な改善点

- **正しいパス渡し**: Claudeバイナリの実際のパスをラッパーに渡す
- **透過的な動作**: ラッパーは期待通りにClaudeを起動できる
- **柔軟性**: カスタムラッパーを使用した高度な設定が可能

## 注意点

- **VS Code専用**: この設定はVS Code拡張でのみ使用可能です（CLI版では別の方法を使用）
- **スクリプトの権限**: ラッパースクリプトには実行権限が必要です
- **パス解決**: ラッパースクリプトは絶対パスで指定することを推奨します
- **エラーハンドリング**: ラッパースクリプト内でエラーハンドリングを適切に行ってください

## ユースケース

この機能は以下の場合に特に有用です：

- **会社環境**: プロキシ設定や認証が必要な環境
- **デバッグ**: Claudeの実行ログを詳細に記録
- **セキュリティ**: Claudeプロセスにセキュリティポリシーを適用
- **パフォーマンス**: リソース制限やプロファイリング
- **マルチプロジェクト**: プロジェクトごとに異なる設定を適用

## 関連情報

- [VS Code拡張設定ガイド](https://code.claude.com/docs/)
- [カスタムラッパーの例](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
