---
title: "SessionStartフックでエージェントタイプを取得可能に"
date: 2026-01-09
tags: ['新機能', 'hooks', 'API', 'エージェント']
---

## 原文（日本語に翻訳）

SessionStartフックの入力パラメータに `agent_type` を追加しました。`--agent` フラグが指定された場合に値が設定されます。

## 原文（英語）

Added `agent_type` to SessionStart hook input, populated if `--agent` is specified

## 概要

Claude Codeのフック機能において、SessionStartフックの入力パラメータに `agent_type` フィールドが追加されました。これにより、起動時に `--agent` フラグで指定されたエージェントタイプをフック内で参照できるようになり、エージェントの種類に応じた初期化処理やカスタマイズが可能になります。

## 基本的な使い方

SessionStartフックを実装するスクリプトで、`agent_type` パラメータにアクセスできます。

### フックスクリプトの例

```javascript
// hooks/sessionStart.js
export default async function sessionStart(input) {
  const { agent_type, cwd, session_id } = input;

  console.log('Session started');
  console.log('Agent type:', agent_type || 'default');
  console.log('Working directory:', cwd);
  console.log('Session ID:', session_id);

  // agent_typeに応じた処理
  if (agent_type === 'code-review') {
    // コードレビュー用の初期設定
    console.log('Code review mode activated');
  } else if (agent_type === 'test-generator') {
    // テスト生成用の初期設定
    console.log('Test generator mode activated');
  }

  return { status: 'ok' };
}
```

### コマンドライン実行例

```bash
# エージェントタイプを指定して起動
claude --agent code-review

# フック内で agent_type = "code-review" として取得可能
```

## 実践例

### エージェント別のログ設定

```javascript
// hooks/sessionStart.js
export default async function sessionStart({ agent_type, cwd }) {
  const logConfig = {
    'code-review': {
      level: 'verbose',
      file: 'logs/review.log'
    },
    'test-generator': {
      level: 'debug',
      file: 'logs/test-gen.log'
    },
    'default': {
      level: 'info',
      file: 'logs/default.log'
    }
  };

  const config = logConfig[agent_type] || logConfig.default;

  // ログ設定を適用
  console.log(`Setting up logging for ${agent_type || 'default'} agent`);
  console.log(`Log level: ${config.level}`);
  console.log(`Log file: ${config.file}`);

  return { status: 'ok' };
}
```

### 環境変数の動的設定

```javascript
// hooks/sessionStart.js
import { writeFileSync } from 'fs';
import { join } from 'path';

export default async function sessionStart({ agent_type, cwd }) {
  // エージェントタイプに応じた環境設定
  const envSettings = {
    'data-analyst': {
      CLAUDE_MAX_TOKENS: '8000',
      CLAUDE_TEMPERATURE: '0.3'
    },
    'creative-writer': {
      CLAUDE_MAX_TOKENS: '4000',
      CLAUDE_TEMPERATURE: '0.8'
    }
  };

  const settings = envSettings[agent_type];
  if (settings) {
    Object.entries(settings).forEach(([key, value]) => {
      process.env[key] = value;
      console.log(`Set ${key}=${value} for ${agent_type} agent`);
    });
  }

  return { status: 'ok' };
}
```

### プロジェクト設定の自動ロード

```javascript
// hooks/sessionStart.js
import { readFileSync } from 'fs';
import { join } from 'path';

export default async function sessionStart({ agent_type, cwd }) {
  if (!agent_type) {
    // デフォルトエージェントの場合は何もしない
    return { status: 'ok' };
  }

  // エージェント専用の設定ファイルを読み込み
  const configPath = join(cwd, `.claude-${agent_type}.json`);

  try {
    const config = JSON.parse(readFileSync(configPath, 'utf-8'));
    console.log(`Loaded configuration for ${agent_type} agent`);
    console.log('Config:', config);

    // 設定を適用（例：プロンプトテンプレートの設定など）
    // applyConfig(config);

  } catch (error) {
    console.log(`No specific config found for ${agent_type} agent`);
  }

  return { status: 'ok' };
}
```

### 分析データの記録

```javascript
// hooks/sessionStart.js
import { appendFileSync } from 'fs';

export default async function sessionStart({ agent_type, cwd, session_id }) {
  // セッション開始を記録
  const record = {
    timestamp: new Date().toISOString(),
    session_id,
    agent_type: agent_type || 'default',
    cwd
  };

  appendFileSync(
    'session-analytics.jsonl',
    JSON.stringify(record) + '\n'
  );

  console.log(`Session analytics recorded for ${agent_type || 'default'} agent`);

  return { status: 'ok' };
}
```

## 注意点

- **オプショナルフィールド**: `agent_type` は `--agent` フラグが指定された場合のみ値が設定されます。指定されない場合は `undefined` です
- **後方互換性**: 既存のSessionStartフックは引き続き動作します。`agent_type` を使用しない場合は無視されます
- **検証**: フック内で `agent_type` を使用する場合、値の存在確認を行うことを推奨します
- **エラーハンドリング**: 予期しない `agent_type` 値が渡される可能性を考慮し、デフォルト処理を実装してください

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [Claude Code Hooks ドキュメント](https://code.claude.com/docs/hooks)
