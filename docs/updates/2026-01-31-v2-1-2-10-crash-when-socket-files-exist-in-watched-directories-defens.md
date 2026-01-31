---
title: "ソケットファイル監視時のクラッシュを修正"
date: 2026-01-09
tags: ['バグ修正', '安定性', 'ファイル監視', 'UNIX']
---

## 原文（日本語に翻訳）

監視対象ディレクトリ内にソケットファイルが存在する際のクラッシュを修正しました（EOPNOTSUPPエラーに対する多層防御）。

## 原文（英語）

Fixed crash when socket files exist in watched directories (defense-in-depth for EOPNOTSUPP errors)

## 概要

Claude Codeがファイル変更を監視しているディレクトリ内にUNIXソケットファイル（.sock）が存在すると、EOPNOTSUPP（Operation not supported）エラーが発生してクラッシュする問題が修正されました。特にDocker、Redis、PostgreSQLなどのサービスがソケットファイルを作成する環境で、安定性が大幅に向上します。

## 基本的な使い方

この修正は自動的に適用されます。ソケットファイルが含まれるプロジェクトでも、Claude Codeが正常に動作します。

### 修正前に発生していた問題

```bash
# プロジェクトディレクトリにソケットファイルが含まれる場合
project/
  src/
  tmp/
    redis.sock    # Redisのソケットファイル
    postgres.sock # PostgreSQLのソケットファイル

# Claude Codeを起動
claude

# 修正前: クラッシュする
# Error: EOPNOTSUPP: operation not supported on socket
```

### 修正後の正常な動作

```bash
# 同じ環境でも正常に動作
claude
# → ソケットファイルは無視され、正常に起動・動作する
```

## 実践例

### Docker開発環境での使用

```bash
# Dockerコンテナ内での開発
project/
  src/
  docker/
    docker.sock   # Dockerソケット

# 修正前: Claude Codeがクラッシュ
# 修正後: 正常に動作

claude
# → Dockerソケットを無視して正常に動作
```

### データベース開発環境

```bash
# PostgreSQLやRedisを使用するプロジェクト
project/
  app/
  tmp/
    pids/
    sockets/
      postgresql/.s.PGSQL.5432  # PostgreSQLソケット
      redis.sock                # Redisソケット

# 修正前: ファイル監視時にクラッシュ
# 修正後: ソケットファイルをスキップして正常動作

claude "データベース接続コードを確認して"
# → 正常に動作
```

### Rails開発環境

```bash
# Ruby on Railsプロジェクト
rails-app/
  app/
  tmp/
    sockets/
      puma.sock   # Pumaサーバーのソケット
    pids/

# 修正前: tmp/sockets/を監視してクラッシュ
# 修正後: ソケットファイルを安全に処理

claude "このRailsアプリをレビューして"
# → 安定して動作
```

### マイクロサービス環境

```bash
# 複数のサービスが動作する環境
services/
  api/
  worker/
  shared/
    sockets/
      service-a.sock
      service-b.sock
      service-c.sock

# 修正前: 複数のソケットファイルで頻繁にクラッシュ
# 修正後: 全てのソケットを適切に処理

claude "サービス間の通信を最適化して"
# → 問題なく動作
```

## 注意点

- **自動スキップ**: ソケットファイルは自動的にスキップされ、監視対象から除外されます
- **エラーハンドリング**: EOPNOTSUPP エラーだけでなく、類似のエラーも適切に処理されます
- **パフォーマンス**: ソケットファイルが多数ある場合でも、パフォーマンスへの影響はありません
- **UNIX系システム**: この問題は主にLinux、macOS、BSDなどのUNIX系システムで発生していました
- **Windowsでは無関係**: Windowsでは名前付きパイプが使用されるため、この問題は発生しません

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [UNIXソケットについて](https://man7.org/linux/man-pages/man7/unix.7.html)
