#!/bin/bash
# changelog差分検出スクリプト
# 新しいエントリがあれば、その内容を標準出力に出力し、終了コード0を返す
# 変更がなければ終了コード1を返す

set -euo pipefail

CHANGELOG_URL="https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md"
LAST_KNOWN_FILE="data/last-known-changelog.md"
CURRENT_FILE="data/current-changelog.md"

# 最新のchangelogを取得
echo "Fetching latest changelog..."
curl -sL "$CHANGELOG_URL" -o "$CURRENT_FILE"

if [ ! -s "$CURRENT_FILE" ]; then
  echo "Error: Failed to fetch changelog" >&2
  exit 2
fi

# 前回のchangelogが空（初回実行）の場合
if [ ! -s "$LAST_KNOWN_FILE" ]; then
  echo "Initial run: saving current changelog as baseline"
  cp "$CURRENT_FILE" "$LAST_KNOWN_FILE"
  # 初回は全体を新規とみなす
  cat "$CURRENT_FILE"
  exit 0
fi

# 差分を検出
if diff -q "$LAST_KNOWN_FILE" "$CURRENT_FILE" > /dev/null 2>&1; then
  echo "No changes detected"
  rm -f "$CURRENT_FILE"
  exit 1
fi

# 新しい部分を抽出（diffの追加行のみ）
# diff は差分がある場合に終了コード1を返すため、pipefail で失敗しないようにする
echo "Changes detected!"
diff "$LAST_KNOWN_FILE" "$CURRENT_FILE" | grep '^>' | sed 's/^> //' > data/new-entries.md || true

cat data/new-entries.md
exit 0
