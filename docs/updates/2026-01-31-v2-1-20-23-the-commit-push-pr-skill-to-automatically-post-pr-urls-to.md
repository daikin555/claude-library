---
title: "`/commit-push-pr`スキルがMCPツール経由でSlackチャンネルに自動投稿"
date: 2026-01-27
tags: ['機能変更', 'スキル', 'Slack連携', 'MCP']
---

## 原文（日本語に翻訳）

MCPツール経由で設定された場合、`/commit-push-pr`スキルがSlackチャンネルに自動的にPR URLを投稿するよう変更

## 原文（英語）

Changed the `/commit-push-pr` skill to automatically post PR URLs to Slack channels when configured via MCP tools

## 概要

Claude Code v2.1.20では、`/commit-push-pr`スキルにSlack連携機能が追加されました。MCPツールを使用してSlack設定を行うことで、プルリクエストを作成した際に、そのURLが自動的に指定したSlackチャンネルに投稿されるようになります。これにより、チーム全体への通知が自動化され、コードレビューのワークフローがスムーズになります。

## 基本的な使い方

MCPでSlackツールを設定すると、PR作成時に自動投稿されます：

```bash
# 1. Slack MCPツールの設定（初回のみ）
> /config mcp
# Slack MCPサーバーを追加

# 2. 通常通りPRを作成
> /commit-push-pr --base main --title "Add new feature"

# 変更前：
# PR created: https://github.com/user/repo/pull/123
# （手動でSlackに貼り付けが必要）

# 変更後（Slack MCP設定済み）：
# PR created: https://github.com/user/repo/pull/123
# ✓ Posted to #engineering on Slack

# Slackチャンネルには自動的に投稿される：
# ┌─────────────────────────────────────┐
# │ Claude Code Bot                     │
# │ New PR: Add new feature             │
# │ https://github.com/user/repo/pull/123│
# │                                     │
# │ Author: @yourname                   │
# │ Branch: feature/new-feature → main │
# │ 📝 Ready for review                │
# └─────────────────────────────────────┘
```

## 実践例

### チーム開発ワークフローの自動化

複数人のチームでの開発：

```bash
# 開発完了後、PRを作成
> /commit-push-pr --base develop --title "Fix authentication bug"

Creating PR...
✓ PR #456 created: https://github.com/company/app/pull/456
✓ Posted to #code-reviews on Slack
✓ Mentioned reviewers: @alice, @bob

# Slackの #code-reviews チャンネル:
# ┌─────────────────────────────────────────────┐
# │ Claude Code 🤖                              │
# │ 🔧 Fix authentication bug                  │
# │ https://github.com/company/app/pull/456     │
# │                                             │
# │ 👤 Author: @yourname                       │
# │ 🌿 feature/auth-fix → develop             │
# │ 📊 +45 -12 lines changed                  │
# │ 👀 Reviewers needed: @alice @bob          │
# │                                             │
# │ [Review Now] [View Diff] [CI Status]      │
# └─────────────────────────────────────────────┘

# チームメンバーは即座に通知を受け取る
# レビュープロセスが自動的に開始される
```

### 緊急バグ修正の迅速な通知

ホットフィックスを作成する場合：

```bash
> /commit-push-pr --base main --title "URGENT: Fix critical security issue"

✓ PR #789 created
⚠️  Urgent label detected
✓ Posted to #urgent-issues and #engineering
✓ Notified: @tech-lead, @security-team

# Slackの #urgent-issues:
# ┌─────────────────────────────────────────────┐
# │ Claude Code 🚨                              │
# │ 🔴 URGENT: Fix critical security issue     │
# │ https://github.com/company/app/pull/789     │
# │                                             │
# │ This PR has been marked as URGENT          │
# │ Requires immediate review                  │
# │                                             │
# │ @tech-lead @security-team please review   │
# └─────────────────────────────────────────────┘

# 変更により：
# - 緊急PRが即座にエスカレーション
# - 適切な人に自動通知
# - 迅速な対応が可能に
```

### 複数チャンネルへの投稿

プロジェクトによって異なるチャンネルに投稿：

```bash
# フロントエンドPR
> /commit-push-pr --base main --title "Update UI components"
✓ Posted to #frontend-team

# バックエンドPR
> /commit-push-pr --base main --title "Optimize database queries"
✓ Posted to #backend-team

# インフラPR
> /commit-push-pr --base main --title "Update Kubernetes config"
✓ Posted to #devops, #platform-team

# MCP設定により：
# - プロジェクト/ブランチに応じて自動振り分け
# - 適切なチームが通知を受け取る
# - 関係ないノイズが減る
```

### CI/CD統合との連携

自動テストとの組み合わせ：

```bash
> /commit-push-pr --base main --title "Add payment integration"

✓ PR #234 created
✓ Posted to #payments-team
✓ CI pipeline started

# 数分後、Slack上で更新：
# ┌─────────────────────────────────────────────┐
# │ Claude Code 🤖                              │
# │ Add payment integration (#234)              │
# │                                             │
# │ ✅ All checks passed                       │
# │   • Tests: 145/145 passed                  │
# │   • Coverage: 94% (+2%)                    │
# │   • Linter: No issues                      │
# │                                             │
# │ Ready to merge 🎉                          │
# └─────────────────────────────────────────────┘

# CI結果も自動的にSlackに反映
```

### カスタマイズされた通知

プロジェクト固有のフォーマット：

```bash
# MCP設定で通知テンプレートをカスタマイズ
{
  "slack_template": {
    "include_diff_stats": true,
    "mention_reviewers": true,
    "add_labels_info": true,
    "include_ci_status": true
  }
}

> /commit-push-pr --base main --title "Refactor authentication module"

# Slack投稿（カスタマイズ版）:
# ┌─────────────────────────────────────────────┐
# │ 📢 New PR from @yourname                   │
# │ Refactor authentication module              │
# │ https://github.com/company/app/pull/567     │
# │                                             │
# │ 📈 Changes:                                │
# │   • 15 files changed                       │
# │   • +234 −156 lines                        │
# │   • 3 new tests added                      │
# │                                             │
# │ 🏷️  Labels: refactoring, security         │
# │ 👀 Reviewers: @alice, @charlie            │
# │ ⚡ CI: Running... (expected ~5 min)        │
# └─────────────────────────────────────────────┘
```

### オープンソースプロジェクトでの活用

コミュニティプロジェクト：

```bash
> /commit-push-pr --base main --title "Add Japanese translation"

✓ PR #89 created
✓ Posted to #contributors channel
✓ Thank you message sent to author

# #contributors チャンネル:
# ┌─────────────────────────────────────────────┐
# │ 🌟 New Contribution!                       │
# │ Add Japanese translation                    │
# │ https://github.com/project/repo/pull/89     │
# │                                             │
# │ Thank you @yourname for contributing! 🙏  │
# │                                             │
# │ This adds Japanese language support:        │
# │   • UI translations                        │
# │   • Documentation                          │
# │   • README.ja.md                           │
# │                                             │
# │ Community members, please review! 👀       │
# └─────────────────────────────────────────────┘

# コントリビューターへの感謝を自動化
# コミュニティのエンゲージメント向上
```

## 注意点

- この機能を使用するには、Slack MCPサーバーの設定が必要です
- Slackボットに適切な権限（チャンネルへの投稿権限など）が必要です
- 投稿先チャンネルはMCP設定で指定します
- プライベートチャンネルへの投稿には、ボットを事前に招待する必要があります
- 投稿失敗時もPR作成自体は成功します（通知のみスキップ）
- 複数のSlackワークスペースへの同時投稿も設定可能です

## 関連情報

- [Commit-Push-PR Skill](https://code.claude.com/docs/en/skills/commit-push-pr)
- [MCP Integration](https://code.claude.com/docs/en/mcp/integrations)
- [Slack MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/slack)
- [Team Workflows](https://code.claude.com/docs/en/workflows/team-collaboration)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
