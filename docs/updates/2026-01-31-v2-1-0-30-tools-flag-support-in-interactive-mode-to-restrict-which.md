---
title: "`--tools` フラグでインタラクティブセッション中のツール使用を制限"
date: 2026-01-31
tags: ['新機能', 'パーミッション', 'CLI']
---

## 原文（日本語に翻訳）

インタラクティブモードで `--tools` フラグのサポートを追加し、インタラクティブセッション中にClaudeが使用できる組み込みツールを制限できるようになりました

## 原文（英語）

Added `--tools` flag support in interactive mode to restrict which built-in tools Claude can use during interactive sessions

## 概要

Claude Code v2.1.0で導入された、セッション単位のツール制限機能です。`--tools` フラグを使うことで、起動時に使用可能なツールのホワイトリストを指定でき、Claudeはそのリストに含まれるツールのみを使用できます。これにより、読み取り専用のセッション、コードレビュー専用セッション、教育目的の制限セッションなど、特定の目的に最適化された環境を簡単に構築できます。

## 基本的な使い方

`--tools` フラグでカンマ区切りのツールリストを指定します。

```bash
# 読み取り専用ツールのみ許可
claude --tools "Read,Grep,Glob"

# 特定のツールセットを許可
claude --tools "Read,Write,Edit"

# 単一ツールのみ許可
claude --tools "Bash"
```

## 実践例

### 読み取り専用セッション

コードベースの調査・分析専用セッションを作成します。

```bash
# ファイル読み取りと検索のみ許可
claude --tools "Read,Grep,Glob,LSP"

# このセッションでは:
# ✅ ファイルの読み取り
# ✅ コード検索
# ✅ ファイル一覧表示
# ✅ LSPによる定義ジャンプ
# ❌ ファイルの変更（Write, Edit）
# ❌ コマンド実行（Bash）
# ❌ ファイル削除

# 使用例
> このプロジェクトの認証機能について教えて
# Claudeは Read, Grep ツールを使って調査
# コードを変更せずに説明のみ提供
```

### コードレビューセッション

コードレビューに必要なツールのみを許可します。

```bash
# コードレビュー用
claude --tools "Read,Grep,Glob,WebFetch,LSP"

# レビューワークフロー
> 最新のPRをレビューして
# ✅ ファイル読み取り
# ✅ GitHubからPR情報取得（WebFetch）
# ✅ コード検索
# ✅ LSPで定義確認
# ❌ コードの修正は提案のみ
```

### 教育・学習セッション

初心者向けに基本ツールのみを有効化します。

```bash
# 基本ツールのみ
claude --tools "Read,Write"

# 学習者は:
# ✅ ファイルを読む
# ✅ 新しいファイルを作成
# ❌ 複雑なツール（Bash, Task）は使用不可
# → 基本操作に集中できる
```

### CI/CD専用セッション

自動化されたCI/CDパイプラインで必要なツールのみを許可します。

```bash
# CI/CD用の制限セッション
claude --tools "Read,Bash,Grep" \
  --prompt "テストを実行してレポートを作成"

# GitHub Actions workflow
- name: Run Claude Code analysis
  run: |
    claude --tools "Read,Grep,Glob,WebSearch" \
      --prompt "セキュリティ脆弱性をスキャン"
```

### データ分析専用セッション

データ分析に必要なツールのみを許可します。

```bash
# データ分析用
claude --tools "Read,Bash,WebFetch"

> このCSVファイルを分析して
# ✅ ファイル読み取り
# ✅ Bashで統計処理（awk, grep）
# ✅ Web APIからデータ取得
# ❌ ファイル変更は不可（元データを保護）
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- `--tools` フラグの動作:
  - ホワイトリスト方式（指定したツールのみ許可）
  - フラグを省略すると、すべてのツールが利用可能（デフォルト動作）
- 主な組み込みツール:
  - **ファイル操作**: `Read`, `Write`, `Edit`, `Glob`
  - **検索**: `Grep`, `WebSearch`, `WebFetch`
  - **実行**: `Bash`, `Task`
  - **LSP**: `LSP`（Language Server Protocol）
  - **その他**: `AskUserQuestion`, `EnterPlanMode`, `Skill`
- ツール名の指定:
  - 大文字小文字を区別（`Read` は正しいが `read` は不可）
  - カンマ区切りで複数指定
  - スペースは含めない（`"Read, Write"` ではなく `"Read,Write"`）
- `--disallowedTools` との違い:
  - `--tools`: ホワイトリスト（指定したもののみ許可）
  - `--disallowedTools`: ブラックリスト（指定したものを禁止）
  - 両方指定した場合、`--tools` が優先される
- 制限の影響:
  - 禁止されたツールを使用しようとすると、Claudeは代替手段を探すか、ユーザーに通知
  - 一部のワークフローが動作しなくなる可能性がある
- 推奨される組み合わせ:
  - **読み取り専用**: `Read,Grep,Glob,LSP`
  - **基本編集**: `Read,Write,Edit,Grep,Glob`
  - **フル編集**: `Read,Write,Edit,Bash,Grep,Glob,Task`
  - **コードレビュー**: `Read,Grep,Glob,LSP,WebFetch`
  - **データ分析**: `Read,Bash,WebFetch,WebSearch`
- settings.jsonとの併用:
  ```json
  // グローバル設定
  {
    "permissions": {
      "disallowedTools": ["Bash"]
    }
  }
  ```
  ```bash
  # CLIフラグが settings.json をオーバーライド
  claude --tools "Read,Bash"  # Bashが使用可能
  ```

## 関連情報

- [Permissions - Claude Code Docs](https://code.claude.com/docs/en/permissions)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
- [CLI reference](https://code.claude.com/docs/en/cli-reference)
