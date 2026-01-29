---
title: "権限管理の強化：ワイルドカード許可とCLAUDE.mdの新機能"
date: 2026-01-27
tags: [permissions, security, claude-md, configuration]
---

# 権限管理の強化：ワイルドカード許可とCLAUDE.mdの新機能

## 概要

Claude Codeの権限管理が強化され、ワイルドカードを使ったツール権限の柔軟な設定が可能になりました。`Bash(npm *)` のようなパターンマッチングで、コマンド単位の細かい許可制御ができます。また、`--add-dir` フラグによる追加ディレクトリの指定や、CLAUDE.mdでの組織全体の設定管理など、マルチリポジトリ環境での運用が改善されています。

## 使い方

### ワイルドカードツール権限

`allowlist`（許可リスト）にワイルドカードパターンを使って、Bashコマンドの実行権限を柔軟に設定できます。

#### 基本パターン

| パターン | マッチするコマンド |
|---------|-----------------|
| `Bash(npm run build)` | 完全一致のみ |
| `Bash(npm run test *)` | `npm run test` で始まるコマンド |
| `Bash(npm *)` | `npm` で始まる任意のコマンド |
| `Bash(* install)` | `install` で終わる任意のコマンド |
| `Bash(git * main)` | `git checkout main`、`git merge main` など |
| `Bash(*-h*)` | `-h` を含む任意のコマンド（ヘルプ表示用） |

#### コロン構文（代替形式）

```
Bash(npm:*)     → npmコマンド全般
Bash(git commit:*)  → 任意のメッセージでのgit commit
```

#### 設定ファイルでの指定

`.claude/settings.json` または `~/.claude/settings.json` で設定：

```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)",
      "Bash(git *)",
      "Bash(python *)",
      "Bash(*-h*)",
      "Read",
      "Write"
    ],
    "deny": [
      "Bash(rm -rf *)"
    ]
  }
}
```

### --add-dir フラグ

初期作業ディレクトリ以外のディレクトリへのアクセスを許可します。

```bash
# コマンドラインで指定
claude --add-dir /path/to/shared-library

# 複数ディレクトリの指定
claude --add-dir /path/to/lib1 --add-dir /path/to/lib2
```

### 設定ファイルでの追加ディレクトリ

```json
{
  "permissions": {
    "additionalDirectories": [
      "/path/to/shared-library",
      "/path/to/config-repo"
    ]
  }
}
```

### CLAUDE.mdの組織管理

エンタープライズチームは、全マシンの `.claude` ディレクトリに標準化されたCLAUDE.mdファイルを配布して、組織全体の設定を統一できます。

CLAUDE.mdファイルの読み込み優先順位：

1. `~/.claude/CLAUDE.md`（ユーザーグローバル）
2. プロジェクトルートの `CLAUDE.md`
3. プロジェクトルートの `.claude/CLAUDE.md`
4. 現在のディレクトリの `CLAUDE.md`（ネスト対応）

## 活用シーン

- **CI/CDパイプラインの安全な実行**: `Bash(npm *)` と `Bash(git *)` のみを許可し、それ以外のコマンドは確認を要求
- **モノレポでの開発**: `--add-dir` で共有ライブラリやconfig リポジトリにアクセスしつつ、メインプロジェクトのディレクトリをベースに作業
- **組織のコーディング規約の統一**: CLAUDE.mdに組織共通のルール（命名規則、アーキテクチャパターン、禁止事項）を記載し全メンバーに配布
- **セキュリティ要件の遵守**: 機密データにアクセスする可能性のあるコマンドをdenyリストで制限

## コード例

### プロジェクト固有の権限設定

`.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git push *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(docker compose *)",
      "Read",
      "Write",
      "Edit"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(sudo *)"
    ],
    "additionalDirectories": [
      "../shared-utils",
      "../proto-definitions"
    ]
  }
}
```

### 組織共通の CLAUDE.md

`~/.claude/CLAUDE.md`:

```markdown
# 組織共通ルール

## コーディング規約
- TypeScriptを使用すること
- ESLint + Prettierの設定に従うこと
- テストカバレッジ80%以上を維持すること

## セキュリティ
- 環境変数にシークレットを含めないこと
- .envファイルをコミットしないこと
- SQLクエリにはパラメータバインディングを使用すること

## アーキテクチャ
- Clean Architecture パターンに従うこと
- 外部依存はインターフェースで抽象化すること
```

## 注意点・Tips

- **`Bash(*)` と `Bash` の等価性**: `Bash(*)` は `Bash` と同じ意味で、すべてのBashコマンドを許可します。意図的に使う場合を除き、セキュリティリスクに注意してください。
- **シェル演算子への注意**: ワイルドカードパーミッションがシェル演算子（`&&`, `||`, `;`, `|`）を含む複合コマンドにマッチする可能性があります。セキュリティ修正で改善されていますが、許可パターンは可能な限り具体的にしてください。
- **設定の優先順位**: プロジェクトの `.claude/settings.json` はグローバルの `~/.claude/settings.json` より優先されます。チーム共通の設定はプロジェクトリポジトリにコミットすることをお勧めします。
- **deny リストの活用**: `allow` だけでなく `deny` リストも活用して、危険なコマンドを明示的にブロックしてください。
- **動作確認の推奨**: 新しい権限パターンを設定した後は、意図通りに動作するかテストすることを強くお勧めします。一部のバージョンでワイルドカードパーミッションが期待通りに機能しない報告もあります。
