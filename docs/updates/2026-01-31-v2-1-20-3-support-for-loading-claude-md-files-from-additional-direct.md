---
title: "追加ディレクトリからのCLAUDE.mdファイル読み込みをサポート"
date: 2026-01-27
tags: ['新機能', 'CLAUDE.md', 'メモリ管理', '設定']
---

## 原文（日本語に翻訳）

`--add-dir`フラグで指定された追加ディレクトリからの`CLAUDE.md`ファイル読み込みをサポート（`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`の設定が必要）

## 原文（英語）

Added support for loading `CLAUDE.md` files from additional directories specified via `--add-dir` flag (requires setting `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`)

## 概要

Claude Code v2.1.20で、`--add-dir`フラグで追加したディレクトリから`CLAUDE.md`ファイルを読み込む機能が追加されました。これにより、複数のプロジェクトやモジュールに分散したコードベースで作業する際に、各ディレクトリの設定やガイドラインを統合的に活用できます。環境変数`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`を設定することで有効化されます。

## 基本的な使い方

環境変数を設定して、追加ディレクトリからCLAUDE.mdを読み込む：

```bash
# 環境変数を設定して追加ディレクトリのCLAUDE.mdを読み込み
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../shared-config

# 複数のディレクトリを指定する場合
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude --add-dir ../app ../lib ../shared
```

## 読み込まれるファイル

この機能を有効にすると、指定した追加ディレクトリから以下のファイルが読み込まれます：

- `CLAUDE.md`
- `.claude/CLAUDE.md`
- `.claude/rules/*.md`（ルールファイル）

## 実践例

### モノレポ構成での利用

複数のアプリケーションやライブラリが含まれるモノレポで作業する場合：

```bash
# ディレクトリ構成
# monorepo/
# ├── apps/
# │   ├── web/
# │   │   └── CLAUDE.md  # Webアプリ固有の設定
# │   └── mobile/
# │       └── CLAUDE.md  # モバイルアプリ固有の設定
# ├── packages/
# │   ├── ui/
# │   │   └── CLAUDE.md  # UIライブラリのガイドライン
# │   └── api/
# │       └── CLAUDE.md  # APIクライアントの規約
# └── shared-config/
#     └── CLAUDE.md      # 共通設定

# webアプリで作業しつつ、共通設定とUIライブラリの設定も読み込む
cd apps/web
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude \
  --add-dir ../../shared-config \
  --add-dir ../../packages/ui
```

### 共有設定ライブラリの利用

チーム全体で共有する設定を別リポジトリで管理：

```bash
# プロジェクト構成
# ~/projects/
# ├── my-project/
# │   └── CLAUDE.md           # プロジェクト固有の設定
# └── shared-claude-rules/
#     ├── CLAUDE.md           # チーム共通の設定
#     └── .claude/rules/
#         ├── code-style.md
#         ├── testing.md
#         └── security.md

# my-projectで作業しつつ、共有ルールも読み込む
cd ~/projects/my-project
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude \
  --add-dir ~/projects/shared-claude-rules
```

### 環境ごとの設定分離

開発、ステージング、本番環境ごとに異なる設定を管理：

```bash
# 環境別設定
# project/
# ├── src/
# │   └── CLAUDE.md              # プロジェクト設定
# └── config/
#     ├── dev/
#     │   └── CLAUDE.md          # 開発環境用設定
#     ├── staging/
#     │   └── CLAUDE.md          # ステージング環境用設定
#     └── production/
#         └── CLAUDE.md          # 本番環境用設定

# 開発環境用の設定で作業
cd src
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude \
  --add-dir ../config/dev

# 本番環境用の設定で作業（異なるURL、厳格なルール等）
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude \
  --add-dir ../config/production
```

### マイクロサービス構成での利用

複数のマイクロサービスを統合的に開発：

```bash
# マイクロサービス構成
# services/
# ├── auth-service/
# │   └── CLAUDE.md
# ├── user-service/
# │   └── CLAUDE.md
# ├── payment-service/
# │   └── CLAUDE.md
# └── shared/
#     ├── CLAUDE.md              # サービス共通の規約
#     └── .claude/rules/
#         ├── api-contracts.md   # API契約
#         └── database.md        # DB規約

# payment-serviceで作業しつつ、共有規約とauth-serviceの設定も参照
cd payment-service
CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 claude \
  --add-dir ../shared \
  --add-dir ../auth-service
```

## 環境変数の永続設定

毎回環境変数を設定するのを避けるため、シェル設定ファイルに追加：

```bash
# ~/.bashrc または ~/.zshrc に追加
export CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1

# これで単純に実行可能
claude --add-dir ../shared-config
```

## 設定の読み込み順序

CLAUDE.mdファイルは以下の優先順位で読み込まれます（高い順）：

1. **Managed policy** - 組織全体の設定
2. **Project memory** - プロジェクト固有の設定（./CLAUDE.md）
3. **Project rules** - プロジェクトルール（./.claude/rules/*.md）
4. **User memory** - ユーザー個人の設定（~/.claude/CLAUDE.md）
5. **Project memory (local)** - ローカル設定（./CLAUDE.local.md）
6. **Additional directories** - 追加ディレクトリの設定（この機能）

## 注意点

- `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`環境変数の設定が必須です
- この環境変数がない場合、`--add-dir`で指定したディレクトリのファイルにはアクセスできますが、CLAUDE.mdは読み込まれません
- 追加ディレクトリのCLAUDE.mdはプロジェクトのCLAUDE.mdより優先度が低いです
- 循環参照やシンボリックリンクのループは自動的に検出・処理されます
- 読み込まれた設定は`/memory`コマンドで確認できます

## 設定の確認方法

読み込まれているCLAUDE.mdファイルを確認：

```bash
# Claude Code内で実行
/memory

# または設定を編集
/memory
```

## 関連情報

- [Memory management](https://code.claude.com/docs/en/memory)
- [Load memory from additional directories](https://code.claude.com/docs/en/memory#load-memory-from-additional-directories)
- [Modular rules with .claude/rules/](https://code.claude.com/docs/en/memory#modular-rules-with-clauderules)
- [CLI reference - --add-dir flag](https://code.claude.com/docs/en/cli-reference)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
