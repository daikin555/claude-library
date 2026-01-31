---
title: "Bashツールパーミッションのワイルドカードパターンマッチングを追加"
date: 2026-01-31
tags: ['新機能', 'bash', 'パーミッション', 'セキュリティ']
---

## 原文（日本語に翻訳）

Bashツールパーミッションでワイルドカードパターンマッチングを追加しました。ルール内の任意の位置で `*` を使用できます（例: `Bash(npm *)`、`Bash(* install)`、`Bash(git * main)`）

## 原文（英語）

Added wildcard pattern matching for Bash tool permissions using `*` at any position in rules (e.g., `Bash(npm *)`, `Bash(* install)`, `Bash(git * main)`)

## 概要

Claude Code v2.1.0で導入された、Bashパーミッションルールのワイルドカードマッチング機能です。パーミッションルール内の任意の位置で `*` ワイルドカードを使用できるようになり、柔軟なコマンドパターンの許可が可能になりました。例えば `Bash(npm *)` は "npm" で始まるすべてのコマンドにマッチし、`Bash(* install)` は "install" で終わるコマンドにマッチします。これにより、個別のコマンドごとにルールを作成する必要がなくなります。

## 基本的な使い方

`settings.json` のパーミッションルールでワイルドカード `*` を使用します。

```json
{
  "permissions": {
    "Bash": {
      "allow": [
        "npm *",
        "git * main",
        "* --help"
      ]
    }
  }
}
```

### ワイルドカードのパターン

- `Bash(npm *)`: "npm" で始まるすべてのコマンド（例: npm install、npm run test）
- `Bash(* install)`: "install" で終わるコマンド（例: npm install、yarn install）
- `Bash(git * main)`: "git" で始まり "main" で終わるコマンド（例: git push origin main）
- `Bash(*-h*)`: "-h" を含むコマンド（例: git -h、npm -h）

## 実践例

### npm/yarnコマンドの一括許可

開発でよく使用するnpm/yarnコマンドを一括で許可します。

```json
{
  "permissions": {
    "Bash": {
      "allow": [
        "npm *",
        "yarn *",
        "pnpm *"
      ]
    }
  }
}
```

これにより `npm install`、`npm run dev`、`yarn build` などがすべて許可されます。

### Gitコマンドの柔軟な許可

特定のブランチへの操作を許可します。

```json
{
  "permissions": {
    "Bash": {
      "allow": [
        "git * main",
        "git * develop",
        "git status",
        "git diff"
      ],
      "deny": [
        "git push * main",
        "git push --force *"
      ]
    }
  }
}
```

### ヘルプコマンドの一括許可

すべてのツールのヘルプオプションを許可します。

```json
{
  "permissions": {
    "Bash": {
      "allow": [
        "* --help",
        "* -h",
        "* help"
      ]
    }
  }
}
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **スペースの扱いに注意**: `Bash(ls *)` は "ls -la" にマッチしますが "lsof" にはマッチしません。`Bash(ls*)` は両方にマッチします
- **セキュリティ上の制限**: ワイルドカードは文字列マッチングであり、以下のような回避が可能です：
  - `Bash(curl http://github.com/ *)` は以下で回避可能:
    - オプションをURLの前に配置: `curl -X POST http://github.com/`
    - 異なるプロトコル: `curl https://github.com/`
    - リダイレクトや変数の使用
    - 余分なスペース
- **フラグと引数の組み合わせ**: 2026年1月時点で、特定のフラグとパス引数の組み合わせで正しくマッチしないエッジケースが報告されています
- **代替アプローチ**: より堅牢なセキュリティが必要な場合は、hooksを使用することを推奨します
  - Hooksはツール使用前に実行されるスクリプトで、より柔軟な承認/拒否ロジックを実装可能
- ワイルドカードは `:*` 構文でも使用可能: `Bash(npm:*)` は npm で始まるすべてのコマンドにマッチ

## 関連情報

- [Identity and Access Management - Claude Code Docs](https://code.claude.com/docs/en/iam)
- [A complete guide to Claude Code permissions](https://www.eesel.ai/blog/claude-code-permissions)
- [Better Claude Code permissions](https://blog.korny.info/2025/10/10/better-claude-code-permissions)
- [GitHub Issue: Bash permission pattern limitations](https://github.com/anthropics/claude-code/issues/20254)
