---
title: "コンテキスト視覚化でスキルを独立したカテゴリとして表示"
date: 2026-01-31
tags: ['改善', 'UX', 'スキル']
---

## 原文（日本語に翻訳）

コンテキスト視覚化にスキルを独立したカテゴリとして追加しました

## 原文（英語）

Added Skills as a separate category in the context visualization

## 概要

Claude Code v2.1.0で導入された、コンテキスト管理の可視化改善です。`Ctrl+O`でトランスクリプトモードを開き、`[Context]`タブを表示すると、従来はツールやファイルと混在していたスキルが、独立した「Skills」カテゴリとして整理されて表示されるようになりました。これにより、どのスキルが現在のセッションで使用可能か、どのスキルがすでにロードされているかが一目で分かり、コンテキストウィンドウの使用状況を把握しやすくなります。

## 基本的な使い方

`Ctrl+O` → `[Context]` タブでスキルカテゴリを確認します。

```bash
claude

# スキルを呼び出す
> /commit

# Ctrl+O を押す
# → キー（右矢印）で [Context] タブに移動

# コンテキスト視覚化が表示される:

Context (85K / 200K tokens)
┌─────────────────────────────
│ Skills (12K tokens)
│   - commit (8K)
│   - review-pr (4K)
│
│ Tools (5K tokens)
│   - Read
│   - Write
│   - Bash
│
│ Files (45K tokens)
│   - src/main.js (20K)
│   - package.json (5K)
│   - ...
│
│ Messages (23K tokens)
│   - User: "このファイルを..."
│   - Assistant: "承知しました..."
└─────────────────────────────
```

## 実践例

### スキル使用状況の確認

どのスキルがロードされているか確認します。

```bash
# 複数のスキルを使用
> /commit
> /review-pr
> /deploy

# Ctrl+O → [Context] タブ

# Skills カテゴリに表示される:
Skills (35K / 200K tokens)
  - commit (8K)
  - review-pr (12K)
  - deploy (15K)

# 各スキルのトークン消費量が確認できる
```

### コンテキストウィンドウの最適化

トークン消費が大きいスキルを特定します。

```bash
# 大量のスキルを定義しているプロジェクト
> /feature-dev

# Ctrl+O → [Context] タブ

Skills (95K / 200K tokens) ⚠️ High usage
  - feature-dev:code-architect (40K)
  - feature-dev:code-explorer (30K)
  - feature-dev:code-reviewer (25K)

# feature-dev が多くのトークンを消費していることが分かる
# 必要に応じてスキルを最適化
```

### スキルのロード状態確認

スキルが正しくロードされているか確認します。

```bash
# カスタムスキルを作成後
cat > ~/.claude/skills/my-skill.md <<'EOF'
---
name: my-skill
description: カスタムスキル
---
# Custom skill
...
EOF

# Claude Code起動
claude

# スキルを呼び出す
> /my-skill

# Ctrl+O → [Context] タブ

Skills (8K tokens)
  - my-skill (8K) ✓ Loaded

# ロード成功を確認
```

### トークン制限への対処

コンテキストウィンドウが満杯に近い場合の対処を検討します。

```bash
# 大規模なセッション
> /plan
> /commit
> /test

# Ctrl+O → [Context] タブ

Context (180K / 200K tokens) ⚠️ 90% full
  Skills (60K)
    - plan (25K)
    - commit (20K)
    - test (15K)
  Files (80K)
  Messages (40K)

# スキルが60Kトークン消費
# 不要なスキルをアンロードするか、セッションを再起動
```

## 注意点

- この機能は Claude Code v2.1.0（2026年1月7日リリース）で導入されました
- コンテキスト視覚化の開き方:
  - `Ctrl+O`: トランスクリプトモード
  - `→` キー: [Context] タブに移動
- Skillsカテゴリの内容:
  - ロード済みのスキル一覧
  - 各スキルのトークン消費量
  - スキルの状態（Loaded, Loading, Error）
- 他のカテゴリ:
  - **Tools**: 利用可能なツール
  - **Files**: 読み込まれたファイル
  - **Messages**: 会話履歴
  - **Agents**: 実行中/完了したエージェント
  - **MCP**: MCPサーバーから提供されるリソース
- トークン消費の計算:
  - スキルのfrontmatterとプロンプト本文の合計
  - 大きなスキル（10K超）は分割を検討
- スキルのアンロード:
  - 明示的なアンロード機能はない
  - 新しいセッション開始で自動的にクリア
  - 長時間セッションでは `/clear` コマンドで会話履歴をクリア（スキルは保持）
- ホットリロードとの関係:
  - スキルファイルを編集すると自動的にリロード
  - コンテキスト視覚化で更新を確認可能
- エラー表示:
  - スキルのロードに失敗した場合、Errorステータスが表示される
  - エラーの詳細はログで確認
- パフォーマンスへの影響:
  - コンテキスト視覚化の表示自体は軽量
  - トークン計算はリアルタイムで行われる
- ベストプラクティス:
  - 大規模なスキルは分割して小さく保つ
  - 不要なスキルはプロジェクトから削除
  - グローバルスキル（`~/.claude/skills`）とプロジェクトスキル（`.claude/skills`）を分ける
- トークン制限への対処:
  - 200K制限に近づいたら、不要なスキルやファイルを削除
  - 新しいセッションを開始してコンテキストをリセット

## 関連情報

- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [Creating skills](https://code.claude.com/docs/en/skills)
- [Context management](https://code.claude.com/docs/en/context-management)
