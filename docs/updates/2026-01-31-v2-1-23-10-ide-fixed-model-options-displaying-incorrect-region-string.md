---
title: "[IDE] Bedrockヘッドレスモードでのリージョン表示エラーを修正"
date: 2026-01-29
tags: ['バグ修正', 'VSCode', 'Bedrock', 'AWS', 'ヘッドレス']
---

## 原文（日本語に翻訳）

[IDE] ヘッドレスモードでBedrockユーザーのモデルオプションが誤ったリージョン文字列を表示する問題を修正

## 原文（英語）

[IDE] Fixed model options displaying incorrect region strings for Bedrock users in headless mode

## 概要

VS CodeなどのIDEでClaude Code拡張機能を使用し、かつAWS Bedrockをバックエンドとして使用している場合に、ヘッドレスモード（`--headless`）でモデルオプションを表示した際、AWSリージョンの文字列が正しく表示されない問題が修正されました。これにより、使用しているAWSリージョンが正確に表示され、設定ミスやコスト計算の誤りを防ぐことができます。

## 基本的な使い方

AWS Bedrockを使用するには、適切な認証情報とリージョンを設定する必要があります。

### Bedrock設定の基本

```json
// VS Code settings.json または ~/.claude/settings.json
{
  "claude": {
    "provider": "bedrock",
    "bedrock": {
      "region": "us-east-1",
      "profile": "default"
    }
  }
}
```

## 実践例

### リージョン表示の確認

修正前は、ヘッドレスモードでリージョンが誤って表示されていました。

```bash
# v2.1.22以前の問題
claude --headless "使用しているモデルとリージョンを教えて"

モデル: claude-3.5-sonnet
リージョン: undefined  # ← 誤った表示

# v2.1.23以降
claude --headless "使用しているモデルとリージョンを教えて"

モデル: claude-3.5-sonnet
リージョン: us-east-1  # ← 正しく表示
```

### CI/CD環境でのBedrock使用

```yaml
# .github/workflows/code-review.yml
name: Code Review with Claude Code

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    env:
      AWS_REGION: ap-northeast-1
      AWS_PROFILE: bedrock-user
    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-northeast-1

      - name: Run Claude Code
        run: |
          claude --headless "Review this PR"
          # v2.1.23では、リージョンが正しく ap-northeast-1 として認識される
```

### 複数リージョンでの使用

異なるリージョンを切り替えて使用する場合：

```bash
# us-east-1 リージョンで実行
AWS_REGION=us-east-1 claude --headless "タスク1"
# リージョン: us-east-1 と正しく表示

# ap-northeast-1 リージョンで実行
AWS_REGION=ap-northeast-1 claude --headless "タスク2"
# リージョン: ap-northeast-1 と正しく表示
```

### Dockerコンテナでの使用

```dockerfile
FROM node:20

# AWS認証情報を環境変数で設定
ENV AWS_REGION=eu-west-1
ENV AWS_PROFILE=default

# Claude Codeのインストール
RUN npm install -g @anthropic-ai/claude-code

# 設定ファイルのコピー
COPY .claude/settings.json /root/.claude/settings.json

# ヘッドレスモードで実行
CMD ["claude", "--headless", "Run tests and report results"]
```

### VSCode拡張機能での設定

```json
// .vscode/settings.json
{
  "claude.provider": "bedrock",
  "claude.bedrock.region": "us-west-2",
  "claude.bedrock.profile": "work-profile",
  "claude.model": "anthropic.claude-3-5-sonnet-20241022-v2:0"
}
```

VSCode内でターミナルを開いてヘッドレスモードで実行する場合も、正しいリージョンが表示されます。

## 注意点

- この修正はIDEの拡張機能（特にVS Code拡張）を使用している場合に適用されます
- AWS Bedrockを使用するには、適切なIAM権限が必要です
- リージョンによって利用可能なモデルが異なる場合があります
- リージョン間のレイテンシとコストも考慮してください（東京リージョン vs 米国リージョンなど）
- Bedrock経由での使用は、Anthropic APIを直接使用する場合と料金体系が異なります
- AWS認証情報が正しく設定されていない場合、リージョンも表示されません
- 環境変数`AWS_REGION`と設定ファイルの`region`が異なる場合、環境変数が優先されます
- この問題はヘッドレスモード特有のもので、インタラクティブモードでは影響がありませんでした

## 関連情報

- [AWS Bedrock Claude モデル](https://aws.amazon.com/bedrock/claude/)
- [AWS Bedrock リージョン別の利用可能性](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)
- [Claude Code Bedrock設定ガイド](https://code.claude.com/docs/bedrock)
- [Changelog v2.1.23](https://github.com/anthropics/claude-code/releases/tag/v2.1.23)
- AWS CLIのインストールと設定については、[AWS公式ドキュメント](https://docs.aws.amazon.com/cli/)を参照してください
