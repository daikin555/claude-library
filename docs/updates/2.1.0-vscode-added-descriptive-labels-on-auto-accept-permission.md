---
title: "[VSCode] パーミッション自動承認ボタンに説明的なラベルを追加"
date: 2026-01-31
tags: ['新機能', 'VSCode', 'パーミッション', 'UI']
---

## 原文（日本語に翻訳）

[VSCode] パーミッション自動承認ボタンに説明的なラベルを追加しました（例: 「Yes, and don't ask again」の代わりに「Yes, allow npm for this project」）

## 原文（英語）

[VSCode] Added descriptive labels on auto-accept permission button (e.g., "Yes, allow npm for this project" instead of "Yes, and don't ask again")

## 概要

Claude Code for VSCode v2.1.0で改善された、パーミッション承認ボタンのラベル表示です。以前のバージョンでは、自動承認ボタンが「Yes, and don't ask again」という曖昧なラベルで、具体的に何を承認するのか分かりにくい問題がありました。この改善により、「Yes, allow npm for this project」のように、承認する操作が明確に表示されるようになりました。

## 改善前の動作

```
# npmコマンド実行時
Permission required:

Execute: npm install

[No]  [Yes]  [Yes, and don't ask again]
               ↑ 何を許可するか不明確
```

## 改善後の動作

```
# 同じ操作
Permission required:

Execute: npm install

[No]  [Yes]  [Yes, allow npm for this project]
               ↑ 何を許可するか明確！

# ✓ npmコマンドを承認と分かる
# ✓ プロジェクト単位の設定と分かる
```

## 実践例

### コマンド別のラベル

```
# npm
[Yes, allow npm for this project]

# git
[Yes, allow git for this project]

# Docker
[Yes, allow docker for this project]

# カスタムスクリプト
[Yes, allow "./deploy.sh" for this project]

# ✓ 各コマンドが明確
```

### ファイル操作

```
# ファイル読み込み
[Yes, allow reading .env]

# ファイル書き込み
[Yes, allow writing config.json]

# ファイル削除
[Yes, allow deleting temp files]

# ✓ 操作内容が明確
```

## 注意点

- VSCode extension v2.1.0で追加
- ラベルの形式:
  - コマンド: `Yes, allow <command> for this project`
  - ファイル: `Yes, allow <operation> <file>`
  - ネットワーク: `Yes, allow API calls to <domain>`
- スコープ:
  - プロジェクト単位: "for this project"
  - グローバル: "for all projects"（設定による）
- 設定の確認:
  - 承認後は `.vscode/claude-permissions.json` に保存
  - いつでも設定から変更・削除可能

## 関連情報

- [VSCode extension - Permissions](https://code.claude.com/docs/en/vscode#permissions)
- [Permission management](https://code.claude.com/docs/en/permissions)
