---
title: "バックグラウンドエージェントが起動前にツール権限を確認するよう変更"
date: 2026-01-27
tags: ['セキュリティ変更', 'パーミッション', 'バックグラウンドエージェント']
---

## 原文（日本語に翻訳）

バックグラウンドエージェントが起動する前にツール権限の確認を求めるよう変更

## 原文（英語）

Changed background agents to prompt for tool permissions before launching

## 概要

Claude Code v2.1.20では、バックグラウンドエージェントのセキュリティと透明性が向上しました。以前は、バックグラウンドで実行されるエージェントが、ユーザーへの確認なしにツールを使用できましたが、この変更により、エージェント起動前に必要な権限の確認プロンプトが表示されるようになります。これにより、ユーザーはバックグラウンド処理が何を行うか事前に把握でき、より安全に使用できます。

## 基本的な使い方

バックグラウンドエージェント起動時に権限確認が表示されます：

```bash
# バックグラウンドタスクを開始
> プロジェクト全体のテストを実行して、完了したら通知して

# 変更前：
# タスクが即座にバックグラウンドで開始
# どのツールが使われるか不明

# 変更後：
Background agent requests the following permissions:
  • Bash - Run test commands
  • Read - Access test files
  • Write - Update test reports

Allow these permissions? (y/n): y

✓ Permissions granted
✓ Background agent started
  Task ID: bg-task-abc123

# ユーザーが何が実行されるか把握した上で承認
```

## 実践例

### 長時間実行タスクのバックグラウンド化

CI/CDパイプラインの実行：

```bash
> 完全なビルドとテストスイートをバックグラウンドで実行

Background Agent Permission Request:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Build and test suite

Requested permissions:
  ✓ Bash(npm run build)
    - Compile TypeScript
    - Bundle assets
    - Minify production code

  ✓ Bash(npm test)
    - Run unit tests (est. 500 tests)
    - Run integration tests
    - Generate coverage report

  ✓ Write(build/, coverage/)
    - Save build artifacts
    - Save test coverage reports

Estimated duration: 10-15 minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Approve? [Y/n]: y

✓ Background task started
  Monitor with: /tasks bg-task-xyz789

# 変更により：
# - 何が実行されるか明確
# - リスクを理解した上で承認
# - 予想実行時間も把握可能
```

### データ処理タスクの承認

大量のファイル処理：

```bash
> 1000個の画像ファイルをリサイズして最適化

Permission Request:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Batch image processing (background)

Tools required:
  🔧 Bash - ImageMagick/sharp commands
     Will process: images/*.{jpg,png}
     Estimated files: ~1000

  📁 Read - Source images
     Directory: ./images/
     Total size: ~2.5GB

  📝 Write - Processed images
     Output: ./images/optimized/
     Expected size: ~800MB

⚠️  Warning: This operation:
    - Will use significant CPU
    - May take 20-30 minutes
    - Requires 3GB disk space

Continue? [y/N]: y

# 変更の利点：
# - リソース使用量が事前に分かる
# - ディスク容量の確認ができる
# - 予期しない処理を防止
```

### MCPツールの使用承認

外部サービスへのアクセス：

```bash
> データベースの全ユーザーをバックグラウンドでエクスポート

Permission Request:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Database export (background)

MCP Tools:
  🗄️  @database.query
     - Read access to users table
     - Estimated rows: 50,000
     - Network: db.company.com

  💾 Write - Local export file
     - File: ./exports/users_YYYY-MM-DD.json
     - Size: ~15MB

🔒 Security note:
   This will export production data.
   Ensure compliance with data policies.

Authorize? [y/N]: y

# セキュリティ向上：
# - 本番データへのアクセスが明示
# - コンプライアンス確認を促進
# - 誤った操作を防止
```

### 権限の拒否とカスタマイズ

不要な権限を除外：

```bash
> このプロジェクトを分析してレポート生成

Permission Request:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tools requested:
  ✓ Read - Project files (src/, tests/)
  ✓ Grep - Search for patterns
  ⚠️ Bash - Install analysis tools
  ⚠️ Write - Modify .gitignore

Bash permission includes:
  - npm install code-analyzer
  - pip install pylint

Approve all? [y/n/customize]: c

Customize permissions:
  [✓] Read project files
  [✓] Search patterns
  [ ] Install tools (Bash)  ← 拒否
  [ ] Modify .gitignore     ← 拒否

Proceed with selected permissions? [y/N]: y

✓ Background task started with limited permissions
  Note: Tool installation skipped

# 変更により：
# - 細かい権限制御が可能
# - 不要な変更を防止
# - セキュリティ意識の向上
```

### 定期実行タスクの設定

スケジュールされたバックグラウンドタスク：

```bash
> 毎朝9時にテストを自動実行するようスケジュール

Scheduled Background Task Permissions:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Schedule: Daily at 09:00

Recurring permissions:
  ✓ Bash(npm test) - Run test suite
  ✓ Read(tests/) - Access test files
  ✓ Write(reports/) - Save test reports
  ✓ @slack.postMessage - Post results

⚠️  This grant will persist until manually revoked.

  Review/revoke: /config permissions

Grant recurring permissions? [y/N]: y

✓ Scheduled task configured
  Next run: Tomorrow 09:00
  Manage: /schedule list

# 定期タスクでも：
# - 明示的な承認が必要
# - 権限の範囲が明確
# - 後から取り消し可能
```

### チーム環境での透明性

複数人で使用するプロジェクト：

```bash
> CI環境でテストを自動実行

Permission Request (CI Mode):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Automated CI workflow

Environment: CI=true
User: ci-bot@company.com

Permissions:
  ✓ Bash - All test commands
  ✓ Read - All project files
  ✓ Write - Test results, artifacts
  ✓ @github - Update PR status

🔍 Audit log will be saved to:
   /var/log/claude-code/ci-permissions.log

Auto-approve for CI? [y/N]: y

# チーム環境での利点：
# - すべての権限が記録される
# - 監査ログで追跡可能
# - 透明性の確保
```

## 注意点

- この変更はバックグラウンドエージェントにのみ適用されます（フォアグラウンドタスクは影響なし）
- 権限を拒否した場合、タスクは制限された機能で実行されるか、開始されません
- 一度承認した権限は、そのセッション中は再度確認されません
- CI/CD環境では、環境変数で自動承認を設定できます
- 権限リクエストは、タスクが実際に使用する予定のツールのみを表示します

## 関連情報

- [Background Agents](https://code.claude.com/docs/en/advanced/background-agents)
- [Permission System](https://code.claude.com/docs/en/security/permissions)
- [Security Best Practices](https://code.claude.com/docs/en/security/best-practices)
- [CI/CD Integration](https://code.claude.com/docs/en/workflows/ci-cd)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
