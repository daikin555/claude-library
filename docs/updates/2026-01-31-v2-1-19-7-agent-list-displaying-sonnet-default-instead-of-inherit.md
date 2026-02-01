---
title: 'エージェントリストでモデル設定がない場合の表示を「Inherit (default)」に修正'
date: 2026-01-23
tags: ['バグ修正', 'エージェント', 'UI']
---

## 原文（日本語に翻訳）

明示的なモデル設定がないエージェントに対して、エージェントリストで「Sonnet (default)」ではなく「Inherit (default)」と表示されるように修正しました。

## 原文（英語）

Fixed agent list displaying "Sonnet (default)" instead of "Inherit (default)" for agents without an explicit model setting

## 概要

Claude Code v2.1.19で修正されたUI表示の問題です。カスタムエージェントで明示的にモデルを指定していない場合、エージェントリストでは「Sonnet (default)」と誤った表示がされていましたが、正しく「Inherit (default)」と表示されるようになりました。これにより、エージェントがグローバル設定からモデルを継承していることが一目で分かるようになります。

## 基本的な使い方

エージェントリストは `claude agent list` コマンドで確認できます。

**修正前の表示:**

```bash
$ claude agent list

Available agents:
  Explore - Sonnet (default)  # ← 誤った表示
  Review - Opus 4
  Default - Sonnet (default)  # ← 誤った表示
```

**修正後の表示:**

```bash
$ claude agent list

Available agents:
  Explore - Inherit (default)  # ← 正しい表示
  Review - Opus 4
  Default - Inherit (default)  # ← 正しい表示
```

## 実践例

### カスタムエージェントの作成と確認

モデルを明示的に指定しないエージェントを作成した場合:

```yaml
# .claude/agents/my-agent/AGENT.md
---
name: MyAgent
description: カスタムエージェント
# model: 指定なし（グローバル設定を継承）
---

特定のタスクを実行するカスタムエージェントです。
```

エージェントリストで確認:

```bash
$ claude agent list

Available agents:
  MyAgent - Inherit (default)  # グローバル設定を継承することが明確
  Default - Inherit (default)
```

### グローバルモデル設定との関係

グローバル設定でデフォルトモデルを変更した場合:

```bash
# グローバル設定で Opus 4.5 を設定
$ claude config set model opus-4-5

# エージェントリストを確認
$ claude agent list

Available agents:
  MyAgent - Inherit (default)  # ← "Inherit" と表示されるので、
                                # 実際は Opus 4.5 が使用されることが分かる
  ReviewAgent - Sonnet 4       # ← 明示的に Sonnet 4 を指定
```

### 明示的なモデル設定との違い

```yaml
# エージェントA: モデル指定なし
---
name: AgentA
description: モデル継承エージェント
---

# エージェントB: モデル明示指定
---
name: AgentB
description: Sonnet固定エージェント
model: sonnet-4
---
```

リスト表示:

```bash
$ claude agent list

Available agents:
  AgentA - Inherit (default)   # グローバル設定に従う
  AgentB - Sonnet 4            # 常に Sonnet 4 を使用
```

### エージェント選択時の挙動

```bash
# グローバル設定が Opus 4.5 の場合

# AgentA を使用 → Opus 4.5 が使用される
$ claude -a AgentA "タスクを実行"

# AgentB を使用 → Sonnet 4 が使用される（設定を上書き）
$ claude -a AgentB "タスクを実行"
```

### 複数エージェントの管理

異なるモデル設定を持つエージェント群:

```bash
$ claude agent list

Available agents:
  QuickTask - Inherit (default)      # 高速タスク用（グローバル設定）
  DeepAnalysis - Opus 4.5            # 深い分析用（明示指定）
  CodeReview - Sonnet 4              # コードレビュー用（明示指定）
  General - Inherit (default)        # 汎用タスク（グローバル設定）
```

この表示により、どのエージェントが柔軟（Inherit）で、どれが固定（明示指定）かが明確になります。

## 注意点

- **「Inherit」の意味**: グローバル設定（`claude config get model`）からモデルを継承することを示します
- **実際の使用モデル**: 「Inherit (default)」と表示されていても、グローバル設定によっては Sonnet 以外のモデルが使用される可能性があります
- **モデル変更の影響範囲**: グローバル設定を変更すると、「Inherit」を使用しているすべてのエージェントに影響します
- **明示指定の利点**: 特定のタスクに最適なモデルを固定したい場合は、エージェント定義で明示的に指定してください
- **下位互換性**: この修正は表示のみの変更で、エージェントの動作には影響しません

## 関連情報

- [Claude Code 公式ドキュメント - Agents](https://code.claude.com/docs/en/agents)
- [Claude Code 公式ドキュメント - Configuration](https://code.claude.com/docs/en/configuration)
- [Changelog v2.1.19](https://github.com/anthropics/claude-code/releases/tag/v2.1.19)
- [モデル選択ガイド](https://www.anthropic.com/models)
