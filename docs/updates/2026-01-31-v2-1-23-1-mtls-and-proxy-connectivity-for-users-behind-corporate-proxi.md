---
title: "企業プロキシ環境でのmTLS接続問題を修正"
date: 2026-01-29
tags: ['バグ修正', 'ネットワーク', 'セキュリティ', '企業環境']
---

## 原文（日本語に翻訳）

企業プロキシ配下のユーザーやクライアント証明書を使用するユーザーのためのmTLSおよびプロキシ接続を修正

## 原文（英語）

Fixed mTLS and proxy connectivity for users behind corporate proxies or using client certificates

## 概要

企業ネットワーク環境でClaude Codeを使用する際に発生していた、mTLS（相互TLS認証）およびプロキシ接続の問題が修正されました。これにより、企業のプロキシサーバー経由でのアクセスや、クライアント証明書を使用したセキュアな接続が正しく機能するようになります。セキュリティポリシーの厳格な企業環境でも、Claude Codeを問題なく利用できるようになりました。

## 基本的な使い方

この修正は自動的に適用されるため、特別な設定は不要です。ただし、企業プロキシやクライアント証明書を使用する場合は、以下の環境変数が正しく設定されていることを確認してください。

### プロキシ設定

```bash
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,.company.com
```

### クライアント証明書の設定

```bash
# Node.jsの証明書設定
export NODE_EXTRA_CA_CERTS=/path/to/company-ca-bundle.crt
```

## 実践例

### 企業プロキシ経由での使用

プロキシ認証が必要な環境では、認証情報を含めて設定します。

```bash
# 認証付きプロキシの設定
export HTTP_PROXY=http://username:password@proxy.company.com:8080
export HTTPS_PROXY=http://username:password@proxy.company.com:8080

# Claude Codeを起動
claude
```

### mTLS環境での使用

クライアント証明書とプライベートキーを使用する環境では、以下のように設定します。

```bash
# クライアント証明書の設定
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/company-ca.pem
export NODE_TLS_REJECT_UNAUTHORIZED=0  # 開発環境のみ

# Claude Codeを起動
claude
```

**注意**: `NODE_TLS_REJECT_UNAUTHORIZED=0`は開発環境でのみ使用し、本番環境では適切な証明書検証を行ってください。

### 複数プロキシ設定の除外

内部リソースへのアクセスをプロキシから除外する場合：

```bash
export NO_PROXY=localhost,127.0.0.1,.internal.company.com,10.0.0.0/8
```

### Docker環境でのプロキシ設定

Docker内でClaude Codeを使用する場合：

```dockerfile
FROM node:20

# プロキシ設定
ENV HTTP_PROXY=http://proxy.company.com:8080
ENV HTTPS_PROXY=http://proxy.company.com:8080
ENV NO_PROXY=localhost,127.0.0.1

# CA証明書の追加
COPY company-ca.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Claude Codeのインストール
RUN npm install -g @anthropic-ai/claude-code
```

## 注意点

- プロキシ設定は環境変数として設定する必要があります
- クライアント証明書のパスは絶対パスで指定してください
- プロキシ認証情報を環境変数に含める場合は、セキュリティに注意してください（履歴に残らないよう配慮）
- 自己署名証明書を使用する場合は、CA証明書を適切に設定する必要があります
- Windows環境では、環境変数の設定方法が異なります（`set`コマンドまたはシステムのプロパティから設定）
- この修正はv2.1.23で導入されたため、それ以前のバージョンでは問題が発生する可能性があります

## 関連情報

- [Node.js プロキシ設定ガイド](https://nodejs.org/api/cli.html#cli_node_extra_ca_certs_file)
- [mTLS（相互TLS認証）について](https://www.cloudflare.com/ja-jp/learning/access-management/what-is-mutual-tls/)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- 企業ネットワーク環境でのトラブルシューティングについては、IT部門にお問い合わせください
