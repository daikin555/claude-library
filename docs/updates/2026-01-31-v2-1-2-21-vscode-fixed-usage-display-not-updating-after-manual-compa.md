---
title: "[VSCode] 手動コンパクト後の使用量表示が更新されない問題を修正"
date: 2026-01-09
tags: ['バグ修正', 'VSCode', 'UI', '使用量表示']
---

## 原文（日本語に翻訳）

[VSCode] 手動コンパクト実行後に使用量表示が更新されない問題を修正しました。

## 原文（英語）

[VSCode] Fixed usage display not updating after manual compact

## 概要

Visual Studio Code版のClaude Codeにおいて、会話履歴の手動コンパクト（圧縮）を実行した後、UI上の使用量表示（トークン数やコンテキストサイズ）が更新されずに古い値が表示され続ける問題が修正されました。これにより、コンパクト後の実際の使用量が正しく表示されるようになります。

## 基本的な使い方

この修正は自動的に適用されます。手動コンパクトを実行すると、使用量表示が即座に更新されます。

### 修正前の問題

```
# VSCode版Claude Codeで長い会話の後

# 使用量表示:
📊 Context: 45,000 / 50,000 tokens (90%)

# 手動コンパクトを実行
# コマンドパレット: "Claude Code: Compact Conversation"

# 修正前: 使用量表示が更新されない
📊 Context: 45,000 / 50,000 tokens (90%)  ← 古い値のまま

# 実際には圧縮されて20,000トークンになっているのに表示が変わらない
```

### 修正後の動作

```
# 同じシナリオ

# 使用量表示:
📊 Context: 45,000 / 50,000 tokens (90%)

# 手動コンパクトを実行
# コマンドパレット: "Claude Code: Compact Conversation"

# 修正後: 使用量表示が即座に更新される
📊 Context: 20,000 / 50,000 tokens (40%)  ✓ 正しく更新

# 実際の使用量が正確に反映される
```

## 実践例

### 長時間セッションでの使用量管理

```
# 1時間の開発作業後

# 現在の使用量を確認
📊 Context: 48,500 / 50,000 tokens (97%)
⚠️ Approaching context limit

# 手動コンパクトを実行
> Claude Code: Compact Conversation

# 修正前: 表示が変わらず、リミットに達したように見える
# 修正後: 正しい使用量が表示される
📊 Context: 22,000 / 50,000 tokens (44%)
✓ Plenty of context available

# 作業を継続できることが明確
```

### リファクタリング作業中の監視

```
# 大規模なリファクタリングで多数のファイルを編集

# コンテキストが増加
📊 Context: 47,000 / 50,000 tokens (94%)

# 重要でない古い会話をコンパクト
> Claude Code: Compact Conversation

# 修正後: すぐに反映される
📊 Context: 25,000 / 50,000 tokens (50%)

# リファクタリングを続行可能
```

### コンテキストウィンドウの最適化

```
# 効率的なコンテキスト管理

# Before compact:
📊 Context Usage:
   - Messages: 150
   - Tokens: 46,000 / 50,000
   - Files: 25

# Execute compact
> Claude Code: Compact Conversation

# After compact (修正後は即反映):
📊 Context Usage:
   - Messages: 50 (important ones kept)
   - Tokens: 18,000 / 50,000
   - Files: 25 (unchanged)

# 容量が大幅に改善されたことが即座に分かる
```

### 複数回のコンパクト

```
# 段階的にコンテキストを整理

# 1回目のコンパクト
📊 45,000 tokens → 30,000 tokens ✓ 表示更新

# 2回目のコンパクト（さらに古い履歴を圧縮）
📊 30,000 tokens → 18,000 tokens ✓ 表示更新

# 修正前: どちらも表示が更新されず、効果が分からない
# 修正後: 各ステップで正確な効果が確認できる
```

## 注意点

- **VSCode版限定**: この問題はVSCode拡張版で発生していました（ターミナル版では発生しません）
- **即座の更新**: コンパクト完了後、数秒以内に表示が更新されます
- **自動コンパクト**: 自動コンパクトの場合は、修正前から正しく更新されていました
- **リロード不要**: 修正後は、VSCodeのリロードなしで表示が更新されます
- **正確な管理**: 正しい使用量が表示されることで、より効率的なコンテキスト管理が可能になります

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [VSCode拡張機能ガイド](https://code.claude.com/docs/vscode)
- [コンテキスト管理ベストプラクティス](https://code.claude.com/docs/context-management)
