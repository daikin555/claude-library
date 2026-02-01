---
title: "PRレビュー状態インジケーターがフッターに追加"
date: 2026-01-27
tags: ['新機能', 'GitHub', 'プルリクエスト', 'UI改善']
---

## 原文（日本語に翻訳）

プロンプトフッターにPRレビュー状態インジケーターを追加。現在のブランチのPR状態（承認済み、変更要求、レビュー待ち、ドラフト）を色付きドットとクリック可能なリンクで表示

## 原文（英語）

Added PR review status indicator to the prompt footer, showing the current branch's PR state (approved, changes requested, pending, or draft) as a colored dot with a clickable link

## 概要

Claude Code v2.1.20で、プロンプトフッターにPRレビュー状態インジケーターが追加されました。オープン中のプルリクエストを持つブランチで作業している場合、Claude Codeのフッターにクリック可能なPRリンク（例：「PR #446」）が表示され、その下線の色でレビュー状態が一目で分かります。60秒ごとに自動更新されるため、レビューステータスの変化をリアルタイムで追跡できます。

## 基本的な使い方

1. GitHub CLIをインストールして認証（`gh auth login`）
2. プルリクエストが存在するブランチで作業
3. Claude Codeのフッターに表示されるPRリンクを確認
4. `Cmd+click`（Mac）または`Ctrl+click`（Windows/Linux）でブラウザでPRを開く

```bash
# GitHub CLIの認証が必要
gh auth login

# プルリクエストを作成
gh pr create --title "新機能追加" --body "説明"

# Claude Codeを起動すると、フッターにPR状態が表示される
claude
```

## レビュー状態の色分け

PRリンクの下線の色で、現在のレビュー状態が分かります：

- **緑（Green）**: 承認済み（Approved） - PRがレビューで承認されました
- **黄（Yellow）**: レビュー待ち（Pending） - レビューが未完了または進行中
- **赤（Red）**: 変更要求（Changes Requested） - レビュアーが変更を要求
- **グレー（Gray）**: ドラフト（Draft） - ドラフトPR
- **紫（Purple）**: マージ済み（Merged） - PRがマージされました

## 実践例

### チーム開発でのレビュー追跡

プルリクエストを作成した後、Claude Codeで作業を続けながらレビュー状態を監視：

```bash
# 1. 新しいブランチでPRを作成
git checkout -b feature/new-api
# ... 変更を加える ...
git add .
git commit -m "Add new API endpoint"
git push origin feature/new-api
gh pr create --title "新しいAPIエンドポイント追加"

# 2. Claude Codeで作業を継続
claude

# フッターに「PR #123」と表示され、色で状態が分かる
# - 黄色の下線 → まだレビューされていない
# - 赤色の下線 → 変更が要求された → 修正が必要
# - 緑色の下線 → 承認された → マージ可能
```

### 変更要求への迅速な対応

レビューで変更が要求された場合、即座に気づいて対応：

```bash
# Claude Codeで作業中、フッターのPRリンクが黄→赤に変化
# Cmd+clickまたはCtrl+clickでブラウザでPRを開く

# レビューコメントを確認して、Claude Codeで修正
"レビューで指摘された○○の部分を修正してください"

# 修正後、自動的に状態が更新される（60秒以内）
```

### ドラフトPRから本PRへの移行

ドラフトPRで作業し、準備ができたら本PRに変換：

```bash
# ドラフトPRを作成
gh pr create --draft --title "作業中: 新機能"

# Claude Codeのフッターに「PR #456」とグレーの下線で表示

# 作業完了後、ドラフトを解除
gh pr ready 456

# フッターの下線が黄色（レビュー待ち）に変化
```

### 複数ブランチでの作業管理

複数のブランチを切り替えながら作業する場合、各ブランチのPR状態を追跡：

```bash
# ブランチAで作業
git checkout feature/api
claude
# フッター: PR #100（緑 = 承認済み）→ マージ可能

# ブランチBに切り替え
git checkout feature/ui
claude
# フッター: PR #101（赤 = 変更要求）→ 修正が必要
```

## 注意点

- GitHub CLIのインストールと認証（`gh auth login`）が必要です
- PRステータスは60秒ごとに自動更新されます（即時更新ではありません）
- プルリクエストが存在しないブランチでは表示されません
- プライベートリポジトリの場合、適切なGitHub認証が必要です
- ネットワークの問題で更新が遅れる場合があります

## GitHub CLIのセットアップ

この機能を使用するには、GitHub CLIの設定が必要です：

```bash
# GitHub CLIのインストール（未インストールの場合）
# macOS (Homebrew)
brew install gh

# Windows (WinGet)
winget install GitHub.cli

# Linux (Debian/Ubuntu)
sudo apt install gh

# 認証
gh auth login

# 認証状態の確認
gh auth status
```

## 関連情報

- [Interactive Mode - PR review status](https://code.claude.com/docs/en/interactive-mode#pr-review-status)
- [GitHub Actions integration](https://code.claude.com/docs/en/github-actions)
- [GitHub CLI documentation](https://cli.github.com/manual/)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
