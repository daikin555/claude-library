---
title: "リポジトリセットアップ用の新しいSetupフックイベント"
date: 2026-01-16
tags: ['新機能', 'hooks', 'CLI', 'セットアップ']
---

## 原文(日本語に翻訳)

`--init`、`--init-only`、または `--maintenance` CLIフラグで実行できる新しい `Setup` フックイベントを追加。リポジトリのセットアップとメンテナンス操作に対応。

## 原文(英語)

Added new `Setup` hook event that can be triggered via `--init`, `--init-only`, or `--maintenance` CLI flags for repository setup and maintenance operations

## 概要

Claude Code v2.1.10で新しく追加された `Setup` フックイベントにより、リポジトリの初期セットアップやメンテナンス作業を自動化できるようになりました。このフックは特定のCLIフラグを使用することで実行され、依存関係のインストールや環境構成など、プロジェクト固有の初期化処理を定義できます。

## 基本的な使い方

`~/.claude/hooks.json` ファイルでSetupフックを設定します。

```json
{
  "Setup": "npm install && npm run build"
}
```

フックを実行するには、以下のいずれかのフラグを使用してClaude Codeを起動します。

```bash
# 初回セットアップ時に実行
claude --init

# セットアップのみ実行(対話モードに入らない)
claude --init-only

# メンテナンス操作として実行
claude --maintenance
```

## 実践例

### Node.jsプロジェクトの初期セットアップ

```json
{
  "Setup": "npm ci && npm run build && npm test"
}
```

このフックは依存関係のクリーンインストール、ビルド、テスト実行を順次行います。

### Python仮想環境のセットアップ

```json
{
  "Setup": "python -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
}
```

新しいリポジトリで仮想環境を作成し、必要なパッケージをインストールします。

### 複数のセットアップタスクを実行

```json
{
  "Setup": "git submodule update --init --recursive && ./scripts/setup-dev-env.sh && make init"
}
```

サブモジュールの初期化、開発環境セットアップスクリプト実行、Makefileの初期化タスクを連続実行します。

### データベースのマイグレーション

```json
{
  "Setup": "docker-compose up -d db && npm run db:migrate && npm run db:seed"
}
```

開発用データベースを起動し、マイグレーションとシードデータ投入を行います。

## 注意点

- Setupフックは通常のフックと異なり、自動実行されません。明示的にフラグを指定する必要があります
- `--init-only` を使用すると、セットアップ後にClaude Codeの対話モードには入りません
- 長時間かかる処理を含む場合は、タイムアウト設定に注意してください
- フック内でエラーが発生した場合、Claude Codeの起動がブロックされる可能性があります

## 関連情報

- [Claude Code フック機能のドキュメント](https://github.com/anthropics/claude-code#hooks)
- [Changelog v2.1.10](https://github.com/anthropics/claude-code/releases/tag/v2.1.10)
