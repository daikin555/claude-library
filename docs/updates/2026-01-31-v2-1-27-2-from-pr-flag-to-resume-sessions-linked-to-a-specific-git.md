---
title: "GitHub PRに紐づいたセッションを再開する--from-prフラグの追加"
date: 2026-01-30
tags: ['新機能', 'GitHub', 'セッション管理', 'PR']
---

## 原文（日本語に翻訳）

特定のGitHub PR番号またはURLに紐づいたセッションを再開するための`--from-pr`フラグを追加

## 原文（英語）

Added `--from-pr` flag to resume sessions linked to a specific GitHub PR number or URL

## 概要

GitHub Pull Requestに紐づいたClaude Codeセッションを素早く再開できるようになりました。PR番号またはURLを指定するだけで、そのPRで作業していたセッションに戻ることができます。これにより、複数のPRを並行して作業する際のワークフローが大幅に改善されます。

## 基本的な使い方

PR番号を指定してセッションを再開：

```bash
claude --from-pr 123
```

PR URLを指定してセッションを再開：

```bash
claude --from-pr https://github.com/owner/repo/pull/456
```

## 実践例

### 複数のPRを並行作業

異なる機能ブランチでの作業を切り替える場合：

```bash
# 認証機能のPR #123 で作業
claude --from-pr 123

# 別のターミナルで、UI改善のPR #456 で作業
claude --from-pr 456
```

各PRに関連付けられたセッションが自動的に選択され、そのPRの文脈で作業を継続できます。

### PR作成後のセッション再開

`gh pr create`でPRを作成した後、そのセッションに戻る場合：

```bash
# PR作成
claude "新しい認証機能を実装"
# (作業後、/commit-push-pr などでPR作成)

# 後日、同じPRで作業再開
claude --from-pr 789
```

セッションはPR作成時に自動的にリンクされるため、PR番号で簡単に再開できます。

### レビューコメントへの対応

PRレビューを受けた後、フィードバックに対応する場合：

```bash
# レビューコメントを確認してから作業再開
gh pr view 123
claude --from-pr 123
# → "PR #123のレビューコメントに対応してください"
```

以前の作業コンテキストを保持したまま、レビュー対応を進められます。

### チーム開発でのPR引き継ぎ

チームメンバーが作成したPRを引き継ぐ場合：

```bash
# 同僚が作成したPRを確認
gh pr checkout 234
claude --from-pr 234
# → "このPRのテストカバレッジを改善してください"
```

## 注意点

- セッションは`gh pr create`経由でPRを作成した場合に自動的にリンクされます
- 手動で作成したPRの場合、セッションとのリンクは自動では確立されません
- PRが複数のセッションに関連付けられている場合、最新のセッションが選択されます
- セッションがディスクに保存されていない場合（`--no-session-persistence`使用時など）、この機能は使用できません
- PRは現在のGitリポジトリのものである必要があります

## 関連フラグ

- `--resume, -r`: セッションIDまたは名前で特定のセッションを再開
- `--continue, -c`: 現在のディレクトリで最新のセッションを再開
- `--fork-session`: セッション再開時に新しいセッションIDを作成（元のセッションを保持）

```bash
# PRセッションを再開しつつ、新しいブランチに分岐
claude --from-pr 123 --fork-session
```

## 関連情報

- [CLI reference - Claude Code Docs](https://code.claude.com/docs/en/cli-reference)
- [Common workflows - Claude Code Docs](https://code.claude.com/docs/en/common-workflows)
- [GitHub Actions - Claude Code Docs](https://code.claude.com/docs/en/github-actions)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
