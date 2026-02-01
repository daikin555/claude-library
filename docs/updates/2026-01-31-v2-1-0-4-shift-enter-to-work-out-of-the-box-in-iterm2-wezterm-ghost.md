---
title: "Shift+Enterが主要ターミナルで設定不要で動作するように変更"
date: 2026-01-31
tags: ['改善', 'ターミナル', 'UX']
---

## 原文（日本語に翻訳）

iTerm2、WezTerm、Ghostty、Kittyで、ターミナル設定を変更せずにShift+Enterが標準で動作するように変更しました

## 原文（英語）

Changed Shift+Enter to work out of the box in iTerm2, WezTerm, Ghostty, and Kitty without modifying terminal configs

## 概要

Claude Code v2.1.0で導入された、Shift+Enterキーバインドの改善です。iTerm2、WezTerm、Ghostty、Kittyの各ターミナルエミュレータで、ターミナル設定ファイルを手動で編集することなく、Shift+Enterで改行を挿入できるようになりました。これにより、セットアップの手間が大幅に削減され、ゼロ設定で複数行入力が可能になります。

## 基本的な使い方

対応ターミナル（iTerm2、WezTerm、Ghostty、Kitty）でClaude Codeを起動すると、Shift+Enterが自動的に改行として機能します。

```bash
# Claude Codeを起動
claude

# プロンプト入力時にShift+Enterで改行
# 例：
# 以下のコードを修正してください： [Shift+Enter]
# 1. バグを修正 [Shift+Enter]
# 2. テストを追加 [Enter で送信]
```

手動でのターミナル設定は不要になりました。

## 実践例

### 複数行のプロンプト入力

長い指示や構造化されたリクエストを複数行で記述できます。

```
以下の要件でAPIエンドポイントを作成してください：[Shift+Enter]
[Shift+Enter]
- エンドポイント: /api/users[Shift+Enter]
- メソッド: GET[Shift+Enter]
- 認証: JWT必須[Shift+Enter]
- レスポンス: JSON形式[Enter で送信]
```

### コードスニペットの貼り付け後の追加指示

コードを貼り付けた後、改行して追加の指示を記述できます。

```
[コードを貼り付け][Shift+Enter]
[Shift+Enter]
上記のコードをリファクタリングして、[Shift+Enter]
パフォーマンスを改善してください。[Enter で送信]
```

### Markdownリストの入力

箇条書きのリストを自然に入力できます。

```
以下のタスクを実行：[Shift+Enter]
- ユニットテストの作成[Shift+Enter]
- ドキュメントの更新[Shift+Enter]
- コードレビューの実施[Enter で送信]
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **対応ターミナル**: iTerm2、WezTerm、Ghostty、Kitty
- 対応ターミナルでは設定ファイルの編集が不要になりました
- SSH接続経由でClaude Codeを使用する場合、一部のターミナルでShift+Enterが動作しないバグが報告されています
- Ghosttyの一部バージョンでは、Shift+Enterが `[27;2;13~` エスケープシーケンスとして送信される問題が報告されています
  - 回避策: Ghostty設定に `keybind = shift+enter=text:\n` を追加
- v2.1.1以降、Option+EnterがiTerm2で動作しなくなったという報告があります
- 問題が発生した場合は `/terminal-setup` コマンドで手動設定も可能です

## 関連情報

- [Optimize your terminal setup - Claude Code Docs](https://code.claude.com/docs/en/terminal-config)
- [Claude Code Terminal Setup - ClaudeLog](https://claudelog.com/faqs/claude-code-terminal-setup/)
- [GitHub Issue: Shift+Enter in Ghostty](https://github.com/anthropics/claude-code/issues/5757)
