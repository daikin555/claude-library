---
title: "外部 CLAUDE.md インポート承認ダイアログにファイル情報を表示"
date: 2026-01-13
tags: ['改善', 'UI', 'CLAUDE.md', 'セキュリティ']
---

## 原文（日本語に翻訳）

外部 CLAUDE.md インポート承認ダイアログを改善し、どのファイルがどこからインポートされるかを表示

## 原文（英語）

Improved the external CLAUDE.md imports approval dialog to show which files are being imported and from where

## 概要

Claude Code v2.1.6 では、外部プロジェクトからの CLAUDE.md ファイルインポート時の承認ダイアログが改善されました。以前のバージョンでは、インポートを承認する際にどのファイルがどこから読み込まれるかが不明瞭でした。この改善により、インポートされるファイルの詳細情報が表示されるようになり、セキュリティと透明性が向上しました。

## 基本的な使い方

外部 CLAUDE.md ファイルを含むプロジェクトで作業する際:

1. プロジェクトディレクトリに移動
2. Claude Code を起動
3. 外部インポートを検出すると承認ダイアログが表示される
4. インポート元とファイル一覧を確認
5. 承認または拒否を選択

## 実践例

### 修正前の問題（v2.1.5以前）

不明瞭な承認ダイアログ:

```
╔════════════════════════════════════╗
║ External CLAUDE.md Detected        ║
║                                    ║
║ This project imports external      ║
║ configuration files.               ║
║                                    ║
║ Do you want to allow this?         ║
║                                    ║
║ [Allow] [Deny]                     ║
╚════════════════════════════════════╝

# どのファイルがインポートされるか不明
# どこから読み込まれるかわからない
# セキュリティリスクを判断できない
```

### 修正後の動作（v2.1.6以降）

v2.1.6 では、詳細な情報が表示されます:

```
╔═══════════════════════════════════════════════╗
║ External CLAUDE.md Imports                    ║
║                                               ║
║ The following files will be imported:         ║
║                                               ║
║ From: /home/user/shared/team-config/          ║
║   📄 CLAUDE.md                                ║
║   📄 prompts/coding-standards.md              ║
║   📄 prompts/review-checklist.md              ║
║                                               ║
║ From: /home/user/shared/project-templates/    ║
║   📄 CLAUDE.md                                ║
║                                               ║
║ These files will have access to your project. ║
║                                               ║
║ [Allow] [Deny] [View Details]                ║
╚═══════════════════════════════════════════════╝

# インポート元のパスが明確
# インポートされるファイルの一覧が表示される
# 安全性を確認してから承認できる
```

### CLAUDE.md のインポート設定

CLAUDE.md でのインポート宣言:

```markdown
<!-- CLAUDE.md -->

# Project Configuration

## Imports

<!-- Import shared team configuration -->
import: /home/user/shared/team-config/CLAUDE.md
import: /home/user/shared/project-templates/CLAUDE.md

## Project Settings
...
```

起動時に承認ダイアログが表示されます。

### インポート詳細の表示

「View Details」を選択した場合:

```
╔═══════════════════════════════════════════════╗
║ Import Details                                ║
║                                               ║
║ File: /home/user/shared/team-config/CLAUDE.md ║
║ Size: 2.4 KB                                  ║
║ Modified: 2026-01-30 14:23                    ║
║ Imports:                                      ║
║   - prompts/coding-standards.md (1.8 KB)      ║
║   - prompts/review-checklist.md (1.2 KB)      ║
║                                               ║
║ File: /home/user/shared/project-templates/... ║
║ Size: 1.1 KB                                  ║
║ Modified: 2026-01-25 09:15                    ║
║                                               ║
║ Total files to import: 4                      ║
║ Total size: 6.5 KB                            ║
║                                               ║
║ [Allow] [Deny]                                ║
╚═══════════════════════════════════════════════╝
```

### セキュリティチェック

インポートを承認する前の確認事項:

1. **インポート元の信頼性**
   ```
   From: /home/user/shared/team-config/
   # チームの公式設定ディレクトリか確認
   ```

2. **ファイルパスの妥当性**
   ```
   # 信頼できる場所からのインポートか？
   ✓ /home/user/shared/team-config/
   ✓ /opt/company/claude-config/

   # 疑わしい場所
   ✗ /tmp/unknown/
   ✗ /home/stranger/config/
   ```

3. **インポートされるファイルの確認**
   ```
   # 予期したファイルのみがリストされているか確認
   ```

### チーム設定のインポート

チーム共有の設定を使用:

```markdown
<!-- プロジェクトの CLAUDE.md -->

# My Project

<!-- チームの共通設定をインポート -->
import: /company/shared/claude/team-standards.md

<!-- プロジェクト固有の設定 -->
...
```

承認ダイアログで確認:
```
From: /company/shared/claude/
  📄 team-standards.md
  📄 coding-style.md
  📄 security-rules.md

# チームメンバーであれば承認
```

### プライベートプロジェクトでの注意

個人プロジェクトで外部インポートが検出された場合:

```
╔═══════════════════════════════════════════════╗
║ ⚠ Warning: Unexpected Import                 ║
║                                               ║
║ From: /tmp/downloaded/config/                 ║
║   📄 CLAUDE.md                                ║
║                                               ║
║ This import was not expected in this project. ║
║ Make sure you trust this source.             ║
║                                               ║
║ [Deny] [Allow Anyway]                         ║
╚═══════════════════════════════════════════════╝

# 不審なインポートは拒否
```

### インポートの記憶

一度承認したインポートを記憶:

```bash
# 初回起動時
# → 承認ダイアログが表示される

# 2回目以降
# → 同じインポートは自動的に許可される

# 設定を変更する場合
/config
# "imports" または "trust" で検索
# trustedImportPaths を編集
```

### インポートの拒否

インポートを拒否した場合:

```
╔═══════════════════════════════════════════════╗
║ Import Denied                                 ║
║                                               ║
║ External imports have been blocked.           ║
║ Claude Code will use default configuration.   ║
║                                               ║
║ You can change this in /config later.         ║
║                                               ║
║ [OK]                                          ║
╚═══════════════════════════════════════════════╝

# デフォルト設定で起動
```

## 注意点

- この改善は Claude Code v2.1.6 で導入されました
- 外部 CLAUDE.md ファイルをインポートする際に、詳細情報が表示されるようになりました
- インポート元のパスとファイル一覧を確認してから承認できます
- セキュリティリスクを評価しやすくなりました
- 信頼できるソースからのインポートのみを承認してください
- 一度承認したインポートは記憶され、次回から自動的に許可されます
- `/config` からインポートの信頼設定を管理できます
- 不審なパスからのインポートは拒否することを推奨します

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [CLAUDE.md 仕様](https://code.claude.com/docs/claude-md)
- [セキュリティベストプラクティス](https://code.claude.com/docs/security)
