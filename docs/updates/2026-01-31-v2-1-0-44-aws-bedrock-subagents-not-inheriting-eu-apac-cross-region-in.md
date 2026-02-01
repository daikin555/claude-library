---
title: "AWS Bedrockサブエージェントが地域限定IAM権限で403エラーになる問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'AWS Bedrock', 'クロスリージョン']
---

## 原文（日本語に翻訳）

IAM権限が特定リージョンにスコープされている場合に403エラーを引き起こしていた、AWS BedrockサブエージェントがEU/APACクロスリージョン推論モデル設定を継承しない問題を修正しました

## 原文（英語）

Fixed AWS Bedrock subagents not inheriting EU/APAC cross-region inference model configuration, causing 403 errors when IAM permissions are scoped to specific regions

## 概要

Claude Code v2.1.0で修正された、AWS Bedrock使用時のサブエージェント実行バグです。以前のバージョンでは、親エージェントでEUやAPACリージョンのクロスリージョン推論設定を使用していても、サブエージェント（Taskツールで起動されるエージェント）がこの設定を継承せず、デフォルトのus-east-1リージョンにアクセスしようとしていました。IAM権限が特定リージョンに限定されている場合、403 Forbiddenエラーが発生してサブエージェントが動作しませんでした。

## 修正前の問題

### 症状

```bash
# EUリージョンのBedrock設定
export AWS_BEDROCK_REGION=eu-west-1
export AWS_BEDROCK_CROSS_REGION_INFERENCE=true

# IAM権限をeu-west-1に限定
# {
#   "Effect": "Allow",
#   "Action": "bedrock:InvokeModel",
#   "Resource": "arn:aws:bedrock:eu-west-1:*:*"
# }

# Claude Code起動（親エージェント）
claude --model bedrock/claude-sonnet-4

> /feature-dev を使ってこの機能を実装

# 親エージェント: ✓ eu-west-1で動作
# サブエージェント起動（feature-dev:code-architect）
# サブエージェント: us-east-1にアクセス試行
# エラー: 403 Forbidden - IAM権限がus-east-1を許可していない

Error: User is not authorized to perform: bedrock:InvokeModel on resource: arn:aws:bedrock:us-east-1:...
```

### 根本原因

```
親エージェント設定:
- Region: eu-west-1
- Cross-region inference: enabled

サブエージェント起動（Task tool）:
- 設定の継承なし
- デフォルト設定を使用
- Region: us-east-1（デフォルト）

IAM権限:
- 許可: eu-west-1のみ
- 拒否: us-east-1

結果: 403エラー
```

## 修正後の動作

### 設定の自動継承

```bash
# EUリージョン設定
export AWS_BEDROCK_REGION=eu-west-1
export AWS_BEDROCK_CROSS_REGION_INFERENCE=true

# Claude Code起動
claude --model bedrock/claude-sonnet-4

> /feature-dev を使って実装

# 親エージェント: eu-west-1で動作
# サブエージェント起動
# 修正後: 親の設定を継承
# サブエージェント: eu-west-1で動作
# ✓ 成功
```

## 実践例

### EUリージョン限定環境での使用

GDPR準拠のため、EUリージョンのみを使用する環境です。

```bash
# EU専用設定
export AWS_BEDROCK_REGION=eu-central-1
export AWS_BEDROCK_CROSS_REGION_INFERENCE=true

# IAM: eu-central-1のみ許可
claude --model bedrock/claude-sonnet-4

> 複雑なリファクタリングを実行
# 複数のサブエージェントが起動

# 修正前: サブエージェントが403エラー
# 修正後: すべてのサブエージェントがeu-central-1を使用
# ✓ 正常動作
```

### APACリージョンでの高速応答

シドニーやシンガポールのユーザー向けに低レイテンシを実現します。

```bash
# APACリージョン設定
export AWS_BEDROCK_REGION=ap-southeast-2  # Sydney
export AWS_BEDROCK_CROSS_REGION_INFERENCE=true

claude --model bedrock/claude-sonnet-4

> /plan を実行してアーキテクチャ設計

# Plan agent: ap-southeast-2で動作
# サブエージェント（各種分析エージェント）
# 修正後: すべてap-southeast-2を使用
# ✓ 低レイテンシで高速応答
```

### マルチリージョン戦略での一貫性

異なるリージョンで同じコードベースを使用します。

```bash
# 開発環境（US）
export AWS_BEDROCK_REGION=us-west-2

# 本番環境（EU）
export AWS_BEDROCK_REGION=eu-west-1

# どちらの環境でも
claude --model bedrock/claude-sonnet-4

> エージェントを使った自動化タスク

# 修正後: 各環境のリージョン設定を正しく継承
# ✓ 環境ごとに適切なリージョンを使用
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- AWS Bedrockのクロスリージョン推論:
  - 複数のリージョンでモデルを利用可能にする機能
  - 地域規制やレイテンシ要件に対応
  - 環境変数で設定: `AWS_BEDROCK_CROSS_REGION_INFERENCE=true`
- サポートされるリージョン（例）:
  - **US**: us-east-1, us-west-2
  - **EU**: eu-west-1, eu-central-1
  - **APAC**: ap-southeast-1 (Singapore), ap-southeast-2 (Sydney), ap-northeast-1 (Tokyo)
- 設定の継承:
  - 親エージェントの `AWS_BEDROCK_REGION` がサブエージェントに継承される
  - `AWS_BEDROCK_CROSS_REGION_INFERENCE` 設定も継承される
  - エンドポイント設定も継承される
- IAM権限の設定例:
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "bedrock:InvokeModel",
        "Resource": "arn:aws:bedrock:eu-west-1:*:foundation-model/*"
      }
    ]
  }
  ```
- 環境変数の設定:
  ```bash
  # リージョン指定
  export AWS_BEDROCK_REGION=eu-west-1

  # クロスリージョン推論を有効化
  export AWS_BEDROCK_CROSS_REGION_INFERENCE=true

  # カスタムエンドポイント（オプション）
  export AWS_BEDROCK_ENDPOINT=https://bedrock-runtime.eu-west-1.amazonaws.com
  ```
- 影響を受けるエージェント:
  - Taskツールで起動されるすべてのサブエージェント
  - カスタムエージェント
  - 組み込みエージェント（Explore, Planなど）
- デバッグ:
  - `--debug` フラグでリージョン設定の継承を確認
  - ログに「Using inherited Bedrock region: eu-west-1」が表示される
- コスト最適化:
  - クロスリージョン推論により、最も近いリージョンを自動選択可能
  - レイテンシ削減と帯域幅コスト削減
- セキュリティ:
  - GDPR準拠にはEUリージョンが必須
  - データ主権要件に応じてリージョンを選択
- トラブルシューティング:
  - 403エラーが出る場合、IAM権限のリージョン制限を確認
  - AWS CLIで権限をテスト:
    ```bash
    aws bedrock-runtime invoke-model \
      --region eu-west-1 \
      --model-id anthropic.claude-sonnet-4 \
      --body '{"prompt": "test"}' \
      output.json
    ```

## 関連情報

- [AWS Bedrock with Claude Code](https://code.claude.com/docs/en/aws-bedrock)
- [Cross-region inference - AWS Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html)
- [IAM policies for Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/security-iam.html)
