---
title: "カスタムコマンド・スキルで個別引数にアクセスする省略記法 $0, $1 の追加"
date: 2026-01-23
tags: ['新機能', 'スキル', 'カスタムコマンド', '引数']
---

## 原文（日本語に翻訳）

カスタムコマンドで個別の引数にアクセスするための省略記法 `$0`, `$1` などを追加しました。

## 原文（英語）

Added shorthand `$0`, `$1`, etc. for accessing individual arguments in custom commands

## 概要

Claude Code v2.1.19で、カスタムコマンドやスキルで個別の引数に簡単にアクセスできる省略記法が追加されました。従来の `$ARGUMENTS[0]`, `$ARGUMENTS[1]` という記法に加えて、より短い `$0`, `$1` という書き方が使えるようになりました。これにより、スキルやカスタムコマンドの定義がよりシンプルで読みやすくなります。

## 基本的な使い方

スキルの `SKILL.md` やカスタムコマンド内で、`$0`, `$1`, `$2` のように使用します。

**従来の記法:**

```yaml
---
name: migrate-component
description: コンポーネントを別フレームワークに移行する
---

$ARGUMENTS[0] コンポーネントを $ARGUMENTS[1] から $ARGUMENTS[2] に移行してください。
既存の動作とテストをすべて保持してください。
```

**新しい省略記法:**

```yaml
---
name: migrate-component
description: コンポーネントを別フレームワークに移行する
---

$0 コンポーネントを $1 から $2 に移行してください。
既存の動作とテストをすべて保持してください。
```

**使用例:**

```bash
/migrate-component SearchBar React Vue
```

上記のコマンドを実行すると:
- `$0` → `SearchBar`
- `$1` → `React`
- `$2` → `Vue`

## 実践例

### ファイル形式変換スキル

複数の引数を受け取って処理するスキルの例:

```yaml
---
name: convert
description: ファイルを別の形式に変換する
argument-hint: [入力ファイル] [出力形式]
---

# ファイル変換タスク

$0 を $1 形式に変換してください。

要件:
- 元のファイル構造を維持する
- データの整合性を保証する
- 変換後のファイルを検証する
```

**使用例:**

```bash
/convert data.json yaml
/convert config.yaml toml
```

### GitHub Issue修正スキル

Issue番号とブランチ名を引数として受け取る例:

```yaml
---
name: fix-issue
description: GitHub Issueを修正する
argument-hint: [issue番号] [ブランチ名(オプション)]
disable-model-invocation: true
---

# Issue #$0 の修正

Issue #$0 を以下の手順で修正してください:

1. Issue内容を確認 (`gh issue view $0`)
2. ブランチ作成 (名前: $1 または自動生成)
3. 修正を実装
4. テストを追加/更新
5. コミットを作成
```

**使用例:**

```bash
/fix-issue 123
/fix-issue 456 feature/auth-fix
```

### デプロイメントスキル

環境と設定を引数で指定する例:

```yaml
---
name: deploy
description: アプリケーションをデプロイする
argument-hint: [環境] [設定ファイル(オプション)]
disable-model-invocation: true
allowed-tools: Bash(*)
---

# $0 環境へのデプロイ

デプロイ手順:

1. テストスイートの実行
2. ビルドの作成
3. 設定ファイル: ${1:-default.config.json}
4. $0 環境へプッシュ
5. デプロイメントの検証
```

**使用例:**

```bash
/deploy staging
/deploy production prod.config.json
```

### コードレビュースキル

レビュー対象とフォーカスエリアを指定:

```yaml
---
name: review
description: コードレビューを実施する
argument-hint: [対象ファイル/ディレクトリ] [フォーカスエリア(オプション)]
context: fork
agent: Explore
---

# $0 のコードレビュー

レビューフォーカス: ${1:-セキュリティ、パフォーマンス、保守性}

以下の観点でレビューしてください:

1. $0 内のファイルを特定
2. ${1:-一般的な}観点でコードを分析
3. 具体的な改善提案を作成
4. ファイルパスと行番号を含める
```

**使用例:**

```bash
/review src/auth
/review src/api セキュリティ
/review components/UserProfile.tsx パフォーマンス
```

## 注意点

- **インデックスは0始まり**: `$0` が最初の引数、`$1` が2番目、というように続きます
- **両方の記法が使用可能**: `$0` と `$ARGUMENTS[0]` は同じ意味で、どちらも使用できます
- **未指定の引数**: 引数が指定されていない場合、該当するプレースホルダーは空文字列になります
- **全引数の取得**: すべての引数をまとめて取得する場合は `$ARGUMENTS` を使用します
- **デフォルト値の設定**: Bash風の構文 `${1:-デフォルト値}` は直接サポートされていないため、スキル内で条件分岐が必要な場合はClaudeに判断させます

## 関連情報

- [Claude Code 公式ドキュメント - Skills](https://code.claude.com/docs/en/skills)
- [Claude Code 公式ドキュメント - Argument Substitution](https://code.claude.com/docs/en/skills#available-string-substitutions)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
