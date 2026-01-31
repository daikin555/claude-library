---
title: "プラグインのallowed-toolsで`${CLAUDE_PLUGIN_ROOT}`が置換されない問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'プラグイン', 'パーミッション']
---

## 原文（日本語に翻訳）

プラグインの`allowed-tools` frontmatterで`${CLAUDE_PLUGIN_ROOT}`が置換されず、ツールが誤って承認を要求する問題を修正しました

## 原文（英語）

Fixed `${CLAUDE_PLUGIN_ROOT}` not being substituted in plugin `allowed-tools` frontmatter, which caused tools to incorrectly require approval

## 概要

Claude Code v2.1.0で修正された、プラグイン開発時のパス変数展開バグです。以前のバージョンでは、プラグインのスキル定義で`${CLAUDE_PLUGIN_ROOT}`変数を使用してツールパスを指定しても、この変数が実際のプラグインディレクトリパスに展開されず、パーミッションチェックが正しく動作しませんでした。結果として、プラグインが提供するツールが毎回ユーザー承認を要求していました。この修正により、変数が正しく展開され、プラグインツールがスムーズに動作するようになりました。

## 修正前の問題

### 症状

```yaml
# プラグインのスキル定義
# ~/.claude/plugins/my-plugin/skills/analyzer.md
---
name: analyzer
allowed-tools:
  - ${CLAUDE_PLUGIN_ROOT}/bin/analyze.sh
---

# スキル実行
> /analyzer を実行

# 修正前: 毎回承認を要求される
# ⚠️ Permission required:
# Execute: ${CLAUDE_PLUGIN_ROOT}/bin/analyze.sh
# Allow? (yes/no)

# ユーザーが yes を選択しても、次回また要求される
# ${CLAUDE_PLUGIN_ROOT} が展開されていないため、
# パスが一致せず、常に新しいツールと認識される
```

### 根本原因

```
プラグイン構造:
~/.claude/plugins/my-plugin/
  ├── skills/analyzer.md
  └── bin/analyze.sh

allowed-tools frontmatter:
  - ${CLAUDE_PLUGIN_ROOT}/bin/analyze.sh

期待される展開:
  - /Users/username/.claude/plugins/my-plugin/bin/analyze.sh

実際の動作（修正前）:
  - ${CLAUDE_PLUGIN_ROOT}/bin/analyze.sh（展開されない）

結果:
  - パーミッションキャッシュに一致するエントリがない
  - 毎回承認を要求
```

## 修正後の動作

### 自動パス展開と承認記憶

```yaml
# 同じスキル定義
---
name: analyzer
allowed-tools:
  - ${CLAUDE_PLUGIN_ROOT}/bin/analyze.sh
---

# スキル実行（初回）
> /analyzer

# 修正後: 初回のみ承認要求
# ⚠️ Permission required:
# Execute: /Users/username/.claude/plugins/my-plugin/bin/analyze.sh
# Allow? (yes/no)

# yes を選択

# 2回目以降
> /analyzer

# ✓ 承認不要、自動実行
# パスが正しく展開されているため、承認が記憶される
```

## 実践例

### プラグイン固有ツールの自動承認

プラグインが提供するツールが初回承認後、自動的に実行されます。

```yaml
# データ分析プラグイン
# ~/.claude/plugins/data-analyzer/skills/analyze.md
---
name: analyze
allowed-tools:
  - ${CLAUDE_PLUGIN_ROOT}/scripts/analyze-csv.py
  - ${CLAUDE_PLUGIN_ROOT}/scripts/generate-report.py
---

# 初回実行
> /analyze data.csv

# 初回: 2つのツールの承認を要求
# Allow analyze-csv.py? yes
# Allow generate-report.py? yes

# 2回目以降
> /analyze other-data.csv

# 修正後: ✓ 自動実行（承認不要）
```

### 複数スクリプトを持つプラグイン

プラグイン内の複数のスクリプトすべてが正しく動作します。

```yaml
# デプロイプラグイン
# ~/.claude/plugins/deployer/skills/deploy.md
---
name: deploy
allowed-tools:
  - ${CLAUDE_PLUGIN_ROOT}/bin/pre-deploy.sh
  - ${CLAUDE_PLUGIN_ROOT}/bin/deploy.sh
  - ${CLAUDE_PLUGIN_ROOT}/bin/post-deploy.sh
  - ${CLAUDE_PLUGIN_ROOT}/bin/rollback.sh
---

# 各スクリプトが初回承認後、記憶される
> /deploy production

# 修正前: 毎回4つのスクリプトの承認を要求
# 修正後: 初回のみ承認、以降は自動実行
```

### 相対パスとの組み合わせ

プラグインルートからの相対パスが正しく処理されます。

```yaml
# テストプラグイン
---
name: test-runner
allowed-tools:
  - ${CLAUDE_PLUGIN_ROOT}/runners/jest.sh
  - ${CLAUDE_PLUGIN_ROOT}/runners/mocha.sh
  - ${CLAUDE_PLUGIN_ROOT}/../shared/validator.sh  # 親ディレクトリも可能
---

# すべてのパスが正しく展開される
# 承認が適切に記憶される
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- `${CLAUDE_PLUGIN_ROOT}` 変数:
  - プラグインのルートディレクトリを指す
  - 例: `~/.claude/plugins/my-plugin`
  - プラグイン配布時にパスを柔軟に指定可能
- 変数展開のタイミング:
  - スキルのロード時に展開
  - frontmatterの `allowed-tools` フィールドで使用可能
- サポートされる使用箇所:
  - ✅ `allowed-tools` フィールド
  - ✅ プラグインのスキル定義
  - ✅ エージェント定義
  - ❌ hooks コマンド内（別の方法で処理）
- 他の変数との組み合わせ:
  ```yaml
  allowed-tools:
    - ${CLAUDE_PLUGIN_ROOT}/bin/tool.sh
    - ${HOME}/.local/bin/helper.sh  # HOME変数も使用可能
  ```
- パーミッションキャッシュ:
  - 展開後のフルパスがキャッシュに保存される
  - `~/.claude/permissions.json` に記録
  - 承認したパスは永続的に記憶される
- プラグイン配布:
  - `${CLAUDE_PLUGIN_ROOT}` を使用することで、ポータブルなプラグインを作成可能
  - ユーザーの環境に依存しない
- デバッグ:
  - `--debug` フラグで変数展開のログを確認
  - ログに「Substituting ${CLAUDE_PLUGIN_ROOT} → /path/to/plugin」が表示される
- トラブルシューティング:
  - 修正後も毎回承認を要求される場合:
    1. パーミッションキャッシュをクリア:
       ```bash
       rm ~/.claude/permissions.json
       ```
    2. Claude Codeを再起動
    3. 再度承認
- プラグイン構造のベストプラクティス:
  ```
  ~/.claude/plugins/my-plugin/
    ├── skills/
    │   └── my-skill.md  # ${CLAUDE_PLUGIN_ROOT} を使用
    ├── bin/
    │   └── tool.sh
    └── lib/
        └── helper.sh
  ```
- 関連する変数:
  - `${CLAUDE_PLUGIN_ROOT}`: プラグインルート
  - `${HOME}`: ユーザーホームディレクトリ
  - `${PWD}`: 現在のワーキングディレクトリ（一部のコンテキスト）

## 関連情報

- [Plugin development - Claude Code Docs](https://code.claude.com/docs/en/plugins)
- [Permissions - Claude Code Docs](https://code.claude.com/docs/en/permissions)
- [Creating skills](https://code.claude.com/docs/en/skills)
