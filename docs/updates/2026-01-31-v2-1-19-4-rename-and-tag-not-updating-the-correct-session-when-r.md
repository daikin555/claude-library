---
title: "別ディレクトリからの再開時に/rename・/tagが正しいセッションを更新しない問題を修正"
date: 2026-01-23
tags: ['バグ修正', 'セッション管理', 'git worktree']
---

## 原文（日本語に翻訳）

別のディレクトリ（例: git worktree）からセッションを再開した際に、`/rename` および `/tag` コマンドが正しいセッションを更新しない問題を修正しました。

## 原文（英語）

Fixed `/rename` and `/tag` not updating the correct session when resuming from a different directory (e.g., git worktrees)

## 概要

Claude Code v2.1.19で、git worktreeなど異なるディレクトリからセッションを再開した際に、`/rename` と `/tag` コマンドが意図しないセッションを更新してしまう問題が修正されました。この問題は、複数のworktreeを使用している場合や、プロジェクトを複数のディレクトリで開いている際に発生していました。

## 問題が発生していたシナリオ

### Git worktreeを使用している場合

```bash
# メインブランチでセッション開始
cd /project/main
claude
# セッションに名前を付ける
/rename "main-work"

# 別のworktreeに移動して同じセッションを再開
cd /project/feature-branch
claude -r "main-work"

# セッション名を変更しようとする
/rename "feature-work"
# → 以前: 誤ったセッションが更新されていた
# → v2.1.19: 正しいセッションが更新される
```

### 複数のプロジェクトディレクトリ

```bash
# プロジェクトAでセッション開始
cd ~/projects/app-a
claude
/tag production

# プロジェクトBで同じセッションを再開
cd ~/projects/app-b
claude -r <session-id>

# タグを変更
/tag staging
# → 以前: 予期しないセッションにタグが付けられていた
# → v2.1.19: 正しいセッションにタグが付与される
```

## 実践例

### Git worktree環境での作業

複数のブランチを並行して作業する場合:

```bash
# worktreeのセットアップ
git worktree add ../feature-a feature-a
git worktree add ../feature-b feature-b

# feature-aで作業開始
cd ../feature-a
claude
/rename "feature-a-implementation"
/tag feature

# feature-bに切り替えて同じセッションを継続
cd ../feature-b
claude -r "feature-a-implementation"

# セッション名を更新（v2.1.19以降は正しく動作）
/rename "feature-b-implementation"
/tag feature-b

# セッション一覧で確認
/history
# ✓ 正しいセッション名とタグが表示される
```

### モノレポでの複数パッケージ作業

```bash
# packages/frontendで作業
cd packages/frontend
claude
/rename "frontend-refactor"
/tag frontend

# packages/backendに移動
cd ../backend
claude -r "frontend-refactor"

# セッション情報を更新
/rename "backend-api-update"
/tag backend

# v2.1.19以降は、正しいセッションが更新される
```

### CI/CDとローカル開発の使い分け

```bash
# ローカルで開発セッション開始
cd ~/project
claude
/rename "local-dev"
/tag development

# CIサーバーで同じプロジェクトのセッションを再開
# （異なるパスにチェックアウトされている）
cd /ci/workspace/project
claude -r "local-dev"

# タグを更新
/tag ci-testing
# v2.1.19: 正しいセッションが更新される
```

## セッション管理のベストプラクティス

### セッション名の付け方

```bash
# 明確で検索しやすい名前を使用
/rename "fix-auth-bug-#123"
/rename "feature/user-dashboard"
/rename "refactor-api-layer"

# 日付を含める
/rename "deploy-2026-01-31"
```

### タグの活用

```bash
# 作業の種類で分類
/tag bugfix
/tag feature
/tag refactor

# 環境で分類
/tag production
/tag staging
/tag development

# 優先度で分類
/tag urgent
/tag low-priority
```

### セッション一覧の確認

```bash
# すべてのセッション表示
/history

# タグでフィルタ
# （セッション一覧から選択）

# 特定のセッションを再開
claude -r "fix-auth-bug-#123"
```

## トラブルシューティング

### 以前のバージョンで誤った更新が発生した場合

```bash
# セッション一覧を確認
/history

# 誤って名前が変更されたセッションを見つける
# 正しい名前に戻す
claude -r <session-id>
/rename "correct-name"

# または新しいセッションとして開始
claude --fork-session -r <session-id>
/rename "new-session-name"
```

### セッションIDの確認

```bash
# 現在のセッションIDを確認
/context

# または環境変数から取得
echo $CLAUDE_SESSION_ID
```

### v2.1.19へのアップグレード

```bash
# Claude Codeをアップデート
claude update

# バージョン確認
claude --version

# v2.1.19以上であることを確認
```

## 注意点

- **worktree使用時**: git worktreeを使用している場合は、セッション管理が正しく動作するv2.1.19以降の使用を強く推奨します
- **セッションの一意性**: セッションIDは一意ですが、ディレクトリが異なる場合は同じセッション名でも別のセッションとして扱われる可能性があります
- **タグの重複**: 同じタグを複数のセッションに付けることができます
- **アップグレード**: この修正はv2.1.19で導入されているため、古いバージョンでは問題が発生します

## 関連情報

- [Claude Code 公式ドキュメント - Interactive Mode](https://code.claude.com/docs/en/interactive-mode)
- [Claude Code 公式ドキュメント - CLI Reference](https://code.claude.com/docs/en/cli-reference)
- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
