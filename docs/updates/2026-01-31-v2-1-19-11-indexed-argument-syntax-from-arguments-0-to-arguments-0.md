---
title: "インデックス付き引数構文をドット記法からブラケット記法に変更"
date: 2026-01-23
tags: ['変更', 'スキル', '引数', '構文']
---

## 原文（日本語に翻訳）

インデックス付き引数構文を `$ARGUMENTS.0` から `$ARGUMENTS[0]` （ブラケット構文）に変更しました。

## 原文（英語）

Changed indexed argument syntax from `$ARGUMENTS.0` to `$ARGUMENTS[0]` (bracket syntax)

## 概要

Claude Code v2.1.19で導入された構文変更です。スキルやカスタムコマンドで個別の引数にアクセスする際の記法が、ドット記法（`$ARGUMENTS.0`）からブラケット記法（`$ARGUMENTS[0]`）に変更されました。この変更により、一般的なプログラミング言語の配列アクセス構文との一貫性が向上し、より直感的に引数を扱えるようになります。なお、v2.1.19では省略記法 `$0`, `$1` も追加されており、さらに簡潔な記述が可能です。

## 基本的な使い方

スキル定義で引数にアクセスする際の記法が変更されました。

**旧記法（非推奨）:**

```yaml
---
name: migrate
description: コンポーネントを移行
---

$ARGUMENTS.0 を $ARGUMENTS.1 から $ARGUMENTS.2 へ移行してください。
```

**新記法（ブラケット構文）:**

```yaml
---
name: migrate
description: コンポーネントを移行
---

$ARGUMENTS[0] を $ARGUMENTS[1] から $ARGUMENTS[2] へ移行してください。
```

**省略記法（推奨）:**

```yaml
---
name: migrate
description: コンポーネントを移行
---

$0 を $1 から $2 へ移行してください。
```

## 実践例

### 既存スキルの更新

旧記法で書かれたスキルを新記法に更新:

**更新前:**

```yaml
# .claude/skills/convert-file/SKILL.md
---
name: convert-file
description: ファイル形式を変換
argument-hint: [入力ファイル] [出力形式]
---

# ファイル変換

$ARGUMENTS.0 を $ARGUMENTS.1 形式に変換してください。

変換手順:
1. $ARGUMENTS.0 を読み込む
2. $ARGUMENTS.1 形式で出力
3. 元のファイルは保持
```

**更新後（ブラケット構文）:**

```yaml
# .claude/skills/convert-file/SKILL.md
---
name: convert-file
description: ファイル形式を変換
argument-hint: [入力ファイル] [出力形式]
---

# ファイル変換

$ARGUMENTS[0] を $ARGUMENTS[1] 形式に変換してください。

変換手順:
1. $ARGUMENTS[0] を読み込む
2. $ARGUMENTS[1] 形式で出力
3. 元のファイルは保持
```

**更新後（省略記法 - 推奨）:**

```yaml
# .claude/skills/convert-file/SKILL.md
---
name: convert-file
description: ファイル形式を変換
argument-hint: [入力ファイル] [出力形式]
---

# ファイル変換

$0 を $1 形式に変換してください。

変換手順:
1. $0 を読み込む
2. $1 形式で出力
3. 元のファイルは保持
```

### データベーススクリプト生成

```yaml
# 旧記法
---
name: generate-migration
description: データベースマイグレーションを生成
argument-hint: [マイグレーション名] [テーブル名]
---

"$ARGUMENTS.0" という名前で $ARGUMENTS.1 テーブルのマイグレーションを生成

# 新記法（ブラケット）
"$ARGUMENTS[0]" という名前で $ARGUMENTS[1] テーブルのマイグレーションを生成

# 省略記法（推奨）
"$0" という名前で $1 テーブルのマイグレーションを生成
```

**使用例:**

```bash
/generate-migration add-email-column users
```

### コンポーネント生成スキル

```yaml
# 旧記法
---
name: create-component
description: Reactコンポーネントを生成
argument-hint: [コンポーネント名] [タイプ]
---

$ARGUMENTS.0 という名前の $ARGUMENTS.1 コンポーネントを作成:

- ファイル名: $ARGUMENTS.0.tsx
- タイプ: $ARGUMENTS.1 (functional/class)
- PropTypesを含める
- テストファイルも生成

# 新記法（ブラケット）
$ARGUMENTS[0] という名前の $ARGUMENTS[1] コンポーネントを作成:

- ファイル名: $ARGUMENTS[0].tsx
- タイプ: $ARGUMENTS[1] (functional/class)
- PropTypesを含める
- テストファイルも生成

# 省略記法（推奨）
$0 という名前の $1 コンポーネントを作成:

- ファイル名: $0.tsx
- タイプ: $1 (functional/class)
- PropTypesを含める
- テストファイルも生成
```

**使用例:**

```bash
/create-component UserProfile functional
```

### API エンドポイント生成

```yaml
# 旧記法
---
name: create-endpoint
description: RESTful APIエンドポイントを生成
argument-hint: [リソース名] [HTTPメソッド] [認証が必要か]
---

# $ARGUMENTS.1 $ARGUMENTS.0 エンドポイント

パス: /$ARGUMENTS.0
メソッド: $ARGUMENTS.1
認証: $ARGUMENTS.2

# 新記法（ブラケット）
# $ARGUMENTS[1] $ARGUMENTS[0] エンドポイント

パス: /$ARGUMENTS[0]
メソッド: $ARGUMENTS[1]
認証: $ARGUMENTS[2]

# 省略記法（推奨）
# $1 $0 エンドポイント

パス: /$0
メソッド: $1
認証: $2
```

**使用例:**

```bash
/create-endpoint users GET true
/create-endpoint posts POST true
```

### 一括リネームスキル

```yaml
# 旧記法
---
name: bulk-rename
description: ファイルを一括リネーム
argument-hint: [パターン] [置換文字列] [ディレクトリ]
---

$ARGUMENTS.2 内で $ARGUMENTS.0 を $ARGUMENTS.1 に置換してファイルをリネーム:

1. $ARGUMENTS.2 でファイルを検索
2. $ARGUMENTS.0 にマッチするファイル名を特定
3. $ARGUMENTS.1 で置換
4. 変更をプレビュー
5. 確認後に実行

# 新記法（ブラケット）
$ARGUMENTS[2] 内で $ARGUMENTS[0] を $ARGUMENTS[1] に置換してファイルをリネーム:

1. $ARGUMENTS[2] でファイルを検索
2. $ARGUMENTS[0] にマッチするファイル名を特定
3. $ARGUMENTS[1] で置換
4. 変更をプレビュー
5. 確認後に実行

# 省略記法（推奨）
$2 内で $0 を $1 に置換してファイルをリネーム:

1. $2 でファイルを検索
2. $0 にマッチするファイル名を特定
3. $1 で置換
4. 変更をプレビュー
5. 確認後に実行
```

**使用例:**

```bash
/bulk-rename "test-" "spec-" src/tests
```

## 注意点

- **下位互換性**: 旧記法（`$ARGUMENTS.0`）も当面サポートされる可能性がありますが、新規スキルでは新記法を使用してください
- **省略記法の推奨**: `$ARGUMENTS[0]` よりも `$0` の方が簡潔で読みやすいため、省略記法の使用を推奨します
- **配列インデックスとの一貫性**: ブラケット記法は、JavaScript、Python、Go などの配列アクセス構文と一致します
- **既存スキルの更新**: 既存のスキルは必須ではありませんが、可読性向上のため更新を検討してください
- **0始まりのインデックス**: `$ARGUMENTS[0]` または `$0` が最初の引数であることに注意
- **全引数へのアクセス**: すべての引数をまとめて取得する場合は `$ARGUMENTS` を使用します

## 関連情報

- [Claude Code 公式ドキュメント - Skills](https://code.claude.com/docs/en/skills)
- [Claude Code 公式ドキュメント - Argument Substitution](https://code.claude.com/docs/en/skills#available-string-substitutions)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
- [省略記法 $0, $1 の追加（v2.1.19）](./2026-01-31-v2-1-19-1-shorthand-0-1-etc-for-accessing-individual-argument.md)
