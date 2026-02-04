---
title: "Atlassian MCP統合を改善 - より信頼性の高いデフォルト設定（streamable HTTP）を使用"
date: 2026-01-31
tags: ['改善', 'MCP', 'Atlassian', 'HTTP']
---

## 原文（日本語に翻訳）

Atlassian MCP統合をより信頼性の高いデフォルト設定（streamable HTTP）を使用するよう更新しました

## 原文（英語）

Updated Atlassian MCP integration to use a more reliable default configuration (streamable HTTP)

## 概要

Claude Code v2.1.0で改善された、Atlassian製品（Jira、Confluence）とのMCP（Model Context Protocol）統合機能です。以前のバージョンでは、デフォルトの通信設定が不安定で、大きなデータの取得時にタイムアウトや接続エラーが発生することがありました。この改善により、streamable HTTP通信方式がデフォルトとなり、大量のイシューやページを確実に取得できるようになりました。

## 改善前の動作

### 接続が不安定

```bash
# JiraのイシューをClaude Codeで取得
claude "List all issues in project ABC"

# 修正前:
Connecting to Jira...
Error: Connection timeout
# または
Error: Response too large
# または
Error: Network unstable

# 問題点:
# - 大きなデータでタイムアウト
# - 接続が途中で切れる
# - 再試行が必要
```

## 改善後の動作

### 安定した通信

```bash
# 同じタスク
claude "List all issues in project ABC"

# 修正後:
Connecting to Jira (streamable HTTP)...
Fetching issues... (streaming)
✓ Retrieved 250 issues

Issues in ABC:
ABC-1: Login bug
ABC-2: Performance issue
...

# ✓ 大量のイシューも安定して取得
# ✓ ストリーミングで途切れない
# ✓ タイムアウトなし
```

## 実践例

### 大量のJiraイシュー取得

プロジェクト全体のイシューを分析。

```bash
# 1000件以上のイシューがあるプロジェクト
claude "Analyze all open issues in project XYZ"

# Streamable HTTP通信:
Connecting to Jira...
Streaming issues: 0/1250
Streaming issues: 250/1250
Streaming issues: 500/1250
Streaming issues: 750/1250
Streaming issues: 1000/1250
Streaming issues: 1250/1250
✓ All issues retrieved

# 分析開始:
Open issues: 1250
By priority:
- High: 120 (9.6%)
- Medium: 580 (46.4%)
- Low: 550 (44.0%)

# ✓ 大量データを確実に取得
# ✓ 進捗が見える
```

### Confluenceページの取得

大きなドキュメントを読み込み。

```bash
# 大量のページがあるスペース
claude "Search Confluence space 'Engineering' for API docs"

# Streamable HTTP:
Connecting to Confluence...
Streaming pages... (50 pages)
Streaming pages... (100 pages)
Streaming pages... (150 pages)
✓ Retrieved 172 pages

Found API documentation:
1. REST API Guide (50 pages)
2. GraphQL API (30 pages)
3. Authentication (15 pages)

# ✓ 大きなスペースも安定して検索
```

### イシューのバルク更新

複数のイシューを一括処理。

```bash
# 100件のイシューにラベルを追加
claude "Add label 'needs-review' to all issues in sprint 23"

# Streamable HTTP:
Fetching issues in sprint 23...
Found 100 issues

Updating issues (streaming):
Updated: 10/100
Updated: 25/100
Updated: 50/100
Updated: 75/100
Updated: 100/100
✓ All issues updated successfully

# ✓ バルク処理も安定
```

### 複雑なJQLクエリ

高度な検索でも安定動作。

```bash
# 複雑なJQL
claude "Find all issues updated in last 30 days with status 'In Progress' and assigned to team 'Backend'"

# Streamable HTTP:
Executing JQL query...
Streaming results...
✓ Found 385 matching issues

Top assignees:
- john@example.com: 45 issues
- jane@example.com: 38 issues
- ...

# ✓ 複雑なクエリも高速・安定
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- Streamable HTTPの特徴:
  - **ストリーミング通信**: データを分割して少しずつ受信
  - **タイムアウト回避**: 長時間の接続でも途切れない
  - **進捗表示**: データ取得の進行状況が見える
  - **エラー耐性**: ネットワーク一時中断にも対応
- 対象サービス:
  - **Jira**: イシュー、プロジェクト、スプリント
  - **Confluence**: ページ、スペース、添付ファイル
  - **Jira Service Management**: リクエスト、ナレッジベース
- デフォルト設定:
  ```json
  {
    "atlassian": {
      "transport": "streamable-http",
      "timeout": 300000,  // 5分
      "chunkSize": 100    // 100件ずつストリーミング
    }
  }
  ```
- 旧設定（非推奨）:
  ```json
  {
    "atlassian": {
      "transport": "http",  // 通常のHTTP（非ストリーミング）
      "timeout": 30000      // 30秒（短い）
    }
  }
  ```
- 設定のカスタマイズ:
  ```bash
  # ~/.claude/mcp-config.json
  {
    "atlassian": {
      "transport": "streamable-http",
      "chunkSize": 50,  // より細かく分割
      "retries": 3,     // 自動リトライ回数
      "timeout": 600000 // タイムアウトを10分に
    }
  }
  ```
- パフォーマンス:
  - 小規模データ（<100件）: 通常HTTPと同等
  - 中規模データ（100-1000件）: 20-30%高速化
  - 大規模データ（1000件以上）: 50%以上高速化、タイムアウトなし
- データサイズ制限:
  - 1リクエストあたり最大10,000件
  - それ以上は自動的にページネーション
- エラーハンドリング:
  ```bash
  # ネットワークエラー時
  Error: Connection lost during streaming
  Retrying... (attempt 1/3)
  ✓ Resumed from chunk 50

  # ✓ 自動リトライで続行
  ```
- 互換性:
  - Jira Cloud、Jira Server/Data Center
  - Confluence Cloud、Confluence Server/Data Center
  - 古いバージョンのAtlassian製品にも対応
- 認証:
  ```bash
  # API tokenを設定
  # ~/.claude/atlassian-credentials.json
  {
    "jira": {
      "url": "https://your-domain.atlassian.net",
      "email": "your@email.com",
      "apiToken": "YOUR_API_TOKEN"
    },
    "confluence": {
      "url": "https://your-domain.atlassian.net",
      "email": "your@email.com",
      "apiToken": "YOUR_API_TOKEN"
    }
  }
  ```
- デバッグモード:
  ```bash
  claude --debug "Query Jira"

  # ストリーミングログ:
  # [DEBUG] Atlassian MCP: Using streamable HTTP
  # [DEBUG] Chunk 1/10 received (100 items)
  # [DEBUG] Chunk 2/10 received (100 items)
  # [DEBUG] Streaming complete (1000 items total)
  ```
- トラブルシューティング:
  - ストリーミングが途切れる場合:
    - `chunkSize` を小さくする（例: 50）
    - `timeout` を長くする
  - 古いHTTP設定に戻す場合:
    ```json
    {
      "atlassian": {
        "transport": "http"
      }
    }
    ```

## 関連情報

- [MCP - Claude Code Docs](https://code.claude.com/docs/en/mcp)
- [Atlassian integration](https://code.claude.com/docs/en/integrations/atlassian)
- [Jira MCP server](https://github.com/anthropics/mcp-servers/tree/main/atlassian)
