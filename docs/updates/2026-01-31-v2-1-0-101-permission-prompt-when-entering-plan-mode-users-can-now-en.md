---
title: "プランモード移行時のパーミッションプロンプトを削除 - 承認なしで移行可能に"
date: 2026-01-31
tags: ['削除', 'パーミッション', 'プランモード', 'UX']
---

## 原文（日本語に翻訳）

プランモード移行時のパーミッションプロンプトを削除しました - ユーザーは承認なしでプランモードに入れるようになりました

## 原文（英語）

Removed permission prompt when entering plan mode - users can now enter plan mode without approval

## 概要

Claude Code v2.1.0で削除された、プランモード移行時のパーミッション確認です。以前のバージョンでは、Claudeがタスクの計画を立てるためにプランモードに入る際、毎回ユーザーに許可を求めるプロンプトが表示され、ワークフローが中断される問題がありました。この削除により、プランモードへの移行がスムーズになり、タスクの計画立案が即座に開始されるようになりました。

## 削除前の動作

### 毎回確認が必要

```bash
# 複雑なタスクを依頼
claude "Implement user authentication system"

# 削除前:
Claude wants to enter plan mode to design the implementation.

┌─────────────────────────────────┐
│ Enter plan mode?                │
│ > [yes/no]:                     │
└─────────────────────────────────┘

# ユーザーが入力
> yes

# プランモード開始
[Plan Mode] Planning implementation...

# 問題点:
# - 毎回確認が必要
# - ワークフロー中断
# - 承認は実質的に常にyes
```

## 削除後の動作

### スムーズな移行

```bash
# 同じタスク
claude "Implement user authentication system"

# 削除後:
[Plan Mode] Planning implementation...
[Plan Mode] Analyzing requirements...
[Plan Mode] Designing architecture...

# ✓ 即座にプランモード開始
# ✓ 中断なし
# ✓ スムーズなワークフロー
```

## 実践例

### 大規模実装タスク

複雑な機能の実装計画。

```bash
# 複雑な機能
claude "Add real-time notifications with WebSocket"

# 削除後:
[Plan Mode] Analyzing task...
[Plan Mode] Breaking down into steps:
  1. WebSocket server setup
  2. Client connection handling
  3. Notification delivery system
  4. Frontend integration
  5. Testing strategy

[Plan Mode] Plan complete. Proceed? [y/n]

# ✓ プランモード移行が自動
# ✓ 計画立案に集中できる
```

### リファクタリングタスク

コードベース全体の改善。

```bash
# リファクタリング
claude "Refactor authentication module to use modern patterns"

# 削除後:
[Plan Mode] Scanning codebase...
[Plan Mode] Identifying refactoring targets...
[Plan Mode] Planning migration strategy...
[Plan Mode] Estimating impact...

# ✓ 承認待ちなし
# ✓ 計画がスムーズに進行
```

### マルチステップタスク

複数のサブタスクを含む作業。

```bash
# 複数ステップのタスク
claude "Set up CI/CD pipeline with testing and deployment"

# 削除後:
[Plan Mode] Breaking down task...
[Plan Mode] Phase 1: Test configuration
[Plan Mode] Phase 2: Build automation
[Plan Mode] Phase 3: Deployment setup
[Plan Mode] Dependencies identified...

# ✓ 各フェーズの計画が途切れない
```

### 連続タスク

複数のタスクを連続実行。

```bash
# タスク1
claude "Implement feature A"
[Plan Mode] Planning...
[Plan Mode] Plan ready

# タスク2（続けて）
claude "Implement feature B"
[Plan Mode] Planning...
[Plan Mode] Plan ready

# タスク3（続けて）
claude "Implement feature C"
[Plan Mode] Planning...
[Plan Mode] Plan ready

# ✓ 承認プロンプトで邪魔されない
# ✓ リズムよく作業できる
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で削除
- 削除の理由:
  - プランモードは読み取り専用の計画フェーズ
  - 実際のコード変更はプラン承認後
  - 承認プロンプトが冗長だった
  - 99%のユーザーが常に "yes" を選択
- プランモードとは:
  - タスクの実装計画を立てるフェーズ
  - コードベースを分析
  - 実装戦略を設計
  - ファイル変更リストを作成
  - **この段階ではコードは変更されない**
- プラン実行時の承認:
  ```bash
  [Plan Mode] Plan complete:
  • Modify src/auth.ts
  • Create tests/auth.test.ts  • Update package.json

  Execute this plan? [y/n]: _
  # ↑ この承認は引き続き必要
  ```
- プランモードのスキップ:
  ```bash
  # プランモードを使わずに直接実行
  claude --no-plan "Simple task"

  # または設定で無効化
  # ~/.claude/settings.json
  {
    "planMode": {
      "enabled": false
    }
  }
  ```
- プランモードの表示:
  - `[Plan Mode]` プレフィックスで明示
  - 進行状況をリアルタイム表示
  - プラン完成後に承認を求める
- 手動でのプランモード開始:
  ```bash
  # EnterPlanModeツールを明示的に呼び出し
  claude "Plan the implementation of..."

  # または
  > /plan "Design authentication system"
  ```
- プランのキャンセル:
  ```bash
  [Plan Mode] Planning...
  ^C  # Ctrl+C で中断

  ⏸  Plan mode interrupted
  # プランモード終了、通常モードに戻る
  ```
- セキュリティ:
  - プランモード自体は安全（読み取り専用）
  - 実際の変更には別途承認が必要
  - 削除しても安全性は変わらない
- プランの詳細表示:
  ```bash
  [Plan Mode] Plan complete

  # 詳細を表示
  > /plan-details

  ┌─ Implementation Plan ─────────┐
  │ Files to modify: 5            │
  │ Files to create: 3            │
  │ Tests to add: 8               │
  │ Estimated time: 2-3 hours     │
  └───────────────────────────────┘
  ```
- 以前のバージョンとの違い:
  - v2.0.x: プランモード開始時に承認必要
  - v2.1.0: 承認不要、自動的に開始
  - プラン実行時の承認は両方で必要
- 関連する改善:
  - プランモードのパフォーマンス向上
  - プラン表示の改善

## 関連情報

- [Plan mode - Claude Code Docs](https://code.claude.com/docs/en/plan-mode)
- [Permissions](https://code.claude.com/docs/en/permissions)
- [Workflow optimization](https://code.claude.com/docs/en/workflow)
