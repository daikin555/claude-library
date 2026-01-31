---
title: "セッション再開時のレート制限メニューの誤表示を修正"
date: 2026-01-13
tags: ['バグ修正', 'レート制限', 'UI', 'セッション管理']
---

## 原文（日本語に翻訳）

前回のセッションを再開した際にレート制限オプションメニューが誤って自動的に開く問題を修正

## 原文（英語）

Fixed rate limit options menu incorrectly auto-opening when resuming a previous session

## 概要

Claude Code v2.1.6 では、セッション管理に関する問題が修正されました。以前のバージョンでは、前回の会話セッションを再開した際に、レート制限オプションメニューが不必要に自動的に開いてしまう問題がありました。この修正により、セッション再開がよりスムーズになり、不要な中断がなくなりました。

## 基本的な使い方

この修正は自動的に適用され、ユーザー側での設定変更は不要です。

正常なセッション再開:
1. Claude Code を終了
2. 後で Claude Code を再起動
3. 前回のセッションが自動的に復元される
4. レート制限メニューは必要な場合のみ表示される

## 実践例

### 修正前の問題（v2.1.5以前）

セッション再開時に以下の問題が発生していました:

```bash
# Claude Code を起動
$ claude

# 前回のセッションを復元中...
Restoring previous session...

# 突然レート制限メニューが表示される
╔════════════════════════════════════╗
║  Rate Limit Options                ║
║                                    ║
║  1. View current usage             ║
║  2. Upgrade plan                   ║
║  3. Optimize usage                 ║
║  4. Dismiss                        ║
╚════════════════════════════════════╝

# レート制限に達していないのにメニューが開く
# 毎回手動で閉じる必要があった
```

これにより、スムーズな作業の再開が妨げられていました。

### 修正後の動作（v2.1.6以降）

v2.1.6 では、レート制限メニューは必要な場合のみ表示されます:

```bash
# Claude Code を起動
$ claude

# 前回のセッションを静かに復元
Restoring previous session...
Session restored successfully.

# メニューは表示されず、すぐに作業を再開できる
> How can I help you today?

# レート制限に実際に近づいた場合のみ警告が表示される
```

### レート制限メニューが表示される正常なケース

メニューが表示されるべき状況:

1. **使用率が70%を超えた場合**
   ```
   ⚠ Warning: You have used 75% of your weekly quota

   Rate Limit Options:
   1. View detailed usage
   2. Optimize current session
   3. Continue anyway
   ```

2. **レート制限に達した場合**
   ```
   ⚠ Rate limit reached

   Options:
   1. Wait for reset (2 days)
   2. Upgrade plan
   3. View alternative actions
   ```

3. **手動でメニューを開いた場合**
   ```bash
   /stats  # 使用状況を確認
   # メニューが表示される（意図的な操作）
   ```

### セッション復元の正常な流れ

セッション再開時の動作:

```bash
# Claude Code を起動
$ claude

# 自動的に前回のセッションをチェック
Checking for previous session...

# セッションが見つかった場合
Found previous session from 2 hours ago
Restoring conversation history...

# コンテキストを復元
Restored 15 messages
Total context: 12,450 tokens

# すぐに作業を再開
> Ready to continue. What would you like to work on?
```

### セッションの手動管理

セッションを管理する方法:

```bash
# 現在のセッションを保存して終了
/exit

# 新しいセッションを開始（前回のセッションを無視）
claude --new-session

# 特定のセッションを復元
claude --restore-session <session-id>

# セッション一覧を表示
/sessions
```

### レート制限の手動確認

必要に応じて手動で使用状況を確認:

```bash
# 使用統計を表示
/stats

# レート制限の詳細を表示
/stats --detailed

# 使用率が高い場合のみメニューが表示される
```

### セッション復元の設定

セッション復元の動作をカスタマイズ:

```bash
/config
# "session" で検索

# 設定例:
# autoRestoreSession: true/false
# sessionTimeout: 24h, 7d など
# showRestoreNotification: true/false
```

## 注意点

- この修正は Claude Code v2.1.6 で導入されました
- レート制限メニューは、実際に制限に近づいた場合のみ表示されます
- セッション復元時の不要な中断がなくなり、作業がスムーズになります
- レート制限の状態は正確に追跡され、必要な場合のみ警告が表示されます
- 手動で `/stats` を実行すれば、いつでも使用状況を確認できます
- セッションの自動復元は設定でオフにすることも可能です
- この修正により、起動時の UX が大幅に改善されました

## 関連情報

- [Changelog v2.1.6](https://github.com/anthropics/claude-code/releases/tag/v2.1.6)
- [Changelog v2.1.6 - Rate limit warning fix](https://github.com/anthropics/claude-code/releases/tag/v2.1.6) - 関連するレート制限の修正
- [Claude Code セッション管理](https://code.claude.com/docs/sessions)
