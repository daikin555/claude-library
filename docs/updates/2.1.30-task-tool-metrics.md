---
title: "Taskツールのメトリクス表示 - トークン数、ツール使用回数、実行時間"
date: 2026-02-03
tags: [task, metrics, performance, monitoring]
---

## 原文（日本語）
Taskツールの結果にトークン数、ツール使用回数、実行時間のメトリクスを追加しました。

## 原文（英語）
Added token count, tool uses, and duration metrics to Task tool results.

## 概要
Taskツールを使用してサブエージェントを実行した際に、パフォーマンスメトリクスが自動的に表示されるようになりました。トークン消費量、ツールの使用回数、実行時間を確認できるため、タスクの効率性を評価し、最適化の判断材料として活用できます。

## 基本的な使い方

Taskツールを通常通り実行すると、結果に自動的にメトリクスが含まれます。

```
Claudeに探索タスクを依頼
```

実行結果の例：
```
Task completed successfully

Metrics:
- Token count: 1,234 tokens
- Tool uses: 5 calls (Glob: 2, Read: 2, Grep: 1)
- Duration: 12.3 seconds
```

## 実践例

### コードベースの探索効率を測定
大規模なコードベースで特定の機能を探す際のコスト把握：

```
「認証機能の実装場所を探してください」
```

メトリクスから分かること：
- **Token count: 2,500**: 中規模の調査、適切な範囲
- **Tool uses: 8 (Grep: 4, Read: 4)**: 効率的な検索パターン
- **Duration: 18.5s**: 許容範囲内のレスポンス時間

### 複数アプローチの比較
同じタスクを異なる方法で実行した場合の効率比較：

**アプローチ1: 広範囲検索**
```
「プロジェクト全体でエラーハンドリングのパターンを調査してください」
```
- Token count: 8,000
- Tool uses: 25
- Duration: 45s

**アプローチ2: 絞り込み検索**
```
「src/utilsディレクトリ内のエラーハンドリングパターンを調査してください」
```
- Token count: 1,500
- Tool uses: 8
- Duration: 12s

より具体的な指示により、トークン消費を80%削減できました。

### バッチ処理のパフォーマンス監視
複数ファイルの一括処理時のリソース使用量：

```
「docs/配下のすべてのMarkdownファイルを読んで構造を分析してください」
```

メトリクスの確認ポイント：
- **Token count**: ファイル数に対して妥当か
- **Tool uses**: 効率的にRead/Globを使用しているか
- **Duration**: 処理時間が許容範囲か

### コスト最適化の意思決定
トークン消費が多い場合、タスクを分割すべきか判断：

**Before: 一度に全調査**
```
「プロジェクト全体の技術スタックとアーキテクチャを分析してください」
```
- Token count: 15,000 (高額)
- Tool uses: 40
- Duration: 2分

**After: 段階的調査**
```
1. 「package.jsonとREADMEから技術スタックを確認してください」
   - Token count: 500
   - Tool uses: 2
   - Duration: 3s

2. 「src/ディレクトリ構造を調査してください」
   - Token count: 1,200
   - Tool uses: 5
   - Duration: 8s
```

段階的アプローチで必要な情報のみを取得し、トークンを90%削減。

### パフォーマンスのベンチマーク
定期的なタスクのパフォーマンス変化を追跡：

**週次レポート生成タスク**
- 第1週: Token count: 3,000, Duration: 25s
- 第2週: Token count: 3,200, Duration: 27s
- 第4週: Token count: 5,500, Duration: 48s (←肥大化を検知)

メトリクスの増加傾向から、タスクの見直しが必要と判断できます。

### エージェントタイプの選択最適化
異なるエージェントタイプのコスト比較：

**Explore agent (medium thoroughness)**
- Token count: 2,000
- Tool uses: 10
- Duration: 15s

**General-purpose agent**
- Token count: 4,500
- Tool uses: 18
- Duration: 35s

Exploreエージェントの方が効率的と判断し、今後はこちらを使用。

## 注意点

- **メトリクスは目安**: トークン数や実行時間は、タスクの複雑さやコードベースのサイズによって大きく変動します
- **ツール使用回数の解釈**: 多い=悪いではありません。複雑なタスクでは自然に増加します
- **トークンコスト意識**: 特に大規模タスクでは、トークン消費がAPI利用料に直結するため注意が必要です
- **実行時間の変動**: ネットワーク状況やシステム負荷により変動する可能性があります
- **最適化のバランス**: パフォーマンスを追求しすぎて、タスクの品質を下げないよう注意してください

## メトリクスの読み方

### Token count（トークン数）
- **500以下**: 小規模タスク
- **500-2,000**: 中規模タスク
- **2,000-5,000**: 大規模タスク
- **5,000以上**: 非常に大規模、分割を検討

### Tool uses（ツール使用回数）
- 使用されたツールの種類と回数
- 効率的なツール選択ができているか確認
- 同じツールの繰り返し使用は最適化の余地あり

### Duration（実行時間）
- タスクの完了までの実時間
- ユーザー体験に直結する指標
- 30秒以上の場合、タスク分割を検討

## 関連情報

- [Claude Code Task Tool ドキュメント](https://docs.anthropic.com/claude/docs/task-tool)
- [トークン使用量の最適化ガイド](https://docs.anthropic.com/claude/docs/optimizing-token-usage)
- [エージェントタイプとパフォーマンス](https://github.com/anthropics/claude-code/blob/main/docs/agents.md)
