---
title: "ExFATなど大きなinode値を持つファイルシステムでの誤検出修正"
date: 2026-01-09
tags: ['バグ修正', 'ファイルシステム', 'スキル']
---

## 原文（日本語に翻訳）

大きなinode値を持つファイルシステム（ExFATなど）で発生していたスキル重複の誤検出を、64ビット精度のinode値を使用することで修正しました

## 原文（英語）

Fixed false skill duplicate detection on filesystems with large inodes (e.g., ExFAT) by using 64-bit precision for inode values

## 概要

Claude Code v2.1.3では、ExFATなどの特定のファイルシステムで発生していた、スキルの重複検出に関する誤報問題が修正されました。inode値の処理を64ビット精度に変更することで、大きなinode値を正しく扱えるようになり、実際には異なるスキルファイルが誤って重複として検出される問題が解消されました。

## 基本的な使い方

この修正は自動的に適用されるため、ユーザー側での特別な操作は不要です。

```bash
# ExFATドライブでClaude Codeを使用する場合
# v2.1.3以降では、スキルの重複警告が正確に動作する
```

## 実践例

### 修正前の問題

ExFATなどのファイルシステムでスキルを管理すると、誤った重複警告が表示されることがありました。

```bash
# 修正前の動作例
# ExFATドライブに複数のスキルを配置

/my-skills/
  ├── skill-a.js  # inode: 4294967296
  └── skill-b.js  # inode: 4294967297

# 誤検出が発生：
# ⚠️ Warning: Duplicate skill detected
#    skill-a.js and skill-b.js appear to be the same file
# （実際には異なるファイル）
```

### 修正後の動作

v2.1.3では、大きなinode値も正確に処理されます。

```bash
# 修正後の動作例
# ExFATドライブに複数のスキルを配置

/my-skills/
  ├── skill-a.js  # inode: 4294967296（正しく認識）
  └── skill-b.js  # inode: 4294967297（正しく認識）

# 誤検出なし：
# ✅ 2 skills loaded successfully
```

### 影響を受けるファイルシステム

以下のファイルシステムで特に効果があります。

```bash
# 大きなinode値を持つファイルシステム
# - ExFAT（外付けドライブで一般的）
# - FAT32（一部の環境）
# - ネットワークドライブ（NFS、Sambaなど）

# 使用例：
# 外付けドライブ（ExFAT）にスキルを保存
/Volumes/ExternalDrive/claude-skills/
  ├── project-helper.js
  ├── code-formatter.js
  └── documentation-gen.js
# すべて正しく個別のスキルとして認識される
```

### 複数環境での利用

クラウドストレージや外付けドライブでスキルを共有する場合に特に有用です。

```bash
# Dropbox、OneDrive、Google Driveなどでスキルを同期
~/Dropbox/claude-skills/
  └── shared-skills/
      ├── team-skill-1.js
      ├── team-skill-2.js
      └── team-skill-3.js

# 各環境で正しく読み込まれる
# - Windows（ExFAT USB）
# - macOS（ExFAT外付けHDD）
# - Linux（FUSE経由のクラウドドライブ）
```

## 注意点

- この修正は内部的な変更であり、スキルの使用方法に変更はありません
- ExFATドライブを使用している場合、v2.1.3へのアップデートを推奨します
- 以前のバージョンで誤検出が発生していた場合、v2.1.3で自動的に解消されます
- 通常のファイルシステム（NTFS、APFS、ext4など）では元々この問題は発生していませんでした

## 関連情報

- [Claude Code 公式ドキュメント](https://claude.ai/code)
- [Changelog v2.1.3](https://github.com/anthropics/claude-code/releases/tag/v2.1.3)
- [スキル管理のベストプラクティス](https://github.com/anthropics/claude-code)
- [ファイルシステムの互換性](https://github.com/anthropics/claude-code)
