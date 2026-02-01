---
title: "Windows: 子プロセス起動時のコンソールウィンドウのフラッシュを修正"
date: 2025-01-27
tags: [bugfix, windows, ui]
---

## 原文（日本語訳）

Windows: 子プロセスを起動する際にコンソールウィンドウが一瞬表示される問題を修正

## 原文（英語）

Windows: Fixed console windows flashing when spawning child processes

## 概要

Windows版のClaude Codeで、Bashコマンドの実行やサブエージェントの起動時にコンソールウィンドウが一瞬表示されてちらつく問題が修正されました。これにより、よりスムーズで視覚的に快適なユーザー体験が得られます。

## 基本的な使い方

修正後は、特別な設定なしに快適に使用できます。

```bash
# Windows上でClaude Codeを起動
claude

# コマンド実行時にウィンドウがフラッシュしなくなった
> "Run npm test"
> "Build the project"
```

## 実践例

### バックグラウンドタスクの実行

長時間実行されるタスクをバックグラウンドで実行する際、ウィンドウのフラッシュがなくなります。

```bash
# Claude Code内で
> "Start development server in background"
# Ctrl+B でバックグラウンド化

# 子プロセスが起動されるが、コンソールが一瞬表示されることはない
```

### 複数コマンドの連続実行

複数のコマンドを連続実行する場合も、スムーズに動作します。

```bash
> "Run npm install && npm run build && npm test"

# 各コマンドで子プロセスが起動されるが、
# ウィンドウのフラッシュが発生しない
```

### サブエージェントの起動

Taskツールを使用してサブエージェントを起動する際も快適です。

```bash
> "Use the Explore agent to search the codebase for authentication logic"

# サブエージェントが子プロセスとして起動されるが、
# コンソールウィンドウが表示されない
```

### Git操作の実行

Gitコマンドなど、頻繁に子プロセスを起動する操作でも視覚的なノイズがありません。

```bash
> "Check git status, stage all changes, and commit"

# git add, git commit などの各コマンドで
# ウィンドウがフラッシュすることはない
```

## 注意点

- この修正はWindows版のClaude Codeにのみ適用されます
- PowerShellやコマンドプロンプトを直接起動する場合は対象外です
- 一部のサードパーティツールが独自にコンソールを表示する場合があります
- Windows Terminalなど、モダンなターミナルエミュレータの使用を推奨します

## 関連情報

- [Windows版Claude Code インストールガイド](https://code.claude.com/docs/en/getting-started#windows)
- [Bashツールの使い方](https://code.claude.com/docs/en/tools#bash)
- [バックグラウンドタスク管理](https://code.claude.com/docs/en/background-tasks)
- [サブエージェント](https://code.claude.com/docs/en/agents)
