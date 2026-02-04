---
title: "BashコマンドとエージェントのCtrl+Bバックグラウンド化を統合"
date: 2026-01-31
tags: ['新機能', 'bash', 'エージェント', 'UX']
---

## 原文（日本語に翻訳）

BashコマンドとエージェントのCtrl+Bバックグラウンド化を統合しました - Ctrl+Bを押すと、実行中のすべてのフォアグラウンドタスクが同時にバックグラウンドに移動します

## 原文（英語）

Added unified Ctrl+B backgrounding for both bash commands and agents - pressing Ctrl+B now backgrounds all running foreground tasks simultaneously

## 概要

Claude Code v2.1.0で導入された、統一されたバックグラウンド実行機能です。Ctrl+Bキーを押すだけで、Bashコマンドとエージェントの両方を含む、実行中のすべてのフォアグラウンドタスクを同時にバックグラウンドに移動できます。これにより、長時間実行されるビルド、テスト、サーバー起動などを実行しながら、Claude Codeで他の作業を継続できます。v2.0.64以降、バックグラウンドタスクは非同期に実行され、完了時にメインエージェントに通知できます。

## 基本的な使い方

実行中のコマンドやエージェントがある状態で、`Ctrl+B` を押すとバックグラウンドに移動します。

```bash
claude

# 長時間かかるコマンドを実行
> npm run build を実行してください
# ビルドが開始される...

# Ctrl+B を押す
# → ビルドがバックグラウンドに移動
# → プロンプトが再度利用可能になる

# 他の作業を続行
> テストを実行してください
# バックグラウンドでビルドが継続しながら、テストも実行される
```

Tmuxユーザーの場合、Tmuxのプレフィックスキー（Ctrl+B）と重複するため、**Ctrl+Bを2回**押す必要があります。

## 実践例

### 開発サーバーのバックグラウンド実行

開発サーバーを起動しながら、他のコードを編集します。

```bash
> 開発サーバーを起動してください
# サーバーが起動中...
# Ctrl+B を押す

> src/components/Header.tsxを編集してください
# サーバーは裏で実行継続
```

### 複数のビルドタスクの並行実行

```bash
> フロントエンドのビルドを実行
# Ctrl+B でバックグラウンド化

> バックエンドのビルドを実行
# Ctrl+B でバックグラウンド化

> ドキュメントの生成を実行
# 3つのタスクがすべてバックグラウンドで並行実行される
```

### 探索エージェントのバックグラウンド実行

```bash
> Exploreエージェントでコードベース全体を分析してください
# 分析が開始される...
# Ctrl+B を押す

> 並行して、このバグを修正してください
# 分析とバグ修正が同時進行
```

### Dockerコンテナの管理

```bash
> Docker Composeでサービスを起動
# Ctrl+B でバックグラウンド化

> コンテナのログを確認
# Ctrl+B でバックグラウンド化

# 両方のタスクがバックグラウンドで実行
# BashOutputツールで後から結果を確認可能
```

## バックグラウンドタスクの管理

### タスクの確認

```bash
# /tasksコマンドでバックグラウンドタスクを確認
> /tasks

# 実行中のタスク一覧が表示される
```

### タスクの出力確認

Claude CodeはBashOutputツールを使って、バックグラウンドタスクの状態を自動的に確認できます。

```bash
> バックグラウンドのビルドタスクの結果を確認して
# Claude CodeがBashOutputツールで出力を取得
```

### タスクの無効化

バックグラウンドタスク機能をすべて無効にする場合：

```bash
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1
claude
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- **Tmuxユーザー**: Tmuxのプレフィックスキー（Ctrl+B）と重複するため、**Ctrl+Bを2回**押す必要があります
- バックグラウンドタスクは Claude Code 終了時に自動的にクリーンアップされます
- v2.0.64以降、バックグラウンドエージェントとBashコマンドは非同期実行され、メインエージェントにメッセージを送信して起動できます
- バックグラウンドタスクは、メインエージェントに注意が必要なときに通知でき、メインエージェントはポーリング不要になります
- 複数のターミナルタブで別々のClaudeインスタンスを開くのではなく、バックグラウンドエージェントはClaude自身が管理します
  - Claude自身が複数のエージェントを調整し、結果を統合できます
- プロンプトでバックグラウンド実行を指示するか、Ctrl+Bで手動移行するかを選択できます

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [What are Background Agents in Claude Code](https://claudelog.com/faqs/what-are-background-agents/)
- [Background commands - Claude Flow Wiki](https://github.com/ruvnet/claude-flow/wiki/background-commands)
- [The Ultimate Claude Code Cheat Sheet](https://medium.com/@tonimaxx/the-ultimate-claude-code-cheat-sheet-your-complete-command-reference-f9796013ea50)
