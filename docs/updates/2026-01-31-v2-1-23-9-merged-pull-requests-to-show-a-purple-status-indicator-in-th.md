---
title: "マージ済みPRを紫色のステータス表示で識別"
date: 2026-01-29
tags: ['変更', 'UI', 'Git', 'GitHub', 'プルリクエスト']
---

## 原文（日本語に翻訳）

プロンプトフッターでマージ済みのプルリクエストを紫色のステータスインジケーターで表示するように変更

## 原文（英語）

Changed merged pull requests to show a purple status indicator in the prompt footer

## 概要

Claude CodeのプロンプトフッターにGitHub PRの状態が表示される際、マージ済みのプルリクエストが紫色（GitHub UIと同じ色）で表示されるようになりました。これにより、オープン中（緑）、クローズ済み（赤）、マージ済み（紫）のPRを視覚的に区別しやすくなり、現在作業しているブランチの状態を一目で把握できるようになります。

## 基本的な使い方

Claude CodeをGitリポジトリ内で起動すると、自動的にプロンプトフッターにブランチとPR情報が表示されます。

### ステータスインジケーターの色

- 🟢 **緑**: オープン中のPR
- 🔴 **赤**: クローズされたPR（マージされずに閉じられた）
- 🟣 **紫**: マージ済みのPR（v2.1.23で追加）

## 実践例

### マージ済みブランチでの作業

```bash
# マージ済みのブランチで作業している場合
claude

# プロンプトフッター表示例
🟣 PR #123: Add new feature (merged)
main...feature/new-feature

# 紫色の表示により、このブランチは既にマージ済みであることが明確
```

### オープン中のPRとの違い

```bash
# オープン中のPRブランチ
🟢 PR #124: Fix bug (open)
main...fix/bug-123

# マージ済みのPRブランチ
🟣 PR #123: Add new feature (merged)
main...feature/new-feature

# クローズ済み（マージなし）のPRブランチ
🔴 PR #122: Experimental change (closed)
main...experiment/test
```

### PR作成後のワークフロー

```bash
# 1. 新しいブランチでPRを作成
> /commit
> git push

# PR作成
🟢 PR #125: Update documentation (open)

# 2. レビュー完了後、GitHubでマージ

# 3. ローカルで確認
> git fetch

# ステータスが紫に変わる
🟣 PR #125: Update documentation (merged)
```

### マージ済みブランチのクリーンアップ

紫色のステータスを見て、不要になったブランチを削除できます。

```bash
# マージ済みブランチを確認
🟣 PR #120: Feature A (merged)
🟣 PR #121: Feature B (merged)
🟢 PR #123: Feature C (open)

# マージ済みブランチを削除
> git branch -d feature/feature-a
> git branch -d feature/feature-b
```

### 複数のブランチ間での切り替え

```bash
# ブランチを切り替えると、ステータス表示も更新される

> git checkout feature/new-feature
🟢 PR #126: New feature (open)

> git checkout hotfix/urgent
🟣 PR #127: Urgent fix (merged)  # 既にマージされていることが分かる

> git checkout main
# PRなし（mainブランチ）
```

## 注意点

- PR情報の表示には、GitHubリポジトリとの接続が必要です
- GitHub CLIツール（`gh`）がインストールされている必要があります
- プライベートリポジトリの場合、適切な認証設定が必要です
- PR情報は定期的に更新されますが、リアルタイムではない場合があります
- 手動で最新情報を取得するには、`git fetch`を実行してください
- GitLab、BitbucketなどのプラットフォームではPR情報が表示されない場合があります
- フォークからのPRの場合、表示が異なる場合があります
- 非常に古いマージ済みPRは、API制限により表示されない可能性があります

## 関連情報

- [GitHub CLI 公式ドキュメント](https://cli.github.com/)
- [GitHubのPRステータスについて](https://docs.github.com/ja/pull-requests/collaborating-with-pull-requests)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- GitHub CLIのインストール: `brew install gh`（macOS）または公式サイトからダウンロード
