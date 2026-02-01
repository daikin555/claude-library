---
title: "複数行構造内のdiffに対するシンタックスハイライトを修正"
date: 2026-01-27
tags: ['バグ修正', 'シンタックスハイライト', 'diff表示', 'Python']
---

## 原文（日本語に翻訳）

Pythonのdocstringなどの複数行構造内で発生するdiffに対するシンタックスハイライトを修正

## 原文（英語）

Fixed syntax highlighting for diffs occurring within multiline constructs like Python docstrings

## 概要

Claude Code v2.1.20では、Pythonのdocstringsやその他の複数行文字列リテラル内でコード変更（diff）を表示する際のシンタックスハイライトが修正されました。以前は、複数行構造内の変更箇所が正しくハイライトされず、追加・削除行の色分けが壊れたり、全体が一色で表示されることがありました。この修正により、ネストされた構造内でも正確なdiff表示が可能になります。

## 基本的な使い方

複数行文字列内の変更が正しくハイライトされます：

```python
# Python docstringの変更例
def calculate_total(items):
    """
-   Calculate total price of items
+   Calculate total price of items with tax

    Args:
-       items: List of items
+       items: List of items with prices

    Returns:
-       Total price
+       Total price including tax
    """
    pass

# 修正前：
# - docstring全体が緑色（追加）または赤色（削除）で表示
# - 個別の行の変更が識別できない

# 修正後：
# - 削除行（-）が赤色で表示
# - 追加行（+）が緑色で表示
# - 変更されていない行は通常の色
```

## 実践例

### Pythonドキュメントの更新

関数のdocstringを改善する場合：

```python
# エージェントが提案する変更：

class UserManager:
    def create_user(self, username, email):
        """
-       Create a new user
+       Create a new user account with validation

-       Parameters:
-       - username: str
-       - email: str
+       Args:
+           username (str): Unique username for the account
+           email (str): Valid email address

-       Returns: User object
+       Returns:
+           User: Newly created user instance
+
+       Raises:
+           ValueError: If username or email is invalid
        """
        pass

# 修正により：
# - 各行の変更が正確に色分け
# - docstring内のdiffが読みやすい
# - レビューが容易
```

### 複数行文字列リテラルの編集

SQL クエリやテンプレートの変更：

```python
# SQL クエリの更新
query = """
-   SELECT id, name
+   SELECT id, name, email, created_at
    FROM users
-   WHERE active = true
+   WHERE active = true
+   AND deleted_at IS NULL
    ORDER BY created_at DESC
-   LIMIT 10
+   LIMIT 100
"""

# 修正により：
# - 変更行が明確に識別可能
# - クエリの差分が一目瞭然
```

### マルチラインコメントの変更

コードブロックコメントの更新：

```javascript
/*
- This function handles user authentication
+ This function handles user authentication and session management

  Steps:
- 1. Validate credentials
- 2. Create session
- 3. Return token
+ 1. Validate user credentials
+ 2. Check user permissions
+ 3. Create secure session
+ 4. Generate JWT token
+ 5. Return authentication response
*/

// 修正前の問題：
// - コメント全体が誤ってハイライト
// - どの行が変更されたか不明

// 修正後：
// - 各変更行が適切に色分け
// - コメント内の差分が明確
```

### Markdown ドキュメント内のコードブロック

ドキュメント内の埋め込みコード例の更新：

````markdown
# API ドキュメント

## 使用例

```python
-import requests
+import requests
+import json

-response = requests.get('https://api.example.com/users')
+response = requests.get(
+    'https://api.example.com/users',
+    headers={'Authorization': 'Bearer token'}
+)
-print(response.json())
+data = response.json()
+print(json.dumps(data, indent=2))
```
````

修正により、Markdown内のコードブロックの変更も正確にハイライトされます。

### テンプレート文字列の編集

HTMLやYAMLなどの埋め込みテンプレート：

```python
html_template = """
<div class="user-card">
-   <h2>{username}</h2>
+   <h2>{username} ({user_id})</h2>
    <p>{email}</p>
+   <p class="role">{role}</p>
+   <span class="status">{status}</span>
</div>
"""

# 修正により：
# - HTML構造内の変更が正確に表示
# - タグと属性のハイライトも保持
# - diff表示とシンタックスハイライトが共存
```

### 複雑なネスト構造

Jinja2テンプレートなどの複雑な構造：

```jinja
{% macro render_user(user) %}
    <div class="user">
-       <h3>{{ user.name }}</h3>
+       <h3>{{ user.full_name }}</h3>
        {% if user.is_active %}
-           <span class="badge">Active</span>
+           <span class="badge badge-success">Active</span>
+       {% else %}
+           <span class="badge badge-danger">Inactive</span>
        {% endif %}
    </div>
{% endmacro %}

# 修正により：
# - テンプレート構文とdiffの両方が正しくハイライト
# - ネストされた制御構造内の変更も明確
```

## 注意点

- この修正は、複数行文字列リテラル内のdiff表示に影響します
- Python docstrings、SQL クエリ、HTML テンプレートなどが対象です
- シンタックスハイライトとdiff表示が同時に適用されます
- 言語によってハイライトの詳細度は異なります
- この問題は特にドキュメント重視のプロジェクトで顕著でした

## 関連情報

- [Syntax Highlighting](https://code.claude.com/docs/en/reference/syntax-highlighting)
- [Diff Display](https://code.claude.com/docs/en/features/diff-display)
- [Code Review Features](https://code.claude.com/docs/en/workflows/code-review)
- [Changelog v2.1.20](https://github.com/anthropics/claude-code/releases/tag/v2.1.20)
