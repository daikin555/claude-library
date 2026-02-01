---
title: "/skills/ディレクトリのスキルがデフォルトでスラッシュコマンドメニューに表示されるよう改善"
date: 2026-01-31
tags: ['改善', 'スキル', 'スラッシュコマンド', 'UI']
---

## 原文（日本語に翻訳）

`/skills/` ディレクトリのスキルがデフォルトでスラッシュコマンドメニューに表示されるよう改善（frontmatterで `user-invocable: false` を設定することでオプトアウト可能）

## 原文（英語）

Improved skills from `/skills/` directories to be visible in the slash command menu by default (opt-out with `user-invocable: false` in frontmatter)

## 概要

Claude Code v2.1.0で改善された、スキルのスラッシュコマンドメニュー表示機能です。以前のバージョンでは、`~/.claude/skills` や `.claude/skills` にスキルを作成しても、明示的に設定しない限りスラッシュコマンドメニューに表示されませんでした。この改善により、すべてのスキルがデフォルトで `/skill-name` としてメニューに表示され、必要に応じて `user-invocable: false` で非表示にできるようになりました。

## 改善前の動作

### スキルが表示されない

```bash
# スキルを作成
cat > ~/.claude/skills/my-task.md <<'EOF'
---
name: my-task
description: My custom task
---
# My task content
EOF

# Claude Codeで確認
claude

> /
# 修正前:
# - /my-task が表示されない
# - user-invocable: true を追加する必要

# Frontmatter修正が必要だった:
---
name: my-task
description: My custom task
user-invocable: true  # これを追加
---
```

## 改善後の動作

### デフォルトで表示

```bash
# スキルを作成
cat > ~/.claude/skills/my-task.md <<'EOF'
---
name: my-task
description: My custom task
---
# My task content
EOF

# Claude Codeで確認
claude

> /
# 修正後:
# ✓ /my-task が自動的に表示される
# ✓ 追加設定不要

# 非表示にしたい場合:
---
name: my-task
description: My custom task
user-invocable: false  # オプトアウト
---
```

## 実践例

### 個人用スキルの作成

日常タスクを自動化。

```bash
# デイリータスクスキル
cat > ~/.claude/skills/daily-standup.md <<'EOF'
---
name: daily-standup
description: Generate daily standup report
---

Please generate my daily standup report:
1. List commits from yesterday
2. Show current branch status
3. List open PRs
4. Suggest today's priorities
EOF

# Claude Code起動
claude

> /dai[Tab]
# ✓ /daily-standup が補完される
# ✓ すぐに使える
```

### プロジェクト固有のスキル

チーム共有のワークフロー。

```bash
# プロジェクトディレクトリ
cd ~/projects/my-app

# プロジェクト固有のスキル
cat > .claude/skills/deploy-staging.md <<'EOF'
---
name: deploy-staging
description: Deploy to staging environment
---

Please deploy to staging:
1. Run tests
2. Build production bundle
3. Deploy to staging server
4. Run smoke tests
5. Notify team in Slack
EOF

# チームメンバーがClaudeを起動
claude

> /
# ✓ /deploy-staging が表示される
# ✓ チーム全員が同じスキルを使える
```

### 内部ヘルパースキル（非表示）

他のスキルから呼ばれるヘルパー。

```bash
# ヘルパースキル（ユーザーには見せない）
cat > ~/.claude/skills/_git-helpers.md <<'EOF'
---
name: git-helpers
description: Internal git helper functions
user-invocable: false  # メニューに表示しない
---

Internal helper functions for git operations...
EOF

# メインスキル
cat > ~/.claude/skills/release.md <<'EOF'
---
name: release
description: Create a new release
---

Create a new release using git-helpers...
EOF

# Claude Code起動
claude

> /
# ✓ /release は表示される
# ✗ /git-helpers は表示されない（user-invocable: false）
```

### スキルディスカバリー

新しいスキルの発見が簡単。

```bash
# 複数のスキルを追加
ls ~/.claude/skills/
# commit-with-ai.md
# code-review.md
# refactor-helper.md
# test-generator.md
# doc-writer.md

# Claude Code起動
claude

> /
# すべてのスキルが表示される:
# /commit-with-ai
# /code-review
# /refactor-helper
# /test-generator
# /doc-writer

# ✓ すぐに使える
# ✓ 説明も表示される
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- デフォルト動作:
  - すべてのスキルが `/skill-name` として表示
  - 設定不要で即座に使える
  - ホットリロード対応（保存後すぐ反映）
- オプトアウト方法:
  ```yaml
  ---
  name: my-skill
  user-invocable: false  # スラッシュコマンドメニューに表示しない
  ---
  ```
- 使用場面:
  - **user-invocable: true（デフォルト）**: ユーザーが直接実行するスキル
  - **user-invocable: false**: 内部ヘルパー、ライブラリスキル
- スキルの優先順位:
  - プロジェクトスキル（`.claude/skills`）がグローバルスキル（`~/.claude/skills`）より優先
  - 同名のスキルがある場合、プロジェクトスキルが表示される
- スラッシュコマンドメニューの表示:
  - `/` を入力すると全スキルが表示
  - `/部分文字列` で絞り込み可能
  - Tab キーで補完
- スキル名の命名規則:
  - kebab-case 推奨（例: `my-task`, `deploy-prod`）
  - 英数字とハイフンのみ使用
  - 短く覚えやすい名前を推奨
- 説明文の表示:
  - `description` フィールドがメニューに表示される
  - 簡潔で分かりやすい説明を推奨（50文字以内）
- 内部スキルの命名:
  ```bash
  # アンダースコアで開始（慣例）
  _helper-functions.md
  _internal-utils.md

  # user-invocable: false を設定
  ```
- スキルの整理:
  ```bash
  ~/.claude/skills/
  ├── commit.md              # 表示される
  ├── review.md              # 表示される
  ├── _git-utils.md          # user-invocable: false
  └── _internal-helpers.md   # user-invocable: false
  ```
- デバッグ:
  ```bash
  # スキルがメニューに表示されない場合:
  # 1. frontmatterの構文を確認
  # 2. user-invocable: false がないか確認
  # 3. スキル名が有効か確認（英数字とハイフン）

  claude --debug
  # スキル読み込みログを確認
  ```
- 関連する改善:
  - index 0: スキルの自動ホットリロード
  - index 91: スキル提案で最近使用したスキルを優先

## 関連情報

- [Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Custom skills](https://code.claude.com/docs/en/custom-skills)
- [Skill frontmatter](https://code.claude.com/docs/en/skills#frontmatter)
