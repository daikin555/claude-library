---
title: "フック出力がない場合に成功メッセージ末尾にコロンが表示される問題を修正"
date: 2026-01-31
tags: ['バグ修正', 'hooks', 'UI', 'メッセージ']
---

## 原文（日本語に翻訳）

フックに出力がない場合、成功メッセージの末尾にコロンが表示される問題を修正しました

## 原文（英語）

Fixed hook success message showing trailing colon when hook has no output

## 概要

Claude Code v2.1.0で修正された、フック実行成功メッセージの表示バグです。以前のバージョンでは、フックが正常に実行されたが標準出力に何も出力しなかった場合、成功メッセージの末尾に不要なコロン（`:`）が表示されていました。この修正により、出力の有無に応じて適切なメッセージが表示されるようになりました。

## 修正前の問題

### 出力なしフックの表示

```bash
# 出力を生成しないフック（~/.claude/hooks/pre-commit）
#!/bin/bash
# ファイルをフォーマットするだけ（出力なし）
prettier --write src/**/*.ts
exit 0

# フックが実行される
git commit -m "Update"

# 修正前の表示:
✓ pre-commit hook succeeded:
#                            ↑ 不要なコロン

# 見た目が不自然
```

### 複数フックの場合

```bash
# 複数のフックを実行
# hook1: 出力あり
# hook2: 出力なし
# hook3: 出力あり

# 修正前の表示:
✓ hook1 succeeded: Linting passed
✓ hook2 succeeded:
✓ hook3 succeeded: Tests passed

# hook2のコロンが不自然
```

## 修正後の動作

### クリーンな表示

```bash
# 出力なしフック
prettier --write src/**/*.ts

# 修正後の表示:
✓ pre-commit hook succeeded
#                          ↑ コロンなし、クリーン

# 出力ありフック
echo "All checks passed"

# 修正後の表示:
✓ pre-commit hook succeeded: All checks passed
#                          ↑ 出力があればコロン表示
```

### 様々なフックパターン

```bash
# 1. 出力なし（exit 0のみ）
✓ format hook succeeded

# 2. 短い出力
✓ lint hook succeeded: OK

# 3. 複数行出力
✓ test hook succeeded:
  • Unit tests: 45 passed
  • Integration tests: 12 passed

# 4. エラー出力（stderr）
✗ validate hook failed: Missing required field
```

## 実践例

### サイレントフォーマッター

出力なしで動作するフォーマッターフック。

```bash
# ~/.claude/hooks/pre-commit
#!/bin/bash
prettier --write --loglevel=silent src/**/*.ts
black --quiet src/**/*.py
exit 0

# 修正後: クリーンな表示
✓ pre-commit hook succeeded

# 修正前:
✓ pre-commit hook succeeded:  # 不要なコロン
```

### ファイル検証フック

検証のみ行い、出力は最小限。

```bash
# ~/.claude/hooks/pre-push
#!/bin/bash
# ファイルサイズをチェック（出力なし）
find . -type f -size +10M | grep -q . && exit 1
exit 0

# 修正後:
✓ pre-push hook succeeded

# シンプルで読みやすい
```

### 条件付き出力フック

問題がある場合のみ出力。

```bash
# ~/.claude/hooks/post-commit
#!/bin/bash
# TODOコメントをカウント
TODO_COUNT=$(grep -r "TODO" src/ | wc -l)
if [ $TODO_COUNT -gt 10 ]; then
  echo "Warning: $TODO_COUNT TODOs found"
fi
exit 0

# TODO多い場合:
✓ post-commit hook succeeded: Warning: 15 TODOs found

# TODO少ない場合（出力なし）:
✓ post-commit hook succeeded

# ✓ 両方とも適切な表示
```

### 複数フックの連続実行

```bash
# 4つのフックを連続実行
✓ lint hook succeeded
✓ format hook succeeded: 3 files formatted
✓ type-check hook succeeded
✓ test hook succeeded: All tests passed

# ✓ 統一感のある表示
# ✓ 出力の有無に応じて適切に表示
```

## 注意点

- Claude Code v2.1.0（2026年1月7日リリース）で実装
- フック出力の扱い:
  - **stdout（標準出力）**: 成功メッセージに続けて表示
  - **stderr（標準エラー）**: エラー時に赤色で表示
  - **出力なし**: コロンなしのシンプルな成功メッセージ
- メッセージフォーマット:
  - 出力あり: `✓ <hook-name> succeeded: <output>`
  - 出力なし: `✓ <hook-name> succeeded`
  - エラー: `✗ <hook-name> failed: <error>`
- 表示の最適化:
  - 出力の前後の空白は自動的にトリミング
  - 複数行出力は適切にインデント
  - 長い出力は折り返し表示
- フック開発のベストプラクティス:
  - 重要な情報のみ出力する
  - 成功時は出力を最小限に
  - エラー時は詳細な情報を提供
  - `--quiet` や `--silent` フラグを活用
- デバッグ:
  - `--debug` フラグでフックの詳細ログを確認
  - フックの終了コードとstdout/stderrを分離表示
- 関連する改善:
  - フック実行時間の表示（v2.1.0で追加）
  - フックスキップ時のメッセージ改善

## 関連情報

- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Hook development guide](https://code.claude.com/docs/en/hooks-guide)
