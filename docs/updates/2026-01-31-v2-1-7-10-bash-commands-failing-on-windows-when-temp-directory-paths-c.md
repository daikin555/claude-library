---
title: "Windows一時ディレクトリパスのエスケープシーケンス問題を修正"
date: 2026-01-14
tags: ['バグ修正', 'Windows', 'bash', 'コマンド']
---

## 原文（日本語に翻訳）

一時ディレクトリのパスに`t`や`n`のような文字が含まれ、エスケープシーケンスとして誤って解釈されることで、Windows上でbashコマンドが失敗する問題を修正しました。

## 原文（英語）

Fixed bash commands failing on Windows when temp directory paths contained characters like `t` or `n` that were misinterpreted as escape sequences

## 概要

Windows環境で、一時ディレクトリのパスに特定の文字（`t`, `n`, `r`など）が含まれている場合、これらがエスケープシーケンス（`\t`=タブ、`\n`=改行、`\r`=キャリッジリターン）として誤って解釈され、bashコマンドが失敗する問題が修正されました。

## 問題の詳細

### 問題が発生するパスの例

```
C:\Users\nathan\AppData\Local\Temp
      ↑ \n が改行として解釈される

C:\projects\testproject\tmp
             ↑ \t がタブとして解釈される

C:\data\reports\output
        ↑ \r がキャリッジリターンとして解釈される
```

### 修正前の動作

```bash
# ユーザー名が "nathan" の場合
temp_file = "C:\Users\nathan\AppData\Local\Temp\claude_temp.txt"
           → "C:\Users
athan\..." # \n が改行に変換される

❌ Error: Invalid path
❌ Bash command failed
```

### 修正後の動作

```bash
# パスを正しくエスケープ
temp_file = "C:\\Users\\nathan\\AppData\\Local\\Temp\\claude_temp.txt"
           → 正しいパスとして認識される

✓ Bash command executes successfully
```

## 実践例

### ユーザー名に "n" を含む場合

**ユーザー名:** `nathan`, `johndoe`, `jane`など

**修正前:**
```
Working directory: C:\Users\nathan\...
❌ All bash commands fail
Error: Path not found
```

**修正後（v2.1.7）:**
```
Working directory: C:\Users\nathan\...
✓ All bash commands work correctly
```

### プロジェクトパスに "t" を含む場合

**プロジェクトパス:** `C:\projects\testapp\`, `C:\data\reports\`

**修正前:**
```bash
$ claude "Run npm install"
❌ Error: Invalid working directory
```

**修正後（v2.1.7）:**
```bash
$ claude "Run npm install"
✓ npm install runs successfully
```

### 一時ファイル操作

bashツールが一時ファイルを作成する際：

**修正前:**
```
Creating temp file at: C:\Users\nathan\AppData\Local\Temp\
❌ File creation failed
```

**修正後（v2.1.7）:**
```
Creating temp file at: C:\Users\nathan\AppData\Local\Temp\
✓ File created successfully
```

## 影響を受けるシナリオ

この修正により、以下のシナリオが改善されました：

- **ユーザー名に特定文字を含む**: nathan, anna, robert, など
- **プロジェクトパスに特定文字を含む**: test, data, reports, など
- **一時ディレクトリ**: `\temp`, `\tmp`などのパス
- **すべてのbashコマンド**: git, npm, python, など全てが影響

## 技術的な改善点

- **パスエスケープ**: Windowsパスの`\`を`\\`に正しくエスケープ
- **自動検出**: エスケープが必要な文字を自動的に検出
- **透過的な動作**: ユーザーは何も意識する必要がない

## 注意点

- **Windows固有**: この問題と修正はWindows環境のみに関連します
- **後方互換性**: 既存のコードに影響はありません
- **手動回避策不要**: v2.1.7以降、手動でパスをエスケープする必要はありません

## 関連情報

- [Windows環境での Claude Code 使用ガイド](https://code.claude.com/docs/)
- [Bash Tool ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
