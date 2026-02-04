---
title: "Gateway利用者向けのコンテキスト管理検証エラーを修正"
date: 2025-01-27
tags: [bugfix, gateway, bedrock, vertex]
---

## 原文(日本語訳)

Gateway利用者向けのコンテキスト管理検証エラーを修正。`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定することでエラーを回避できるようになりました。

## 原文（英語）

Fixed context management validation error for gateway users, ensuring `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` avoids the error

## 概要

AWS BedrockやVertex AIなどのGatewayを経由してClaude Codeを使用している利用者が、コンテキスト管理の検証エラーに遭遇する問題が修正されました。環境変数を設定することで、実験的なベータ機能を無効化し、エラーを回避できます。

## 基本的な使い方

環境変数を設定してClaude Codeを起動します。

```bash
# 実験的なベータ機能を無効化
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
claude
```

## 実践例

### Bedrock利用者の場合

AWS Bedrockを使用している場合、環境変数を設定してから起動します。

```bash
# .bashrc または .zshrc に追加
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
export AWS_PROFILE=your-profile

# Claude Codeを起動
claude
```

### Vertex AI利用者の場合

Google Cloud Vertex AIを使用している場合も同様です。

```bash
# 環境変数を設定
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
export CLOUD_ML_REGION=us-central1

# Claude Codeを起動
claude
```

### Docker環境での設定

Docker内でClaude Codeを実行する場合、環境変数を渡します。

```bash
docker run -e CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1 \
  -e AWS_PROFILE=your-profile \
  claude-code
```

## 注意点

- この設定により、一部の実験的な新機能が利用できなくなる可能性があります
- Gateway経由でない通常のAnthropic API利用者は、この設定は不要です
- エラーが解消されない場合は、`/doctor` コマンドで診断情報を確認してください

## 関連情報

- [AWS Bedrock設定ガイド](https://code.claude.com/docs/en/bedrock)
- [Vertex AI設定ガイド](https://code.claude.com/docs/en/vertex)
- [環境変数リファレンス](https://code.claude.com/docs/en/environment-variables)
