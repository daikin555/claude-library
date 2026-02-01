---
title: "ペーストしたテキストの一括削除機能の改善"
date: 2026-01-20
tags: ['改善', 'UI/UX', 'テキスト編集', '操作性']
---

## 原文（日本語に翻訳）

ペーストしたテキストを1文字ずつではなく、1つのトークンとして一括で削除できるようにBackspace動作を改善

## 原文（英語）

Improved backspace to delete pasted text as a single token instead of one character at a time

## 概要

Claude Codeの入力エリアにテキストをペーストした後、Backspaceキーを押すとペーストした内容全体が一度に削除されるように改善しました。以前は1文字ずつ削除する必要がありましたが、この改善により、誤ってペーストした内容や不要なテキストを素早く削除できるようになりました。一般的なテキストエディタやIDE（VS Code、IntelliJ等）と同様の直感的な操作が可能になり、作業効率が大幅に向上しています。

## 基本的な使い方

テキストをペーストした直後にBackspaceキーを1回押すと、ペーストした内容全体が削除されます。

```
# 通常の入力
Fix the bug in → (1文字ずつBackspaceで削除)

# ペーストした内容
[Cmd/Ctrl + V でコードをペースト]
→ Backspace 1回で全削除 ✓
```

## 実践例

### コードスニペットの誤ペースト

コードをペーストしたが間違いに気づいた場合。

```
# 誤って古いコードをペースト
const oldFunction = () => {
  console.log("deprecated");
  return null;
}

# 以前: Backspaceを何十回も押す必要があった
# 改善後: Backspace 1回で全削除

# 正しいコードをペースト
const newFunction = () => {
  console.log("updated");
  return true;
}
```

### 長いエラーメッセージのペースト

ログやエラーメッセージを貼り付けてから考え直した場合。

```
# エラーログをペースト
Error: Cannot find module 'express'
Require stack:
- /Users/dev/project/src/server.js
- /Users/dev/project/src/index.js
  at Function.Module._resolveFilename (internal/modules/cjs/loader.js:815:15)
  at Function.Module._load (internal/modules/cjs/loader.js:667:27)
  ...（さらに50行続く）

# やっぱり不要だと判断
# 改善後: Backspace 1回で全削除
# 以前: 数百文字を1文字ずつ削除...
```

### URLや長いパスの誤ペースト

長いファイルパスやURLをペーストしたが間違いだった場合。

```
# 間違ったURLをペースト
https://github.com/organization/repository/blob/main/src/components/features/authentication/hooks/useAuthenticationWithRefreshToken.tsx

# 改善後: Backspace 1回で削除
# 正しいURLをペースト
https://github.com/organization/repository/blob/main/src/auth/index.tsx
```

### 複数行のテキストのペースト

複数行のテキストブロックをペーストした後の削除。

```
# 設定ファイルの内容をペースト
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "outDir": "./dist",
    "rootDir": "./src"
  }
}

# 不要だと判断
# 改善後: Backspace 1回で全削除（複数行でも対応）
```

## 注意点

- この改善は Claude Code v2.1.14 で適用されました
- 一括削除が適用されるのは「ペースト直後のBackspace」のみです
- 以下の場合は通常の1文字削除になります:
  - ペースト後に何か文字を入力した場合
  - ペースト後にカーソルを移動した場合
  - ペースト後に時間が経過した場合（数秒以上）
- 通常の手入力テキストは引き続き1文字ずつ削除されます
- この機能は以下のペースト方法すべてで動作します:
  - Cmd+V / Ctrl+V
  - 右クリック → ペースト
  - ミドルクリックペースト（Linux）
- Ctrl+Backspace（単語削除）は従来通り動作します
- やり直し（Undo: Cmd+Z / Ctrl+Z）でペーストした内容を復元できます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.14](https://github.com/anthropics/claude-code/releases/tag/v2.1.14)
- [キーボードショートカット](https://code.claude.com/docs/keyboard-shortcuts)
- [テキスト編集のベストプラクティス](https://code.claude.com/docs/best-practices/text-editing)
