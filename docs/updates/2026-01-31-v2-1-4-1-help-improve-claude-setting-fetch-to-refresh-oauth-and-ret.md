---
title: "「Claudeの改善に協力」設定の取得時のOAuth更新処理を修正"
date: 2026-01-11
tags: ['バグ修正', 'OAuth', '認証', '設定']
---

## 原文（日本語に翻訳）

古いOAuthトークンが原因で失敗した場合に、OAuthを更新して再試行するよう「Claudeの改善に協力」設定の取得処理を修正しました。

## 原文（英語）

Fixed "Help improve Claude" setting fetch to refresh OAuth and retry when it fails due to a stale OAuth token

## 概要

Claude Code v2.1.4では、ユーザーのデータ使用設定（「Claudeの改善に協力」）を取得する際に、古くなったOAuthトークンが原因で失敗していた問題が修正されました。この修正により、OAuthトークンの有効期限が切れていた場合、自動的にトークンを更新して再試行するようになり、設定の同期がより確実に行われるようになりました。

## 基本的な使い方

この修正は自動的に適用されるため、ユーザー側で特別な操作は不要です。Claude Codeを起動すると、以下のプロセスが自動的に実行されます：

1. claude.aiの設定を確認
2. OAuthトークンが古い場合は自動更新
3. 設定を正常に取得

以前のバージョンでは、OAuthトークンの有効期限が切れていた場合、設定の取得に失敗していましたが、v2.1.4以降では自動的に回復します。

## 実践例

### データプライバシー設定の同期

ユーザーがclaude.aiで「Claudeの改善に協力」設定を変更した場合、Claude Codeは自動的にその設定を取得します。

```bash
# Claude Codeを起動
claude

# 設定が自動的に同期される
# OAuthトークンが古い場合でも、自動更新されて正常に取得される
```

### 複数デバイス間での設定の一貫性

複数のマシンでClaude Codeを使用している場合、各マシンで同じデータプライバシー設定が適用されます。

```bash
# マシンA: claude.aiで設定を変更
# マシンB: Claude Codeを起動
claude

# マシンBでも最新の設定が自動的に反映される
# OAuthトークンの更新処理により、設定取得の失敗が防がれる
```

### API利用時の自動認証更新

Claude APIを使用している場合でも、設定の同期が正常に動作します。

```bash
# 環境変数でAPI設定を使用
export ANTHROPIC_API_KEY=your_api_key
claude -p "Run tests"

# バックグラウンドで設定が同期される
# OAuthエラーが発生しても自動的に回復
```

### チームでの統一設定

Team/Enterpriseプランを使用している場合、組織の設定が正しく同期されます。

```bash
# 組織管理者が設定を変更
# 各メンバーのClaude Codeに自動的に反映

claude
# 組織の最新のデータ使用ポリシーが適用される
```

## 注意点

- この修正は、Free、Pro、Maxプラン、Team、EnterpriseプランのすべてのユーザーにClaude API使用時に適用されます
- OAuthトークンの更新は自動的に行われるため、ユーザーが手動で認証をやり直す必要はありません
- 設定の取得に失敗した場合でも、Claude Codeの基本機能は引き続き使用できます
- データプライバシー設定は [claude.ai/settings/data-privacy-controls](https://claude.ai/settings/data-privacy-controls) で確認・変更できます
- Team/Enterpriseプランでは、30日間のデータ保持期間がデフォルトで適用されます（ゼロデータ保持オプションも利用可能）

## 関連情報

- [Data Usage - Claude Code 公式ドキュメント](https://code.claude.com/docs/en/data-usage)
- [Data Privacy Controls - Claude Settings](https://claude.ai/settings/data-privacy-controls)
- [Privacy Center - Anthropic](https://privacy.anthropic.com/)
- [Changelog v2.1.4](https://github.com/anthropics/claude-code/releases/tag/v2.1.4)
