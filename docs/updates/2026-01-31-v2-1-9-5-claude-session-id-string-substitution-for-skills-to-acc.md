---
title: "Skillsで現在のセッションIDにアクセス可能に"
date: 2026-01-16
tags: ['新機能', 'Skills', '変数展開']
---

## 原文（日本語訳）

Skillsが現在のセッションIDにアクセスできるよう、`${CLAUDE_SESSION_ID}` 文字列置換を追加しました。

## 原文（英語）

Added `${CLAUDE_SESSION_ID}` string substitution for skills to access the current session ID

## 概要

Skills（スキル）の定義内で `${CLAUDE_SESSION_ID}` 変数を使用できるようになり、現在のClaude Codeセッションの一意なIDにアクセスできます。これにより、セッション固有のログファイル作成、セッション間の関連付け、セッション単位のデバッグ情報収集などが可能になります。各セッションには一意のIDが割り当てられており、この変数を通じてSkillやスクリプトから参照できます。

## 基本的な使い方

Skillの `SKILL.md` ファイル内で `${CLAUDE_SESSION_ID}` を記述します。Skillが実行される際、この変数が現在のセッションIDに置き換えられます。

```yaml
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```

## 実践例

### セッション専用のログファイルを作成

各セッションごとに別々のログファイルを作成し、後から特定セッションの活動を追跡できるようにします。

`~/.claude/skills/session-logger/SKILL.md`:
```yaml
---
name: session-logger
description: Log important events for this session
---

Log the following event to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS

Make sure the logs directory exists first.
```

使用例:
```
> /session-logger Started authentication implementation
```

### セッション固有の一時ファイル管理

セッションごとに一時ファイルを分離し、セッション終了時にクリーンアップします。

`~/.claude/skills/temp-workspace/SKILL.md`:
```yaml
---
name: temp-workspace
description: Create temporary workspace for this session
---

Create a temporary workspace at /tmp/claude-${CLAUDE_SESSION_ID}/:

1. Create the directory if it doesn't exist
2. Set appropriate permissions
3. Return the full path to the user
```

### セッション間の関連付け

複数のセッションにまたがる作業を関連付けて追跡します。

`~/.claude/skills/link-sessions/SKILL.md`:
```yaml
---
name: link-sessions
description: Link current session to previous work
---

Create a session link file at .claude/session-links/${CLAUDE_SESSION_ID}.json:

{
  "current_session": "${CLAUDE_SESSION_ID}",
  "related_to": "$ARGUMENTS",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
```

### デバッグ情報の収集

セッションIDを使用して、問題が発生したセッションのコンテキストを保存します。

`~/.claude/skills/debug-snapshot/SKILL.md`:
```yaml
---
name: debug-snapshot
description: Save debugging snapshot for this session
---

Create debug snapshot at debug/${CLAUDE_SESSION_ID}/:

1. Save current git status
2. Save environment variables
3. Save recent command history
4. Save error logs if any
5. Create README.md with session info:
   - Session ID: ${CLAUDE_SESSION_ID}
   - Timestamp: $(date)
   - Issue: $ARGUMENTS
```

### セッションレポートの生成

セッション終了時に、そのセッションでの活動サマリーを生成します。

`~/.claude/skills/session-report/SKILL.md`:
```yaml
---
name: session-report
description: Generate activity report for this session
---

Generate session report at reports/session-${CLAUDE_SESSION_ID}.md:

## Session ${CLAUDE_SESSION_ID}

### Summary
$ARGUMENTS

### Files Modified
[List files changed in this session]

### Commands Executed
[List significant commands run]

### Next Steps
[Document what remains to be done]
```

## 注意点

- セッションIDは各セッションごとに一意ですが、形式や長さは実装によって変わる可能性があります
- セッションIDはファイル名として使用できる文字列ですが、パスインジェクション対策として検証することを推奨します
- セッションIDは機密情報ではありませんが、プロジェクトの構造や活動パターンを推測できる可能性があります
- この変数はSkillsでのみ利用可能です（Hooksでは直接利用できません）
- 他の利用可能な変数: `$ARGUMENTS`, `$ARGUMENTS[N]`, `$N`

## 関連情報

- [Skills公式ドキュメント](https://code.claude.com/docs/en/skills)
- [String Substitutions](https://code.claude.com/docs/en/skills#available-string-substitutions)
- [Changelog v2.1.9](https://github.com/anthropics/claude-code/releases/tag/v2.1.9)
