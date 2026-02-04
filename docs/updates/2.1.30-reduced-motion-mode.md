---
title: "モーション削減モード - アクセシビリティ設定の追加"
date: 2026-02-03
tags: [accessibility, config, ui, motion]
---

## 原文（日本語）
設定にモーション削減モードを追加しました。

## 原文（英語）
Added reduced motion mode to the config.

## 概要
Claude Codeにアクセシビリティ機能として「モーション削減モード」が追加されました。この設定を有効にすると、アニメーションやトランジション効果が最小限に抑えられ、動きに敏感な方や、前庭障害、片頭痛、注意欠陥などを持つユーザーにとって、より快適に使用できるようになります。

## 基本的な使い方

### 設定ファイルでの有効化
`~/.claude/config.json`を編集して、モーション削減モードを有効にします。

```json
{
  "reducedMotion": true
}
```

設定を保存すると、次回のClaude Code起動時から適用されます。

## 実践例

### 前庭障害のあるユーザー向け設定
動きによるめまいや吐き気を軽減：

```json
{
  "reducedMotion": true,
  "theme": "dark"
}
```

アニメーションが無効化され、画面の変化が急激でなくなります。

### 片頭痛持ちの開発者向け設定
視覚的な刺激を最小限に抑える：

```json
{
  "reducedMotion": true,
  "brightness": 0.7
}
```

モーション削減とともに、明るさを調整することで、片頭痛のトリガーを減らします。

### ADHD（注意欠陥多動性障害）向け設定
気が散る動きを排除し、集中力を維持：

```json
{
  "reducedMotion": true,
  "notifications": {
    "enabled": false
  }
}
```

不要な動きや通知を無効化し、コーディングに集中できる環境を作ります。

### パフォーマンス重視の環境
古いハードウェアやリソース制限のある環境でのパフォーマンス改善：

```json
{
  "reducedMotion": true,
  "enableAnimations": false
}
```

アニメーション処理を省略することで、CPUリソースを節約します。

### スクリーンリーダー使用時の最適化
視覚障害のあるユーザーがスクリーンリーダーと併用する場合：

```json
{
  "reducedMotion": true,
  "screenReaderMode": true
}
```

視覚的なアニメーションは不要なため、モーション削減モードが適しています。

## 注意点

- **システム設定との連携**: 多くのOSには「視差効果を減らす」や「アニメーションを減らす」といったシステムレベルの設定があります。Claude Codeがこれらを自動検出する場合もあります
- **再起動が必要**: 設定変更後は、Claude Codeを再起動する必要がある場合があります
- **すべてのアニメーションが対象ではない**: 機能上必要な最小限の視覚フィードバックは残る場合があります
- **パフォーマンスへの影響**: モーション削減により、わずかにパフォーマンスが向上する可能性がありますが、体感できる差は限定的です

## モーション削減で影響を受けるUI要素

### 無効化または最小化される効果
- スムーズスクロール → 即座のジャンプ
- フェードイン/アウト → 即座の表示/非表示
- スライドアニメーション → 即座の配置変更
- ホバー時のトランジション → 即座の状態変化
- プログレスバーのアニメーション → 静的な表示

### 影響を受けない要素
- 機能的なローディングインジケーター（処理中の表示）
- カーソルの点滅
- 必須のフォーカスインジケーター

## アクセシビリティのベストプラクティス

モーション削減モードと併用すると効果的な設定：

```json
{
  "reducedMotion": true,
  "highContrast": true,
  "fontSize": 14,
  "lineHeight": 1.6,
  "cursorBlinkRate": 0
}
```

視覚的な配慮を総合的に適用した設定例です。

## 関連情報

- [Web Content Accessibility Guidelines (WCAG) 2.1 - Animation from Interactions](https://www.w3.org/WAI/WCAG21/Understanding/animation-from-interactions.html)
- [MDN - prefers-reduced-motion](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion)
- [Claude Code アクセシビリティガイド](https://docs.anthropic.com/claude/docs/accessibility)
- [Vestibular Disorders Association](https://vestibular.org/)
