---
title: "リポジトリ名にドットを含む場合のバックグラウンドタスクエラーを修正"
date: 2026-01-31
tags: ['バグ修正', 'Git', 'バックグラウンドタスク']
---

## 原文（日本語に翻訳）

リポジトリ名にドットを含む場合に「git repository not found」エラーでバックグラウンドタスクが失敗する問題を修正しました

## 原文（英語）

Fixed background tasks failing with "git repository not found" error for repositories with dots in their names

## 概要

Claude Code v2.1.0で修正された、Gitリポジトリ名の処理バグです。リポジトリ名にドット（.）を含む場合（例: `my.project`、`api.v2.backend`）、バックグラウンドタスクがGitリポジトリを見つけられずに失敗していました。この修正により、ドットを含むリポジトリ名でも正しく処理されるようになり、バックグラウンドタスクが正常に動作します。

## 修正前の問題

```bash
# リポジトリ名にドットを含むプロジェクト
cd ~/projects/api.v2.backend
git init
claude

# バックグラウンドでタスクを実行
> ビルドをバックグラウンドで実行してください
# Ctrl+B を押してバックグラウンド化

# エラー: git repository not found
# バックグラウンドタスクが失敗
```

### 影響を受けるリポジトリ名の例

- `api.v2.backend`
- `my.company.project`
- `service.auth`
- `lib.utils.core`
- `app.web.v1.0`

## 修正後の動作

```bash
# 同じリポジトリ名
cd ~/projects/api.v2.backend
claude

# バックグラウンドタスク実行
> ビルドをバックグラウンドで実行
# Ctrl+B

# ✓ 正常動作: Gitリポジトリが正しく認識される
# ✓ バックグラウンドタスクが成功
```

## 実践例

### ドット含むリポジトリでのCI/CD

```bash
# リポジトリ: deploy.prod.scripts
cd ~/work/deploy.prod.scripts

# バックグラウンドでテスト実行
claude
> テストをバックグラウンドで実行
# Ctrl+B

# 修正後: 正常に動作
# Git情報が正しく取得される
```

### バージョン番号付きプロジェクト

```bash
# リポジトリ: app.v2.1.stable
cd ~/projects/app.v2.1.stable

# 複数のバックグラウンドタスク
> ビルドを実行
# Ctrl+B

> テストを実行
# Ctrl+B

# ✓ 両方のタスクが正常に動作
```

### マイクロサービスアーキテクチャ

```bash
# 複数のサービス
~/services/
├── auth.service/
├── payment.api/
├── user.mgmt/
└── notification.worker/

# どのサービスでもバックグラウンドタスクが動作
cd ~/services/auth.service
claude
> サーバーを起動
# Ctrl+B  # ✓ 正常動作
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- ドットを含むディレクトリ名全般に対応（ドメイン名スタイルのリポジトリなど）
- 修正内容:
  - Gitリポジトリパスの解析ロジックを改善
  - ドットを特殊文字として誤認識しないように修正
  - パス区切りとドット区切りを正しく区別
- 影響範囲:
  - バックグラウンドBashコマンド
  - バックグラウンドエージェント
  - Git操作を伴うすべてのバックグラウンドタスク
- 推奨事項:
  - リポジトリ名にはASCII文字、数字、ドット、ハイフン、アンダースコアの使用を推奨
  - スペースや特殊文字は避ける

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [What are Background Agents in Claude Code](https://claudelog.com/faqs/what-are-background-agents/)
