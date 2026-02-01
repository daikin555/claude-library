#!/bin/bash
# v2.1.0記事の日付を一括修正

TARGET_DIR="docs/updates"
OLD_DATE="2026-01-07"
NEW_DATE="2026-01-31"

echo "Fixing dates in v2.1.0 articles..."
count=0

for file in "$TARGET_DIR"/2026-01-31-v2-1-0-*.md; do
  if [ -f "$file" ]; then
    sed -i '' "s/^date: $OLD_DATE$/date: $NEW_DATE/" "$file"
    ((count++))
  fi
done

echo "Updated $count files"
