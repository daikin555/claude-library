---
title: "タスク通知にエージェントの最終応答をインライン表示"
date: 2026-01-14
tags: ['新機能', 'エージェント', 'UX', 'タスク']
---

## 原文（日本語に翻訳）

タスク通知にエージェントの最終応答をインライン表示する機能を追加しました。これにより、完全なトランスクリプトファイルを読まなくても、結果を簡単に確認できるようになります。

## 原文（英語）

Added inline display of agent's final response in task notifications, making it easier to see results without reading the full transcript file

## 概要

Claude Codeでバックグラウンドタスクやエージェントを実行した際、その結果がタスク通知内に直接表示されるようになりました。従来はトランスクリプトファイル全体を開いて確認する必要がありましたが、最終的な結果をすぐに確認できるため、作業効率が大幅に向上します。

## 基本的な使い方

この機能は自動的に有効化されており、特別な設定は不要です。

### タスク実行時の動作

1. `Task`ツールを使用してバックグラウンドでエージェントを実行
2. タスクが完了すると通知が表示される
3. 通知内にエージェントの最終応答が直接表示される
4. 詳細が必要な場合は、トランスクリプトファイルへのリンクも利用可能

## 実践例

### コードベース探索エージェントの結果確認

Exploreエージェントを使用して特定の機能を調査した場合。

**従来の方法:**
```
✓ Task completed
View full transcript: /path/to/transcript.md
```
→ ファイルを開いて最後までスクロールして結果を確認

**v2.1.7以降:**
```
✓ Task completed

Final response:
The authentication system is implemented in src/auth/
with the following key files:
- src/auth/login.ts - handles user login
- src/auth/session.ts - manages sessions
- src/auth/middleware.ts - protects routes

View full transcript: /path/to/transcript.md
```
→ 通知内で即座に結果を確認可能

### テスト実行結果の確認

テストエージェントを使用した場合。

**v2.1.7以降:**
```
✓ Task completed

Final response:
All tests passed! ✓
- 45 tests ran
- 0 failures
- Coverage: 87%

View full transcript: /path/to/transcript.md
```

### ビルド結果の確認

ビルドエージェントを実行した場合。

**v2.1.7以降:**
```
✓ Task completed

Final response:
Build successful!
Output: dist/app.js (2.3 MB)
Build time: 12.4s
No warnings or errors.

View full transcript: /path/to/transcript.md
```

### 複数タスクの並列実行

複数のバックグラウンドタスクを同時実行している場合でも、各通知に結果が表示されるため、どのタスクがどんな結果を返したか一目で把握できます。

## 注意点

- **最終応答のみ**: インライン表示されるのはエージェントの最後の応答のみです。途中経過を確認したい場合はトランスクリプトファイルを参照してください
- **長い応答**: 応答が非常に長い場合、通知内では一部が省略される可能性があります
- **通知の表示期間**: 通知は一定時間後に消える場合があるため、後で確認したい場合はトランスクリプトファイルを保存してください
- **フォーマット**: 応答はプレーンテキストとして表示されるため、複雑なフォーマットや画像は含まれません

## 関連情報

- [Claude Code Task ツール](https://code.claude.com/docs/)
- [Claude Code エージェント機能](https://code.claude.com/docs/)
- [Changelog v2.1.7](https://github.com/anthropics/claude-code/releases/tag/v2.1.7)
