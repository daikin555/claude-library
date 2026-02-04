---
title: "グローバルオプション後のサブコマンド識別を修正"
date: 2026-01-31
tags: ['バグ修正', 'bash', 'パーミッション']
---

## 原文（日本語に翻訳）

グローバルオプション後のサブコマンドを正しく識別するようBashコマンドプレフィックス抽出を修正しました（例: `git -C /path log` が `Bash(git log:*)` ルールに正しくマッチするように）

## 原文（英語）

Fixed bash command prefix extraction to correctly identify subcommands after global options (e.g., `git -C /path log` now correctly matches `Bash(git log:*)` rules)

## 概要

Claude Code v2.1.0で修正された、パーミッションルールマッチングバグです。以前のバージョンでは、gitやdockerなどのグローバルオプション（`-C`, `--config`など）をサブコマンドの前に指定すると、パーミッションルールのサブコマンド識別が正しく動作せず、事前に承認したコマンドでも再度承認を要求されていました。この修正により、グローバルオプションをスキップしてサブコマンドを正しく抽出し、パーミッションルールが適切にマッチするようになりました。

## 修正前の問題

### 症状

```bash
# settings.jsonでgit logを事前承認
{
  "permissions": {
    "allowed": ["Bash(git log:*)"]
  }
}

# 通常のgit logコマンド
> git log --oneline

# ✓ 承認済み、自動実行

# グローバルオプション付きgit log
> git -C /path/to/repo log --oneline

# 修正前: 再度承認を要求
# ⚠️ Permission required: Execute "git -C /path/to/repo log --oneline"
# Allow? (yes/no)

# 理由: サブコマンド "log" が識別されず、ルールにマッチしない
```

### 影響を受けるコマンド

```bash
# git -C (change directory)
git -C /path log  # "log" が識別されない

# git --git-dir (リポジトリ指定)
git --git-dir=/path/.git status  # "status" が識別されない

# docker --config (設定ファイル指定)
docker --config ~/.docker ps  # "ps" が識別されない

# npm --prefix (プロジェクトディレクトリ指定)
npm --prefix /path test  # "test" が識別されない
```

## 修正後の動作

### 正しいサブコマンド識別

```bash
# settings.jsonで事前承認
{
  "permissions": {
    "allowed": ["Bash(git log:*)"]
  }
}

# グローバルオプション付きコマンド
> git -C /path/to/repo log --oneline

# 修正後:
# 1. "git -C /path/to/repo" → グローバルオプションと認識
# 2. "log" → サブコマンドとして識別
# 3. "Bash(git log:*)" ルールにマッチ
# ✓ 自動実行（承認不要）

> git --git-dir=/repo/.git log --graph

# ✓ 同様に "log" が識別され、自動実行
```

## 実践例

### Gitマルチリポジトリ管理

複数のリポジトリで同じgitコマンドを使用します。

```bash
# settings.json
{
  "permissions": {
    "allowed": [
      "Bash(git log:*)",
      "Bash(git status:*)"
    ]
  }
}

# 異なるリポジトリでgit log
> git -C ~/projects/repo1 log --oneline
# ✓ 自動実行

> git -C ~/projects/repo2 log --graph
# ✓ 自動実行

# git status も同様
> git --git-dir=/var/repos/repo3/.git status
# ✓ 自動実行
```

### Dockerコンテナ管理

異なる設定ファイルでdockerコマンドを使用します。

```bash
# settings.json
{
  "permissions": {
    "allowed": ["Bash(docker ps:*)"]
  }
}

# 異なる設定でdocker ps
> docker --config ~/.docker-dev ps
# 修正後: ✓ "ps" が識別され、自動実行

> docker --config ~/.docker-prod ps -a
# ✓ 同様に自動実行
```

### NPMプロジェクト管理

異なるプロジェクトディレクトリでnpmコマンドを実行します。

```bash
# settings.json
{
  "permissions": {
    "allowed": ["Bash(npm test:*)"]
  }
}

# 異なるプロジェクトでnpm test
> npm --prefix /path/to/project1 test
# ✓ "test" が識別され、自動実行

> npm --prefix /path/to/project2 test --coverage
# ✓ 自動実行
```

### Kubectlコンテキスト切り替え

異なるクラスターでkubectlコマンドを使用します。

```bash
# settings.json
{
  "permissions": {
    "allowed": ["Bash(kubectl get:*)"]
  }
}

# 異なるコンテキストで実行
> kubectl --context=dev-cluster get pods
# ✓ "get" が識別され、自動実行

> kubectl --context=prod-cluster get services
# ✓ 自動実行
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- グローバルオプション:
  - コマンド全体に影響するオプション
  - サブコマンドの前に指定
  - 例: `git -C <path>`, `docker --config <path>`, `npm --prefix <path>`
- サブコマンド:
  - メインコマンドの特定の機能を実行
  - 例: `git log`, `docker ps`, `npm test`
- サポートされるコマンドとグローバルオプション:
  - **git**: `-C`, `--git-dir`, `--work-tree`, `-c`
  - **docker**: `--config`, `--context`, `--host`
  - **kubectl**: `--context`, `--namespace`, `--kubeconfig`
  - **npm**: `--prefix`, `--global`
  - その他の一般的なCLIツール
- パーミッションルールの構文:
  ```json
  {
    "allowed": [
      "Bash(git log:*)",      // git log とそのすべてのオプション
      "Bash(docker ps:*)",    // docker ps とそのすべてのオプション
      "Bash(npm test:*)"      // npm test とそのすべてのオプション
    ]
  }
  ```
- 修正の詳細:
  - コマンドプレフィックス抽出アルゴリズムの改善
  - グローバルオプションとその引数を認識してスキップ
  - 最初の非オプション引数をサブコマンドとして識別
- 複数のグローバルオプション:
  ```bash
  git -C /path --git-dir=/repo/.git log
  # "log" が正しく識別される
  ```
- デバッグ:
  - `--debug` フラグでサブコマンド抽出のログを確認
  - ログに「Extracted subcommand: log from git -C /path log」が表示される
- パフォーマンスへの影響:
  - サブコマンド抽出ロジックがわずかに複雑化
  - 実行時のパフォーマンスは変わらず
- 関連する改善:
  - index 20: ワイルドカードパターンマッチング
  - より柔軟なパーミッションルールが可能に
- トラブルシューティング:
  - グローバルオプション付きコマンドが承認を要求する場合:
    1. パーミッションルールを確認
    2. サブコマンドが正しく指定されているか確認
    3. `--debug` でサブコマンド抽出を確認

## 関連情報

- [Permissions - Claude Code Docs](https://code.claude.com/docs/en/permissions)
- [Bash tool](https://code.claude.com/docs/en/bash-tool)
- [Git documentation - Command options](https://git-scm.com/docs/git#_options)
