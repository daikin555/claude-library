---
title: "Bedrock/Vertexユーザーの--model haikuでモデル選択表示が不正確な問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'モデル選択', 'Bedrock', 'Vertex', 'UI']
---

## 原文（日本語に翻訳）

`--model haiku`を使用するBedrock/Vertexユーザーに対して、モデル選択表示が不正確に表示される問題を修正しました

## 原文（英語）

Fixed model picker showing incorrect selection for Bedrock/Vertex users using `--model haiku`

## 概要

Claude Code v2.1.0で修正された、モデル選択UI表示バグです。BedrockやVertex AIで`--model haiku`を指定しても、UIには別のモデルが選択されているように表示されていました。修正後は、実際に使用中のモデルが正しく表示されます。claude --model bedrock/claude-haikuでUIを確認すると、正しくhaikuが選択表示されます。

## 注意点

- Claude Code v2.1.0で実装
- Bedrock/Vertex AIプロバイダー固有の問題
- モデル表示と実際のモデルの不一致を解消
- UIの正確性向上

## 関連情報

- [Model providers - Claude Code Docs](https://code.claude.com/docs/en/model-providers)
- [Bedrock configuration](https://code.claude.com/docs/en/bedrock)
- [Vertex AI configuration](https://code.claude.com/docs/en/vertex)
