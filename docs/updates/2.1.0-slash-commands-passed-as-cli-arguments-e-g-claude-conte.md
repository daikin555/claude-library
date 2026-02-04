---
title: "CLI引数で渡されたスラッシュコマンドが正しく実行されない問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'CLI', 'スラッシュコマンド']
---

## 原文（日本語に翻訳）

CLI引数として渡されたスラッシュコマンド（例: `claude /context`）が正しく実行されない問題を修正しました

## 原文（英語）

Fixed slash commands passed as CLI arguments (e.g., `claude /context`) not being executed properly

## 概要

Claude Code v2.1.0で修正された、CLI起動時のスラッシュコマンド処理バグです。以前のバージョンでは、`claude /commit`のようにスラッシュコマンドをCLI引数として渡しても、正しく認識・実行されず、エラーが発生したり無視されたりしていました。この修正により、CLI起動時にスラッシュコマンドを直接指定できるようになり、スクリプトや自動化での使用が容易になりました。

## 修正前の問題

### 症状

```bash
# CLI引数でスラッシュコマンドを指定
claude /commit

# 修正前: エラーまたは無視される
# Error: Unknown command '/commit'
# または
# Claude Codeが起動するが、コマンドが実行されない

# 期待: コミットスキルが自動実行される
```

### 影響を受けるコマンド

```bash
# すべてのスラッシュコマンド
claude /help       # ヘルプ表示
claude /context    # コンテキスト表示
claude /plan       # プランモード
claude /commit     # コミットスキル
claude /review-pr  # PRレビュー
# など
```

## 修正後の動作

### 直接実行

```bash
# スラッシュコマンドをCLI引数で指定
claude /commit

# 修正後: 即座にコミットスキルが実行される
# Claude Codeが起動 → /commit スキル実行 → 完了後終了

# コンテキスト表示
claude /context

# ✓ コンテキスト情報が表示される
```

## 実践例

### スクリプトから自動コミット

シェルスクリプトから自動的にコミットを作成します。

```bash
#!/bin/bash
# auto-commit.sh

# コード変更を実施
./make-changes.sh

# 自動的にコミット
claude /commit

# 修正後: ✓ コミットが自動作成される
# スクリプトが完了
```

### CI/CDパイプラインでのPRレビュー

GitHub Actionsから自動レビューを実行します。

```yaml
# .github/workflows/review.yml
name: Auto Review
on: pull_request

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code
      - name: Review PR
        run: claude /review-pr ${{ github.event.pull_request.number }}
        # 修正後: ✓ PR自動レビューが実行される
```

### クイックコンテキスト確認

現在のコンテキストを即座に確認します。

```bash
# 通常の確認（対話モード経由）
claude
> /context
> exit

# 修正後: 1コマンドで確認
claude /context

# ✓ コンテキスト表示 → 自動終了
# より高速
```

### エイリアス設定

よく使うスラッシュコマンドをエイリアス化します。

```bash
# ~/.bashrc または ~/.zshrc
alias ccommit='claude /commit'
alias cplan='claude /plan'
alias ccontext='claude /context'

# 使用例
ccommit  # 即座にコミット作成
cplan   # 即座にプランモード起動
```

### ワンライナーでの使用

パイプラインや連続コマンドで使用します。

```bash
# テスト実行 → レビュー → コミット
npm test && claude /review-pr && claude /commit

# 修正後: ✓ すべてのステップが自動実行

# バックグラウンドでプラン作成
claude /plan &
# 他の作業を並行実行
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- サポートされるスラッシュコマンド:
  - **組み込みコマンド**: `/help`, `/context`, `/plan`, etc.
  - **スキル**: `/commit`, `/review-pr`, カスタムスキルなど
  - すべてのスラッシュコマンドがCLI引数として使用可能
- 動作モード:
  - **非対話モード**: CLI引数でスラッシュコマンドを指定すると、実行後自動終了
  - **対話モード**: 引数なしで起動すると、通常の対話モード
- 引数の渡し方:
  ```bash
  # 基本
  claude /command

  # スラッシュコマンド + 追加引数
  claude /commit --amend

  # 複数の単語（クォート）
  claude "/commit with message"
  ```
- `--prompt` との違い:
  ```bash
  # --prompt: 自然言語
  claude --prompt "コミットを作成して"

  # スラッシュコマンド: 直接コマンド実行
  claude /commit
  # より高速、スキル直接実行
  ```
- スクリプトでの使用:
  - 終了コードで成功/失敗を判定可能
  - エラーハンドリングが容易
  ```bash
  if claude /commit; then
    echo "Commit successful"
  else
    echo "Commit failed"
    exit 1
  fi
  ```
- インタラクティブモードとの併用:
  ```bash
  # 対話モードで特定のコマンドから開始
  claude /plan
  # プランモードで起動 → ユーザー入力を待つ
  ```
- デバッグ:
  - `--debug` フラグでスラッシュコマンド処理のログを確認
  - ログに「Executing CLI slash command: /commit」が表示される
- 複数のスラッシュコマンド:
  ```bash
  # 修正後も、1つのコマンドのみサポート
  claude /commit  # ✓ OK
  claude /commit /plan  # ✗ 最初のコマンドのみ実行
  ```
- エラーハンドリング:
  - スラッシュコマンドが存在しない場合、エラーを返す
  - 終了コード非0
- 自動終了:
  - スラッシュコマンド実行後、自動的に終了
  - 対話を継続したい場合、通常起動してからコマンド入力
- パフォーマンス:
  - CLI引数として渡す方が、対話モードより高速
  - 起動 → 実行 → 終了がシームレス

## 関連情報

- [Slash commands - Claude Code Docs](https://code.claude.com/docs/en/slash-commands)
- [CLI reference](https://code.claude.com/docs/en/cli-reference)
- [Skills](https://code.claude.com/docs/en/skills)
