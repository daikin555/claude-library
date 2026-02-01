---
title: "gh pr create経由でPR作成時にセッションが自動的にリンクされるように改善"
date: 2026-01-30
tags: ['改善', 'GitHub', 'PR', 'セッション管理']
---

## 原文（日本語に翻訳）

`gh pr create`経由でPRを作成した際に、セッションが自動的にPRにリンクされるようになりました

## 原文（英語）

Sessions are now automatically linked to PRs when created via `gh pr create`

## 概要

Claude CodeのセッションからGitHub CLIの`gh pr create`コマンドでPull Requestを作成すると、そのセッションが自動的にPRに紐づけられるようになりました。これにより、後から`--from-pr`フラグを使用してPR関連の作業を簡単に再開できます。

## 機能の仕組み

1. Claude Codeのセッション中に`gh pr create`を実行
2. PRが作成されると同時に、セッションIDとPR番号が自動的に関連付けられる
3. 後日、`claude --from-pr <PR番号>`で同じセッションに戻れる

この自動リンク機能により、手動でセッションとPRを紐づける必要がなくなります。

## 基本的な使い方

通常のPR作成ワークフロー内で自動的に機能します：

```bash
# Claude Codeを起動して機能を実装
claude "ユーザー認証機能を追加"

# (実装作業)

# PR作成（セッションが自動的にリンク）
gh pr create --title "Add user authentication" --body "..."

# 後日、同じPRで作業を再開
claude --from-pr 123
```

## 実践例

### 機能開発からPR作成までの完全なワークフロー

```bash
# 1. 新しい機能を開発
claude "新しいダッシュボード機能を実装"

# 2. Claude Codeと対話しながら実装
> "Reactコンポーネントを作成して"
> "テストを追加して"
> "ドキュメントを更新して"

# 3. 変更をコミット
> "/commit"

# 4. PRを作成（自動リンク）
> "このブランチでPRを作成して"
# Claude CodeがGitHub CLIを使用してPR作成
# セッションが自動的にPR #456にリンク

# 5. 数日後、レビューコメントに対応
claude --from-pr 456
# → 以前のセッションコンテキストで再開
```

### 複数PRの並行作業

```bash
# Feature A のPR作成
claude "Feature Aを実装"
# (実装)
gh pr create  # → PR #100 (自動リンク)

# Feature B のPR作成
claude "Feature Bを実装"
# (実装)
gh pr create  # → PR #101 (自動リンク)

# 後日、各PRに簡単にアクセス
claude --from-pr 100  # Feature Aのセッション
claude --from-pr 101  # Feature Bのセッション
```

### チーム開発でのPR引き継ぎ

```bash
# 開発者Aがセッションで作業してPR作成
# (開発者A)
claude "API エンドポイントを実装"
gh pr create  # → PR #200 (自動リンク)

# 開発者BがPRをチェックアウトして作業継続
# (開発者B)
gh pr checkout 200
claude --from-pr 200
# → 開発者Aのセッションコンテキストにアクセス可能
```

### CI/CDとの統合

```yaml
# .github/workflows/create-pr.yml
name: Create PR with Claude
on:
  push:
    branches-ignore:
      - main

jobs:
  create-pr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Claude Code
        run: |
          claude -p "変更をレビューしてPR作成"
          # gh pr create が実行され、セッションが自動リンク
```

## --from-prフラグとの連携

自動リンク機能は`--from-pr`フラグと連携します：

```bash
# PR作成時（自動リンク）
claude "新機能を実装"
gh pr create  # → PR #300

# 後日、PR番号で再開
claude --from-pr 300
# セッションが自動的に見つかる

# URLでも可能
claude --from-pr https://github.com/owner/repo/pull/300
```

## v2.1.27以前との違い

**v2.1.26以前：**
- PRとセッションの紐づけは手動で管理
- セッションIDを覚えておく必要があった
- `--resume <session-id>`でしか再開できない

**v2.1.27以降：**
- `gh pr create`でPR作成時に自動リンク
- PR番号でセッションを特定できる
- `--from-pr`で直感的にアクセス可能

## 注意点

- 自動リンクは`gh pr create`コマンド経由のPR作成時のみ機能します
- GitHubのWeb UIや他のツールでPRを作成した場合は自動リンクされません
- セッションの永続化が有効になっている必要があります（`--no-session-persistence`使用時は無効）
- 同じPRに複数のセッションがリンクされている場合、最新のセッションが使用されます
- セッションファイルが削除された場合、リンクも失われます

## セッション管理のベストプラクティス

```bash
# 1. 意味のあるセッション名を使用（オプション）
claude --session-id "feature-auth-$(date +%Y%m%d)"

# 2. PR作成時にわかりやすいタイトルと説明を
gh pr create --title "明確なタイトル" --body "詳細な説明"

# 3. セッション一覧の確認
claude --resume
# インタラクティブにセッションを選択可能

# 4. 不要なセッションの整理
# ~/.claude/ ディレクトリ内のセッションファイルを定期的に整理
```

## トラブルシューティング

### セッションがPRにリンクされない場合

```bash
# 1. GitHub CLIが正しくインストールされているか確認
gh --version

# 2. GitHub CLIが認証されているか確認
gh auth status

# 3. デバッグモードで確認
claude --debug
```

### リンクされたセッションが見つからない場合

```bash
# セッション一覧を確認
claude --resume

# 該当するセッションIDを探す
# セッションファイルの場所
ls ~/.claude/sessions/
```

## 関連機能

- **`--from-pr` フラグ**: PR番号/URLでセッション再開
- **`--resume` フラグ**: セッションIDまたは名前でセッション再開
- **`--fork-session` フラグ**: セッション再開時に新しいIDで分岐

## 関連情報

- [CLI reference - Claude Code Docs](https://code.claude.com/docs/en/cli-reference)
- [GitHub Actions - Claude Code Docs](https://code.claude.com/docs/en/github-actions)
- [Common workflows - Claude Code Docs](https://code.claude.com/docs/en/common-workflows)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
