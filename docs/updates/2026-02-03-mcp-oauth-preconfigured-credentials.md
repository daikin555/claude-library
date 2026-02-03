---
title: "MCPサーバーのOAuth事前設定 - クライアント認証情報の追加"
date: 2026-02-03
tags: [mcp, oauth, authentication, slack]
---

## 原文（日本語）
Dynamic Client RegistrationをサポートしていないMCPサーバー（Slackなど）向けに、事前設定されたOAuthクライアント認証情報を追加しました。`claude mcp add`コマンドで`--client-id`と`--client-secret`を使用できます。

## 原文（英語）
Added pre-configured OAuth client credentials for MCP servers that don't support Dynamic Client Registration (e.g., Slack). Use `--client-id` and `--client-secret` with `claude mcp add`.

## 概要
一部のMCPサーバー（特にSlackなど）はDynamic Client Registrationに対応していないため、OAuth認証にクライアントIDとシークレットの事前登録が必要です。この新機能により、これらのサービスでもClaude CodeからMCPサーバーを簡単に追加できるようになりました。

## 基本的な使い方

### クライアント認証情報を指定してMCPサーバーを追加
```bash
claude mcp add <server-name> \
  --client-id "your-client-id" \
  --client-secret "your-client-secret"
```

基本的な構文は、`--client-id`と`--client-secret`フラグを`claude mcp add`コマンドに追加するだけです。

## 実践例

### Slack MCPサーバーの追加
Slackはよく使われるMCPサーバーの一つで、Dynamic Client Registrationに非対応です。

```bash
# Slack Appから取得したクライアント認証情報を使用
claude mcp add slack \
  --client-id "123456789.123456789012" \
  --client-secret "abcdef1234567890abcdef1234567890"
```

**事前準備:**
1. [Slack API](https://api.slack.com/apps)でアプリを作成
2. OAuth & PermissionsセクションでリダイレクトURLを設定
3. Client IDとClient Secretを取得

### カスタムOAuthプロバイダーとの連携
独自のOAuthサーバーを使用するカスタムMCPサーバーの場合：

```bash
claude mcp add my-custom-service \
  --client-id "custom_app_id_xyz" \
  --client-secret "super_secret_key_123"
```

### 環境変数からの認証情報の読み込み
セキュリティのため、シークレットを環境変数から読み込むことを推奨します：

```bash
export MCP_CLIENT_SECRET="your-secret-here"

claude mcp add slack \
  --client-id "123456789.123456789012" \
  --client-secret "$MCP_CLIENT_SECRET"
```

### 複数のワークスペースで異なる認証情報を使用
異なるSlackワークスペースごとに異なる認証情報を持つ場合：

```bash
# ワークスペース1
claude mcp add slack-workspace1 \
  --client-id "111111111.111111111111" \
  --client-secret "secret1111111111111111111111111111"

# ワークスペース2
claude mcp add slack-workspace2 \
  --client-id "222222222.222222222222" \
  --client-secret "secret2222222222222222222222222222"
```

## 注意点

- **クライアントシークレットの保護**: Client Secretは機密情報です。コマンド履歴に残らないよう、環境変数や設定ファイルから読み込むことを推奨します
- **事前登録が必要**: OAuthアプリケーションをサービス側で事前に作成し、リダイレクトURLを正しく設定する必要があります
- **Dynamic Client Registrationとの違い**: この機能は、DCRをサポートしていないサービス専用です。DCR対応サービスでは通常の`claude mcp add`で自動的に処理されます
- **リダイレクトURL**: 多くのOAuthプロバイダーでは、Claude CodeのローカルリダイレクトURL（通常は`http://localhost:xxxxx/callback`）をホワイトリストに登録する必要があります

## 関連情報

- [Claude Code MCP公式ドキュメント](https://docs.anthropic.com/claude/docs/mcp)
- [Slack API - OAuth Documentation](https://api.slack.com/authentication/oauth-v2)
- [MCPサーバーの設定ガイド](https://github.com/anthropics/claude-code/blob/main/docs/mcp.md)
