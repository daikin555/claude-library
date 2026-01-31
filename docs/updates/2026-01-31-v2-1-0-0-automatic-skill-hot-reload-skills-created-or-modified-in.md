---
title: "スキルの自動ホットリロード機能を追加"
date: 2026-01-31
tags: ['新機能', 'スキル', '開発効率']
---

## 原文（日本語に翻訳）

スキルの自動ホットリロード機能を追加 - `~/.claude/skills` または `.claude/skills` ディレクトリで作成・変更されたスキルが、セッションを再起動せずに即座に利用可能になりました

## 原文（英語）

Added automatic skill hot-reload - skills created or modified in `~/.claude/skills` or `.claude/skills` are now immediately available without restarting the session

## 概要

Claude Code v2.1.0で導入されたスキルの自動ホットリロード機能です。この機能により、スキルファイルを作成または編集すると、Claude Codeを再起動することなく、即座に新しいスキルが利用可能になります。開発ワークフローが大幅に効率化され、スキルの反復開発が約24倍高速化（2分のサイクルから5秒に短縮）されます。

## 基本的な使い方

スキルディレクトリ（`~/.claude/skills` または `.claude/skills`）に新しいスキルファイルを作成または既存ファイルを編集すると、自動的にClaude Codeがスキルを検出し、スラッシュコマンドメニューで即座に利用可能になります。

```bash
# グローバルスキルの作成
cat > ~/.claude/skills/example/SKILL.md <<'EOF'
---
name: example
description: 例示用のスキル
---
# Example skill content
このスキルは即座に /example として利用可能になります
EOF

# プロジェクト固有のスキルの作成
cat > .claude/skills/project-task/SKILL.md <<'EOF'
---
name: project-task
description: プロジェクト固有のタスク
---
# プロジェクトタスクの内容
EOF
```

## 実践例

### 既存スキルの即座の修正

スキルのロジックやテンプレートを修正した場合、セッションを再起動せずにすぐに変更が反映されます。

```bash
# スキルの内容を更新
echo "Updated instructions" >> ~/.claude/skills/my-skill/SKILL.md

# 保存直後にClaude Codeで最新版が利用可能
# セッション再起動は不要
```

### チーム開発での共有スキル管理

`.claude/skills` にプロジェクト固有のスキルを配置し、チームメンバーが追加・修正すると、各メンバーのセッションで自動的に最新版が利用可能になります。

```bash
# チームメンバーがgit pullで最新のスキルを取得
git pull origin main

# 追加されたスキルが即座に /new-team-skill として利用可能
# 手動でのリロードや再起動は不要
```

### スキル開発の効率化

スキルの開発中、保存するたびに即座にテストできるため、開発サイクルが高速化されます。従来の2分から5秒へと約24倍の高速化が報告されています。

```bash
# 1. スキルを編集
vim ~/.claude/skills/test-skill/SKILL.md

# 2. 保存（:w）

# 3. Claude Codeで即座にテスト
# /test-skill を実行して動作確認

# 4. 必要に応じて再度編集
# このサイクルが5秒程度で完了
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- スキルファイルの構文エラーがある場合、エラーメッセージが表示されます
- ホットリロードは `.md` 形式のスキルファイル（SKILL.md）に対応しています
- 既存のセッションで実行中のスキルは、リロードの影響を受けません
- グローバルスキル（`~/.claude/skills`）とプロジェクトスキル（`.claude/skills`）の両方が監視されます
- 開発サイクルが従来の約2分から約5秒へと24倍高速化されます

## 関連情報

- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Claude Code 2.1.0 Release Notes](https://hyperdev.matsuoka.com/p/claude-code-210-ships)
- [Claude Code Must-Haves - January 2026](https://dev.to/valgard/claude-code-must-haves-january-2026-kem)
