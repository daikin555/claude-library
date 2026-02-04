---
title: "Bedrock・Vertex環境での実験的機能の無効化"
date: 2026-01-30
tags: [bedrock, vertex, environment-variables, troubleshooting]
---

# Bedrock・Vertex環境での実験的機能の無効化

## 概要

Claude Code 2.1.25では、AWS BedrockやGoogle Vertex AIといったゲートウェイ環境でベータヘッダー検証エラーが発生する問題が修正されました。環境変数 `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1` を設定することで、これらのプラットフォームでエラーを回避できます。

## 使い方

### 環境変数の設定

ターミナルで以下のコマンドを実行して、実験的なベータ機能を無効化します。

```bash
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
```

恒久的に設定する場合は、シェルの設定ファイル（`~/.bashrc`, `~/.zshrc` など）に追加してください。

```bash
# ~/.bashrc または ~/.zshrc に追加
echo 'export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1' >> ~/.bashrc
source ~/.bashrc
```

### Claude Codeの起動

環境変数を設定した後、通常通りClaude Codeを起動します。

```bash
claude
```

## 活用シーン

この設定は以下のような場合に役立ちます。

### 1. AWS Bedrockを使用している場合

企業環境やAWSインフラでClaude Codeを利用する際、Bedrockゲートウェイ経由でAPIにアクセスする場合に必要です。

```bash
export CLAUDE_CODE_USE_BEDROCK=1
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
claude
```

### 2. Google Vertex AIを使用している場合

Vertex AI環境でClaude Codeを使う場合、ベータ機能が原因で400エラーが発生することがあります。この環境変数を設定することで問題を回避できます。

```bash
export CLOUD_ML_REGION=us-central1
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
claude
```

### 3. 安定性を重視する本番環境

実験的な機能を無効化することで、より安定した動作を確保したい場合にも有効です。

## コード例

### シェルスクリプトでの設定

プロジェクトごとに環境を切り替える場合、以下のようなスクリプトを用意すると便利です。

```bash
#!/bin/bash
# start-claude-bedrock.sh

# Bedrock環境の設定
export CLAUDE_CODE_USE_BEDROCK=1
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
export AWS_REGION=us-east-1

# Claude Codeの起動
claude
```

実行権限を付与して使用します。

```bash
chmod +x start-claude-bedrock.sh
./start-claude-bedrock.sh
```

### Docker環境での設定

Dockerコンテナ内でClaude Codeを使用する場合の例。

```dockerfile
FROM node:20

# Claude Codeのインストール
RUN npm install -g @anthropic-ai/claude-code

# 環境変数の設定
ENV CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
ENV CLAUDE_CODE_USE_BEDROCK=1

# 作業ディレクトリの設定
WORKDIR /workspace

# Claude Codeの起動
CMD ["claude"]
```

## 注意点・Tips

### 注意点

1. **環境変数の優先順位**: この環境変数は、設定ファイル（`settings.json`）よりも優先されます。シェルで `export` コマンドを使って設定する必要があります。

2. **設定ファイルでの設定は無効**: 過去のバージョンでは、`settings.json` に `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` を記述しても効果がないというバグがありました。必ず環境変数として設定してください。

3. **機能制限**: この設定を有効にすると、Claude Codeの一部の実験的機能が使えなくなる可能性があります。

### Tips

- **設定確認**: 環境変数が正しく設定されているか確認するには、以下のコマンドを実行します。

```bash
echo $CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS
```

- **一時的な設定**: 特定のセッションでのみ設定を有効にしたい場合は、Claude Code起動時に直接指定できます。

```bash
CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1 claude
```

- **トラブルシューティング**: エラーが発生した場合は、`/doctor` コマンドで診断を実行してみてください。

```bash
# Claude Code内で実行
/doctor
```

## 参考情報

この修正により、BedrockやVertex AIを使用するゲートウェイユーザーが、ベータヘッダー検証エラーに遭遇することなくClaude Codeを利用できるようになりました。企業環境やクラウドプラットフォームでClaude Codeを安定して運用するための重要な設定です。

## 関連リンク

- [Claude Code on Amazon Bedrock - 公式ドキュメント](https://code.claude.com/docs/en/amazon-bedrock)
- [環境変数ガイド](https://www.eesel.ai/blog/environment-variables-claude-code)
