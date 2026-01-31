---
title: "[SDK] Zodの最小バージョン要件を4.0.0以上に変更"
date: 2026-01-09
tags: ['SDK', '開発者向け', '依存関係', 'Zod']
---

## 原文（日本語に翻訳）

[SDK] Zodのピア依存関係の最小バージョンを ^4.0.0 に変更しました。

## 原文（英語）

[SDK] Changed minimum zod peer dependency to ^4.0.0

## 概要

Claude Code SDKを使用したプラグイン開発やカスタムツール開発において、バリデーションライブラリZodの最小必須バージョンが3.x系から4.0.0以上に引き上げられました。これにより、Zod 4.xの新機能とパフォーマンス改善を活用できるようになります。

## 基本的な使い方

プラグインやカスタムツールを開発する際、package.jsonでZod 4.0.0以上を指定する必要があります。

### package.json の更新

```json
{
  "name": "my-claude-plugin",
  "version": "1.0.0",
  "peerDependencies": {
    "@anthropic/claude-code-sdk": "^2.1.2",
    "zod": "^4.0.0"
  },
  "devDependencies": {
    "@anthropic/claude-code-sdk": "^2.1.2",
    "zod": "^4.0.0",
    "typescript": "^5.0.0"
  }
}
```

### 既存プロジェクトの更新

```bash
# Zodを最新版（4.x）にアップグレード
npm install zod@^4.0.0

# または
yarn add zod@^4.0.0

# または
pnpm add zod@^4.0.0
```

## 実践例

### プラグイン開発での使用

```typescript
// プラグインのスキーマ定義
import { z } from 'zod';
import { definePlugin } from '@anthropic/claude-code-sdk';

// Zod 4.0の新機能を活用
const ConfigSchema = z.object({
  apiKey: z.string().min(1),
  endpoint: z.string().url(),
  timeout: z.number().int().positive().default(5000),
  // Zod 4.0の改善された型推論
  options: z.object({
    retries: z.number().int().nonnegative(),
    verbose: z.boolean()
  }).optional()
});

type Config = z.infer<typeof ConfigSchema>;

export default definePlugin({
  name: 'my-api-plugin',
  configSchema: ConfigSchema,
  async initialize(config: Config) {
    // 設定が自動的にバリデーションされる
    console.log('API endpoint:', config.endpoint);
  }
});
```

### MCPサーバー開発での使用

```typescript
import { z } from 'zod';
import { createMCPServer } from '@anthropic/claude-code-sdk';

// ツールの入力スキーマ
const SearchInputSchema = z.object({
  query: z.string().min(1).max(500),
  limit: z.number().int().min(1).max(100).default(10),
  filters: z.array(z.string()).optional(),
  // Zod 4.0の強化された配列処理
  sortBy: z.enum(['relevance', 'date', 'popularity']).default('relevance')
});

const server = createMCPServer({
  name: 'search-server',
  tools: {
    search: {
      description: 'Search for content',
      inputSchema: SearchInputSchema,
      async execute(input) {
        // inputは自動的にバリデート済み
        const results = await performSearch(input);
        return results;
      }
    }
  }
});
```

### カスタムツールの型安全性向上

```typescript
import { z } from 'zod';

// Zod 4.0の改善された型推論により、
// より正確な型が自動生成される

const UserSchema = z.object({
  id: z.number(),
  name: z.string(),
  email: z.string().email(),
  role: z.enum(['admin', 'user', 'guest']),
  metadata: z.record(z.unknown()).optional()
});

// 型推論が以前より正確
type User = z.infer<typeof UserSchema>;

function processUser(data: unknown): User {
  // Zod 4.0の高速なパース処理
  return UserSchema.parse(data);
}
```

### 移行時の互換性チェック

```typescript
// 既存のZod 3.xコードからの移行

// Zod 3.x（動作しない）
// const schema = z.string().nonempty();

// Zod 4.0（推奨）
const schema = z.string().min(1);

// バージョンチェック
import { z } from 'zod';
console.log('Zod version:', z.version);
// 出力: Zod version: 4.x.x
```

## 注意点

- **破壊的変更**: Zod 3.xから4.0への移行時、一部のAPIが変更されています
- **マイグレーションガイド**: Zodの公式マイグレーションガイドを参照してください
- **パフォーマンス改善**: Zod 4.0はパース処理が高速化されています
- **型推論の改善**: より正確な型推論により、TypeScriptの開発体験が向上します
- **既存プラグイン**: 既存のプラグインはZod 4.0に更新する必要があります

### 主な変更点

```typescript
// Zod 3.x → 4.0 の主な変更

// 1. .nonempty() が非推奨
// Before (3.x):
z.string().nonempty()
// After (4.0):
z.string().min(1)

// 2. エラーメッセージのカスタマイズ構文変更
// Before (3.x):
z.string().min(5, { message: "Too short" })
// After (4.0): 同じ構文だが、内部実装が改善

// 3. パフォーマンスの向上
// 複雑なスキーマでも高速にバリデーション可能
```

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [Claude Code SDK ドキュメント](https://code.claude.com/docs/sdk)
- [Zod 公式サイト](https://zod.dev/)
- [Zod v4 マイグレーションガイド](https://zod.dev/migration)
