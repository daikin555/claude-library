---
title: 'Windows環境での誤ったファイル変更エラーを修正'
date: 2026-01-14
tags: ['バグ修正', 'Windows', 'ファイル監視']
---

## 原文（日本語に翻訳）

クラウド同期ツール、ウイルス対策スキャナー、またはGitがファイルの内容を変更せずにタイムスタンプだけを更新した際に、Windows上で誤った「ファイルが変更されました」エラーが表示される問題を修正しました。

## 原文（英語）

Fixed false "file modified" errors on Windows when cloud sync tools, antivirus scanners, or Git touch file timestamps without changing content

## 概要

Windows環境で、OneDrive、Dropbox、Google Driveなどのクラウド同期ツールや、Windows Defenderなどのウイルス対策ソフト、あるいはGit操作がファイルのタイムスタンプを更新した際、実際にはファイル内容が変わっていないにもかかわらず、Claude Codeが「ファイルが変更されました」という誤った警告を表示する問題が修正されました。

## 問題の詳細

### 修正前の動作

Claude Codeでファイルを編集中に、以下のような外部プロセスがファイルのタイムスタンプを更新すると：

- **クラウド同期ツール**: OneDrive、Dropbox、Google Driveがファイルメタデータを同期
- **ウイルス対策ソフト**: Windows Defenderや他のアンチウイルスがファイルをスキャン
- **Git操作**: `git checkout`や`git reset`がタイムスタンプを更新

Claude Codeは誤って「このファイルは外部で変更されました」というエラーを表示していました。

### 修正後の動作

v2.1.7以降、Claude CodeはWindowsでファイルの**内容のハッシュ値**を比較するようになり、タイムスタンプのみの変更では警告を表示しなくなりました。

## 実践例

### OneDriveと併用する場合

OneDriveフォルダ内のプロジェクトでClaude Codeを使用している場合。

**修正前:**
```
# ファイルを編集中
# OneDriveがバックグラウンドでメタデータを同期
❌ Error: file.ts has been modified externally
```

**修正後（v2.1.7）:**
```
# ファイルを編集中
# OneDriveがバックグラウンドでメタデータを同期
✓ 正常に動作（誤警告なし）
```

### ウイルス対策ソフトが有効な環境

Windows Defenderのリアルタイムスキャンが有効な環境でファイル編集を行う場合。

**修正前:**
```
# Pythonスクリプトを編集中
# Windows Defenderがファイルをスキャン
❌ Error: script.py has been modified externally
```

**修正後（v2.1.7）:**
```
# 内容が実際に変更された場合のみ警告
✓ タイムスタンプのみの変更は無視
```

### Git操作との併用

ブランチ切り替え後にClaude Codeでファイルを編集する場合。

```bash
git checkout feature-branch
# Gitがファイルのタイムスタンプを更新
```

**修正前:** Claude Codeで編集しようとすると誤警告
**修正後:** 内容が変わっていれば警告、タイムスタンプのみなら無視

## 技術的な改善点

- **タイムスタンプベース → ハッシュベース**: ファイル変更検知をタイムスタンプではなく内容のハッシュ値で判定
- **パフォーマンス**: ハッシュ計算のオーバーヘッドは最小限
- **正確性**: 実際にファイル内容が変わった場合のみ警告を表示

## 注意点

- **Windows固有の修正**: この問題は主にWindows環境で発生していたため、修正もWindows固有です
- **真の変更は検知される**: 実際にファイル内容が外部で変更された場合は、引き続き警告が表示されます
- **同期遅延**: クラウド同期ツールによる実際の内容変更は正しく検知されますが、同期のタイミングによっては若干の遅延があります
- **大きなファイル**: 非常に大きなファイル（数百MB以上）の場合、ハッシュ計算にわずかな時間がかかる場合があります

## 影響を受けるツール

この修正により、以下のツールとの互換性が改善されました：

- **クラウドストレージ**: OneDrive、Dropbox、Google Drive、iCloud Drive
- **ウイルス対策**: Windows Defender、Norton、McAfee、Avast
- **バージョン管理**: Git（特にcheckout、reset、rebase操作）
- **IDEとの併用**: VS Code、JetBrains IDEなど

## 関連情報

- [Windows環境での Claude Code 使用ガイド](https://code.claude.com/docs/)
- [ファイル監視システムの仕組み](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
