---
title: "Claude Code Skills：再利用可能なスキルでワークフローを拡張する"
date: 2026-01-06
tags: [skills, hooks, workflow, slash-commands]
---

# Claude Code Skills：再利用可能なスキルでワークフローを拡張する

## 概要

Claude Code v2.1.0で、従来のスラッシュコマンドがSkillsシステムに統合されました。Skillsは、カスタムワークフローや専門知識をClaude Codeに提供する拡張機能で、`SKILL.md`ファイルに定義することで、チーム全体で再利用可能なコマンドや自動化を実現できます。フロントマターでのhooks定義、ホットリロード、ネストディレクトリの自動検出など、柔軟な拡張が可能です。

## 使い方

### SKILL.mdの基本構造

`.claude/skills/` ディレクトリに `SKILL.md` ファイルを配置します。

```markdown
---
name: my-skill
description: "このスキルの説明（Claudeが自動読み込みを判断する際に使用）"
---

# スキルの内容

ここにClaudeへの指示を記述します。
```

### スキルの呼び出し

ユーザーは `/` コマンドでスキルを呼び出せます。

```
/my-skill
```

`name` フィールドがスラッシュコマンド名になります。

### フロントマターでのHooks定義

v2.1.0から、スキルのフロントマターにhooksを直接定義できるようになりました。

```markdown
---
name: safe-deploy
description: "安全なデプロイワークフロー"
hooks:
  PreToolUse:
    - command: "echo 'ツール実行前のチェック'"
  PostToolUse:
    - command: "echo 'ツール実行後の処理'"
  Stop:
    - command: "echo 'スキル終了時のクリーンアップ'"
  Setup:
    - command: "npm install"
---
```

利用可能なhookイベント：

| Hook | 実行タイミング |
|------|-------------|
| `PreToolUse` | ツール実行前 |
| `PostToolUse` | ツール実行後 |
| `Stop` | スキル終了時 |
| `Setup` | `--init` / `--init-only` / `--maintenance` フラグ実行時 |

フロントマターで定義されたhooksは、そのスキルのライフサイクル中のみ実行されるスコープ付きhooksです。

### 制御オプション

```yaml
---
name: dangerous-operation
disable-model-invocation: true  # ユーザーのみが呼び出し可能
---
```

```yaml
---
name: background-knowledge
user-invocable: false  # Claudeのみが呼び出し可能（背景知識用）
---
```

```yaml
---
name: isolated-task
context: fork  # フォークされたサブエージェントで実行
---
```

## 活用シーン

- **チーム共通のコーディング規約**: レビュー基準やフォーマットルールをスキルとして共有
- **プロジェクト固有のデプロイ手順**: hooksを使った自動チェック付きのデプロイワークフロー
- **コード生成テンプレート**: 新しいコンポーネントやAPIエンドポイントの雛形を統一的に生成
- **モノレポでの個別設定**: パッケージごとに異なるスキルを自動検出

## コード例

### プロジェクトのスキルディレクトリ構成

```
my-project/
├── .claude/
│   └── skills/
│       ├── commit.md          # /commit コマンド
│       ├── review.md          # /review コマンド
│       └── deploy.md          # /deploy コマンド
├── packages/
│   └── frontend/
│       └── .claude/
│           └── skills/
│               └── component.md  # フロントエンド用スキル
└── ...
```

### コミットスキルの例

```markdown
---
name: commit
description: "規約に沿ったコミットメッセージでコミットする"
hooks:
  Stop:
    - command: "git status"
---

# コミットスキル

以下のルールに従ってコミットを作成してください：

1. `git status` で変更を確認
2. 変更内容を分析
3. Conventional Commits形式でコミットメッセージを作成
   - feat: 新機能
   - fix: バグ修正
   - docs: ドキュメント
   - refactor: リファクタリング
4. `git add` で関連ファイルをステージング
5. `git commit` でコミット
```

## 注意点・Tips

- **ホットリロード対応**: `~/.claude/skills/` や `.claude/skills/` 内のスキルを追加・更新しても、セッションを再起動する必要はありません。変更は即座に反映されます。
- **ネストディレクトリの自動検出**: モノレポなどで `packages/frontend/.claude/skills/` のようなネストされたディレクトリ内のスキルも、そのディレクトリ内のファイルを操作する際に自動検出されます。
- **サブディレクトリ非対応**: `.claude/skills/` フォルダ内でのさらなるサブディレクトリ化はサポートされていません。スキルは `.claude/skills/` 直下にフラットに配置してください。
- **グローバルスキルとプロジェクトスキル**: `~/.claude/skills/` にグローバルスキル、プロジェクトルートの `.claude/skills/` にプロジェクト固有のスキルを配置できます。
- **セキュリティ**: `disable-model-invocation: true` を設定すると、副作用のあるワークフローをユーザーが明示的に呼び出した場合のみ実行するように制限できます。
