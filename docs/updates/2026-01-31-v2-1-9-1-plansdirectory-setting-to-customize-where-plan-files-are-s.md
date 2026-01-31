---
title: "プランファイルの保存場所をカスタマイズ可能に"
date: 2026-01-16
tags: ['新機能', '設定', 'プランモード']
---

## 原文（日本語訳）

プランファイルの保存場所をカスタマイズするための `plansDirectory` 設定を追加しました。

## 原文（英語）

Added `plansDirectory` setting to customize where plan files are stored

## 概要

Claude Codeのプランモードで生成されるプランファイルの保存場所を、プロジェクトごとにカスタマイズできるようになりました。デフォルトでは `~/.claude/plans` に保存されますが、プロジェクト内のディレクトリに保存することで、プランをGitで管理したり、チーム全体で共有したりできます。

## 基本的な使い方

設定ファイル（`~/.claude/settings.json`、`.claude/settings.json`、または `.claude/settings.local.json`）に `plansDirectory` を追加します。

```json
{
  "plansDirectory": "./plans"
}
```

パスは**プロジェクトルートからの相対パス**として解釈されます。

## 実践例

### プロジェクト内にプランを保存

プランファイルをプロジェクトディレクトリ内に保存し、バージョン管理できるようにします。

`.claude/settings.json`:
```json
{
  "plansDirectory": "./plans"
}
```

この設定により、プランファイルは `<project-root>/plans/` に保存されます。

### ドキュメントディレクトリにプランを保存

既存のドキュメント構造に合わせて、プランをdocsフォルダに保存します。

```json
{
  "plansDirectory": "./docs/plans"
}
```

### チーム全体で標準化

プロジェクトの `.claude/settings.json` に設定することで、チーム全員が同じディレクトリにプランを保存できます。

`.claude/settings.json`:
```json
{
  "plansDirectory": "./.claude/plans"
}
```

この設定をGitにコミットすることで、全メンバーが統一された場所でプランを管理できます。

### 個人用とプロジェクト用を使い分け

- **プロジェクト設定** (`.claude/settings.json`): チーム共有用
  ```json
  {
    "plansDirectory": "./docs/planning"
  }
  ```

- **ローカル設定** (`.claude/settings.local.json`): 個人的な実験用
  ```json
  {
    "plansDirectory": "./tmp/my-plans"
  }
  ```

ローカル設定はプロジェクト設定より優先されるため、個人的な作業では別の場所に保存できます。

## 注意点

- パスはプロジェクトルートからの相対パスとして解釈されます
- 指定したディレクトリが存在しない場合は自動的に作成されます
- デフォルトの保存場所は `~/.claude/plans` です
- 設定は user、project、local の各スコープで指定可能です
- プランファイルをGitで管理する場合は、機密情報が含まれていないか確認してください

## 関連情報

- [Settings公式ドキュメント](https://code.claude.com/docs/en/settings)
- [プランモードについて](https://code.claude.com/docs/en/how-claude-code-works)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
