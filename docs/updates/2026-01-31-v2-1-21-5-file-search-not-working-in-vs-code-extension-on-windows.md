---
title: "Windows版VSCode拡張でのファイル検索不具合を修正"
date: 2026-01-28
tags: ['バグ修正', 'Windows', 'VSCode']
---

## 原文（日本語に翻訳）

VS Code拡張のWindows版でファイル検索が動作しない問題を修正

## 原文（英語）

Fixed file search not working in VS Code extension on Windows

## 概要

Claude CodeのVS Code拡張において、Windows環境でファイル検索機能が正しく動作しない問題が修正されました。この問題により、WindowsユーザーがClaudeにファイルを探させようとしても検索が失敗し、コードベースの分析や編集作業が困難になっていました。v2.1.21では、Windowsのパス区切り文字（バックスラッシュ）やファイルシステムの違いが適切に処理されるようになり、すべてのプラットフォームで一貫した動作が保証されます。

## 基本的な使い方

VS Code拡張でClaude Codeを使用する際、Windowsでも他のOSと同様にファイル検索が機能します。

```bash
# VS CodeでClaude Codeを起動後
> src/配下のすべてのReactコンポーネントを探して

# Globツールとgrepツールが正しく動作
# Windows特有のパス（C:\Users\...）も正しく処理される
```

## 実践例

### プロジェクト内のファイル検索

VS Code拡張を使用してプロジェクト内のファイルを検索する場合：

```
> tsconfig.jsonファイルを探して内容を確認
# v2.1.21: Windowsでも正常に検索され、ファイルが見つかる
# v2.1.20以前: 検索が失敗し、ファイルが見つからない
```

### パターンマッチング検索

ワイルドカードを使った検索もWindows上で正常に動作します：

```
> src/**/*.tsxファイルをすべて検索
# Windowsのパス区切り文字（\）が正しく処理される
# 結果: src\components\Button.tsx
#       src\pages\Home.tsx
#       src\layouts\MainLayout.tsx
```

### コードベース全体の分析

大規模なプロジェクトでの検索も安定して動作します：

```
> プロジェクト内で"useState"を使用しているすべてのファイルを探して
# Grepツールが正しく動作し、Windows上でも高速に検索
# C:\Projects\myapp\src\components\Counter.tsx: 見つかりました
# C:\Projects\myapp\src\hooks\useAuth.tsx: 見つかりました
```

### VS Code統合での利用

VS Codeのサイドバーやターミナルからの検索が快適に：

```
> このワークスペースのpackage.jsonを確認
# Windowsの絶対パス（C:\Users\...）とUNCパス（\\server\share）の両方に対応
```

## 注意点

- この修正はv2.1.21で適用されました
- VS Code拡張をv2.1.21以降にアップデートする必要があります
- macOSやLinuxでは以前から正常に動作していました（影響なし）
- Windows特有のパス形式（ドライブレター、バックスラッシュ）が正しく処理されます
- UNCパス（`\\server\share`形式）も正常にサポートされます
- この問題によりWindows上でファイル検索ができなかった場合、v2.1.21へのアップデートで解決します
- 検索のパフォーマンスは、プロジェクトのサイズとファイル数に依存します

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.21](https://github.com/anthropics/claude-code/releases/tag/v2.1.21)
- [VS Code拡張機能ガイド](https://code.claude.com/docs/vscode)
- [Windows環境での設定ガイド](https://code.claude.com/docs/windows)
