---
title: "プラグインからpromptとagent hookタイプをサポート"
date: 2026-01-31
tags: ['新機能', 'hooks', 'プラグイン']
---

## 原文（日本語に翻訳）

プラグインから prompt と agent hook タイプのサポートを追加しました（従来は command hooks のみサポート）

## 原文（英語）

Added support for prompt and agent hook types from plugins (previously only command hooks were supported)

## 概要

Claude Code v2.1.0で導入された、プラグインフックの拡張機能です。従来はプラグインから `command` タイプのフック（シェルコマンド実行）のみをエクスポートできましたが、`prompt` タイプ（Claudeへのプロンプト注入）と `agent` タイプ（専用エージェント起動）もサポートされるようになりました。これにより、プラグインがより高度な機能を提供でき、コマンド実行以外の柔軟な処理が可能になります。

## 基本的な使い方

プラグインの `hooks` エクスポートで、異なるタイプのフックを定義します。

```typescript
// プラグインの index.ts
export const hooks = {
  PreToolUse: [
    {
      type: 'command',
      command: 'echo "Command hook"'
    },
    {
      type: 'prompt',
      prompt: 'Remember to follow security best practices.'
    },
    {
      type: 'agent',
      agent: 'security-checker'
    }
  ]
};
```

## 実践例

### プロンプトフックで自動アドバイス

ツール使用前にClaudeにコンテキストやアドバイスを注入します。

```typescript
// security-plugin/index.ts
export const hooks = {
  PreToolUse: [
    {
      type: 'prompt',
      prompt: `
Before executing any Bash commands, verify:
- No hardcoded credentials
- No destructive operations without confirmation
- Proper error handling
`
    }
  ]
};
```

```bash
# プラグインインストール後
claude

> rm -rf /tmp/*
# Claudeは削除前に確認プロンプトを受け取る
# "Are you sure you want to delete all files in /tmp/?"
```

### エージェントフックで専門処理

特定のツール使用時に専門エージェントを自動起動します。

```typescript
// terraform-plugin/index.ts
export const hooks = {
  PreToolUse: [
    {
      type: 'agent',
      agent: 'terraform-validator',
      condition: {
        tool: 'Bash',
        pattern: /terraform (apply|destroy)/
      }
    }
  ]
};
```

```bash
> terraform apply を実行して
# terraform-validator エージェントが自動起動
# プラン内容を検証してから apply 実行
```

### 複数タイプの組み合わせ

1つのプラグインで複数のフックタイプを組み合わせます。

```typescript
// git-workflow-plugin/index.ts
export const hooks = {
  PreToolUse: [
    {
      // コマンドフック: git状態をログ
      type: 'command',
      command: 'git status >> ~/.claude/git-operations.log'
    },
    {
      // プロンプトフック: コミットメッセージ規約を通知
      type: 'prompt',
      prompt: 'Follow conventional commit format: type(scope): description'
    },
    {
      // エージェントフック: コミット前レビュー
      type: 'agent',
      agent: 'commit-reviewer',
      condition: {
        tool: 'Bash',
        pattern: /git commit/
      }
    }
  ]
};
```

### 条件付きプロンプト注入

特定の条件でのみプロンプトを注入します。

```typescript
// database-plugin/index.ts
export const hooks = {
  PreToolUse: [
    {
      type: 'prompt',
      prompt: `
⚠️ Production database detected!
- Use transactions for all modifications
- Create backups before schema changes
- Test queries on staging first
`,
      condition: {
        env: {
          DATABASE_URL: /production/
        }
      }
    }
  ]
};
```

### ポストツールフックでの通知

ツール実行後にエージェントで結果を分析します。

```typescript
// monitoring-plugin/index.ts
export const hooks = {
  PostToolUse: [
    {
      type: 'agent',
      agent: 'performance-monitor',
      condition: {
        tool: 'Bash',
        pattern: /npm (test|build)/
      }
    },
    {
      type: 'prompt',
      prompt: 'Consider optimizing if build time exceeds 60 seconds.'
    }
  ]
};
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- サポートされるフックタイプ:
  1. **command**: シェルコマンド実行（従来からサポート）
     ```typescript
     { type: 'command', command: 'echo "Hello"' }
     ```
  2. **prompt**: Claudeへのプロンプト注入（新機能）
     ```typescript
     { type: 'prompt', prompt: 'Remember to...' }
     ```
  3. **agent**: エージェント起動（新機能）
     ```typescript
     { type: 'agent', agent: 'agent-name' }
     ```
- プロンプトフックの動作:
  - ツール実行前（PreToolUse）または後（PostToolUse）にClaudeにテキストを注入
  - Claudeはこのプロンプトを次の応答で考慮
  - ユーザーには表示されない（Claudeの内部コンテキストのみ）
- エージェントフックの動作:
  - 指定されたエージェントを自動的に起動
  - エージェントが完了するまで、メインフローは待機
  - エージェントの出力はClaudeのコンテキストに追加される
- 条件付き実行:
  - `condition` フィールドで実行条件を指定可能
  - サポートされる条件:
    - `tool`: 特定のツール名（例: `"Bash"`, `"Write"`）
    - `pattern`: 正規表現パターン（ツール入力にマッチ）
    - `env`: 環境変数のパターンマッチ
- 実行順序:
  1. Command hooks
  2. Prompt hooks
  3. Agent hooks
  4. （ツール実行）
  5. PostToolUse hooks（同じ順序）
- パフォーマンスへの影響:
  - プロンプトフック: 軽量（テキスト注入のみ）
  - エージェントフック: 重い（エージェント起動とAPI呼び出し）
  - 頻繁に実行されるフックは条件付きにすることを推奨
- プラグイン開発:
  - TypeScript/JavaScriptでプラグインを作成
  - `hooks` オブジェクトをエクスポート
  - 各フックタイプに適切な型定義を使用
- デバッグ:
  - `--debug` フラグでフック実行のログを確認
  - プロンプトフックの内容は通常のログには表示されない

## 関連情報

- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Plugin development](https://code.claude.com/docs/en/plugins)
- [Creating custom agents](https://code.claude.com/docs/en/custom-agents)
