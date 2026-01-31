---
title: "プラグインマーケットプレイスの戻るナビゲーション改善"
date: 2026-01-20
tags: ['バグ修正', 'プラグイン', 'UI/UX', 'ナビゲーション']
---

## 原文（日本語に翻訳）

マーケットプレイスが1つだけ設定されている場合のプラグインマーケットプレイスでの戻るナビゲーションの不整合を修正

## 原文（英語）

Fixed inconsistent back navigation in plugin marketplace when only one marketplace is configured

## 概要

Claude Codeのプラグインマーケットプレイスにおいて、設定されているマーケットプレイスが1つだけの場合に、「戻る」ボタンの動作が不安定になる問題を修正しました。この修正により、プラグインの詳細ページから一覧に戻る際や、カテゴリ間を移動する際のナビゲーションが一貫した動作をするようになり、ユーザーエクスペリエンスが向上しました。

## 基本的な使い方

プラグインマーケットプレイスは `/plugins` コマンドまたは設定から開くことができます。

```
/plugins

# または
/config → Plugins → Browse Marketplace
```

プラグイン詳細を見た後、戻るボタンで一覧に戻れます。

## 実践例

### プラグインの閲覧と戻る操作

1つのマーケットプレイスを使用している場合の基本的な操作。

```
# プラグインマーケットプレイスを開く
/plugins

# 表示される画面:
📦 Plugin Marketplace
├─ Featured
├─ Development Tools
├─ Productivity
└─ Integrations

# プラグインを選択
Development Tools → "ESLint Integration" を選択

# 詳細画面で「戻る」をクリック
← Back

# 以前の問題: トップ画面に戻らず、画面が閉じることがあった
# 修正後: 確実にDevelopment Toolsの一覧に戻る
```

### カテゴリ間の移動

複数のプラグインを比較検討する際の操作性改善。

```
# カテゴリを順番に見る
1. Featured → "Git Helper" の詳細を確認 → 戻る ✓
2. Development Tools → "TypeScript Utils" を確認 → 戻る ✓
3. Productivity → "Quick Commands" を確認 → 戻る ✓

# 各ステップで確実に前の画面に戻れる
```

### プラグインのインストールとナビゲーション

プラグインをインストールした後の画面遷移。

```
# プラグイン詳細からインストール
1. /plugins → Development Tools
2. "Prettier Integration" を選択
3. [Install] ボタンをクリック
4. インストール完了メッセージ表示
5. ← Back をクリック

# 修正後: Development Tools一覧に戻る（期待通りの動作）
# 以前: マーケットプレイスが閉じてしまうことがあった
```

### 検索結果からの戻る操作

プラグインを検索して詳細を見た後の動作。

```
# プラグインを検索
1. /plugins
2. 検索ボックスに "git" と入力
3. 検索結果が表示される:
   - Git Helper
   - GitLens Extension
   - GitHub Integration
4. "Git Helper" を選択して詳細を確認
5. ← Back をクリック

# 修正後: 検索結果の画面に戻る
# 以前: 検索結果が失われてトップに戻ることがあった
```

## 注意点

- この修正は Claude Code v2.1.14 で適用されました
- 複数のマーケットプレイスを設定している場合は、元々正常に動作していました
- この修正は主に以下の構成で効果があります:
  - デフォルトの公式マーケットプレイスのみを使用
  - カスタムマーケットプレイスを1つだけ設定
- ブラウザの「戻る」ボタンとは異なる独自のナビゲーション履歴を持ちます
- プラグインマーケットプレイス内のナビゲーション履歴は、マーケットプレイスを閉じるとクリアされます
- キーボードショートカット（Escキー）でもマーケットプレイスを閉じられます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
- [プラグインシステムについて](https://code.claude.com/docs/plugins)
- [プラグインのインストールガイド](https://code.claude.com/docs/plugins/installation)
- [カスタムマーケットプレイスの設定](https://code.claude.com/docs/plugins/custom-marketplace)
