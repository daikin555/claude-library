---
title: "プラグイン検索とログセレクターで上矢印キーを押すと検索モードが終了する問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'UI', '検索', 'キーバインド']
---

## 原文（日本語に翻訳）

プラグイン検索画面とログセレクター画面で、上矢印キーを押すと検索モードが終了する問題を修正しました

## 原文（英語）

Fixed search mode in plugin discovery and log selector views exiting when pressing up arrow

## 概要

Claude Code v2.1.0で修正された、検索モードのキーバインドバグです。以前のバージョンでは、プラグイン検索画面やログセレクター画面で検索モードを使用している際、上矢印キー（↑）を押すと意図せず検索モードが終了し、通常の選択モードに戻ってしまっていました。この修正により、矢印キーで検索結果内を移動できるようになり、検索体験が改善されました。

## 修正前の問題

### プラグイン検索での症状

```bash
# プラグインを検索
claude

> /mcp  # MCPサーバー管理画面を開く

# 検索モードに入る
/ を押す

# プラグイン名を入力
> "github"

# 検索結果が表示される:
# 1. github-mcp-server
# 2. github-actions-helper
# 3. github-copilot-integration

# 上矢印キーで前の結果に移動しようとする
↑

# 修正前: 検索モードが終了
# - 検索入力欄が消える
# - 検索結果がクリアされる
# - 通常の選択モードに戻る
# - 意図しない動作
```

### ログセレクターでの症状

```bash
# ログを検索
claude --logs

# 検索モードに入る
/ を押す

# エラーログを検索
> "error"

# 検索結果が表示される
# 上矢印で前のログに移動
↑

# 修正前: 検索モードが終了
# 検索がリセットされる
```

## 修正後の動作

### 矢印キーで検索結果を移動

```bash
# プラグイン検索
> /mcp
/  # 検索モード開始
> "git"

# 検索結果:
# 1. git-mcp-server
# 2. github-mcp-server
# 3. gitlab-integration

# 修正後: 矢印キーで移動可能
↓  # 次の結果へ (github-mcp-server)
↓  # 次の結果へ (gitlab-integration)
↑  # 前の結果へ (github-mcp-server)
↑  # 前の結果へ (git-mcp-server)

# ✓ 検索モードは維持される
# ✓ 検索結果内をスムーズに移動
```

### Escキーで検索終了

```bash
# 検索モード中
> "search query"

# 検索を終了したい場合
Esc  # 検索モードを終了

# ✓ 意図的な終了のみ
```

## 実践例

### MCPサーバー検索

効率的にMCPサーバーを見つけられます。

```bash
# MCPサーバー管理画面
> /mcp

# 検索モード
/
> "database"

# 検索結果を矢印キーで移動
↓ postgresql-mcp
↓ mysql-mcp
↓ mongodb-mcp
↑ mysql-mcp  # 戻る

# Enter で選択
# ✓ スムーズな検索体験
```

### ログ検索とナビゲーション

大量のログから目的のエントリーを見つけます。

```bash
# ログビューアー
claude --logs

# エラーログを検索
/
> "TypeError"

# 検索結果が複数ある場合
↓  # 次のTypeError
↓  # さらに次のTypeError
↑  # 前のTypeErrorに戻る

# 詳細を確認
Enter

# ✓ ログ調査が効率的
```

### 長いリストでの絞り込み検索

```bash
# スキル一覧
> /skills

# 特定のスキルを検索
/
> "terraform"

# 検索結果:
# - terraform-aws-expert
# - terraform-code-reviewer
# - terraform-engineer

# 矢印キーで選択
↓ terraform-code-reviewer
Enter  # 実行

# ✓ 高速なスキル選択
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- 検索モードのキーバインド:
  - **/**: 検索モード開始
  - **↑/↓**: 検索結果内を移動（修正後）
  - **Enter**: 選択した項目を確定
  - **Esc**: 検索モードを終了
  - **Ctrl+C**: 検索をキャンセル
- 適用される画面:
  - プラグイン検索（`/mcp`）
  - ログセレクター（`--logs`）
  - スキル一覧（`/skills`）
  - フック設定（`/hooks`）
  - その他のリスト表示画面
- 検索モードの動作:
  - インクリメンタル検索（入力に応じて即座に絞り込み）
  - 大文字小文字を区別しない
  - 部分一致検索
- 修正前の問題:
  - 上矢印キーが「前の画面に戻る」として解釈されていた
  - キーバインドの優先順位の問題
- 修正後の改善:
  - 検索モード中は矢印キーが検索結果のナビゲーションに専念
  - Escキーのみが検索モード終了に使用される
- 関連する改善:
  - 検索結果のハイライト表示
  - 検索結果数の表示（例: "3 results"）
  - 検索履歴の保存

## 関連情報

- [MCP servers - Claude Code Docs](https://code.claude.com/docs/en/mcp)
- [Logs - Claude Code Docs](https://code.claude.com/docs/en/logs)
- [Keyboard shortcuts](https://code.claude.com/docs/en/keyboard-shortcuts)
