---
title: "/contextコマンドのトークン表示の一貫性改善"
date: 2026-01-20
tags: ['バグ修正', 'コマンド', 'context', 'トークン管理']
---

## 原文（日本語に翻訳）

`/context` コマンドがverboseモードでステータスラインと同じトークン数とパーセンテージを表示するように修正

## 原文（英語）

Fixed `/context` command to show the same token count and percentage as the status line in verbose mode

## 概要

Claude Codeの `/context` コマンドにおいて、詳細表示モード（verbose mode）で表示されるトークン数とパーセンテージが、ステータスラインの表示と一致しない問題を修正しました。この修正により、コンテキスト情報の表示が統一され、トークン使用状況をより正確に把握できるようになりました。大規模なプロジェクトでコンテキスト管理を行う際の信頼性が向上しています。

## 基本的な使い方

`/context` コマンドを実行すると、現在のコンテキストに含まれるファイルやトークン使用状況が表示されます。

```
/context
```

verboseモードを有効にしている場合、より詳細な情報が表示されます。

```
# 設定でverboseモードを有効化
/config

# コンテキスト情報を確認
/context
```

## 実践例

### トークン使用状況の確認

現在の会話で使用しているトークン数を正確に把握します。

```
/context

# 表示例（修正後）:
Context Usage: 45,230 tokens (58.4%)
├─ System: 2,150 tokens (2.8%)
├─ Conversation: 28,560 tokens (36.9%)
└─ Files: 14,520 tokens (18.7%)

Files in context:
- src/main.py (3,450 tokens)
- src/utils.py (2,120 tokens)
- config/settings.json (890 tokens)
...

# ステータスラインの表示: 58.4% (45,230 / 77,500)
# → 数値が一致している
```

以前: `/context` の表示とステータスラインの数値が異なる場合があった
修正後: 常に一貫した数値が表示される

### コンテキスト最適化の判断

トークン制限に近づいている場合の対処。

```
/context

# 表示例:
Context Usage: 72,890 tokens (94.1%)  ⚠️ High usage

# ステータスライン: 94.1% (72,890 / 77,500)
# → 両方で同じ警告レベルを確認できる

# 対処方法:
1. 不要なファイルを削除
2. 古いメッセージを圧縮（/compact）
3. 新しいセッションを開始
```

### 大規模プロジェクトでのコンテキスト管理

複数ファイルを参照している場合のトークン配分確認。

```
# 複数のファイルを参照
@src/backend/api/users.py
@src/backend/models/user.py
@src/frontend/components/UserProfile.tsx
@tests/test_users.py

# コンテキスト確認
/context

# 表示例:
Context Usage: 38,450 tokens (49.6%)
├─ System: 2,150 tokens (2.8%)
├─ Conversation: 15,200 tokens (19.6%)
└─ Files: 21,100 tokens (27.2%)
    ├─ src/backend/api/users.py: 6,500 tokens
    ├─ src/backend/models/user.py: 4,200 tokens
    ├─ src/frontend/components/UserProfile.tsx: 7,800 tokens
    └─ tests/test_users.py: 2,600 tokens

# 各ファイルのトークン数を見て、必要なものだけを保持
```

### 長時間の会話でのトークン監視

セッションが長くなってきた際の状況確認。

```
# 2時間のコーディングセッション後
/context

# 表示例:
Context Usage: 68,920 tokens (88.9%)
├─ System: 2,150 tokens (2.8%)
├─ Conversation: 52,340 tokens (67.5%)  ⚠️ 会話が多い
└─ Files: 14,430 tokens (18.6%)

# ステータスライン: 88.9% (68,920 / 77,500)

# 推奨アクション:
/compact  # 会話履歴を圧縮してトークンを削減
```

## 注意点

- この修正は Claude Code v2.1.14 で適用されました
- トークン数は使用しているモデル（Sonnet、Haiku、Opus）によって計算方法が異なる場合があります
- ステータスラインとコマンド出力の両方で一貫した表示が保証されるようになりました
- verboseモードは設定で有効化できます（デフォルトではオフ）
- トークン使用率が80%を超えた場合は、コンテキストの整理を検討してください
- `/compact` コマンドを使用すると、会話履歴を圧縮してトークンを削減できます
- 大規模なファイルを参照する場合は、必要な部分だけを抽出して参照することを推奨します

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
- [コンテキスト管理のベストプラクティス](https://code.claude.com/docs/context-management)
- [トークン制限について](https://code.claude.com/docs/token-limits)
- [/compactコマンドの使い方](https://code.claude.com/docs/commands/compact)
