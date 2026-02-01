---
title: "[VSCode] 現在のプラン使用状況を表示する /usage コマンドを追加"
date: 2026-01-20
tags: ['新機能', 'VSCode', 'コマンド', '使用量管理']
---

## 原文（日本語に翻訳）

[VSCode] 現在のプラン使用状況を表示する `/usage` コマンドを追加

## 原文（英語）

[VSCode] Added `/usage` command to display current plan usage

## 概要

Claude Code v2.1.14では、VS Code拡張機能に `/usage` コマンドが追加されました。このコマンドを使用すると、現在のClaudeサブスクリプションプランの使用状況とレート制限のステータスを確認できます。月間の使用量上限、残り使用可能量、APIレート制限などを一目で把握でき、効率的なリソース管理が可能になります。

## 基本的な使い方

VS Code でClaude Code拡張機能を使用している場合：

1. Claude Codeのチャット画面を開く
2. `/usage` と入力してEnterキーを押す
3. 現在のプラン使用状況が表示される

表示される情報には以下が含まれます：
- サブスクリプションプランの種類（Pro、Max、Teams など）
- 月間使用量の上限
- 現在の使用量
- 残り使用可能量
- レート制限のステータス

## 実践例

### 月間使用量の確認

月の途中で残りどれくらい使えるか確認：

```
/usage
```

表示例：
```
プラン: Claude Pro
月間上限: 1000 メッセージ
使用済み: 750 メッセージ
残り: 250 メッセージ (25%)
リセット日: 2026年2月1日
```

### レート制限の確認

API使用量が制限に近づいているか確認：

```
/usage
```

レート制限情報も表示される場合：
```
レート制限ステータス:
- 1分あたりのリクエスト: 45/50
- 1時間あたりのトークン: 180k/200k
```

### チーム使用量の監視

Teamsプランで複数メンバーの使用状況を把握：

```
/usage
```

チーム全体の使用状況が表示される（権限に応じて）

### 大規模プロジェクト前の確認

リソースを多く消費する作業の前に確認：

```
# 大規模なリファクタリングや分析タスクの前に
/usage

# 十分な残量があることを確認してから作業開始
"プロジェクト全体をリファクタリングしてください"
```

## 注意点

- **VS Code専用機能**：この `/usage` コマンドはVS Code拡張機能専用です。CLI版では別の方法で使用量を確認します
- **サブスクリプション限定**：この機能はClaude Pro、Max、Teams、Enterpriseプラン加入者のみ利用可能です
- **APIキーユーザーには非対応**：Claude API（旧Anthropic API）のAPIキーを使用している場合、使用量はConsoleで確認する必要があります
- **リアルタイム更新**：表示される使用量はリアルタイムまたは数分以内の情報です
- **CLI版の `/usage`**：CLI版のClaude Codeでも `/usage` コマンドは使用できますが、v2.1.14以前から存在していました
- **`/cost`との違い**：`/cost`コマンドはトークン使用統計を表示し、`/usage`はプラン上限と残量を表示します

## 関連情報

- [Claude Code VS Code拡張](https://code.claude.com/docs/en/vs-code)
- [Claude Code インタラクティブモード - コマンド一覧](https://code.claude.com/docs/en/interactive-mode#built-in-commands)
- [Claude Code コスト追跡](https://code.claude.com/docs/en/costs)
- [Claude プランと料金](https://claude.com/pricing)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
