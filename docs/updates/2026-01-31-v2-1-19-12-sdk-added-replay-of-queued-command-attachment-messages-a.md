---
title: "[SDK] queued_commandアタッチメントのリプレイイベント対応を追加"
date: 2026-01-23
tags: ['SDK', 'イベント', 'リプレイ']
---

## 原文（日本語に翻訳）

[SDK] `replayUserMessages` が有効な場合、`queued_command` アタッチメントメッセージを `SDKUserMessageReplay` イベントとしてリプレイする機能を追加しました。

## 原文（英語）

[SDK] Added replay of `queued_command` attachment messages as `SDKUserMessageReplay` events when `replayUserMessages` is enabled

## 概要

Claude Code SDK v2.1.19で追加された機能です。セッションのリプレイ機能を使用する際、ユーザーがキューに入れたコマンド（`queued_command` アタッチメント）も `SDKUserMessageReplay` イベントとして再生されるようになりました。これにより、セッション履歴の完全な再現が可能になり、デバッグやセッション分析がより正確に行えます。

## 基本的な使い方

SDK でセッションリプレイ機能を使用する場合、`replayUserMessages` オプションを有効にします。

**SDKの設定例:**

```typescript
import { Agent } from '@anthropic-ai/claude-code-sdk';

const agent = new Agent({
  replayUserMessages: true,  // ユーザーメッセージのリプレイを有効化
});

// セッションを開始
agent.on('SDKUserMessageReplay', (event) => {
  console.log('リプレイイベント:', event);

  if (event.attachment?.type === 'queued_command') {
    console.log('キューされたコマンド:', event.attachment.command);
  }
});
```

## 実践例

### セッション履歴の完全な再生

```typescript
import { Agent, SDKUserMessageReplay } from '@anthropic-ai/claude-code-sdk';

const agent = new Agent({
  replayUserMessages: true,
});

// セッションリプレイのログ収集
const replayLog: SDKUserMessageReplay[] = [];

agent.on('SDKUserMessageReplay', (event) => {
  replayLog.push(event);

  // テキストメッセージの記録
  if (event.text) {
    console.log(`[${event.timestamp}] ユーザー: ${event.text}`);
  }

  // queued_command アタッチメントの記録（v2.1.19で追加）
  if (event.attachment?.type === 'queued_command') {
    console.log(`[${event.timestamp}] コマンド実行: ${event.attachment.command}`);
  }

  // その他のアタッチメント
  if (event.attachment?.type === 'file') {
    console.log(`[${event.timestamp}] ファイル添付: ${event.attachment.path}`);
  }
});

// セッションを再生
await agent.replaySession(sessionId);
```

### デバッグツールの実装

```typescript
class SessionDebugger {
  private agent: Agent;
  private commands: Array<{timestamp: string, command: string}> = [];

  constructor() {
    this.agent = new Agent({
      replayUserMessages: true,
    });

    this.agent.on('SDKUserMessageReplay', this.handleReplay.bind(this));
  }

  private handleReplay(event: SDKUserMessageReplay) {
    // queued_command イベントを追跡
    if (event.attachment?.type === 'queued_command') {
      this.commands.push({
        timestamp: event.timestamp,
        command: event.attachment.command,
      });
    }
  }

  async analyzeSession(sessionId: string) {
    // セッションをリプレイ
    await this.agent.replaySession(sessionId);

    // コマンド実行パターンを分析
    console.log('実行されたコマンド一覧:');
    this.commands.forEach(cmd => {
      console.log(`  ${cmd.timestamp}: ${cmd.command}`);
    });

    return this.commands;
  }
}

// 使用例
const debugger = new SessionDebugger();
await debugger.analyzeSession('session-123');
```

### セッションの自動テスト

```typescript
import { Agent, SDKUserMessageReplay } from '@anthropic-ai/claude-code-sdk';

interface SessionTestCase {
  sessionId: string;
  expectedCommands: string[];
}

async function validateSession(testCase: SessionTestCase): Promise<boolean> {
  const agent = new Agent({
    replayUserMessages: true,
  });

  const executedCommands: string[] = [];

  agent.on('SDKUserMessageReplay', (event) => {
    if (event.attachment?.type === 'queued_command') {
      executedCommands.push(event.attachment.command);
    }
  });

  // セッションをリプレイ
  await agent.replaySession(testCase.sessionId);

  // 期待されるコマンドが実行されたか確認
  const isValid = testCase.expectedCommands.every((expected, index) =>
    executedCommands[index] === expected
  );

  if (!isValid) {
    console.error('コマンド実行の不一致:');
    console.error('期待:', testCase.expectedCommands);
    console.error('実際:', executedCommands);
  }

  return isValid;
}

// テストケースの実行
const testCase: SessionTestCase = {
  sessionId: 'test-session-456',
  expectedCommands: [
    'npm install',
    'npm test',
    'git commit -m "fix"',
  ],
};

const isValid = await validateSession(testCase);
console.log('テスト結果:', isValid ? '成功' : '失敗');
```

### セッション分析ダッシュボード

```typescript
import { Agent } from '@anthropic-ai/claude-code-sdk';

interface SessionStats {
  totalMessages: number;
  totalCommands: number;
  commandTypes: Record<string, number>;
  timeline: Array<{type: string, timestamp: string, data: any}>;
}

class SessionAnalyzer {
  async analyze(sessionId: string): Promise<SessionStats> {
    const agent = new Agent({
      replayUserMessages: true,
    });

    const stats: SessionStats = {
      totalMessages: 0,
      totalCommands: 0,
      commandTypes: {},
      timeline: [],
    };

    agent.on('SDKUserMessageReplay', (event) => {
      stats.totalMessages++;

      // queued_command の統計
      if (event.attachment?.type === 'queued_command') {
        stats.totalCommands++;

        const cmdType = event.attachment.command.split(' ')[0];
        stats.commandTypes[cmdType] = (stats.commandTypes[cmdType] || 0) + 1;

        stats.timeline.push({
          type: 'command',
          timestamp: event.timestamp,
          data: event.attachment.command,
        });
      }

      // テキストメッセージの記録
      if (event.text) {
        stats.timeline.push({
          type: 'message',
          timestamp: event.timestamp,
          data: event.text,
        });
      }
    });

    await agent.replaySession(sessionId);

    return stats;
  }

  displayStats(stats: SessionStats) {
    console.log('=== セッション統計 ===');
    console.log(`総メッセージ数: ${stats.totalMessages}`);
    console.log(`総コマンド数: ${stats.totalCommands}`);
    console.log('\nコマンドタイプ別実行回数:');
    Object.entries(stats.commandTypes).forEach(([type, count]) => {
      console.log(`  ${type}: ${count}回`);
    });
    console.log('\nタイムライン:');
    stats.timeline.forEach(item => {
      console.log(`  [${item.timestamp}] ${item.type}: ${item.data}`);
    });
  }
}

// 使用例
const analyzer = new SessionAnalyzer();
const stats = await analyzer.analyze('session-789');
analyzer.displayStats(stats);
```

### CI/CDでのセッション検証

```typescript
import { Agent } from '@anthropic-ai/claude-code-sdk';

interface CIValidationConfig {
  sessionId: string;
  requiredCommands: string[];
  forbiddenCommands: string[];
}

async function validateCISession(config: CIValidationConfig): Promise<void> {
  const agent = new Agent({
    replayUserMessages: true,
  });

  const executedCommands: string[] = [];

  agent.on('SDKUserMessageReplay', (event) => {
    if (event.attachment?.type === 'queued_command') {
      executedCommands.push(event.attachment.command);
    }
  });

  await agent.replaySession(config.sessionId);

  // 必須コマンドのチェック
  const missingCommands = config.requiredCommands.filter(
    cmd => !executedCommands.includes(cmd)
  );

  if (missingCommands.length > 0) {
    throw new Error(`必須コマンドが実行されていません: ${missingCommands.join(', ')}`);
  }

  // 禁止コマンドのチェック
  const violatingCommands = config.forbiddenCommands.filter(
    cmd => executedCommands.includes(cmd)
  );

  if (violatingCommands.length > 0) {
    throw new Error(`禁止されたコマンドが実行されました: ${violatingCommands.join(', ')}`);
  }

  console.log('セッション検証成功');
}

// CI/CDパイプラインでの使用
const ciConfig: CIValidationConfig = {
  sessionId: process.env.SESSION_ID!,
  requiredCommands: ['npm test', 'npm run build'],
  forbiddenCommands: ['rm -rf /', 'sudo'],
};

await validateCISession(ciConfig);
```

## 注意点

- **SDK専用機能**: この機能はClaude Code SDKを使用する場合のみ有効です
- **replayUserMessages の有効化**: `replayUserMessages: true` を設定しないとリプレイイベントは発生しません
- **v2.1.19以降**: この機能はv2.1.19で追加されたため、それ以前のバージョンでは `queued_command` アタッチメントはリプレイされません
- **イベントハンドラー**: リプレイイベントを受け取るには、適切なイベントハンドラーを登録する必要があります
- **パフォーマンス**: 大量のコマンドを含むセッションをリプレイする場合、処理時間が長くなる可能性があります
- **セキュリティ**: リプレイされるコマンドには機密情報が含まれる可能性があるため、ログ出力時は注意が必要です

## 関連情報

- [Claude Code SDK 公式ドキュメント](https://github.com/anthropics/claude-code-sdk)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
- [セッションリプレイ機能](https://code.claude.com/docs/en/sdk/replay)
