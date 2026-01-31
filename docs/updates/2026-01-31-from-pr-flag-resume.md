---
title: "特定のPRにリンクされたセッションを再開する--from-prフラグを追加"
date: 2025-01-27
tags: [github, pull-request, session-management]
---

## 原文（日本語訳）

特定のGitHub PRの番号またはURLにリンクされたセッションを再開する `--from-pr` フラグを追加

## 原文（英語）

Added `--from-pr` flag to resume sessions linked to a specific GitHub PR number or URL

## 概要

`--from-pr` フラグを使用することで、特定のGitHub Pull Requestに関連付けられたClaude Codeセッションを簡単に再開できるようになりました。PR番号またはURLを指定するだけで、そのPRに紐づく作業セッションにすぐに戻ることができます。

## 基本的な使い方

PR番号を指定してセッションを再開します。

```bash
# PR番号で再開
claude --from-pr 123

# PR URLで再開
claude --from-pr https://github.com/owner/repo/pull/456
```

## 実践例

### PR番号でセッションを再開

特定のPR番号に紐づくセッションを再開します。

```bash
# PR #42の作業を再開
claude --from-pr 42
```

### PR URLでセッションを再開

GitHub上でPRを見ている時、URLをコピーしてそのまま使用できます。

```bash
# URLから直接再開
claude --from-pr https://github.com/myorg/myrepo/pull/789
```

### 複数のPRを扱うワークフロー

異なるPRの作業を切り替える場合に便利です。

```bash
# レビュー対応のPRに切り替え
claude --from-pr 101

# 別ターミナルで新機能のPRに切り替え
claude --from-pr 102
```

### CI/CDパイプラインとの統合

GitHub ActionsなどからPRに関連する作業を自動化する際に活用できます。

```bash
#!/bin/bash
PR_NUMBER=${{ github.event.pull_request.number }}
claude --from-pr "$PR_NUMBER" -p "Run tests and fix any issues"
```

## 注意点

- セッションがPRにリンクされていない場合、エラーになります
- PRは現在のリポジトリに存在する必要があります
- `gh` CLI がインストールされている必要があります
- 複数のセッションが同じPRにリンクされている場合、最新のセッションが選択されます

## 関連情報

- [セッション管理ガイド](https://code.claude.com/docs/en/session-management)
- [GitHub統合](https://code.claude.com/docs/en/github-integration)
- [Pull Requestワークフロー](https://code.claude.com/docs/en/pr-workflow)
