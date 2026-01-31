---
title: "`/copy`コマンドを全ユーザーに開放"
date: 2026-01-27
tags: ['機能変更', 'コマンド', 'アクセシビリティ']
---

## 原文（日本語に翻訳）

`/copy`コマンドを全てのユーザーが利用できるよう変更

## 原文（英語）

Changed the `/copy` command to be available to all users

## 概要

Claude Code v2.1.20では、以前は一部のユーザーに限定されていた`/copy`コマンドが、全てのユーザーに開放されました。このコマンドを使用することで、会話の内容やコード、エージェントの出力を簡単にクリップボードにコピーできるようになります。この変更により、すべてのユーザーが効率的に情報を共有し、他のアプリケーションで活用できるようになります。

## 基本的な使い方

`/copy`コマンドで様々なコンテンツをコピーできます：

```bash
# 直前のエージェント応答をコピー
> /copy

✓ Copied last response to clipboard

# 特定のコードブロックをコピー
> /copy code

✓ Copied code block to clipboard

# 会話全体をコピー
> /copy all

✓ Copied entire conversation to clipboard
```

## 実践例

### コード例の共有

エージェントが生成したコードをSlackやメールで共有：

```bash
> Pythonでファイルを読み込む関数を書いて

# エージェントがコード生成:
```python
def read_file(file_path):
    """Read and return file contents."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        print(f"Error: {file_path} not found")
        return None
```

# コードをコピー
> /copy code

✓ Copied code to clipboard

# 変更前の問題：
# - /copy コマンドが使えない
# - 手動で選択してコピー（ターミナルで面倒）
# - フォーマットが崩れることがある

# 変更後の利点：
# - ワンコマンドでコピー
# - フォーマット維持
# - すぐにSlackやドキュメントに貼り付け可能
```

### ドキュメント作成

技術ドキュメントやREADMEの作成：

```bash
> このAPIエンドポイントの使い方を説明して

# エージェントが詳細な説明を生成...

# 説明をコピー
> /copy

✓ Copied to clipboard

# Markdownエディタに貼り付け
# README.mdに追加
# ConfluenceやNotionにアップロード

# 変更により：
# - ドキュメント作成がスムーズ
# - 全ユーザーが恩恵を受ける
# - 知識共有が促進される
```

### バグレポートの作成

エラーログやスタックトレースを共有：

```bash
> このエラーを分析して

Error: Cannot read property 'user' of undefined
  at getUserData (app.js:42)
  at processRequest (server.js:128)
  ...

# エージェントが分析結果を提示

# 分析結果をコピー
> /copy

✓ Copied analysis to clipboard

# GitHub Issueに貼り付け：
# ┌─────────────────────────────────────┐
# │ Bug Report                          │
# ├─────────────────────────────────────┤
# │ Error Analysis:                     │
# │ [Claudeの分析内容をペースト]        │
# │                                     │
# │ Root Cause: ...                     │
# │ Suggested Fix: ...                  │
# └─────────────────────────────────────┘

# チーム全体で情報共有が容易に
```

### コマンド履歴の保存

よく使うコマンドシーケンスを記録：

```bash
> この環境をセットアップする手順を教えて

# エージェントがステップバイステップ説明:
1. npm install
2. cp .env.example .env
3. npm run db:migrate
4. npm run dev

# 手順をコピー
> /copy

✓ Copied to clipboard

# setup.mdとして保存
# 新しいチームメンバーに共有
# オンボーディングドキュメントに追加

# 全ユーザーが使えることで：
# - 社内ドキュメントの充実
# - ナレッジの標準化
```

### 会議メモの作成

技術的な議論の記録：

```bash
# 会話の中で設計案を議論...

> このアーキテクチャの利点と欠点をまとめて

# エージェントが包括的なサマリーを生成

# 会話全体をコピー
> /copy all

✓ Copied entire conversation (234 lines) to clipboard

# Google Docsに貼り付け
# 会議メモとして保存
# 関係者に共有

# 変更の効果：
# - 全員が会議記録を簡単に作成
# - 情報の透明性向上
```

### レビューコメントの準備

コードレビューでの活用：

```bash
> このコードのリファクタリング案を提示して

# エージェントが改善案を生成...

Before:
```javascript
function processData(data) {
  // 複雑な実装...
}
```

After:
```javascript
function processData(data) {
  // リファクタリング版...
}
```

# レビューコメントとしてコピー
> /copy

✓ Copied to clipboard

# GitHub PRのコメント欄に貼り付け
# 建設的なフィードバックを提供

# 全ユーザーが使えることで：
# - レビュー品質の向上
# - 一貫したフィードバック
```

### スニペットライブラリの構築

再利用可能なコードを蓄積：

```bash
> よく使うユーティリティ関数を作って

# エージェントが便利な関数を生成

> /copy code

✓ Copied to clipboard

# snippets.txt に追加
# VS Codeのスニペットとして登録
# チームのライブラリに貢献

# 民主化の効果：
# - 全員がスニペットを貢献
# - 集合知の蓄積
# - チーム全体の生産性向上
```

### トラブルシューティングログ

サポートチケットの作成：

```bash
> この問題のトラブルシューティングを手伝って

# 長いデバッグセッション...
# 試行錯誤の記録...

> /copy all

✓ Copied full debugging session (450 lines) to clipboard

# サポートチケットに添付
# 問題の全体像を共有
# 効率的な問題解決

# 全ユーザーがアクセスできることで：
# - サポート品質の向上
# - 早期の問題解決
```

## 注意点

- `/copy` コマンドは現在の会話セッション内のコンテンツのみをコピーします
- 非常に長い会話をコピーする場合、クリップボードの容量制限に注意してください
- コピーされたテキストのフォーマットは、貼り付け先のアプリケーションによって異なる場合があります
- コードブロックは言語情報を含めてコピーされます（多くの場合、Markdown形式）
- この機能は全てのプラットフォーム（macOS、Linux、Windows）で利用可能です

## 関連情報

- [Slash Commands Reference](https://code.claude.com/docs/en/reference/slash-commands)
- [Copy Command](https://code.claude.com/docs/en/commands/copy)
- [Clipboard Integration](https://code.claude.com/docs/en/features/clipboard)
- [Sharing Workflows](https://code.claude.com/docs/en/best-practices/sharing)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
