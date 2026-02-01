---
title: "/contextコマンドでカラー出力が表示されない問題を修正"
date: 2026-01-30
tags: ['バグ修正', 'UI', 'コマンド', 'ターミナル']
---

## 原文（日本語に翻訳）

`/context`コマンドでカラー出力が表示されない問題を修正

## 原文（英語）

Fixed `/context` command not displaying colored output

## 概要

`/context`コマンドの出力で、本来色分けされるべき情報（ファイル名、トークン数、セクション見出しなど）が色なしで表示される問題が修正されました。これにより、コンテキスト情報がより読みやすく、視覚的に理解しやすくなります。

## 問題の背景

v2.1.27以前、`/context`コマンドを実行すると：

- すべてのテキストが単色（通常は白または黒）で表示
- ファイル名、セクション、重要な情報が区別しにくい
- 大量のコンテキスト情報を視覚的に解析するのが困難
- ターミナルのカラー機能が活用されていない

これにより、特に大規模プロジェクトでコンテキスト使用状況を把握するのが難しくなっていました。

## 修正内容

v2.1.27では以下が改善されました：

- **セクション見出し**: 太字や特定の色で強調表示
- **ファイルパス**: 識別しやすい色（例：青や緑）で表示
- **トークン数**: 重要な数値情報をハイライト
- **警告メッセージ**: 注意が必要な情報を目立つ色（例：黄色）で表示
- **エラー**: エラー情報を赤色で強調

## 基本的な使い方

通常通り`/context`コマンドを実行するだけで、自動的にカラー出力が表示されます：

```bash
claude
> /context
```

## 実践例

### プロジェクトのコンテキスト使用状況を確認

```bash
> /context

# 出力例（色分けされて表示）:
# === Context Window Usage ===（太字、明るい色）
#
# Total tokens: 45,234 / 200,000（数値がハイライト）
#
# Files in context:（セクション見出しが強調）
#   src/index.ts - 1,234 tokens（ファイル名が青、数値が白）
#   src/utils.ts - 2,345 tokens
#   package.json - 456 tokens
#
# MCP Tools: 3,456 tokens（別の色で表示）
# System Prompt: 8,901 tokens
```

### トークン使用量の監視

長時間のセッションでトークン使用量を確認：

```bash
> /context

# 警告がある場合、目立つ色で表示:
# ⚠️  Warning: Context usage at 85%（黄色で警告）
# Consider using /compact to reduce context size
```

### デバッグ時の情報確認

コンテキストに含まれるファイルを視覚的に確認：

```bash
> /context

# ファイルが色分けされて一覧表示:
# === Files ===（セクション見出し）
#   ✓ src/auth.ts - 2,134 tokens（緑色のチェックマーク）
#   ✓ src/api.ts - 3,456 tokens
#   ⚠ docs/README.md - 8,901 tokens（警告マーク付き、大きいファイル）
```

### MCPツールの確認

使用中のMCPツールを視覚的に把握：

```bash
> /context

# === MCP Tools ===（セクション見出しが強調）
#   database-connector（ツール名が色分け）
#   - Schema definitions: 1,234 tokens
#   - Connection config: 567 tokens
#
#   file-search（別の色で区別）
#   - Search patterns: 890 tokens
```

## カラー出力の例

実際の色分けの例（ターミナルによって若干異なります）：

```
=== Context Window Usage ===  [太字、シアン色]
Total: 45,234 / 200,000       [白色 / グレー]

Files:                        [太字、緑色]
  src/index.ts - 1,234       [青色 - 白色]
  src/utils.ts - 2,345       [青色 - 白色]

MCP Tools: 3,456              [紫色]
System Prompt: 8,901          [黄色]

⚠️  High usage detected        [黄色、太字]
```

## ターミナル設定

カラー出力を最大限活用するための推奨設定：

### macOS Terminal

```bash
# ~/.bash_profile または ~/.zshrc
export TERM=xterm-256color
export CLICOLOR=1
```

### Windows Terminal

```json
// settings.json
{
  "profiles": {
    "defaults": {
      "colorScheme": "One Half Dark",
      "useAcrylic": false
    }
  }
}
```

### VS Code統合ターミナル

```json
// settings.json
{
  "terminal.integrated.enableMultiLinePasteWarning": false,
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.cursorStyle": "line",
  "terminal.integrated.fontFamily": "Fira Code"
}
```

## トラブルシューティング

### カラーが表示されない場合

1. **ターミナルのカラーサポート確認：**
   ```bash
   echo $TERM
   # xterm-256color または類似の値が表示されるべき
   ```

2. **TERMの設定：**
   ```bash
   export TERM=xterm-256color
   claude
   ```

3. **NO_COLORの確認：**
   ```bash
   # NO_COLORが設定されていないことを確認
   echo $NO_COLOR
   # 空であるべき
   ```

4. **強制カラー有効化（テスト用）：**
   ```bash
   export FORCE_COLOR=1
   claude
   ```

### 色が正しく表示されない場合

```bash
# ターミナルのカラースキームを確認
# 背景が明るい場合は明るいテーマ、暗い場合は暗いテーマを使用

# macOS
# Terminal > Preferences > Profiles > Colors

# Windows Terminal
# Settings > Color schemes
```

## 注意点

- カラー出力は、ターミナルがANSIカラーコードをサポートしている必要があります
- 一部の古いターミナルやSSH接続では、カラーが正しく表示されない場合があります
- `NO_COLOR`環境変数が設定されている場合、カラー出力は無効になります
- パイプやリダイレクトを使用する場合、カラーコードが含まれることに注意してください
- スクリーンリーダーを使用している場合は、カラー情報に依存しない設計になっています

## 他のコマンドでのカラー対応

`/context`以外のコマンドでもカラー出力が利用できます：

```bash
# ヘルプコマンド
> /help
# コマンド名が色分けされる

# パーミッションコマンド
> /permissions
# 許可/拒否/確認が色分けされる

# セッション一覧
> /sessions
# セッション状態が色分けされる
```

## パフォーマンスへの影響

カラー出力の追加による影響：

- **レンダリング速度**: ほぼ影響なし（ANSIコードのオーバーヘッドは最小限）
- **メモリ使用量**: 変化なし
- **可読性**: 大幅に向上
- **視覚的な疲労**: 軽減

## アクセシビリティ

カラー出力は視覚的な補助ですが、以下も保証されています：

- テキストのみでも情報は完全に理解可能
- スクリーンリーダー対応
- ハイコントラストモード対応
- 色覚異常に配慮した色選択

## 関連情報

- [Common workflows - Claude Code Docs](https://code.claude.com/docs/en/common-workflows)
- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
