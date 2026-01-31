---
title: "プラグイン自動更新を個別制御できる環境変数を追加"
date: 2026-01-09
tags: ['新機能', 'プラグイン', '環境変数', '設定']
---

## 原文（日本語に翻訳）

本体の自動更新が無効な場合でも、プラグインの自動更新を許可する `FORCE_AUTOUPDATE_PLUGINS` 環境変数を追加しました。

## 原文（英語）

Added `FORCE_AUTOUPDATE_PLUGINS` environment variable to allow plugin autoupdate even when the main auto-updater is disabled

## 概要

Claude Code本体の自動更新機能を無効にしている環境でも、プラグインだけは自動更新を有効にしたい場合に使用できる環境変数 `FORCE_AUTOUPDATE_PLUGINS` が追加されました。これにより、企業環境などで本体のバージョンは固定しつつ、プラグインは最新版を保つといった柔軟な運用が可能になります。

## 基本的な使い方

環境変数を設定してClaude Codeを起動します。

### Linuxの場合

```bash
export FORCE_AUTOUPDATE_PLUGINS=true
claude
```

または一時的に使用する場合:

```bash
FORCE_AUTOUPDATE_PLUGINS=true claude
```

### Windowsの場合（PowerShell）

```powershell
$env:FORCE_AUTOUPDATE_PLUGINS="true"
claude
```

### macOSの場合

```bash
export FORCE_AUTOUPDATE_PLUGINS=true
claude
```

## 実践例

### 企業環境での安定運用

```bash
# 本体の自動更新を無効化（企業ポリシー）
export CLAUDE_CODE_DISABLE_AUTO_UPDATE=true

# プラグインのみ自動更新を許可
export FORCE_AUTOUPDATE_PLUGINS=true

# この設定で起動
claude

# 結果:
# - Claude Code本体: 自動更新されない（手動管理）
# - プラグイン: 最新版に自動更新される
```

企業のIT部門が本体バージョンを管理しつつ、開発者が使用するプラグインは最新機能を利用できます。

### CI/CD環境での設定

```yaml
# .github/workflows/test.yml
name: Test with Claude Code
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Setup Claude Code
        run: |
          # 本体バージョンを固定
          export CLAUDE_CODE_DISABLE_AUTO_UPDATE=true
          # プラグインは最新版を使用
          export FORCE_AUTOUPDATE_PLUGINS=true

          claude --version
```

CI環境でテストの再現性を保ちつつ、プラグインの最新機能を活用できます。

### シェル設定ファイルでの永続化

```bash
# ~/.bashrc または ~/.zshrc に追加
export CLAUDE_CODE_DISABLE_AUTO_UPDATE=true
export FORCE_AUTOUPDATE_PLUGINS=true

# これで全てのセッションで設定が有効に
```

### Docker環境での使用

```dockerfile
FROM ubuntu:latest

# 環境変数を設定
ENV CLAUDE_CODE_DISABLE_AUTO_UPDATE=true
ENV FORCE_AUTOUPDATE_PLUGINS=true

# Claude Codeのインストール
RUN curl -sSL https://claude.ai/install.sh | bash

CMD ["claude"]
```

コンテナイメージでは本体バージョンを固定し、プラグインのみ更新する構成が可能です。

## 注意点

- **本体の自動更新が無効の場合のみ有効**: この環境変数は、本体の自動更新が無効化されている場合にのみ意味を持ちます
- **プラグインの互換性**: 本体のバージョンが古い場合、最新プラグインが正しく動作しない可能性があります
- **セキュリティアップデート**: 本体を自動更新しない場合、セキュリティパッチが適用されない可能性があるため、定期的な手動更新を検討してください
- **値の設定**: 環境変数の値は `true` または `1` を設定します（大文字小文字は問いません）

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
