---
title: "OAuthとAPIコンソールのURLを新ドメインに変更"
date: 2026-01-14
tags: ['変更', '設定', 'OAuth', 'API']
---

## 原文（日本語に翻訳）

OAuthとAPIコンソールのURLを`console.anthropic.com`から`platform.claude.com`に変更しました。

## 原文（英語）

Changed OAuth and API Console URLs from console.anthropic.com to platform.claude.com

## 概要

AnthropicのプラットフォームURL体系の変更に伴い、Claude CodeのOAuth認証とAPIコンソールへのリンクが、旧ドメイン`console.anthropic.com`から新ドメイン`platform.claude.com`に更新されました。これにより、Anthropicの統一されたプラットフォームブランディングに対応しています。

## 変更内容

### 影響を受けるURL

| 機能 | 旧URL | 新URL |
|------|------|------|
| OAuth認証 | console.anthropic.com/oauth | platform.claude.com/oauth |
| APIキー管理 | console.anthropic.com/account/keys | platform.claude.com/account/keys |
| API設定 | console.anthropic.com/settings/api | platform.claude.com/settings/api |
| 使用量確認 | console.anthropic.com/usage | platform.claude.com/usage |

### 自動リダイレクト

旧URLは新URLに自動的にリダイレクトされるため、既存のブックマークも引き続き機能します。

## 実践例

### OAuth認証フロー

**修正前（v2.1.6以前）:**
```bash
$ claude auth login
Opening: https://console.anthropic.com/oauth/authorize?...
```

**修正後（v2.1.7）:**
```bash
$ claude auth login
Opening: https://platform.claude.com/oauth/authorize?...
```

### APIキー設定

設定時に表示されるリンク：

**修正前:**
```
To get your API key, visit:
https://console.anthropic.com/account/keys
```

**修正後（v2.1.7）:**
```
To get your API key, visit:
https://platform.claude.com/account/keys
```

### エラーメッセージ内のリンク

認証エラーが発生した際：

**修正前:**
```
Authentication failed.
Please check your settings at:
https://console.anthropic.com/settings/api
```

**修正後（v2.1.7）:**
```
Authentication failed.
Please check your settings at:
https://platform.claude.com/settings/api
```

## ユーザーへの影響

### 特別な対応は不要

- **既存の認証情報**: 引き続き有効です
- **APIキー**: 変更不要です
- **ブックマーク**: 旧URLは自動的に新URLにリダイレクトされます

### 推奨される対応

1. **ブックマークの更新**: 新しいドメインに更新することを推奨
2. **ドキュメントの更新**: 社内ドキュメントやwikiに旧URLを記載している場合は更新を推奨
3. **ファイアウォール設定**: 企業ネットワークで`platform.claude.com`へのアクセスを許可

## 新プラットフォームの機能

`platform.claude.com`では、以下の新機能が利用可能です：

- **統一されたダッシュボード**: すべてのClaude製品を一箇所で管理
- **改善されたAPI管理**: より直感的なAPIキー管理UI
- **詳細な使用量分析**: より詳細な使用状況の追跡
- **新しいドキュメント**: 最新のAPIドキュメントとガイド

## 技術的な詳細

### リダイレクトチェーン

```
https://console.anthropic.com/*
  ↓ 301 Permanent Redirect
https://platform.claude.com/*
```

### DNS変更

- 旧ドメインは引き続き解決されます
- 新ドメインが優先的に使用されます
- 両方のドメインでSSL/TLS証明書が有効です

## 注意点

- **企業ファイアウォール**: `platform.claude.com`へのアクセスを許可する必要がある場合があります
- **プロキシ設定**: プロキシ経由で使用している場合、新ドメインをホワイトリストに追加
- **旧URLの削除予定**: 将来的に旧URLのリダイレクトが削除される可能性があるため、早めの移行を推奨

## 移行チェックリスト

- [ ] ブックマークを`platform.claude.com`に更新
- [ ] 社内ドキュメントのURL更新
- [ ] ファイアウォール設定の確認
- [ ] プロキシ設定の確認（該当する場合）
- [ ] CI/CDスクリプト内のURL更新（該当する場合）

## 関連情報

- [Claude Platform](https://platform.claude.com/)
- [APIドキュメント](https://platform.claude.com/docs/)
- [OAuth設定ガイド](https://platform.claude.com/docs/oauth)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
