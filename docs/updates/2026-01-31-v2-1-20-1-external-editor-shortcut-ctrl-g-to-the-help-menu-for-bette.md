---
title: "外部エディタショートカット（Ctrl+G）がヘルプメニューに追加"
date: 2026-01-27
tags: ['新機能', 'キーボードショートカット', 'エディタ連携']
---

## 原文（日本語に翻訳）

見つけやすさを向上させるため、外部エディタショートカット（Ctrl+G）をヘルプメニューに追加

## 原文（英語）

Added external editor shortcut (Ctrl+G) to the help menu for better discoverability

## 概要

Claude Code v2.1.20で、`Ctrl+G`ショートカットがヘルプメニューに追加され、見つけやすくなりました。このショートカットを使用すると、現在のプロンプトやカスタムレスポンスをデフォルトのテキストエディタで編集できます。長文のプロンプトや複雑なコード例を記述する際に、使い慣れたエディタの機能（シンタックスハイライト、複数カーソル、検索置換など）を活用できます。

## 基本的な使い方

1. Claude Codeの入力プロンプトで`Ctrl+G`を押す
2. デフォルトのテキストエディタが開き、現在の入力内容が表示される
3. エディタで自由に編集
4. エディタを保存して閉じると、編集内容がClaude Codeに反映される

```bash
# ヘルプメニューで確認
# Claude Code内で`?`を押すとショートカット一覧が表示される
# Ctrl+G: Open in default text editor

# 使用例
# 1. 入力プロンプトで何か入力を開始
# 2. Ctrl+Gを押す
# 3. VS Code、vim、emacsなどのデフォルトエディタが開く
# 4. 複雑なプロンプトや長いコード例を記述
# 5. 保存して閉じる
```

## 実践例

### 長いプロンプトの作成

複数の要件や詳細な指示を含む長いプロンプトを作成する場合：

```
1. Claude Codeで大まかな指示を入力開始
2. Ctrl+Gで外部エディタを開く
3. エディタで以下のような詳細を追加：
   - 複数の箇条書き
   - コードスニペット例
   - 詳細な仕様や制約
4. 保存して閉じると、Claude Codeに完全な形で反映
```

### コード例を含むプロンプトの編集

エディタのシンタックスハイライトを活用してコード例を記述：

```python
# Ctrl+Gで外部エディタを開き、以下のようなプロンプトを作成

次のコードをリファクタリングしてください：

\`\`\`python
def process_data(data):
    result = []
    for item in data:
        if item['status'] == 'active':
            result.append({
                'id': item['id'],
                'name': item['name'],
                'processed': True
            })
    return result
\`\`\`

要件：
- リスト内包表記を使用
- 型ヒントを追加
- docstringを追加
```

### 複雑な正規表現やSQLクエリの作成

エディタの検索・置換機能を使って複雑なパターンを作成：

```sql
-- Ctrl+Gでエディタを開き、複雑なSQLクエリを記述
-- エディタのシンタックスハイライトでミスを防ぐ

SELECT
    users.id,
    users.name,
    COUNT(orders.id) as order_count,
    SUM(orders.amount) as total_amount
FROM users
LEFT JOIN orders ON users.id = orders.user_id
WHERE users.created_at >= '2025-01-01'
GROUP BY users.id, users.name
HAVING COUNT(orders.id) > 5
ORDER BY total_amount DESC;
```

### マークダウン形式のドキュメント作成

外部エディタのプレビュー機能を使って、整形されたドキュメントを作成：

```markdown
# Ctrl+GでMarkdownエディタを開く

## 機能仕様書

### 概要
このAPIは...

### エンドポイント
- `GET /api/users` - ユーザー一覧取得
- `POST /api/users` - ユーザー作成

### レスポンス例
\`\`\`json
{
  "id": 1,
  "name": "John Doe"
}
\`\`\`
```

## 注意点

- デフォルトエディタは環境変数`$EDITOR`または`$VISUAL`で設定されます
- エディタが設定されていない場合、システムのデフォルトが使用されます
- エディタを閉じずに保存しただけでは、変更はClaude Codeに反映されません
- ヘルプメニューは`?`キーで表示できます
- このショートカットは入力プロンプト以外の場所では動作しません

## デフォルトエディタの設定

環境変数を設定することで、好みのエディタを指定できます：

```bash
# VS Code
export EDITOR="code --wait"

# Vim
export EDITOR="vim"

# Emacs
export EDITOR="emacs"

# Nano
export EDITOR="nano"

# Sublime Text
export EDITOR="subl -w"

# シェル設定ファイル（~/.bashrc、~/.zshrcなど）に追加
```

## 関連情報

- [Interactive Mode - Keyboard shortcuts](https://code.claude.com/docs/en/interactive-mode#keyboard-shortcuts)
- [Interactive Mode - General controls](https://code.claude.com/docs/en/interactive-mode#general-controls)
- [Terminal configuration](https://code.claude.com/docs/en/terminal-config)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
