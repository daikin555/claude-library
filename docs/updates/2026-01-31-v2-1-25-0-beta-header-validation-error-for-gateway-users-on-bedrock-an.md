---
title: "BedrockとVertex AIでのベータヘッダー検証エラーを修正"
date: 2026-01-29
tags: ['バグ修正', 'Bedrock', 'Vertex', '環境変数']
---

## 原文（日本語に翻訳）

BedrockとVertex AIのゲートウェイユーザー向けのベータヘッダー検証エラーを修正し、`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`環境変数を設定することでエラーを回避できるようになりました。

## 原文（英語）

Fixed beta header validation error for gateway users on Bedrock and Vertex, ensuring `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` avoids the error

## 概要

Claude Code v2.1.25では、AWS BedrockやGoogle Vertex AIを経由してClaude APIを使用しているユーザーが遭遇していたベータヘッダー検証エラーが修正されました。この修正により、`CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`環境変数を設定することで、実験的なベータ機能を無効化し、エラーを確実に回避できるようになりました。

## 基本的な使い方

### 環境変数の設定

ベータ機能を無効化してエラーを回避するには、以下のように環境変数を設定します。

#### Bash/Zsh（Linux/macOS）

```bash
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
claude
```

#### PowerShell（Windows）

```powershell
$env:CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
claude
```

#### .bashrcや.zshrcに永続的に設定

```bash
echo 'export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1' >> ~/.bashrc
source ~/.bashrc
```

## 実践例

### AWS Bedrockを使用している場合

AWS Bedrockでクロスリージョンルーティングを使用している場合、ベータヘッダーが原因でエラーが発生することがありました。

```bash
# エラーを回避するための設定
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
export ANTHROPIC_BEDROCK_REGION=us-east-1

# Claude Codeを起動
claude
```

### Google Vertex AIを使用している場合

Vertex AI経由でClaude APIを使用する際も、同様にベータ機能を無効化できます。

```bash
# Vertex AI向けの設定
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
export ANTHROPIC_VERTEX_PROJECT_ID=your-project-id
export ANTHROPIC_VERTEX_REGION=us-central1

# Claude Codeを起動
claude
```

### CI/CD環境での設定

GitHub ActionsやGitLab CIなどのCI/CD環境でClaude Codeを使用する場合も、環境変数を設定することでエラーを防げます。

```yaml
# GitHub Actions の例
env:
  CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS: 1
  ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Docker環境での設定

Dockerコンテナ内でClaude Codeを実行する場合の設定例です。

```bash
docker run -e CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1 \
           -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
           your-image
```

## 注意点

- **この修正はv2.1.25以降で有効**: v2.1.25より前のバージョンでは、環境変数を設定してもエラーが回避できない場合があります。最新バージョンへのアップデートを推奨します。

- **ベータ機能が無効になる**: `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1`を設定すると、すべての実験的なベータ機能が無効化されます。ベータ機能を使用したい場合は、この環境変数を設定しないでください。

- **ゲートウェイユーザー向けの修正**: この問題は主にAWS BedrockやGoogle Vertex AI経由でClaude APIを使用しているユーザーに影響していました。Anthropic APIを直接使用している場合は、通常この問題は発生しません。

- **エラーメッセージの確認**: ベータヘッダー検証エラーが発生している場合、エラーメッセージに"beta header validation"などのキーワードが含まれています。このエラーが表示された場合は、環境変数の設定を確認してください。

## 関連情報

- [Changelog v2.1.25](https://github.com/anthropics/claude-code/releases/tag/v2.1.25)
- [Claude Code GitHub リポジトリ](https://github.com/anthropics/claude-code)
- [Anthropic API ドキュメント](https://docs.anthropic.com/)
- [AWS Bedrock - Claude モデル](https://docs.aws.amazon.com/bedrock/latest/userguide/models-claude.html)
- [Google Vertex AI - Claude モデル](https://cloud.google.com/vertex-ai/docs/generative-ai/model-reference/claude)
