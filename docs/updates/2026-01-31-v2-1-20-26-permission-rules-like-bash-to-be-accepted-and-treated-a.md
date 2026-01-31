---
title: "`Bash(*)`のような権限ルールを`Bash`と同等に扱うよう変更"
date: 2026-01-27
tags: ['パーミッション変更', 'ユーザビリティ', '設定']
---

## 原文（日本語に翻訳）

`Bash(*)`のような権限ルールを受け入れ、`Bash`と同等に扱うよう変更

## 原文（英語）

Changed permission rules like `Bash(*)` to be accepted and treated as equivalent to `Bash`

## 概要

Claude Code v2.1.20では、権限設定の柔軟性が向上しました。以前は、`Bash`のような基本的な権限ルールのみが認識され、`Bash(*)`のようなワイルドカード付きの表記はエラーになっていました。この変更により、`Bash(*)`は`Bash`と同等の「すべてのBashコマンド実行を許可」として解釈されるようになります。これにより、より直感的で明示的な権限設定が可能になります。

## 基本的な使い方

設定ファイルで柔軟な権限表記が使えます：

```json
// settings.json または .claude.json

// 変更前：以下はエラーになった
{
  "permissions": {
    "allow": ["Bash(*)"]  // ❌ Invalid format
  }
}

// 変更後：どちらも有効
{
  "permissions": {
    "allow": [
      "Bash",      // ✓ 簡潔な形式
      "Bash(*)"    // ✓ 明示的な形式（同じ意味）
    ]
  }
}
```

## 実践例

### 明示的な「すべて許可」の設定

意図を明確にする権限設定：

```json
{
  "permissions": {
    "allow": [
      "Bash(*)",        // すべてのBashコマンド
      "Read(*)",        // すべてのファイル読み込み
      "Write(*)",       // すべてのファイル書き込み
      "Edit(*)",        // すべてのファイル編集
      "Grep(*)"         // すべての検索操作
    ]
  }
}

// 変更により：
// - (*)が「すべて」を明示的に表現
// - チームメンバーが理解しやすい
// - ドキュメント的な価値がある
```

### 他のツールからの移行

他のツールで慣れている形式をサポート：

```json
// Docker Composeスタイルの設定から移行
{
  "permissions": {
    "allow": [
      "Bash(*)",     // すべてのシェルコマンド
      "MCP(*)"       // すべてのMCPツール
    ],
    "deny": [
      "Bash(rm -rf *)"  // 特定コマンドを拒否
    ]
  }
}

// 変更により：
// - 他ツールの知識を活用できる
// - 学習曲線が緩やかに
```

### ドキュメント化された設定

チーム共有の設定ファイル：

```json
{
  "permissions": {
    "allow": [
      // フルアクセス許可（開発環境）
      "Bash(*)",        // すべてのコマンド実行
      "Read(*)",        // すべてのファイル読み込み
      "Write(*)",       // すべてのファイル書き込み

      // 特定のMCPツールのみ
      "@database.query",
      "@slack.postMessage"
    ]
  },
  "comment": "Development environment - full access granted"
}

// (*) 表記により：
// - 「制限なし」が一目で分かる
// - 本番環境との違いが明確
```

### 段階的な権限設定

プロジェクトの成長に応じて：

```json
// 初期段階：制限的
{
  "permissions": {
    "allow": [
      "Read(src/*, tests/*)",
      "Bash(npm test)"
    ]
  }
}

// 開発が進んで、フルアクセスへ
{
  "permissions": {
    "allow": [
      "Read(*)",     // 簡潔に
      "Bash(*)"      // 簡潔に
    ]
  }
}

// または明示的に
{
  "permissions": {
    "allow": [
      "Read(*)",     // すべての読み込み許可
      "Bash(*)"      // すべてのコマンド許可
    ]
  }
}

// 変更により：
// - どちらの表記も有効
// - プロジェクトの段階に応じて選択可能
```

### CI/CD環境の設定

自動化環境での明示的な設定：

```json
// .claude.ci.json
{
  "environment": "CI",
  "permissions": {
    "allow": [
      "Bash(*)",              // すべてのビルドコマンド
      "Read(*)",              // すべてのソースファイル
      "Write(dist/*, build/*, coverage/*)"],  // 出力ディレクトリのみ
    "deny": [
      "Bash(rm -rf /)",       // 危険なコマンドは明示的に拒否
      "Write(src/*)"          // ソースコード変更は禁止
    ]
  }
}

// (*) 表記の利点：
// - CI設定の意図が明確
// - 監査しやすい
// - ポリシー遵守を証明可能
```

### 既存設定との互換性

レガシーシステムからのアップグレード：

```bash
# 古いClaude Codeバージョンの設定
# permissions.txt
Bash(*)
Read(*)
Edit(src/*)

# v2.1.20にアップグレード後
# そのまま動作する（互換性維持）

# または新しい形式に更新
{
  "permissions": {
    "allow": [
      "Bash(*)",      // ✓ 引き続き有効
      "Read(*)",      // ✓ 引き続き有効
      "Edit(src/*)"   // ✓ パターンも引き続き有効
    ]
  }
}

# 変更により：
# - 既存設定が壊れない
# - 段階的な移行が可能
```

### エラーメッセージの改善

以前はエラーだった記述が有効に：

```bash
# 変更前：
> /config permissions

Error: Invalid permission format: "Bash(*)"
Expected: "Bash" or "Bash(command)"

# ユーザーは混乱...

# 変更後：
> /config permissions

✓ Permissions loaded:
  - Bash(*) → All Bash commands allowed
  - Read(*) → All file reads allowed

# スムーズに動作
```

## 注意点

- `Bash(*)`は`Bash`と完全に同じ意味になります（すべてのBashコマンドを許可）
- より細かい制御には、具体的なパターンを使用してください（例：`Bash(npm *)`）
- この変更は後方互換性を維持しています（既存の`Bash`表記も引き続き有効）
- `(*)`は「すべて」を意味し、他のワイルドカードパターンとは異なります
- 特定のコマンドのみを許可する場合は、`Bash(npm install)`のように明示的に指定してください

## 関連情報

- [Permission System](https://code.claude.com/docs/en/security/permissions)
- [Configuration Reference](https://code.claude.com/docs/en/reference/configuration)
- [Security Best Practices](https://code.claude.com/docs/en/security/best-practices)
- [Permission Patterns](https://code.claude.com/docs/en/security/permission-patterns)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
