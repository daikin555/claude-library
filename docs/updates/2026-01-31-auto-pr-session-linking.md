---
title: "gh pr create でセッションが自動的にPRにリンクされる新機能"
date: 2026-01-31
tags: [github, pull-request, automation, workflow]
---

## 原文（日本語に翻訳）

`gh pr create` でPRを作成する際、セッションが自動的にPRにリンクされるようになりました。

## 原文（英語）

Sessions are now automatically linked to PRs when creating them with `gh pr create`

## 概要

Claude Code 2.1.27から、`gh pr create` コマンドでPRを作成すると、そのセッションが自動的にPRにリンクされるようになりました。これにより、`--from-pr` フラグで該当PRの作業を簡単に再開できます。

## 基本的な使い方

Claude Codeのセッション内で `gh pr create` を実行するだけで、自動的にリンクが作成されます。

```bash
# Claude Codeを起動
claude

# セッション内で機能を実装
# > ユーザープロフィール編集機能を実装してください

# PRを作成（自動的にセッションがリンクされる）
# > PRを作成してください
```

リンクされたPRは後から簡単に再開できます：

```bash
claude --from-pr 123
```

## 実践例

### レビュー駆動開発

機能実装からPR作成、レビュー対応まで一貫した流れで作業できます。

```bash
# Day 1: 機能実装とPR作成
claude
# > 新しい検索機能を実装してPRを作成してください
# （セッションが自動的にPRにリンク）

# Day 2: レビューコメントへの対応
claude --from-pr 456
# > レビューコメントに対応してください
```

### 段階的な機能追加

同じPRに対して複数回のセッションで段階的に機能を追加する場合に便利です。

```bash
# フェーズ1: 基本実装
claude
# > ダークモードの基本実装をしてPRを作成

# フェーズ2: テスト追加
claude --from-pr 789
# > テストを追加してください

# フェーズ3: ドキュメント更新
claude --from-pr 789
# > READMEを更新してください
```

### CI/CDの失敗対応

CI/CDの失敗を修正する際、元のセッションの文脈を保持したまま作業できます。

```bash
# PRを作成後、CIが失敗
# GitHub Actionsの通知を確認

# 元のセッションを再開して修正
claude --from-pr https://github.com/team/project/pull/234
# > テストが失敗しています。修正してください
```

### 典型的なワークフロー

```bash
# 1. 新しい機能ブランチを作成
git checkout -b feature/user-settings

# 2. Claude Codeで実装開始
claude

# 3. セッション内で実装を依頼
# > ユーザー設定画面を実装してください
# > 実装が完了したので、PRを作成してください

# Claudeが以下を自動実行:
# - 変更をコミット
# - gh pr create でPRを作成
# - セッションとPRを自動リンク

# 4. 後日、レビュー対応で再開
claude --from-pr 123
# 以前の実装コンテキストを保持したまま作業継続
```

## 注意点

- 自動リンクは Claude Codeセッション内で `gh pr create` を実行した場合のみ作成されます
- ターミナルから直接 `gh pr create` を実行した場合は、リンクは作成されません
- 同じPRに複数のセッションがリンクされている場合、`--from-pr` では最新のセッションが使用されます
- リンクされたセッションは、PRがマージ・クローズされた後も保持されます
- 異なるブランチでセッションを再開すると警告が表示される場合があります

## 関連情報

- [Claude Code公式ドキュメント](https://docs.claude.ai/claude-code)
- [--from-pr フラグの使い方](./2026-01-31-from-pr-flag)
- [GitHub CLI (gh) ドキュメント](https://cli.github.com/)
