---
title: "バックスラッシュ継続の複数行コマンドが誤分割される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'bash', 'パーミッション']
---

## 原文（日本語に翻訳）

バックスラッシュ継続を含む複数行Bashコマンドが誤って分割され、パーミッションフラグが立つ問題を修正しました

## 原文（英語）

Fixed multi-line bash commands with backslash continuations being incorrectly split and flagged for permissions

## 概要

Claude Code v2.1.0で修正された、複数行コマンド解析バグです。以前のバージョンでは、バックスラッシュ（`\`）で継続する複数行のBashコマンドを実行しようとすると、パーミッションチェック時に各行が独立したコマンドとして誤認識され、不要なパーミッション要求が発生していました。この修正により、バックスラッシュ継続が正しく処理され、複数行にまたがる長いコマンドもスムーズに実行できるようになりました。

## 修正前の問題

### 症状

```bash
claude

# 複数行にわたるdockerコマンド
> docker run \
    --name myapp \
    --port 8080:8080 \
    myimage

# 修正前: 各行が独立したコマンドとして認識される
# ⚠️ Permission required: Execute "docker"
# Allow? yes
# ⚠️ Permission required: Execute "--name"
# ⚠️ Permission required: Execute "--port"
# ⚠️ Permission required: Execute "myimage"

# 各行ごとにパーミッションを要求される
# さらにコマンド実行失敗
```

### 根本原因

```
入力コマンド:
docker run \
  --name myapp \
  --port 8080:8080 \
  myimage

パーミッションチェッカーの解析（修正前）:
- 行1: "docker run \" → "docker run" コマンド
- 行2: "  --name myapp \" → "--name" コマンド（誤認識）
- 行3: "  --port 8080:8080 \" → "--port" コマンド（誤認識）
- 行4: "  myimage" → "myimage" コマンド（誤認識）

結果: 4つの独立したコマンドとして処理
```

## 修正後の動作

### 正しい複数行解析

```bash
claude

# 複数行dockerコマンド
> docker run \
    --name myapp \
    --port 8080:8080 \
    myimage

# 修正後: 1つのコマンドとして認識
# ⚠️ Permission required: Execute "docker run --name myapp --port 8080:8080 myimage"
# Allow? yes

# ✓ 1回の承認で実行
# ✓ コマンドが正常に実行される
```

## 実践例

### 長いcurlコマンドの整形

複雑なAPI呼び出しを読みやすく記述します。

```bash
# REST APIへのPOSTリクエスト
> curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"name": "test", "value": 42}' \
    https://api.example.com/v1/items

# 修正前: 各行でパーミッション要求
# 修正後: ✓ 1つのcurlコマンドとして実行
```

### 複数オプションを持つgitコマンド

長いgitコマンドを整理して記述します。

```bash
# リモートリポジトリのクローン
> git clone \
    --depth 1 \
    --branch main \
    --single-branch \
    https://github.com/user/repo.git \
    my-project

# 修正後: ✓ 1つのコマンドとして正しく実行
# my-project ディレクトリが作成される
```

### Docker Composeコマンドの可読性向上

複数のオプションを持つdocker-composeコマンドを整形します。

```bash
# docker-compose up with options
> docker-compose \
    -f docker-compose.yml \
    -f docker-compose.override.yml \
    up \
    --build \
    --remove-orphans \
    -d

# 修正後: ✓ 1つのコマンドとして認識・実行
```

### スクリプト内での使用

Bashスクリプトから複数行コマンドを呼び出します。

```bash
# deploy.sh
#!/bin/bash

# Claudeに実行させるコマンド
claude --prompt "
kubectl apply \
  -f deployment.yaml \
  -f service.yaml \
  --namespace production \
  --validate=true
"

# 修正後: ✓ 正常に実行される
```

### findコマンドの複雑な条件

複数の条件を持つfindコマンドを整理します。

```bash
# 特定のファイルを検索
> find . \
    -type f \
    -name "*.js" \
    -not -path "*/node_modules/*" \
    -not -path "*/dist/*" \
    -exec grep -l "TODO" {} \;

# 修正後: ✓ 1つのfindコマンドとして実行
# TODO を含む.jsファイルを検索
```

## 注意点

- この修正は Claude Code v2.1.0（2026年1月7日リリース）で実装されました
- バックスラッシュ継続（Line Continuation）:
  - 行末の `\` は「次の行に続く」を意味
  - Bashは複数行を1つのコマンドとして結合
  - 可読性向上のため、長いコマンドを複数行に分割
- 正しい使用方法:
  ```bash
  # ✓ 正しい
  command \
    --option1 value1 \
    --option2 value2

  # ✗ バックスラッシュの後にスペースがある（動作しない）
  command \
    --option1

  # ✗ バックスラッシュがない（別々のコマンド）
  command
    --option1
  ```
- インデント:
  - 継続行はインデントして可読性を向上
  - インデントは無視される（スペース/タブどちらでも可）
- 引用符との組み合わせ:
  ```bash
  # 引用符内では \改行 が必要
  echo "Long \
  string"

  # または引用符を各行に
  echo "First line" \
       "Second line"
  ```
- 修正の詳細:
  - Bashコマンドパーサーがバックスラッシュ継続を認識
  - 複数行を1つの論理行に結合
  - 結合後のコマンドでパーミッションチェック
- パフォーマンスへの影響:
  - パース処理がわずかに複雑化
  - 実行時のパフォーマンスは変わらず
- デバッグ:
  - `--debug` フラグでコマンド結合のログを確認
  - ログに「Joined multi-line command: ...」が表示される
- 関連する修正:
  - index 51: コマンド置換 `$()`のサポート
  - index 53: Bashコマンドプレフィックス抽出の改善
- トラブルシューティング:
  - 複数行コマンドが動作しない場合:
    1. バックスラッシュの直後に空白がないか確認
    2. 各行末に `\` があるか確認
    3. 最終行には `\` が不要
- シェルスクリプトとの互換性:
  - Bashシェルと同じ動作
  - 既存のシェルスクリプトをそのまま使用可能
- ヒアドキュメントとの併用:
  ```bash
  cat << EOF \
    > output.txt
  Content here
  EOF
  # ✓ 正常に動作
  ```

## 関連情報

- [Bash tool - Claude Code Docs](https://code.claude.com/docs/en/bash-tool)
- [Bash line continuation](https://www.gnu.org/software/bash/manual/html_node/Escape-Character.html)
- [Shell command quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)
