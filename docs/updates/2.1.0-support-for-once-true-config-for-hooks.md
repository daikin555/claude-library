---
title: "hooksに `once: true` 設定を追加 - 初回のみ実行するフックが定義可能に"
date: 2026-01-31
tags: ['新機能', 'hooks', '設定']
---

## 原文（日本語に翻訳）

hooksに `once: true` 設定のサポートを追加しました

## 原文（英語）

Added support for `once: true` config for hooks

## 概要

Claude Code v2.1.0で導入された、フックの実行回数を制御する設定オプションです。`once: true` を設定したフックは、セッション中に最初の1回のみ実行され、2回目以降は自動的にスキップされます。セッション開始時の初期化処理、ワンタイムの環境チェック、初回のみ必要な通知など、重複実行を避けたい処理に最適です。これにより、パフォーマンスへの影響を最小限に抑えつつ、必要な初期化を確実に実行できます。

## 基本的な使い方

hooks設定で `once: true` を指定します。

```json
// ~/.claude/settings.json または .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "echo 'Session initialized' >> /tmp/claude-session.log"
      }
    ]
  }
}
```

## 実践例

### セッション開始時の環境チェック

最初のツール使用時のみ、環境の健全性をチェックします。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "bash -c 'git --version && node --version && echo Environment check passed'"
      }
    ]
  }
}
```

```bash
claude

> ファイルを読んで
# 初回実行時:
# git version 2.39.0
# v18.16.0
# Environment check passed
# (ファイル読み取り実行)

> 別のファイルも読んで
# 2回目以降: 環境チェックはスキップ
# (ファイル読み取りのみ実行)
```

### セッション開始通知

セッション開始時に1回だけ通知を送信します。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "osascript -e 'display notification \"Claude Code session started\" with title \"Claude Code\"'"
      }
    ]
  }
}
```

### プロジェクト情報の初回表示

セッション開始時に、プロジェクトのブランチ情報を1回だけ表示します。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "bash -c 'echo \"Current branch: $(git branch --show-current)\" && echo \"Last commit: $(git log -1 --oneline)\"'"
      }
    ]
  }
}
```

```
# セッション開始時（初回ツール使用時）:
Current branch: feature/new-api
Last commit: abc1234 Add new endpoint

# 2回目以降のツール使用: 表示なし
```

### 初回のみGit状態をキャプチャ

セッション開始時のGit状態を記録します。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "git status > /tmp/claude-session-git-status.txt && echo 'Initial git status captured'"
      }
    ],
    "Stop": [
      {
        "command": "rm -f /tmp/claude-session-git-status.txt"
      }
    ]
  }
}
```

### 依存関係の初回チェック

セッション開始時に、必要な依存関係がインストールされているか確認します。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "bash -c 'if [ ! -d node_modules ]; then echo \"⚠️ Warning: node_modules not found. Run npm install.\"; fi'"
      }
    ]
  }
}
```

### 初回限定の設定読み込み

プロジェクト固有の設定を初回のみ読み込みます。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "once": true,
        "command": "bash -c 'if [ -f .claude/project-config.sh ]; then source .claude/project-config.sh; echo \"Project config loaded\"; fi'"
      }
    ]
  }
}
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- `once: true` の動作:
  - セッション（Claude Code起動から終了まで）中に1回のみ実行
  - 2回目以降のトリガーでは完全にスキップされる（実行時間ゼロ）
  - Claude Codeを再起動すると、カウンターがリセットされる
- 適用可能なフックタイプ:
  - `PreToolUse`
  - `PostToolUse`
  - `Stop`（ただしStopは元々1回のみ実行されるので、`once: true` は不要）
- フック設定の形式:
  ```json
  {
    "hooks": {
      "PreToolUse": [
        {
          "once": true,
          "command": "your-command-here"
        },
        {
          "command": "this-runs-every-time"
        }
      ]
    }
  }
  ```
- 複数のフックがある場合:
  - `once: true` のフックと通常のフックを混在させることが可能
  - 実行順序は定義順
  - `once: true` フックがスキップされても、他のフックは実行される
- 初回実行のタイミング:
  - PreToolUse: 最初のツール使用時
  - PostToolUse: 最初のツール完了時
- パフォーマンスへの影響:
  - 重い初期化処理を `once: true` にすることで、2回目以降のオーバーヘッドを削減
  - 環境チェックや依存関係チェックに最適
- 状態の保持:
  - `once` フラグの状態はメモリ内に保持（ファイルには保存されない）
  - セッションをまたいで状態を保持したい場合、フック内でファイルマーカーを使用:
    ```bash
    if [ ! -f /tmp/initialized ]; then
      # 初期化処理
      touch /tmp/initialized
    fi
    ```
- デバッグ:
  - フックが実行されたかどうかは、ログファイルへの書き込みで確認可能
  - `--debug` フラグでフックの実行状況を確認

## 関連情報

- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Settings configuration](https://code.claude.com/docs/en/settings)
- [Hook examples](https://code.claude.com/docs/en/hook-examples)
