---
title: "MCPツールレスポンスの特殊Unicode文字によるJSONパースエラーを修正"
date: 2026-01-27
tags: ['バグ修正', 'MCP', 'Unicode', 'JSON']
---

## 原文（日本語に翻訳）

MCPツールのレスポンスに特殊なUnicode文字が含まれる場合のJSONパースエラーを修正

## 原文（英語）

Fixed JSON parsing errors when MCP tool responses contain special Unicode characters

## 概要

Claude Code v2.1.20では、MCP（Model Context Protocol）サーバーからのツールレスポンスに特殊なUnicode文字が含まれている場合、JSONパースが失敗する問題が修正されました。以前は、絵文字や制御文字、非BMP文字などが含まれるとエラーが発生し、MCPツールが正常に動作しませんでした。この修正により、多様な文字セットを扱うMCPツールが安定して動作するようになります。

## 基本的な使い方

この修正は自動的に適用され、MCPツールを使用する際に特別な設定は不要です：

```bash
# MCPサーバーが絵文字や特殊文字を返す場合でも正常に動作
claude
> @database データベースから最新のユーザー情報を取得して

# レスポンス例（特殊文字を含む）：
# {
#   "username": "田中太郎 🎌",
#   "status": "アクティブ ✅",
#   "notes": "特記事項：改行\nタブ\t終わり"
# }

# 修正前：JSONパースエラーが発生
# 修正後：正しくパースされ、情報が表示される
```

## 実践例

### 国際化されたデータの取得

多言語対応のMCPツールを使用する場合：

```bash
# データベースMCPツール経由で多言語データを取得
> @database 全ユーザーの表示名を取得

# レスポンスに様々なUnicode文字が含まれる：
# - 日本語：田中太郎
# - 中国語：王小明
# - 韓国語：김철수
# - 絵文字：John Doe 😊
# - アラビア語：محمد
# - 特殊記号：User™ ©2024

# すべて正しくパースされ表示される
```

### ログファイルの解析

制御文字や改行を含むログをMCPツールで処理：

```bash
> @logs 最新のエラーログを取得

# MCPツールが返すログ（制御文字含む）：
# "error_message": "接続エラー\nホスト: db.example.com\nポート: 5432\t原因: タイムアウト"

# 修正により：
# - \n（改行）が正しく処理される
# - \t（タブ）が正しく処理される
# - マルチバイト文字（日本語）もエラーにならない
```

### ソーシャルメディアデータの取得

絵文字や特殊文字を多用するデータソースから情報を取得：

```bash
> @social 最新のツイートを10件取得

# MCPツールのレスポンス：
# [
#   {"text": "今日は良い天気ですね ☀️🌈", "likes": 42},
#   {"text": "新機能リリース 🚀🎉", "likes": 128},
#   {"text": "バグ修正完了 ✅💪", "likes": 56}
# ]

# 修正前の問題：
# - 絵文字を含むJSONがパースエラー
# - ツール実行が失敗

# 修正後：
# - すべての絵文字が正しく処理される
# - データが正常に取得・表示される
```

### ファイルシステムMCPツール

特殊な文字を含むファイル名やパスの処理：

```bash
> @filesystem "📁プロジェクト/🎨デザイン" ディレクトリの内容を表示

# MCPツールが返すファイルリスト：
# {
#   "files": [
#     "ロゴ_v2.0.png",
#     "スクリーンショット①.jpg",
#     "デザイン仕様書（最終版）.pdf"
#   ]
# }

# 修正により：
# - 全角括弧（）が正しく処理
# - 丸数字①が正しく処理
# - 絵文字を含むパスが正しく処理
```

### APIレスポンスのデバッグ

MCP開発者がツールをテストする場合：

```javascript
// MCPサーバー側のコード
{
  "name": "get_user_info",
  "description": "ユーザー情報を取得",
  "parameters": {},
  "response": {
    "user": {
      "name": "山田花子",
      "bio": "エンジニア👩‍💻 | 東京在住🗼 | コーヒー好き☕",
      "emoji_status": "🎯"
    }
  }
}

// 修正前：
// - bioフィールドの絵文字でパースエラー
// - MCPツールが使用不可

// 修正後：
// - すべてのフィールドが正しく処理される
// - 開発とデバッグがスムーズに
```

## 注意点

- この修正はMCPサーバーからのレスポンスのパース処理に適用されます
- MCPサーバー側が有効なJSON形式を返す必要があります（この修正は文字エンコーディングの問題のみを解決）
- 非常に大きなUnicode文字（4バイト文字）も正しく処理されます
- 制御文字（\n, \t, \r など）はJSON仕様に従ってエスケープされている必要があります
- この問題は主に国際化対応のMCPツールや、ユーザー生成コンテンツを扱うツールで発生していました

## 関連情報

- [MCP (Model Context Protocol)](https://code.claude.com/docs/en/mcp/overview)
- [MCP Tool Development](https://code.claude.com/docs/en/mcp/creating-tools)
- [Unicode Support](https://code.claude.com/docs/en/reference/unicode-support)
- [MCP Specification](https://modelcontextprotocol.io/)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
