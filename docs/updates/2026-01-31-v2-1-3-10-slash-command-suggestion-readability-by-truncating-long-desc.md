---
title: "スラッシュコマンドのサジェスト表示を改善"
date: 2026-01-09
tags: ['改善', 'コマンド', 'UI', 'UX']
---

## 原文（日本語に翻訳）

長い説明を2行に切り詰めることで、スラッシュコマンドのサジェストの可読性を向上させました

## 原文（英語）

Improved slash command suggestion readability by truncating long descriptions to 2 lines

## 概要

Claude Code v2.1.3では、スラッシュコマンドやスキルの説明が長い場合に、サジェストリストで2行に切り詰めて表示するようになりました。これにより、一度に表示できるコマンド数が増え、目的のコマンドを素早く見つけやすくなります。詳細な説明は、コマンドを選択した後に確認できます。

## 基本的な使い方

`/` を入力すると、利用可能なコマンドのサジェストリストが表示されます。

```bash
# スラッシュコマンドを入力
/

# サジェストリストが表示される
# v2.1.3では、各項目が最大2行で表示される
```

## 実践例

### 修正前の表示

長い説明のコマンドがあると、リストが見づらくなっていました。

```bash
# 修正前のサジェストリスト表示例
/
├─ /commit
│  Creates a git commit with staged changes. Analyzes the diff,
│  writes a descriptive commit message following conventional
│  commits format, and includes co-authored-by trailer.
│  Supports custom commit messages via -m flag.
├─ /help
│  Shows this very long help message that explains...
│  (1つのコマンドが4-5行を占有)
└─ /config
   ...

# 問題点：
# - 画面に2-3個のコマンドしか表示できない
# - スクロールが必要
# - 目的のコマンドを探しにくい
```

### 修正後の表示

v2.1.3では、説明が2行に切り詰められます。

```bash
# 修正後のサジェストリスト表示例
/
├─ /commit
│  Creates a git commit with staged changes. Analyzes the diff...
├─ /help
│  Shows help information about available commands and features...
├─ /config
│  Opens configuration settings for Claude Code...
├─ /doctor
│  Runs diagnostic checks to identify configuration issues...
├─ /clear
│  Clears the current conversation and starts fresh...
└─ (さらに多くのコマンドが表示される)

# 改善点：
# ✅ 画面に5-7個のコマンドを同時表示
# ✅ スクロールが減る
# ✅ コマンドを素早く見つけられる
```

### カスタムスキルでの効果

詳細な説明を持つカスタムスキルでも、リストが見やすくなります。

```bash
# カスタムスキルの例
/
├─ /my-project-setup
│  This skill sets up the entire project environment including...
├─ /generate-documentation
│  Automatically generates comprehensive documentation for...
├─ /run-tests
│  Executes the full test suite with coverage reports and...

# 長い説明が2行に切り詰められるため、
# 多くのカスタムスキルを登録していても
# サジェストリストが整理されて見やすい
```

### 検索時の動作

コマンド名の一部を入力して絞り込む場合も、見やすい表示が維持されます。

```bash
# 「git」に関連するコマンドを検索
/git

# フィルタされたリストが表示される
├─ /commit
│  Creates a git commit with staged changes...
├─ /git-status
│  Shows the current git repository status...
└─ /git-diff
   Displays changes in the working directory...

# 絞り込まれた結果も2行表示で見やすい
```

### 詳細情報の確認

完全な説明は、コマンドを選択すると表示されます。

```bash
# コマンドを選択（例：/commit）
# → 詳細なヘルプ情報が表示される
# → 完全な説明、オプション、使用例などを確認可能

# サジェストリストでは概要のみを表示し、
# 詳細は選択後に確認する設計
```

## 注意点

- 説明の切り詰めは表示のみに影響し、実際の機能には変更ありません
- 完全な説明を確認したい場合は、コマンドを選択するか `/help <command>` を実行してください
- カスタムスキルを作成する際は、最初の2行に重要な情報を記載することを推奨します
- 2行以下の説明の場合は、切り詰められることなくそのまま表示されます

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3)
- [カスタムスキルの作成ガイド](https://github.com/anthropics/claude-code)
- [コマンド一覧とヘルプ](https://github.com/anthropics/claude-code)
