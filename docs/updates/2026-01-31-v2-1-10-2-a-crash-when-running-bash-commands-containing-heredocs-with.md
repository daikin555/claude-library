---
title: "heredoc内のテンプレートリテラルによるクラッシュを修正"
date: 2026-01-16
tags: ['バグ修正', 'bash', 'コマンド', 'heredoc']
---

## 原文(日本語に翻訳)

JavaScriptのテンプレートリテラル(`${index + 1}`など)を含むheredocを使用したbashコマンド実行時のクラッシュを修正

## 原文(英語)

Fixed a crash when running bash commands containing heredocs with JavaScript template literals like `${index + 1}`

## 概要

Claude Code v2.1.10では、bashコマンド内でheredocとJavaScriptのテンプレートリテラル構文が混在する場合に発生していたクラッシュを修正しました。これにより、複雑なスクリプト生成やコード出力が安全に実行できるようになりました。

## 基本的な使い方

修正前はクラッシュしていた以下のようなコマンドが正常に動作するようになります:

```bash
cat <<'EOF' > script.js
const items = ['a', 'b', 'c'];
items.forEach((item, index) => {
  console.log(`Item ${index + 1}: ${item}`);
});
EOF
```

## 実践例

### JavaScriptファイルの生成

テンプレートリテラルを含むJavaScriptコードをheredocで生成:

```bash
cat <<'EOF' > template.js
function createMessage(name, count) {
  return `Hello ${name}, you have ${count} new messages`;
}
EOF
```

シングルクォート(`'EOF'`)を使用することで、シェルによる変数展開を防ぎ、JavaScriptのテンプレートリテラルがそのまま出力されます。

### Reactコンポーネントの生成

JSX内のテンプレートリテラルを含むコンポーネント:

```bash
cat <<'EOF' > Component.jsx
export const UserCard = ({ user }) => {
  return (
    <div className="user-card">
      <h2>{`${user.firstName} ${user.lastName}`}</h2>
      <p>{`Member since ${user.joinYear}`}</p>
    </div>
  );
};
EOF
```

### TypeScriptの型定義生成

複雑な型定義を含むファイル:

```bash
cat <<'EOF' > types.ts
type FormattedUser = {
  displayName: string;
  fullName: `${string} ${string}`;
  email: `${string}@${string}`;
};

const formatUser = (user: User): FormattedUser => ({
  displayName: `${user.firstName} ${user.lastName}`,
  fullName: `${user.firstName} ${user.lastName}`,
  email: user.email
});
EOF
```

### SQL生成スクリプト

動的なSQLクエリを生成するスクリプト:

```bash
cat <<'EOF' > query-generator.js
const generateQuery = (table, conditions) => {
  const where = conditions.map((c, i) =>
    `${c.field} = $${i + 1}`
  ).join(' AND ');
  return `SELECT * FROM ${table} WHERE ${where}`;
};
EOF
```

## 注意点

- heredocでテンプレートリテラルをそのまま出力したい場合は、`<<'EOF'`のようにシングルクォートで囲むことを推奨します
- シングルクォートなし(`<<EOF`)の場合、シェルが`${...}`を変数として解釈しようとするため注意が必要です
- 複雑なネストされたテンプレートリテラルを含む場合も、この修正により安定して動作します

## 関連情報

- [Bash heredoc のドキュメント](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
- [Changelog v2.1.10](https://github.com/anthropics/claude-code/releases/tag/v2.1.10)
