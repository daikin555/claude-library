---
title: "`CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` 環境変数でファイル読み取りトークン上限を設定"
date: 2026-01-31
tags: ['新機能', '設定', 'パフォーマンス']
---

## 原文（日本語に翻訳）

デフォルトのファイル読み取りトークン制限を上書きできる `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` 環境変数を追加しました

## 原文（英語）

Added `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` environment variable to override the default file read token limit

## 概要

Claude Code v2.1.0で導入された、ファイル読み取り時のトークン制限をカスタマイズできる環境変数です。Claudeがファイルを読み取る際、デフォルトでは一定のトークン数までしか読み込まれませんが、この環境変数を設定することで制限を引き上げたり引き下げたりできます。大きなファイルを扱う場合の制限緩和や、コスト削減のための制限強化など、用途に応じた柔軟な調整が可能になります。

## 基本的な使い方

環境変数を設定してClaude Codeを起動します。

```bash
# 制限を10,000トークンに設定
export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=10000
claude

# または1行で起動
CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=10000 claude
```

## 実践例

### 大きなログファイルの分析

大容量のログファイルを分析する際に制限を引き上げます。

```bash
# デフォルト制限では不十分な場合
export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=50000
claude

> logs/application.log を分析して、エラーの原因を特定して

# 50,000トークン（約37,500単語）まで読み込み可能
# より多くのログエントリを一度に処理できる
```

### 大規模な設定ファイルの編集

長大な設定ファイルを扱う場合に制限を緩和します。

```bash
# package.json や webpack.config.js など大きな設定ファイル
export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=20000
claude

> package.jsonの依存関係を最新版に更新して

# ファイル全体が読み込まれ、正確な編集が可能
```

### コスト削減のために制限を厳格化

APIコストを抑えるために、読み取りトークン数を制限します。

```bash
# トークン消費を抑える（デフォルトより低く設定）
export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=2000
claude

> このファイルの最初の部分を確認して

# 必要最小限のトークンのみ使用
# API コストが削減される
```

### プロジェクト別の設定

`.envrc`（direnv）を使って、プロジェクトごとに制限を設定します。

```bash
# プロジェクトルートに .envrc を作成
cat > .envrc <<EOF
# 大規模プロジェクトのための設定
export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=30000
EOF

# direnvを有効化
direnv allow

# このディレクトリでは自動的に30,000トークン制限が適用
cd ~/projects/large-codebase
claude
```

### CI/CD環境での最適化

CI/CDパイプラインで、必要に応じて制限を調整します。

```yaml
# GitHub Actions
- name: Run Claude Code analysis
  env:
    CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS: 15000
  run: |
    claude --prompt "コードレビューを実施"
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- デフォルト制限:
  - 明示されていませんが、通常は数千トークン程度
  - 環境変数を設定しない場合、この制限が適用される
- トークンとファイルサイズの関係:
  - 1トークン ≈ 0.75単語（英語）
  - 1トークン ≈ 4文字（日本語）
  - 10,000トークン ≈ 7,500単語 ≈ 40,000文字
- 制限の影響範囲:
  - `Read` ツールで読み取られるトークン数
  - ファイル全体が制限内に収まらない場合、切り捨てられる
  - 切り捨てられた場合、Claudeに通知される
- パフォーマンスへの影響:
  - 制限を高くすると:
    - ✅ 大きなファイルを完全に読み込める
    - ❌ APIコストが増加
    - ❌ レスポンス時間が増加
  - 制限を低くすると:
    - ✅ APIコストが削減
    - ✅ レスポンス時間が短縮
    - ❌ ファイルの一部しか読み込めない
- 推奨される設定値:
  - **小規模ファイル主体**: 5,000トークン
  - **通常プロジェクト**: 10,000トークン（デフォルト想定）
  - **大規模ファイル**: 20,000～50,000トークン
  - **ログ分析**: 50,000～100,000トークン
- 注意事項:
  - 極端に高い値（例: 1,000,000）を設定すると、メモリ不足やタイムアウトのリスク
  - Claude APIの最大コンテキストウィンドウ（200K トークン）を超えないように設定
  - ファイルサイズが制限を超える場合、offsetとlimitパラメータで分割読み込みを推奨
- シェル設定ファイルでの永続化:
  ```bash
  # ~/.bashrc または ~/.zshrc
  export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS=15000
  ```

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Environment variables](https://code.claude.com/docs/en/environment-variables)
- [Performance tuning](https://code.claude.com/docs/en/performance)
