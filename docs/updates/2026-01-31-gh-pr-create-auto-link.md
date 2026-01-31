---
title: "gh pr create経由で作成したPRにセッションを自動リンク"
date: 2025-01-27
tags: [github, pull-request, automation]
---

## 原文（日本語訳）

`gh pr create` 経由で作成された際に、セッションが自動的にPRにリンクされるようになりました

## 原文（英語）

Sessions are now automatically linked to PRs when created via `gh pr create`

## 概要

GitHub CLIの `gh pr create` コマンドでPull Requestを作成すると、現在のClaude Codeセッションが自動的にそのPRに関連付けられるようになりました。これにより、後から `--from-pr` フラグで簡単にセッションを再開でき、PR作成からレビュー対応までのワークフローがシームレスになります。

## 基本的な使い方

Claude Code内で通常通り `gh pr create` を実行するだけで、自動的にリンクされます。

```bash
# Claude Code内でPRを作成
gh pr create --title "Add new feature" --body "Description"
```

## 実践例

### 機能開発からPR作成までの一連のフロー

Claude Codeで開発し、そのままPRを作成するワークフローです。

```bash
# Claude Codeを起動
claude

# Claudeに機能開発を依頼
> "Add user authentication feature"

# 開発完了後、PRを作成（自動的にセッションがリンク）
> "Create a PR with gh pr create"
```

### レビュー対応のためにセッションを再開

レビューコメントに対応するため、PR作成時のセッションに戻ります。

```bash
# 後日、レビュー対応のためにセッションを再開
claude --from-pr 123

# セッションのコンテキストを保持したまま修正作業ができる
```

### スキルを使ったPR作成の自動化

`/commit-push-pr` スキルを使用すると、コミット、プッシュ、PR作成が一度に完了し、セッションも自動リンクされます。

```bash
# Claude Code内で
> "/commit-push-pr"

# Claudeがコミットメッセージを作成、プッシュ、PRを作成
# セッションは自動的にPRにリンクされる
```

### 複数ブランチの並行開発

複数の機能を並行開発している場合、各PRに対応するセッションを簡単に切り替えられます。

```bash
# feature-Aブランチで開発
git checkout feature-A
claude
> "Implement feature A"
> "gh pr create -t 'Feature A'"

# 別ターミナルでfeature-Bブランチを開発
git checkout feature-B
claude
> "Implement feature B"
> "gh pr create -t 'Feature B'"

# 後で各セッションを再開
claude --from-pr <feature-A-PR-number>
claude --from-pr <feature-B-PR-number>
```

## 注意点

- この自動リンク機能は `gh pr create` コマンド経由でのみ動作します
- Claude Code外で作成したPRは自動リンクされません
- セッションとPRのリンクは `~/.claude/sessions/` に保存されます
- 手動でPRを作成した場合は、`--from-pr` で後からリンクすることはできません

## 関連情報

- [GitHub CLI統合](https://code.claude.com/docs/en/github-integration)
- [--from-pr フラグの使い方](https://code.claude.com/docs/en/session-management#from-pr)
- [Pull Requestワークフロー](https://code.claude.com/docs/en/pr-workflow)
- [セッション管理](https://code.claude.com/docs/en/session-management)
