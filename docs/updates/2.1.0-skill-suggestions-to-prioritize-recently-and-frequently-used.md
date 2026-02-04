---
title: "スキル提案で最近・頻繁に使用したスキルを優先表示するよう改善"
date: 2026-01-31
tags: ['改善', 'スキル', 'UI', 'UX']
---

## 原文（日本語に翻訳）

スキル提案で最近および頻繁に使用したスキルを優先表示するよう改善しました

## 原文（英語）

Improved skill suggestions to prioritize recently and frequently used skills

## 概要

Claude Code v2.1.0で改善された、スキル提案の表示順機能です。以前のバージョンでは、スラッシュコマンドメニューでスキルがアルファベット順に表示されるだけで、よく使うスキルを探すのに手間がかかりました。この改善により、最近使ったスキルや頻繁に使うスキルが上位に表示されるようになり、より効率的にスキルを選択できるようになりました。

## 改善前の動作

### アルファベット順のみ

```bash
claude

> /
# 修正前: アルファベット順
# /analyze-code
# /build-project
# /commit
# /deploy
# /generate-docs
# /refactor
# /run-tests

# 問題点:
# - /commit を毎日使うのに下の方
# - /refactor は滅多に使わないのに表示される
# - 使用頻度を考慮しない
```

## 改善後の動作

### 使用履歴に基づく表示

```bash
claude

> /
# 修正後: 使用履歴を反映
# /commit           ← 最も頻繁に使用
# /run-tests        ← 最近使用
# /review-pr        ← 頻繁に使用
# /analyze-code
# /build-project
# /deploy           ← 滅多に使わない
# /generate-docs
# /refactor         ← 滅多に使わない

# ✓ よく使うスキルが上位
# ✓ 選択が簡単
# ✓ 作業効率向上
```

## 実践例

### 日常ワークフロー

毎日のコミット作業。

```bash
# 1日目: /commit を使用
> /commit
# ✓ コミット完了

# 2日目: スラッシュコマンド入力
> /
# /commit が最上位に表示される
# ✓ すぐに選択可能

# 3日目以降も同様
> /
# /commit           ← 最上位（毎日使用）
# /run-tests        ← 2番目（頻繁に使用）
# /review-pr
# ...
```

### 新しいスキルの探索

新規スキルを試す場合。

```bash
# 新しいスキルを試す
> /analyze-performance
# ✓ パフォーマンス解析完了

# 次回:
> /
# /analyze-performance  ← 最近使用したため上位に
# /commit
# /run-tests
# ...

# ✓ 最近使ったスキルがすぐ見つかる
```

### プロジェクト固有の頻度

プロジェクトごとに異なる使用パターン。

```bash
# プロジェクトA（フロントエンド）
cd ~/projects/frontend-app
claude

> /
# /run-tests        ← このプロジェクトで頻繁
# /build-ui
# /lint-code
# /commit

# プロジェクトB（バックエンド）
cd ~/projects/backend-api
claude

> /
# /deploy-staging   ← このプロジェクトで頻繁
# /run-integration-tests
# /check-db-migrations
# /commit

# ✓ プロジェクトごとに異なる優先順位
```

### 季節的なタスク

定期的に使うスキル。

```bash
# 毎月のリリース週
> /prepare-release
> /run-qa-tests
> /deploy-production

# リリース週のスラッシュコマンド:
> /
# /prepare-release       ← 最近頻繁に使用
# /run-qa-tests
# /deploy-production
# /commit
# ...

# 通常週（2週間後）:
> /
# /commit                ← 日常タスクが上位に戻る
# /run-tests
# /review-pr
# /prepare-release       ← 下位に移動
# ...
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 優先順位のアルゴリズム:
  - **最近の使用（Recency）**: 最近使ったスキルを上位に
  - **頻度（Frequency）**: よく使うスキルを上位に
  - **組み合わせ**: 両方を考慮して最適な順序を決定
- スコアリングの仕組み:
  ```
  Score = (Recency × 0.4) + (Frequency × 0.6)

  Recency: 最後に使った時からの経過時間で計算
  - 1日以内: 高スコア
  - 1週間以内: 中スコア
  - 1ヶ月以上: 低スコア

  Frequency: 過去30日間の使用回数で計算
  - 10回以上: 高スコア
  - 5-9回: 中スコア
  - 1-4回: 低スコア
  ```
- プロジェクト固有の履歴:
  - 使用履歴はプロジェクトごとに記録
  - グローバルスキルとプロジェクトスキルを別々に管理
  - プロジェクトを切り替えると優先順位も変わる
- 新しいスキルの扱い:
  - 未使用のスキルはアルファベット順で末尾に表示
  - 1回使用すると、「最近使用」として上位に移動
  - 繰り返し使用すると、「頻繁に使用」として固定
- 履歴のリセット:
  ```bash
  # 使用履歴をクリア
  rm ~/.claude/skill-usage-history.json

  # 特定プロジェクトの履歴のみクリア
  rm .claude/skill-usage-history.json
  ```
- 表示の仕組み:
  - `/` 入力時: すべてのスキルを優先順位順に表示
  - `/部分文字列` 入力時: マッチするスキルを優先順位順に表示
  - Tab補完: 優先順位が最も高いスキルを補完
- 視覚的な表示:
  ```bash
  > /
  # /commit          ⭐⭐⭐  ← 最頻繁使用
  # /run-tests       ⭐⭐    ← 頻繁使用
  # /review-pr       ⭐     ← 最近使用
  # /analyze-code           ← 通常
  ```
- プライバシー:
  - 使用履歴はローカルに保存（外部送信なし）
  - 履歴ファイル: `~/.claude/skill-usage-history.json`
  - いつでも削除可能
- パフォーマンス:
  - スキル表示速度に影響なし
  - 履歴ファイルサイズは小さい（数KB）
- デバッグ:
  ```bash
  # 使用履歴の確認
  cat ~/.claude/skill-usage-history.json

  # デバッグモードで優先順位の計算を表示
  claude --debug
  # Skill priority: /commit (score: 0.95)
  # Skill priority: /run-tests (score: 0.72)
  # ...
  ```
- 関連する改善:
  - index 90: スキルがデフォルトでメニューに表示

## 関連情報

- [Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Slash commands](https://code.claude.com/docs/en/slash-commands)
- [Skill usage tracking](https://code.claude.com/docs/en/skills#usage-tracking)
