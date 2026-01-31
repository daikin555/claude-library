---
title: "ファイル内容が変更されていない時の誤った変更警告を修正"
date: 2026-01-13
tags: ['バグ修正', 'ファイル監視', 'エラー処理']
---

## 原文（日本語に翻訳）

ファイルウォッチャーが内容を変更せずにファイルに触れた時に発生する誤った「ファイルが予期せず変更されました」エラーを修正

## 原文（英語）

Fixed false "File has been unexpectedly modified" errors when file watchers touch files without changing content

## 概要

Claude Code v2.1.6 では、ファイル監視システムの問題が修正されました。以前のバージョンでは、ファイルの内容が実際には変更されていないのに、ファイルウォッチャーがタイムスタンプのみを更新した場合に「ファイルが予期せず変更されました」という警告が誤って表示されていました。この修正により、実際の内容変更のみが検出されるようになり、不要な警告が減少します。

## 基本的な使い方

この修正は自動的に適用され、ユーザー側での設定変更は不要です。

通常のファイル編集時:
1. Claude が ファイルを編集する
2. 他のツール（IDE、ビルドツール、linter など）がファイルに触れる
3. 内容が変更されていない場合、警告は表示されない
4. 実際に内容が変更された場合のみ警告が表示される

## 実践例

### 修正前の問題（v2.1.5以前）

以下のようなシナリオで誤警告が発生していました:

```bash
# Claude がファイルを編集中
# 同時に IDE のファイルウォッチャーがタイムスタンプを更新
# → 内容は変更されていないのに警告が表示される

Warning: File has been unexpectedly modified
src/app.ts has changed outside of Claude Code
```

この警告は、実際にはファイル内容が変更されていない場合でも表示されていました。

### 修正後の動作（v2.1.6以降）

v2.1.6 では、内容の実際の変更のみを検出:

```bash
# Claude がファイルを編集中
# IDE がタイムスタンプのみを更新
# → 警告は表示されない（内容が同じため）

# しかし、実際に内容が変更された場合
# → 正しく警告が表示される
Warning: File has been unexpectedly modified
src/app.ts has changed outside of Claude Code
```

### よくある誤警告のケース

以下の場合に誤警告が発生していましたが、v2.1.6 で修正されました:

1. **IDEのオートフォーマット**
   - VSCode、IntelliJ などが保存時にファイルに触れる
   - 実際にはフォーマット変更がない場合でもタイムスタンプが更新される

2. **ビルドツール**
   - webpack、vite などがファイルを監視
   - リロード判定のためにタイムスタンプをチェック

3. **Git操作**
   - `git checkout` や `git pull` がタイムスタンプを更新
   - 内容が同じブランチでも警告が出ていた

4. **Linter/Formatter**
   - eslint、prettier などが `--fix` モードで実行
   - 変更不要な場合でもファイルに触れる

### 実際の変更を検出する

実際にファイルが変更された場合、正しく検出されます:

```bash
# シナリオ: Claude がファイル編集中に、別の開発者が同じファイルを変更

# Claude Code が正しく警告を表示
Warning: src/app.ts has been modified externally
Content may have conflicts. Please review before continuing.

# オプション:
# 1. Reload - 外部の変更を読み込む
# 2. Keep - Claude の変更を保持
# 3. Diff - 差分を確認
```

### ファイル監視の設定

ファイル監視の動作を調整:

```bash
/config
# "file" または "watch" で検索

# 設定例:
# fileWatcherEnabled: true/false
# fileWatcherIgnorePatterns: ["node_modules/**", "build/**"]
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- 内容ベースの検出により、タイムスタンプのみの変更では警告が表示されなくなりました
- 実際のコンテンツ変更は引き続き正しく検出され、警告が表示されます
- ファイルの内容比較にはわずかなオーバーヘッドがありますが、通常は気づかない程度です
- この修正により、開発環境の他のツールとの連携がスムーズになります
- 大規模なファイル（数MB以上）の場合、内容比較に若干時間がかかる可能性があります

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Claude Code ファイル監視設定](https://code.claude.com/docs/configuration#file-watching)
