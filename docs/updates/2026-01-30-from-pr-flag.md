---
title: "PRからセッションを再開できる --from-pr フラグの使い方"
date: 2026-01-30
tags: [github, pull-request, session-management, workflow]
---

## 概要

Claude Code 2.1.27で、特定のGitHub Pull Requestにリンクしたセッションを再開できる `--from-pr` フラグが追加されました。PR番号またはPR URLを指定することで、そのPRに関連する作業を簡単に再開できます。

## 使い方

### PR番号を指定して再開

```bash
claude --from-pr 123
```

リポジトリ内のPR #123に関連するセッションを再開します。

### PR URLを指定して再開

```bash
claude --from-pr https://github.com/owner/repo/pull/456
```

完全なPR URLを指定することでもセッションを再開できます。他のリポジトリのPRを扱う場合に便利です。

## 活用シーン

### 1. レビュー対応の継続作業

レビューコメントに対応する際、以前のセッションで行った作業の文脈を保持したまま作業を再開できます。

```bash
# レビューコメントを確認
gh pr view 123

# 関連セッションを再開して修正作業
claude --from-pr 123
```

### 2. 複数PRの並行作業

複数のPRを同時に進めている場合、それぞれのPRに紐付いたセッションを切り替えながら作業できます。

```bash
# 機能A のPR作業
claude --from-pr 101

# 別のターミナルで 機能B のPR作業
claude --from-pr 102
```

### 3. チーム開発での作業引き継ぎ

チームメンバーが作成したPRの作業を引き継ぐ際、関連するセッション履歴を参照できます。

## コード例

### PRの作成からセッション再開までの一連のフロー

```bash
# 1. 機能ブランチで作業開始
git checkout -b feature/new-auth

# 2. Claude Codeで実装
claude
# > ユーザー認証機能を実装してください
# > PRを作成してください

# 3. 後日、レビュー対応のためセッション再開
claude --from-pr feature/new-auth  # ブランチ名から関連PRを特定

# または PR番号を直接指定
claude --from-pr 150
```

### CI/CDの失敗対応

```bash
# CIが失敗したPRのセッションを再開
claude --from-pr https://github.com/myteam/myapp/pull/89

# セッション内で修正
# > テストが失敗しているようです。修正してください
```

## 注意点・Tips

### PRとセッションの自動リンク

`gh pr create` コマンドを使用してPRを作成すると、そのセッションは自動的にPRにリンクされます。これにより、後から `--from-pr` で簡単に再開できます。

```bash
# Claude Code内で実行
claude> gh pr create --title "新機能: ダークモード対応"
# このセッションが自動的にPRにリンクされる
```

### セッション履歴の確認

どのPRにどのセッションがリンクされているかは、セッション履歴から確認できます。

```bash
claude --list-sessions
```

### 複数のセッションがリンクされている場合

同じPRに複数のセッションがリンクされている場合、最新のセッションが再開されます。

### ローカルブランチとの整合性

セッションを再開する前に、該当するブランチにチェックアウトしておくことをおすすめします。

```bash
git checkout feature-branch
claude --from-pr 123
```

## まとめ

`--from-pr` フラグを活用することで、PRベースの開発ワークフローがよりスムーズになります。レビュー対応や継続的な機能開発において、作業の文脈を失わずに効率的に開発を進められます。
