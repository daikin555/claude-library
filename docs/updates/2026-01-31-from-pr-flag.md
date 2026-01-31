---
title: "PRからセッションを再開できる --from-pr フラグの使い方"
date: 2026-01-31
tags: [github, pull-request, session-management, workflow]
---

## 原文（日本語に翻訳）

特定のGitHub Pull Request番号またはURLにリンクされたセッションを再開する --from-pr フラグを追加しました。

## 原文（英語）

Added --from-pr flag to resume sessions linked to a specific GitHub PR number or URL

## 概要

Claude Code 2.1.27で、特定のGitHub Pull Requestにリンクしたセッションを再開できる `--from-pr` フラグが追加されました。PR番号またはPR URLを指定することで、そのPRに関連する作業を簡単に再開できます。

## 基本的な使い方

PR番号を指定してセッションを再開：

```bash
claude --from-pr 123
```

完全なPR URLでも指定可能：

```bash
claude --from-pr https://github.com/owner/repo/pull/456
```

## 実践例

### レビュー対応の継続作業

レビューコメントに対応する際、以前のセッションの文脈を保持したまま作業を再開できます。

```bash
# レビューコメントを確認
gh pr view 123

# 関連セッションを再開して修正作業
claude --from-pr 123
```

### 複数PRの並行作業

複数のPRを同時に進めている場合、それぞれのPRに紐付いたセッションを切り替えながら作業できます。

```bash
# 機能A のPR作業
claude --from-pr 101

# 別のターミナルで 機能B のPR作業
claude --from-pr 102
```

### CI/CDの失敗対応

```bash
# CIが失敗したPRのセッションを再開
claude --from-pr https://github.com/myteam/myapp/pull/89

# セッション内で修正を依頼
# > テストが失敗しているようです。修正してください
```

### PRの作成からセッション再開までの一連のフロー

```bash
# 1. 機能ブランチで作業開始
git checkout -b feature/new-auth

# 2. Claude Codeで実装
claude
# > ユーザー認証機能を実装してください
# > PRを作成してください

# 3. 後日、レビュー対応のためセッション再開
claude --from-pr 150
```

## 注意点

- `gh pr create` コマンドでPRを作成すると、セッションは自動的にPRにリンクされます
- 同じPRに複数のセッションがリンクされている場合、最新のセッションが再開されます
- セッション履歴は `claude --list-sessions` で確認できます
- セッション再開前に、該当するブランチにチェックアウトしておくことをおすすめします

## 関連情報

- [Claude Code公式ドキュメント](https://docs.claude.ai/claude-code)
- [GitHub CLI (gh) ドキュメント](https://cli.github.com/)
