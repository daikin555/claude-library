---
title: "セッション再開時のファイルとスキルの検出問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'セッション管理', 'スキル']
---

## 原文（日本語に翻訳）

`-c` または `--resume` でセッションを再開した際に、ファイルとスキルが適切に検出されない問題を修正しました

## 原文（英語）

Fixed files and skills not being properly discovered when resuming sessions with `-c` or `--resume`

## 概要

Claude Code v2.1.0で修正された、セッション再開時の検出バグです。以前のバージョンでは、`-c` オプションまたは `--resume` フラグを使用してセッションを再開した際に、プロジェクトファイルやカスタムスキルが正しく認識されない問題がありました。この修正により、セッション再開時にもすべてのファイルとスキルが適切に検出され、中断したところから継続して作業できるようになりました。

## 修正前の問題

### ファイルが認識されない

```bash
# セッションを開始してファイルを作業
claude
# ... 作業中 ...
# Ctrl+D でセッション終了

# セッション再開時
claude --resume

# 問題: 以前扱っていたファイルが認識されない
# @メンションでファイルが候補に表示されない
# Read toolで読み取ったはずのファイルが見つからない
```

### スキルが利用できない

```bash
# カスタムスキルを使用していたセッション
claude
# /my-custom-skill を実行
# Ctrl+D でセッション終了

# セッション再開時
claude -c <session-id>

# 問題: /my-custom-skill が利用不可
# スキル一覧に表示されない
```

## 修正後の動作

### ファイルの継続的な認識

```bash
# セッション開始
claude

# ファイルを作業
> src/main.tsを読んで修正してください

# セッション終了
# Ctrl+D

# セッション再開
claude --resume

# 修正後: ファイルが正しく認識される
> 先ほどのmain.tsの修正を続けてください
# ✓ src/main.tsが正しく認識される
```

### スキルの継続的な利用

```bash
# セッション開始とスキル使用
claude
> /project-setup を実行

# セッション終了後、再開
claude -c abc123

# 修正後: スキルが引き続き利用可能
> /project-setup を再度実行してください
# ✓ スキルが正しく検出され実行される
```

## 実践例

### 長時間プロジェクトの中断と再開

```bash
# 1日目: プロジェクト開始
claude
> プロジェクトの構造を分析してください
# ... 分析作業 ...
# Ctrl+D で終了

# 2日目: セッション再開
claude --resume
> 昨日分析したファイルを基に実装を進めてください
# ✓ 1日目に扱ったファイルがすべて認識される
# ✓ カスタムスキルも引き続き利用可能
```

### CI/CD環境でのセッション管理

```bash
# ビルドプロセスでセッション使用
claude -c build-session
> ビルドスクリプトを確認
# ... 作業 ...

# エラー発生時、デバッグのため再開
claude -c build-session
> 先ほどのエラーをデバッグしてください
# ✓ ビルドスクリプトが正しく認識される
```

### チーム共有セッションの再開

```bash
# チームメンバーAがセッション開始
claude
> コードレビューを実行
# セッションID: team-review-001

# チームメンバーBがセッション再開
claude -c team-review-001
> レビュー結果を確認
# ✓ メンバーAが扱ったファイルがすべて認識される
# ✓ 使用したスキルも利用可能
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- **v2.1.0未満のバージョンではこの問題が発生します**
- セッション再開には以下のオプションが使用できます：
  - `--resume`: 最新のセッションを再開
  - `-c <session-id>`: 特定のセッションIDを指定して再開
- この修正後も、`~/.claude/skills/` のスキル検出に関する別の問題が報告されています
  - 最近（2026年1月時点）、キャッシュされたスキルの内容が更新されない問題
  - 回避策: Claude Codeを再起動するか、スキルキャッシュをクリア
- プロジェクトファイル（`.claude/skills/`）とグローバルスキル（`~/.claude/skills/`）の両方が適切に検出されます

## 関連情報

- [Claude Code Troubleshooting Guide](https://code.claude.com/docs/en/troubleshooting)
- [GitHub Issue: Skills not discovered in ~/.claude/skills/](https://github.com/anthropics/claude-code/issues/21428)
- [Claude Code Skills Not Recognised? Here's the Fix!](https://scottspence.com/posts/claude-code-skills-not-recognised)
