---
title: "CLIヘルプ出力をアルファベット順に表示するよう改善"
date: 2026-01-31
tags: ['改善', 'UX', 'CLI']
---

## 原文（日本語に翻訳）

より簡単にナビゲートできるよう、オプションとサブコマンドをアルファベット順に表示するようCLIヘルプ出力を改善しました

## 原文（英語）

Improved CLI help output to display options and subcommands in alphabetical order for easier navigation

## 概要

Claude Code v2.1.0で実装された、CLIヘルプ出力の改善です。以前のバージョンでは、オプションとサブコマンドが論理的なグループ順や実装順で表示されており、目的のコマンドを見つけにくい問題がありました。この改善により、すべてのオプションとサブコマンドがアルファベット順にソートされ、大量のコマンドがある場合でも素早く目的のコマンドを見つけられるようになりました。

## 改善前の表示

```bash
claude --help

# オプションが論理的グループ順で表示
Options:
  --model <model>      Model to use
  --resume <session>   Resume session
  --verbose            Verbose output
  --api-key <key>      API key
  --debug              Debug mode
  --version            Show version
  # ... 順序が不規則
```

## 改善後の表示

```bash
claude --help

# アルファベット順で表示（見つけやすい）
Options:
  --api-key <key>      API key
  --debug              Debug mode
  --model <model>      Model to use
  --resume <session>   Resume session
  --verbose            Verbose output
  --version            Show version
  # ... すべてアルファベット順
```

## 実践例

### コマンドの素早い検索

```bash
# "permission"関連のオプションを探す
claude --help | grep -i permission

# アルファベット順なので、pから始まるオプションを
# 素早くスキャンできる
```

### サブコマンドの一覧表示

```bash
# すべてのサブコマンドを確認
claude --help

Subcommands:
  auth          Manage authentication
  config        Configure settings
  hooks         Manage hooks
  plugin        Manage plugins
  session       Manage sessions
  settings      View/edit settings
  # ... アルファベット順に整理
```

### 特定コマンドのオプション確認

```bash
# 特定のサブコマンドのヘルプ
claude auth --help

Options:
  --check          Check authentication status
  --login          Login to Claude Code
  --logout         Logout from Claude Code
  --refresh        Refresh authentication token
  --status         Show authentication status
  # アルファベット順で見やすい
```

## 注意点

- この改善は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- 改善内容:
  - オプション（--フラグ）がアルファベット順にソート
  - サブコマンドがアルファベット順にソート
  - エイリアス（短縮形）も同様にソート
- 従来の論理的グループ化より、検索性を優先
- 大規模なCLIツールでの慣例に従った改善
- ヘルプ出力の他の側面:
  - 説明文は変更なし
  - 使用例は変更なし
  - デフォルト値の表示は変更なし
- コマンド補完（タブ補完）にも同様の順序が適用される場合があります

## 関連情報

- [Set up Claude Code - Official Docs](https://code.claude.com/docs/en/setup)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
