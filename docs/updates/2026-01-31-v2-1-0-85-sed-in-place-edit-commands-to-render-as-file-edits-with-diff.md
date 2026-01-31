---
title: "sedインプレース編集コマンドをdiffプレビュー付きファイル編集として表示するよう改善"
date: 2026-01-31
tags: ['改善', 'sed', 'diff', 'UI']
---

## 原文（日本語に翻訳）

sedインプレース編集コマンドを、diffプレビュー付きのファイル編集として表示するよう改善しました

## 原文（英語）

Improved sed in-place edit commands to render as file edits with diff preview

## 概要

Claude Code v2.1.0で改善された、sedコマンド実行時のUI表示です。以前のバージョンでは、Claudeが`sed -i`（インプレース編集）コマンドを実行する際、生のBashコマンドとして表示されるだけで、実際にどのファイルがどう変更されるかが分かりにくい問題がありました。この改善により、Editツールと同様のdiffプレビューが表示され、変更内容を事前に確認できるようになりました。

## 改善前の表示

### 生のsedコマンド表示

```bash
# Claudeがsedを実行
claude "Replace all 'foo' with 'bar' in config.js"

# 修正前の表示:
> Bash: sed -i 's/foo/bar/g' config.js

# 問題点:
# - 実際の変更内容が見えない
# - どの行が変更されるか不明
# - 承認前に確認できない
# - sedの構文を理解する必要がある
```

## 改善後の表示

### Diffプレビュー付き表示

```bash
# 同じタスク
claude "Replace all 'foo' with 'bar' in config.js"

# 修正後の表示:
┌─ config.js ─────────────────┐
│ -  const value = foo;       │
│ +  const value = bar;       │
│                              │
│ -  function getFoo() {      │
│ +  function getBar() {      │
│                              │
│ -    return foo;            │
│ +    return bar;            │
└──────────────────────────────┘

Apply these changes? [y/n]: _

# ✓ 変更内容が明確
# ✓ 承認前に確認可能
# ✓ ユーザーフレンドリー
```

## 実践例

### 設定ファイルの一括置換

環境変数名を変更。

```bash
claude "Rename API_KEY to API_TOKEN in all config files"

# 表示:
┌─ config/development.js ──┐
│ - API_KEY=xxx            │
│ + API_TOKEN=xxx          │
└──────────────────────────┘

┌─ config/production.js ───┐
│ - API_KEY=yyy            │
│ + API_TOKEN=yyy          │
└──────────────────────────┘

# ✓ 各ファイルの変更を確認
# ✓ 個別に承認可能
```

### コードリファクタリング

関数名を変更。

```bash
claude "Rename getUserData to fetchUserProfile"

# 表示:
┌─ src/api.ts ─────────────┐
│ - function getUserData() │
│ + function fetchUserPro  │
│ +   file()               │
└──────────────────────────┘

┌─ src/components.tsx ─────┐
│ - getUserData()          │
│ + fetchUserProfile()     │
└──────────────────────────┘

# ✓ すべての変更箇所を確認
```

### バージョン番号の更新

package.jsonのバージョンを更新。

```bash
claude "Bump version to 2.0.0"

# 表示:
┌─ package.json ───────────┐
│ -  "version": "1.5.0",   │
│ +  "version": "2.0.0",   │
└──────────────────────────┘

# ✓ 変更が1行だけと確認
# ✓ 安全に承認
```

### 正規表現での複雑な置換

URLパターンを変更。

```bash
claude "Update all http:// to https://"

# 表示:
┌─ README.md ──────────────────┐
│ - [Link](http://example.com) │
│ + [Link](https://example.com)│
└──────────────────────────────┘

# ✓ 正規表現の結果を視覚的に確認
# ✓ 意図しない変更がないか確認
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 対象コマンド:
  - `sed -i 's/.../.../g' file`
  - `sed -i.bak 's/.../.../g' file`（バックアップ付き）
  - その他のsedインプレース編集
- 表示される情報:
  - ファイルパス
  - 変更前の内容（赤色、`-`プレフィックス）
  - 変更後の内容（緑色、`+`プレフィックス）
  - 変更行の周辺コンテキスト
- Editツールとの違い:
  - **Editツール**: Claude Code専用の編集機能
  - **sed表示**: sedコマンドの視覚化
  - 両方とも同じdiffプレビューUI
- パーミッション:
  - sedコマンドも通常のBashコマンドとして許可が必要
  - diffプレビュー表示後に承認
  - `--auto-approve` フラグで自動承認可能
- 複数ファイルの編集:
  ```bash
  claude "Replace in all files"

  # 各ファイルごとにdiffを表示
  # 個別に承認または一括承認
  ```
- sedの制限:
  - 複雑なsedスクリプトは生のコマンドとして表示される場合あり
  - 単純な置換のみdiffプレビュー対応
- デバッグ:
  - `--debug` フラグでsedコマンドの詳細を確認
  - diff生成プロセスのログ表示
- 関連する改善:
  - index 24: Bash read commands preview（関連するUI改善）

## 関連情報

- [Edit tool - Claude Code Docs](https://code.claude.com/docs/en/tools#edit)
- [Bash tool](https://code.claude.com/docs/en/tools#bash)
- [Permissions](https://code.claude.com/docs/en/permissions)
