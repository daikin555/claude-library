---
title: "/compact実行後のコンテキスト警告が消えない問題の修正"
date: 2026-01-22
tags: ['バグ修正', 'UI', 'コンテキスト管理']
---

## 原文（日本語に翻訳）

`/compact` 実行後に「コンテキスト残量」警告が非表示にならない問題を修正しました

## 原文（英語）

Fixed an issue where the "context remaining" warning was not hidden after running `/compact`

## 概要

Claude Code v2.1.16では、`/compact` コマンドを実行してセッションを圧縮した後も、コンテキスト残量の警告が表示され続ける不具合が修正されました。この問題により、ユーザーは実際にはコンテキストに余裕があるにもかかわらず、警告が表示され続けることで混乱していました。修正後は、圧縮によってコンテキストが回復した場合、警告が適切に消えるようになりました。

## 基本的な使い方

特別な操作は不要です。`/compact` コマンドを実行すると、警告が自動的に更新されます。

### コンテキスト警告の確認

セッション中、コンテキストが一定量を超えると警告が表示されます：

```
⚠️ Context left until auto-compact: 15%
```

### セッションの圧縮

警告が表示されたら、`/compact` コマンドでセッションを圧縮：

```bash
/compact
```

圧縮後、コンテキストが十分に回復すれば、警告は自動的に消えます。

## 実践例

### 長時間のセッションでの警告管理

コンテキスト警告が表示されてから圧縮する流れ：

```
# セッション中に警告が表示
⚠️ Context left until auto-compact: 10%

# ユーザー
/compact

# システム
Compacting session...
Done! Freed 45% of context window.

# 修正前: 警告が消えない
⚠️ Context left until auto-compact: 10% (実際は55%あるのに表示される)

# 修正後: 警告が適切に消える
(警告なし - コンテキストに余裕あり)
```

### 自動圧縮との併用

自動圧縮が有効な場合でも、手動で圧縮した後の挙動が改善：

```bash
# 設定で自動圧縮を有効化
/config
→ autoCompact: true

# 警告が表示される前に手動で圧縮
/compact

# 修正前: 警告の表示状態が不正確
# 修正後: 圧縮結果に基づいて警告が正しく更新される
```

### コンテキスト使用状況の確認

`/context` コマンドと組み合わせて使用：

```bash
# コンテキストの詳細を確認
/context

# 出力例
Context usage: 85% (170k / 200k tokens)
⚠️ Context left until auto-compact: 15%

# 圧縮を実行
/compact

# 再度確認
/context

# 出力例
Context usage: 40% (80k / 200k tokens)
(警告なし)
```

## 注意点

- **警告の閾値**: デフォルトでは、コンテキスト使用率が80%を超えると警告が表示されます。この閾値は設定で変更できる場合があります
- **自動圧縮**: 自動圧縮が有効な場合、警告が表示される前に自動的に圧縮が実行されることがあります
- **圧縮の効果**: 圧縮の効果はセッションの内容によって異なります。大量の反復的な内容がある場合、圧縮率が高くなります
- **手動圧縮のタイミング**: 重要な作業の直前に圧縮しておくと、作業中にコンテキスト不足に悩まされることが少なくなります

### 効果的な圧縮のタイミング

```
✓ 推奨タイミング:
  - 警告が表示されたとき
  - 大規模な作業を開始する前
  - セッションを保存・終了する前

✗ 避けるべきタイミング:
  - 直近の会話を参照する必要がある場合
  - デバッグ中で詳細な履歴が必要な場合
```

## 関連情報

- [Claude Code 公式ドキュメント - コンテキスト管理](https://code.claude.com/docs/en/context)
- [/compact コマンドについて](https://code.claude.com/docs/en/compact)
- [自動圧縮の設定](https://code.claude.com/docs/en/settings#autoCompact)
- [Changelog v2.1.16](https://github.com/anthropics/claude-code/releases/tag/v2.1.16)
