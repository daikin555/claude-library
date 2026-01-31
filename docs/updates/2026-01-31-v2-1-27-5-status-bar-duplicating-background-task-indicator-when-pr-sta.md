---
title: "PR状態表示時にステータスバーのバックグラウンドタスクインジケーターが重複する問題を修正"
date: 2026-01-30
tags: ['バグ修正', 'UI', 'ステータスバー', 'GitHub']
---

## 原文（日本語に翻訳）

PR状態が表示されているときにステータスバーでバックグラウンドタスクインジケーターが重複表示される問題を修正

## 原文（英語）

Fixed status bar duplicating background task indicator when PR status was shown

## 概要

GitHub Pull Requestの状態をステータスバーに表示している際に、バックグラウンドタスクのインジケーター（スピナーや進行状況）が二重に表示される視覚的なバグが修正されました。これにより、ステータスバーの表示がクリーンで読みやすくなります。

## 問題の背景

v2.1.27以前、以下の状況で問題が発生していました：

1. GitHub PRに関連したセッションで作業中
2. PR状態（マージ可否、チェック状態など）がステータスバーに表示される
3. 同時にバックグラウンドタスク（ファイル検索、テスト実行など）が実行される
4. タスクインジケーターが重複して表示される

### 具体的な症状

```
# 重複表示の例（v2.1.26以前）
[⚙️  Running tests...] [PR #123: ✓ All checks passed] [⚙️  Running tests...]
                                                        ^^^^^^^^^^^^^^^^^^^^
                                                        重複したインジケーター
```

この重複により：
- ステータスバーが不必要に長くなる
- 視覚的なノイズが増加
- どのタスクが実行中なのか把握しにくい
- 画面の表示領域が無駄になる

## 修正内容

v2.1.27での改善：

- PR状態とバックグラウンドタスクの表示ロジックを統合
- 重複チェック機能の実装
- インジケーター表示の優先順位付け
- ステータスバーレイアウトの最適化

## 実践例

### PR関連の作業中

```bash
# v2.1.27以降の正常な表示
[⚙️  Running tests...] [PR #123: ⏳ Checks in progress]

# タスク完了後
[PR #123: ✓ All checks passed]
```

重複なく、クリーンに表示されます。

### 複数のバックグラウンドタスク実行中

```bash
# 複数タスクがある場合も重複なし
[⚙️  2 tasks running] [PR #456: 📝 Review requested]

# タスクの詳細を確認
> /tasks
```

### PR作成ワークフロー

```bash
# 1. 機能実装中
[⚙️  Installing dependencies...]

# 2. PR作成
> "/commit-push-pr"
[⚙️  Creating PR...] [Branch: feature-auth]

# 3. PR作成完了
[PR #789: ⏳ Waiting for checks]

# 4. チェック実行中（重複なし）
[PR #789: ⏳ Checks in progress]
```

### 長時間実行タスク

```bash
# 長時間タスク実行中もクリーンな表示
[⚙️  Building project... (2m 34s)] [PR #100: ✓ Ready to merge]
```

## ステータスバー表示の優先順位

v2.1.27では以下の優先順位で表示されます：

1. **エラー/警告**: 最優先で表示
   ```
   [❌ Error: Build failed] [PR #123]
   ```

2. **アクティブタスク**: エラーがない場合
   ```
   [⚙️  Running tests...] [PR #123]
   ```

3. **PR状態**: タスクがない場合
   ```
   [PR #123: ✓ All checks passed]
   ```

4. **アイドル状態**: 何もない場合
   ```
   [Ready]
   ```

## ステータスバーのカスタマイズ

ステータスバーの表示をカスタマイズできます：

```json
// ~/.claude/settings.json
{
  "statusline": {
    "showPRStatus": true,
    "showBackgroundTasks": true,
    "showTimer": true,
    "maxLength": 80
  }
}
```

## v2.1.27以前の動作との比較

**v2.1.26以前：**
```
[⚙️  Task 1] [PR #123] [⚙️  Task 1] [⚙️  Task 2]
              ^^^^^^^^
              重複表示    混乱を招く配置
```

**v2.1.27以降：**
```
[⚙️  2 tasks running] [PR #123: ✓]
クリーン、簡潔、読みやすい
```

## PR状態の種類

ステータスバーに表示されるPR状態の例：

- `✓ All checks passed` - すべてのチェックが成功
- `⏳ Checks in progress` - チェック実行中
- `❌ Checks failed` - チェック失敗
- `📝 Review requested` - レビュー待ち
- `✅ Approved` - 承認済み
- `🔀 Ready to merge` - マージ可能
- `⛔ Conflicts` - コンフリクトあり

## トラブルシューティング

### ステータスバーが更新されない場合

```bash
# 手動で更新
> /refresh

# または、デバッグモードで確認
claude --debug
```

### PR状態が表示されない場合

```bash
# GitHub CLIの認証確認
gh auth status

# リポジトリ情報の確認
git remote -v
```

### カスタムステータスバースクリプトとの競合

```bash
# カスタムスクリプトを一時的に無効化
# ~/.claude/settings.json
{
  "statusline": {
    "script": null
  }
}
```

## 注意点

- この修正はステータスバーの視覚的な表示のみに影響します
- バックグラウンドタスクの実行自体には影響しません
- カスタムステータスバースクリプトを使用している場合、独自のロジックで重複を防ぐ必要があるかもしれません
- ターミナルの幅が狭い場合、一部の情報が省略される可能性があります

## パフォーマンスへの影響

- **レンダリング**: 重複チェックにより若干効率化
- **CPU使用率**: ほぼ変化なし
- **視認性**: 大幅に向上
- **画面領域**: より効率的に使用

## カスタムステータスバーとの互換性

カスタムステータスバースクリプトを使用している場合でも、重複検出が機能します：

```bash
#!/bin/bash
# ~/.claude/statusline.sh

# カスタム情報を出力
echo -n "Custom: $(date +%H:%M) "

# Claude Codeが自動的に重複を防ぐ
```

## 関連情報

- [Status line configuration - Claude Code Docs](https://code.claude.com/docs/en/statusline)
- [Interactive mode - Claude Code Docs](https://code.claude.com/docs/en/interactive-mode)
- [GitHub Actions - Claude Code Docs](https://code.claude.com/docs/en/github-actions)
- [Changelog v2.1.27](https://github.com/anthropics/claude-code/releases/tag/v2.1.27)
