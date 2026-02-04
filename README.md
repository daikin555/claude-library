# Claude Library

Claude Codeのchangelog監視と活用ガイド記事の自動生成システム。

## 概要

このプロジェクトは、Claude Codeの公式changelogを定期的に監視し、新機能の日本語活用ガイド記事を自動生成します。

## ディレクトリ構成

```
.
├── docs/updates/          # ガイド記事（Markdown）
├── data/
│   ├── last-known-changelog.md  # 前回取得したchangelog
│   ├── current-changelog.md     # 最新のchangelog
│   └── new-entries.md           # 新規エントリ（差分）
├── scripts/
│   ├── detect-changes.sh        # changelog差分検出
│   ├── check-coverage.sh        # 記事カバレッジチェック
│   ├── generate_articles.py     # 記事生成スクリプト
│   └── generate-individual-articles.sh
└── .github/workflows/
    └── monitor-changelog.yml   # 自動監視ワークフロー
```

## 記事作成ガイド

### 自動生成（GitHub Actions）

GitHub Actionsが毎日22:00 UTC（JST 07:00）に自動実行され、新しいchangelog項目を検出すると自動的に記事を生成します。

### 手動生成

```bash
# 1. changelogの差分を検出
bash scripts/detect-changes.sh

# 2. 記事を生成（Python）
python scripts/generate_articles.py

# 3. または、シェルスクリプト版
bash scripts/generate-individual-articles.sh
```

### カバレッジチェック

全changelogエントリに対応する記事が作成されているか確認：

```bash
bash scripts/check-coverage.sh
```

**出力例：**

```
=== Claude Code Changelog Coverage Check ===

Version 2.1.31:
  Changelog items: 11
  Articles:        11
  ✓ Complete coverage

Version 2.1.30:
  Changelog items: 19
  Articles:        19
  ✓ Complete coverage

Version 2.1.27:
  Changelog items: 9
  Articles:        7
  ✗ Missing: 2 article(s)
  Missing changelog items:
    - Added tool call failures and denials to debug logs
    - Fixed context management validation error for gateway users

=== Summary ===
Versions checked: 10
✗ Total missing articles: 66
```

### 記事フォーマット

詳細な記事フォーマットは `CLAUDE.md` を参照してください。

**基本構成：**

```markdown
---
title: "記事タイトル（日本語）"
date: YYYY-MM-DD
tags: [tag1, tag2]
---

# 記事タイトル

## 原文（日本語に翻訳）
changelogの該当項目を日本語に翻訳

## 原文（英語）
changelogの該当項目を英語で記載

## 概要
機能の説明（2-3文）

## 基本的な使い方
シンプルな例

## 実践例
具体的なユースケース別のコード例
（ユースケースごとにH3見出しで区切る）

## 注意点
知っておくべきこと

## 関連情報
公式ドキュメントや関連記事へのリンク
```

### ファイル命名規則

`docs/updates/VERSION-feature-name.md`

- **VERSION**: セマンティックバージョニング形式（例: `2.1.30`）
- **feature-name**: 英語のkebab-case（例: `debug-command`）

**例：**
- `2.1.30-debug-command.md`
- `2.1.31-japanese-ime-zenkaku-space.md`

### ファイル分割ルール

**重要：** changelogの1項目ごとに1ファイルを作成します。

例えば、以下のchangelogがある場合：

```markdown
## 2.1.30

- Added `/debug` command
- Fixed prompt cache invalidation
- Improved memory usage for `--resume`
```

**3つのファイル**を作成します：
1. `2.1.30-debug-command.md`
2. `2.1.30-prompt-cache-invalidation-fix.md`
3. `2.1.30-resume-memory-optimization.md`

## トラブルシューティング

### 記事が不足している

カバレッジチェックで不足が検出された場合：

1. **自動生成を試す：**
   ```bash
   python scripts/generate_articles.py
   ```

2. **手動で作成：**
   - `CLAUDE.md` のガイドラインに従って記事を作成
   - Web検索で公式ドキュメントと関連情報を調査

3. **作成後にチェック：**
   ```bash
   bash scripts/check-coverage.sh
   ```

### GitHub Actionsが失敗する

1. **ログを確認：**
   - Actions タブで失敗したワークフローを開く
   - エラーメッセージを確認

2. **よくある原因：**
   - `CLAUDE_CODE_OAUTH_TOKEN` の期限切れ
   - `PAT_TOKEN` の権限不足
   - changelogの形式変更

3. **手動実行：**
   ```bash
   # ローカルでテスト
   bash scripts/detect-changes.sh
   python scripts/generate_articles.py
   ```

## 自動化の仕組み

### GitHub Actions ワークフロー

`.github/workflows/monitor-changelog.yml` が以下を実行：

1. **差分検出：** Claude Code公式changelogから新しいエントリを検出
2. **記事生成：** Claude Code Actionを使って日本語ガイド記事を自動生成
3. **カバレッジチェック：** 全項目に記事が存在するか確認
4. **Issue作成：** 不足がある場合、自動的にGitHub Issueを作成
5. **コミット＆プッシュ：** 生成された記事とchangelogをコミット

### カバレッジチェック＆Issue自動作成

記事の不足が検出された場合、以下の情報を含むIssueが自動作成されます：

- 不足している記事の総数
- バージョンごとの詳細
- 対処方法（コマンド例）

## 設定

### 環境変数

- `CLAUDE_CODE_OAUTH_TOKEN`: Claude Code Action用のOAuthトークン（Secretsに設定）
- `PAT_TOKEN`: GitHub Personal Access Token（リポジトリへのpush権限が必要）

### スケジュール

デフォルトでは毎日22:00 UTC（JST 07:00）に実行されます。

変更する場合は `.github/workflows/monitor-changelog.yml` の `cron` 設定を編集：

```yaml
schedule:
  - cron: '0 22 * * *'  # 毎日22:00 UTC
```

## 開発

### ローカルテスト

```bash
# カバレッジチェック
bash scripts/check-coverage.sh

# 差分検出
bash scripts/detect-changes.sh

# 記事生成（テスト）
python scripts/generate_articles.py --dry-run
```

### コントリビューション

1. 新しい記事を作成する場合は `CLAUDE.md` のガイドラインに従ってください
2. 記事作成後は必ず `bash scripts/check-coverage.sh` でカバレッジを確認
3. プルリクエストには記事の概要とカバレッジチェック結果を含めてください

## ライセンス

MIT License

## 関連リンク

- [Claude Code 公式リポジトリ](https://github.com/anthropics/claude-code)
- [Claude Code Changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)
- [Claude Code ドキュメント](https://code.claude.com/docs/en/)
