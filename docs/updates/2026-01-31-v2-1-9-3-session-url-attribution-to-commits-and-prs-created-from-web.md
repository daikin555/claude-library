---
title: "Webセッションからのコミット・PRにセッションURLを自動追加"
date: 2026-01-16
tags: ['新機能', 'Git', 'Web版', 'トレーサビリティ']
---

## 原文（日本語訳）

Webセッションから作成されたコミットとプルリクエストにセッションURLの帰属情報を追加しました。

## 原文（英語）

Added session URL attribution to commits and PRs created from web sessions

## 概要

Claude Code on the Web（ブラウザ版）から作成されたGitコミットやプルリクエストに、セッションURLが自動的に追加されるようになりました。これにより、どのClaude CodeセッションでコミットやPRが作成されたかを後から追跡できます。コミットメッセージやPRの説明に、対応するWebセッションへのリンクが含まれるため、コードレビュー時や後から経緯を確認する際に、Claudeとのやり取りの全コンテキストを参照できます。

## 基本的な使い方

この機能は自動的に動作するため、特別な設定は不要です。Claude Code on the Webでコミットやプルリクエストを作成すると、自動的にセッションURLが含まれます。

1. [claude.ai/code](https://claude.ai/code) でClaude Code on the Webを開く
2. コード変更を依頼する
3. Claudeにコミットまたはプルリクエストを作成してもらう
4. コミットメッセージやPR本文に、セッションURLが自動的に追加される

## 実践例

### コミットメッセージでの例

Webセッションから作成されたコミットには、以下のような形式でセッションURLが追加されます。

```
feat: add user authentication

Implement JWT-based authentication with refresh tokens.

Session: https://claude.ai/code/sessions/abc123xyz

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### プルリクエストでの例

PRの説明にもセッションURLが含まれるため、レビュアーは元の会話を確認できます。

```markdown
## Summary
- Implement JWT authentication
- Add refresh token rotation
- Update security middleware

## Test plan
- [x] Unit tests pass
- [x] Integration tests pass
- [x] Manual testing completed

🤖 Generated with [Claude Code](https://claude.com/claude-code)
Session: https://claude.ai/code/sessions/abc123xyz
```

### コードレビューでの活用

PRレビュー時に、セッションURLをクリックすることで：
- どのような指示でコードが生成されたか確認できる
- Claudeとのやり取りの全コンテキストを参照できる
- なぜその実装方針が選ばれたかを理解できる

### トラブルシューティング時の活用

バグ調査時に、問題のあるコミットのセッションURLから：
- 当時の要件や制約を確認できる
- 見落とされた考慮事項を発見できる
- 修正のヒントを得られる

## 注意点

- この機能はClaude Code on the Web（ブラウザ版）でのみ動作します
- CLI版のClaude Codeでは、セッションURLは追加されません（ローカル実行のため）
- セッションURLは公開される可能性があるため、機密情報を含むセッションには注意が必要です
- セッションURLへのアクセスには認証が必要な場合があります

## 関連情報

- [Claude Code on the Web](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Git統合ガイド](https://code.claude.com/docs/en/common-workflows)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
