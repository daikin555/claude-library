---
title: "別ディレクトリからカスタムタイトルでセッション再開できない問題を修正"
date: 2026-01-23
tags: ['バグ修正', 'セッション管理', 'ディレクトリ']
---

## 原文（日本語に翻訳）

別のディレクトリから実行した際に、カスタムタイトルでセッションを再開できない問題を修正しました。

## 原文（英語）

Fixed resuming sessions by custom title not working when run from a different directory

## 概要

Claude Code v2.1.19で、異なるディレクトリから実行した場合に、カスタムタイトル（`/rename` で設定した名前）を使ってセッションを再開できない問題が修正されました。この修正により、どのディレクトリからでもセッション名を指定して作業を再開できるようになりました。

## 問題が発生していた状況

### ディレクトリ移動後の再開失敗

```bash
# プロジェクトAでセッション作成
cd ~/projects/app-a
claude
/rename "auth-feature"

# プロジェクトBに移動して同じセッションを再開しようとする
cd ~/projects/app-b
claude -r "auth-feature"
# → 以前: セッションが見つからないエラー
# → v2.1.19: 正常に再開できる
```

### ホームディレクトリからの再開

```bash
# プロジェクト内でセッション作成
cd ~/work/my-project/src/components
claude
/rename "component-refactor"

# ホームディレクトリから再開を試みる
cd ~
claude -r "component-refactor"
# → 以前: 失敗
# → v2.1.19: 成功
```

## 修正による改善

### 場所を問わないセッション再開

v2.1.19以降では、セッションをどこからでも再開可能になります:

```bash
# セッションを作成（任意の場所で）
cd /project/feature-a
claude
/rename "my-work-session"

# 別の場所から再開
cd /completely/different/path
claude -r "my-work-session"
# ✓ 正常に再開

# さらに別の場所から
cd ~/Desktop
claude -r "my-work-session"
# ✓ 正常に再開
```

## 実践例

### プロジェクト横断的な作業

複数のプロジェクトで同じセッションを継続:

```bash
# フロントエンドプロジェクトで開始
cd ~/projects/frontend
claude
/rename "fullstack-feature"

# APIプロジェクトに移動して継続
cd ~/projects/api
claude -r "fullstack-feature"
# ✓ セッションを再開

# モバイルアプリプロジェクトでも継続
cd ~/projects/mobile-app
claude -r "fullstack-feature"
# ✓ 同じセッションで作業
```

### モノレポ内の移動

```bash
# packages/backendで作業開始
cd ~/monorepo/packages/backend
claude
/rename "api-redesign"

# packages/frontendに移動
cd ../frontend
claude -r "api-redesign"
# ✓ セッションを再開して、バックエンド変更に合わせてフロントエンドを更新

# ドキュメント更新
cd ../../docs
claude -r "api-redesign"
# ✓ 同じセッションでドキュメントを更新
```

### リモート作業とローカル作業の切り替え

```bash
# ローカルでセッション開始
cd ~/local/project
claude
/rename "production-hotfix"

# リモートサーバーにSSH接続
ssh production-server
cd /var/www/app

# 同じセッション名で作業継続
claude -r "production-hotfix"
# ✓ ローカルとリモートで同じコンテキストを共有
```

### CI/CD環境での利用

```bash
# ローカルで開発
cd ~/project
claude
/rename "ci-pipeline-update"

# CIサーバー（異なるパス）で同じセッションを利用
# /ci/workspace/project
claude -r "ci-pipeline-update"
# ✓ ローカルとCI環境で一貫した作業
```

### 複数のワークスペースでの作業

```bash
# VSCodeワークスペース1
cd ~/workspace1/project
claude
/rename "shared-library-update"

# 別のIDEやエディタで開いているワークスペース2
cd ~/workspace2/another-project
claude -r "shared-library-update"
# ✓ 異なるワークスペース間でセッションを共有
```

## セッション管理のワークフロー

### セッションの命名規則

場所に依存しない明確な名前を使用:

```bash
# 機能名ベース
/rename "user-authentication"
/rename "payment-integration"

# Issue/PR番号を含める
/rename "fix-issue-123"
/rename "pr-456-review"

# 日付を含める
/rename "deploy-2026-01-31"

# チーム名やプロジェクト名
/rename "backend-team-sprint"
/rename "mobile-app-release"
```

### セッション一覧の表示と検索

```bash
# すべてのセッション表示
/history

# セッション名で検索（セッション名の一部を入力）
claude -r "auth"
# → "user-authentication" などの候補が表示

# 完全一致で再開
claude -r "user-authentication"
```

### セッションIDとタイトルの両方で再開

```bash
# セッションIDで再開
claude -r 550e8400-e29b-41d4-a716-446655440000

# または カスタムタイトルで再開
claude -r "my-custom-title"

# どちらも同じセッションを再開
```

## トラブルシューティング

### セッションが見つからない場合

```bash
# セッション一覧を確認
/history

# セッション名のスペルを確認
# 大文字小文字も区別される場合があります

# セッションIDを使用して再開
claude -r <session-id>
```

### 古いバージョンで問題が発生している場合

```bash
# Claude Codeをv2.1.19以降にアップデート
claude update

# バージョン確認
claude --version

# アップデート後、セッション再開を再試行
claude -r "session-name"
```

### セッション名の変更

```bash
# 現在のセッションを再開
claude -r <session-id>

# 新しい名前に変更
/rename "new-descriptive-name"

# 確認
/context
```

## 注意点

- **セッション名の一意性**: セッション名は一意である必要があります。同じ名前のセッションが複数ある場合、最新のものが選択されます
- **パス依存性の削減**: v2.1.19以降、セッションの再開はパスに依存しなくなりました
- **セッションIDの保存**: 重要なセッションはIDを記録しておくと確実に再開できます
- **互換性**: この修正はv2.1.19で導入されているため、それより前のバージョンでは機能しません

## 関連情報

- [Claude Code 公式ドキュメント - CLI Reference: --resume flag](https://code.claude.com/docs/en/cli-reference#cli-flags)
- [Claude Code 公式ドキュメント - Interactive Mode](https://code.claude.com/docs/en/interactive-mode)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
