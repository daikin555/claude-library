---
title: "LSPサーバー未設定時のLSPツール誤有効化を修正"
date: 2026-01-31
tags: ['バグ修正', 'LSP', 'プラグイン']
---

## 原文（日本語に翻訳）

LSPサーバーが設定されていない場合にLSPツールが誤って有効化される問題を修正しました

## 原文（英語）

Fixed LSP tool being incorrectly enabled when no LSP servers were configured

## 概要

Claude Code v2.1.0で修正された、LSP（Language Server Protocol）ツールの誤有効化バグです。以前のバージョンでは、LSPサーバーが設定されていない環境でもLSPツールが有効化され、Claude CodeがLSP機能を使用しようとして「No LSP server available」エラーが頻発していました。この修正により、LSPサーバーが実際に設定されている場合のみLSPツールが有効化されるようになりました。

## 修正前の問題

```bash
# LSPプラグインを設定していない状態
# （または設定が不完全な状態）

# Claude Codeを起動すると...
# LSPツールが有効になっているが、実際には使用できない

# コード編集中にLSP機能が呼び出される
> この関数の定義箇所を教えて

# エラー: No LSP server available for file type .ts
# エラー: LSP tool returns "No LSP server available"
```

### 根本原因

- `LspServerManager.initialize()` が空の実装
- 有効化されたプラグインからLSPサーバーが読み込まれない
- LSPツール自体は有効だが、バックエンドサーバーが存在しない

## 修正後の動作

```bash
# LSPサーバーが設定されていない場合
# ✓ LSPツールは無効のまま
# ✓ Claude CodeはLSP機能を使用しようとしない
# ✓ エラーメッセージが表示されない

# LSPサーバーが正しく設定されている場合のみ
# LSPツールが有効化され、機能する
```

## 実践例

### LSP未設定環境での使用

```bash
# LSPプラグインなしでClaude Code使用
claude

# 修正前: LSP関連のエラーが頻発
# 修正後: LSPツールが無効なので、エラーなし
```

### LSP設定環境での使用

```bash
# LSPプラグインを設定
# settings.jsonまたはプラグイン設定

{
  "plugins": {
    "typescript-lsp": {
      "enabled": true
    }
  }
}

# LSPサーバーが正しく動作
> この関数の定義を見せて
# ✓ LSPツールが有効化され、正常に動作
```

### 段階的なLSP導入

```bash
# ステップ1: LSPなしで開始
claude  # LSPツール無効

# ステップ2: LSPプラグインをインストール
claude plugin install typescript-lsp

# ステップ3: 再起動後、LSPツールが有効化
claude  # LSPツール有効
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- LSPサポートは2026年1月時点で「まだ未完成」の状態です:
  - 一部のLSP操作にバグがある
  - ドキュメントが不十分
  - LSPサーバーの起動/実行/エラー状態を示すUIがない
- LSPツールを有効にするには:
  - 適切なLSPプラグインをインストール
  - 言語サーバーをグローバルにインストール（例: `npm install -g typescript-language-server`）
  - 設定でプラグインを有効化
- コミュニティツール「tweakcc」を使用すると、組み込みLSPサポートを自動的に修正できます:
  ```bash
  npx tweakcc --apply
  ```
- v2.0.74以前は環境変数 `$ENABLE_LSP_TOOL=1` で手動有効化が必要でした
- 複数の未解決バグ（2026年1月時点）:
  - TypeScript LSPプラグインが認識されない
  - 「No LSP server available」エラーが正しい設定でも発生

## 関連情報

- [Claude Code gets native LSP support (Hacker News)](https://news.ycombinator.com/item?id=46355165)
- [GitHub Issue #14803: LSP plugins not recognized](https://github.com/anthropics/claude-code/issues/14803)
- [Claude Code LSP: Complete Setup Guide](https://www.aifreeapi.com/en/posts/claude-code-lsp)
- [Claude Code LSPs Marketplace (GitHub)](https://github.com/Piebald-AI/claude-code-lsps)
